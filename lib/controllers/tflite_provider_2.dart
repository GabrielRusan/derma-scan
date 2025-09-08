// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:derma_scan/constant/uuid_generator.dart';
import 'package:derma_scan/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// ====== THRESHOLD (Triad-only; Micro-2 di-skip) ======
const double MIN_CONF_BYPASS = 0.90; // General langsung bypass kalau p1 >= ini
const double DELTA_TRIAD_GATE = 0.10; // ke Triad jika margin (p1-p2) kecil
const double FAIL_SAFE_LOW_G2S = 0.60; // ke Triad jika p1 General rendah

/// Nama folder model khusus untuk router Triad (bukan node hierarki)

/// Label-level untuk gate Triad (harus cocok dengan isi labels.txt General & Triad)
const Set<String> TRIAD_LABELS = {
  "Infectious",
  "Inflammatory Autoimmune",
  "Keratotic Neoplastic Pigmentary",
};

/// Runtime satu model/node
class _ModelRuntime {
  final String key; // e.g. "General", "Infectious"
  final String modelPath; // assets/mobilenet_models/<key>/<file>.tflite
  final String labelsPath; // assets/mobilenet_models/<key>/labels.txt

  late Interpreter interpreter;
  late List<String> labels;
  bool loaded = false;

  _ModelRuntime({
    required this.key,
    required this.modelPath,
    required this.labelsPath,
  });
}

// =========================
// KELAS hasil turun (descend)
// =========================
class DescendResult {
  final String finalLabel; // leaf akhir
  final double routeScoreDownstream; // produk probabilitas sepanjang jalur
  final String lastNode; // node terakhir yang dipakai mem-predict leaf
  final List<double> lastProbs; // distribusi prob di node terakhir
  final List<String> lastLabels; // label pada node terakhir
  final List<({String node, String child, double prob})> logs; // jejak

  DescendResult({
    required this.finalLabel,
    required this.routeScoreDownstream,
    required this.lastNode,
    required this.lastProbs,
    required this.lastLabels,
    required this.logs,
  });
}

class TFLiteProvider2 extends ChangeNotifier {
  // ===== state dasar =====
  final Map<String, _ModelRuntime> _models = {}; // key -> runtime
  bool _allLoaded = false;
  bool get allLoaded => _allLoaded;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  List<Map<String, dynamic>>? _predictions;
  List<Map<String, dynamic>>? get predictions => _predictions;

  String? _lastModelKey;
  String? get lastModelKey => _lastModelKey;

  String _uuid = '';
  String get uuid => _uuid;

  // =========================
  // 1) DISCOVER dari AssetManifest
  // =========================
  Future<Map<String, Map<String, String>>> _discoverModelsFromManifest({
    required String prefix, // 'assets/mobilenet_models/'
  }) async {
    final Map<String, Map<String, String>> out = {};

    // Ambil semua asset yang dipaketkan Flutter
    final manifestRaw = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifest = jsonDecode(manifestRaw);

    // Filter yang berada di bawah prefix
    final assetPaths =
        manifest.keys.where((p) => p.startsWith(prefix)).toList();

    // Kelompokkan per folder (tiap node = satu folder)
    final Map<String, List<String>> byDir = {};
    for (final p in assetPaths) {
      final i = p.lastIndexOf('/');
      if (i <= 0) continue;
      final dir = p.substring(0, i + 1); // include trailing '/'
      byDir.putIfAbsent(dir, () => []).add(p);
    }

    // Ambil pasangan <.tflite, labels.txt> per folder
    for (final entry in byDir.entries) {
      final dir = entry.key;
      final files = entry.value;

      final tflitePath = files.firstWhere(
        (f) => f.toLowerCase().endsWith('.tflite'),
        orElse: () => '',
      );
      final labelsPath = files.firstWhere(
        (f) => f.toLowerCase().endsWith('labels.txt'),
        orElse: () => '',
      );

      if (tflitePath.isEmpty || labelsPath.isEmpty) continue;

      // key = nama folder terakhir
      final parts = dir.split('/').where((e) => e.isNotEmpty).toList();
      final key = parts.isNotEmpty ? parts.last : tflitePath;

      out[key] = {"model": tflitePath, "labels": labelsPath};
    }

    return out;
  }

  // =========================
  // 2) LOAD semua interpreter + labels
  // =========================
  Future<void> loadAllModels() async {
    if (_allLoaded) return;

    final discovered = await _discoverModelsFromManifest(
      prefix: 'assets/mobilenet_models/',
    );

    if (discovered.isEmpty) {
      debugPrint(
        '[TFLiteProvider] Tidak ada model di assets/mobilenet_models/',
      );
      _allLoaded = true;
      notifyListeners();
      return;
    }

    // Buat runtime untuk tiap node
    for (final e in discovered.entries) {
      _models[e.key] = _ModelRuntime(
        key: e.key,
        modelPath: e.value['model']!,
        labelsPath: e.value['labels']!,
      );
    }

    // Load interpreter & labels
    for (final rt in _models.values) {
      try {
        // Opsi thread (opsional): tambah performa
        final options = InterpreterOptions()..threads = 2;
        rt.interpreter = await Interpreter.fromAsset(
          rt.modelPath,
          options: options,
        );

        final raw = await rootBundle.loadString(rt.labelsPath);
        rt.labels =
            raw
                .split('\n')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();

        rt.loaded = true;
        debugPrint(
          '[TFLiteProvider] Loaded ${rt.key} | #labels=${rt.labels.length}',
        );
      } catch (e) {
        rt.loaded = false;
        debugPrint('[TFLiteProvider] Gagal load ${rt.key}: $e');
      }
    }

    _allLoaded = true;
    notifyListeners();
  }

  // =========================
  // Util kecil
  // =========================
  List<String> listAvailableModels() =>
      _models.values.where((m) => m.loaded).map((m) => m.key).toList()..sort();

  bool isModelLoaded(String modelKey) => _models[modelKey]?.loaded ?? false;

  @override
  void dispose() {
    for (final rt in _models.values) {
      if (rt.loaded) {
        try {
          rt.interpreter.close();
        } catch (_) {}
      }
    }
    _models.clear();
    super.dispose();
  }

  // =========================
  // PREPROCESSING
  // =========================
  Future<List> _makeInputTensor(String imagePath, Interpreter interp) async {
    // 1) Decode gambar + hormati orientasi EXIF
    final bytes = await File(imagePath).readAsBytes();
    img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw StateError('Gagal decode image: $imagePath');
    }
    try {
      decoded = img.bakeOrientation(decoded);
    } catch (_) {
      // abaikan kalau versi package lama
    }

    // 2) Ambil info input tensor
    final inTensor = interp.getInputTensors().first;
    final shape = inTensor.shape; // [1, H, W, C]
    final inH = shape[1];
    final inW = shape[2];
    final inC = shape[3];

    // 3) Resize (bilinear)
    final resized = img.copyResize(
      decoded!,
      width: inW,
      height: inH,
      interpolation: img.Interpolation.linear,
    );

    // 4) Float32 input (default MobileNetV3 exported with include_preprocessing=True)
    final input = List.generate(
      1,
      (_) => List.generate(inH, (y) {
        return List.generate(inW, (x) {
          final p = resized.getPixel(x, y);
          if (inC == 3) {
            return [p.r.toDouble(), p.g.toDouble(), p.b.toDouble()];
          } else if (inC == 1) {
            final gray = 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;
            return [gray];
          } else {
            throw StateError(
              'Model mengharapkan $inC channel, tidak didukung.',
            );
          }
        });
      }),
    );

    return input;
  }

  // =========================
  // HELPER: RUN 1 MODEL
  // =========================
  /// Jalankan model (by key) → kembalikan semua probabilitas + urutan labelnya.
  Future<({List<double> probs, List<String> labels})> _runModel({
    required String modelKey,
    required List inputTensor,
  }) async {
    final rt = _models[modelKey];
    if (rt == null || !rt.loaded) {
      throw StateError('Model "$modelKey" tidak ditemukan / belum termuat.');
    }

    final numClasses = rt.labels.length;
    final output = List.generate(1, (_) => List.filled(numClasses, 0.0));
    rt.interpreter.run(inputTensor, output);

    final probs = List<double>.from(output[0].map((e) => e));
    return (probs: probs, labels: rt.labels);
    // Catatan: jika model quantized & output bukan float32,
    // tflite_flutter akan dekuantisasi otomatis ke double di List<double>.
  }

  // =========================
  // SIMPAN KE DB (FORMATMU)
  // =========================
  /// Simpan hasil single-model ke SQLite menggunakan struktur yang kamu kirim.
  /// - all_predictions: list JSON berisi {predicted_class, confidence}
  /// - top3_confidence_sum: kamu minta diabaikan → set 0.0 (kolom NOT NULL)
  Future<void> _saveSingleModelPredictionToDb({
    required String imagePath,
    required String topLabel,
    required double topConfidence,
    required List<Map<String, dynamic>> allPreds,
  }) async {
    _uuid = generateUuid();

    // Ubah ke bentuk yang cocok dengan AllPrediction.fromJson()
    final formatted =
        allPreds
            .map(
              (m) => {
                "predicted_class": m["label"],
                "confidence": m["confidence"],
              },
            )
            .toList();

    await DatabaseHelper.insertPrediction({
      "id": _uuid,
      "image_path": imagePath,
      "predicted_class": topLabel,
      "confidence": topConfidence,
      "top3_confidence_sum": 0.0, // diabaikan sesuai request
      "all_predictions": jsonEncode(formatted),
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  // =========================
  // PUBLIC API: KLASIFIKASI 1 MODEL
  // =========================
  /// Klasifikasi tanpa pipeline (langsung 1 model).
  /// Mengembalikan semua kelas + confidence (diurut desc) & simpan ke DB.
  Future<List<Map<String, dynamic>>> classifyImageSingleModel({
    required String imagePath,
    required String modelKey,
    bool saveToDb = true,
  }) async {
    if (!_allLoaded) await loadAllModels();
    final rt = _models[modelKey];
    if (rt == null || !rt.loaded) {
      throw StateError('Model "$modelKey" tidak ditemukan / belum termuat.');
    }

    _isProcessing = true;
    notifyListeners();

    try {
      final input = await _makeInputTensor(imagePath, rt.interpreter);
      final res = await _runModel(modelKey: modelKey, inputTensor: input);

      // Susun semua prediksi
      final results = <Map<String, dynamic>>[];
      for (int i = 0; i < res.labels.length; i++) {
        results.add({"label": res.labels[i], "confidence": res.probs[i]});
      }
      results.sort(
        (a, b) =>
            (b["confidence"] as double).compareTo(a["confidence"] as double),
      );

      _predictions = List.from(results);
      _lastModelKey = modelKey;

      if (saveToDb && results.isNotEmpty) {
        final top = results.first;
        await _saveSingleModelPredictionToDb(
          imagePath: imagePath,
          topLabel: top["label"] as String,
          topConfidence: top["confidence"] as double,
          allPreds: results,
        );
      }

      return _predictions!;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // =========================
  // HELPER: cek apakah label adalah "node" (punya model sendiri)
  // =========================
  bool _isNode(String label) {
    // Triad Specialist itu router, bukan node hierarki
    return _models.containsKey(label) && (_models[label]?.loaded ?? false);
  }

  void _applyLastNodeDistribution({
    required String lastNode,
    required List<String> labels,
    required List<double> probs,
  }) {
    _lastModelKey = lastNode;
    _predictions = List.generate(
      labels.length,
      (i) => {"label": labels[i], "confidence": probs[i]},
    )..sort(
      (a, b) =>
          (b["confidence"] as double).compareTo(a["confidence"] as double),
    );
  }

  // =========================
  // HELPER: turun dari kandidat hingga daun
  // =========================
  Future<DescendResult> _descendFromCandidate({
    required String startLabel,
    required List inputTensor,
  }) async {
    final logs = <({String node, String child, double prob})>[];
    double routeScoreDownstream = 1.0;
    String current = startLabel;

    // Default (kalau startLabel sudah leaf): gunakan distribusi kosong
    String lastNode = current;
    List<double> lastProbs = const [];
    List<String> lastLabels = const [];

    while (_isNode(current)) {
      final res = await _runModel(modelKey: current, inputTensor: inputTensor);
      final probs = res.probs;
      final labels = res.labels;

      // argmax
      int idx = 0;
      double maxv = probs[0];
      for (int i = 1; i < probs.length; i++) {
        if (probs[i] > maxv) {
          maxv = probs[i];
          idx = i;
        }
      }
      final child = labels[idx];
      final p = maxv;

      // simpan jejak & update score
      logs.add((node: current, child: child, prob: p));
      routeScoreDownstream *= p;

      // simpan distribusi terakhir (node ini)
      lastNode = current;
      lastProbs = probs;
      lastLabels = labels;

      // lanjut kalau child juga node; kalau tidak, berarti leaf
      if (_isNode(child)) {
        current = child;
      } else {
        return DescendResult(
          finalLabel: child,
          routeScoreDownstream: routeScoreDownstream,
          lastNode: lastNode,
          lastProbs: lastProbs,
          lastLabels: lastLabels,
          logs: logs,
        );
      }
    }

    // Jika startLabel bukan node (langsung leaf)
    return DescendResult(
      finalLabel: startLabel,
      routeScoreDownstream: routeScoreDownstream,
      lastNode: lastNode,
      lastProbs: lastProbs,
      lastLabels: lastLabels,
      logs: logs,
    );
  }

  // =========================
  // SIMPAN KE DB untuk pipeline (pakai distribusi node terakhir)
  // =========================
  Future<void> _savePipelinePredictionToDb({
    required String imagePath,
    required String finalLabel,
    required String lastNode,
    required List<double> lastProbs,
    required List<String> lastLabels,
  }) async {
    _uuid = generateUuid();

    // Bentuk all_predictions sesuai AllPrediction.toJson() kamu
    final zipped = List.generate(
      lastLabels.length,
      (i) => {"predicted_class": lastLabels[i], "confidence": lastProbs[i]},
    )..sort(
      (a, b) =>
          (b["confidence"] as double).compareTo(a["confidence"] as double),
    );

    // top-1 dari distribusi node terakhir (sesuai semantik single-model)
    int topIdx = 0;
    double topVal = lastProbs.isNotEmpty ? lastProbs[0] : 1.0;
    for (int i = 1; i < lastProbs.length; i++) {
      if (lastProbs[i] > topVal) {
        topVal = lastProbs[i];
        topIdx = i;
      }
    }
    final topLabel = lastLabels.isNotEmpty ? lastLabels[topIdx] : finalLabel;
    final topConfidence = lastProbs.isNotEmpty ? lastProbs[topIdx] : 1.0;

    await DatabaseHelper.insertPrediction({
      "id": _uuid,
      "image_path": imagePath,
      "predicted_class": topLabel, // finalNode top-1
      "confidence": topConfidence, // finalNode top-1 prob
      "top3_confidence_sum": 0.0, // diabaikan sesuai request
      "all_predictions": jsonEncode(zipped), // distribusi node terakhir
      "created_at": DateTime.now().toIso8601String(),
    });

    // update state untuk UI lama (opsional)
    _lastModelKey = lastNode;
    _predictions = List.generate(
      lastLabels.length,
      (i) => {"label": lastLabels[i], "confidence": lastProbs[i]},
    )..sort(
      (a, b) =>
          (b["confidence"] as double).compareTo(a["confidence"] as double),
    );
  }

  /// =========================
  /// PIPELINE: General → (descend jika NODE) → Leaf
  /// Gate di General & Leaf: p1≥0.80 && margin≥0.25
  /// =========================
  Future<List<Map<String, dynamic>>?> classifyImage({
    required String imagePath,
    bool saveToDb = true,
  }) async {
    if (!_allLoaded) await loadAllModels();
    if (!isModelLoaded("General")) {
      throw StateError("Node 'General' wajib tersedia.");
    }

    const double P1_THRESHOLD = 0.79;
    const double MARGIN_THRESHOLD = 0.25;

    bool passGate(List<double> probs, String nodeName, List<String> labels) {
      if (probs.isEmpty) return false;
      final idxs = List<int>.generate(probs.length, (i) => i)
        ..sort((a, b) => probs[b].compareTo(probs[a]));
      final p1 = probs[idxs[0]];
      final p2 = idxs.length > 1 ? probs[idxs[1]] : 0.0;
      final margin = p1 - p2;

      final passed = (p1 >= P1_THRESHOLD) && (margin >= MARGIN_THRESHOLD);

      if (passed) {
        debugPrint(
          "[ACCEPTED] Node=$nodeName → Top1=${labels[idxs[0]]} p1=${p1.toStringAsFixed(3)}, "
          "Top2=${labels[idxs[1]]} p2=${p2.toStringAsFixed(3)}, margin=${margin.toStringAsFixed(3)}",
        );
      } else {
        debugPrint(
          "[REJECTED] Node=$nodeName → Top1=${labels[idxs[0]]} p1=${p1.toStringAsFixed(3)}, "
          "Top2=${labels[idxs[1]]} p2=${p2.toStringAsFixed(3)}, margin=${margin.toStringAsFixed(3)}",
        );
      }

      return passed;
    }

    _isProcessing = true;
    notifyListeners();

    try {
      // ====== GENERAL ======
      final generalInterp = _models["General"]!.interpreter;
      final inputTensor = await _makeInputTensor(imagePath, generalInterp);

      final gen = await _runModel(
        modelKey: "General",
        inputTensor: inputTensor,
      );
      final gProbs = gen.probs;
      final gLabels = gen.labels;

      // Gate di GENERAL
      if (!passGate(gProbs, "General", gLabels)) {
        return null;
      }

      // Ambil top-1 General
      final gi = List<int>.generate(gProbs.length, (i) => i)
        ..sort((a, b) => gProbs[b].compareTo(gProbs[a]));
      final int i1 = gi[0];
      final String c1 = gLabels[i1];

      // === Jika c1 NODE → turun ke leaf ===
      if (_isNode(c1)) {
        final desc = await _descendFromCandidate(
          startLabel: c1,
          inputTensor: inputTensor,
        );

        // Gate di LEAF
        if (!passGate(desc.lastProbs, desc.lastNode, desc.lastLabels)) {
          return null;
        }

        if (saveToDb) {
          await _savePipelinePredictionToDb(
            imagePath: imagePath,
            finalLabel: desc.finalLabel,
            lastNode: desc.lastNode,
            lastProbs: desc.lastProbs,
            lastLabels: desc.lastLabels,
          );
        } else {
          _applyLastNodeDistribution(
            lastNode: desc.lastNode,
            labels: desc.lastLabels,
            probs: desc.lastProbs,
          );
        }
        return _predictions ?? [];
      }

      // === Jika c1 LEAF langsung dari General ===
      // Gate leaf pakai distribusi General juga
      if (!passGate(gProbs, "General-Leaf", gLabels)) {
        return null;
      }

      if (saveToDb) {
        await _savePipelinePredictionToDb(
          imagePath: imagePath,
          finalLabel: c1,
          lastNode: "General",
          lastProbs: gProbs,
          lastLabels: gLabels,
        );
      } else {
        _applyLastNodeDistribution(
          lastNode: "General",
          labels: gLabels,
          probs: gProbs,
        );
      }
      return _predictions ?? [];
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
}
