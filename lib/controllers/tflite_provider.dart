import 'dart:convert';
import 'dart:io';
import 'package:derma_scan/constant/uuid_generator.dart';
import 'package:derma_scan/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class TFLiteProvider extends ChangeNotifier {
  late Interpreter _interpreter;
  bool _modelLoaded = false;
  bool get modelLoaded => _modelLoaded;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  List<Map<String, dynamic>>? _predictions;
  List<Map<String, dynamic>>? get predictions => _predictions;

  String _uuid = '';
  String get uuid => _uuid;

  double _top3ConfidenceSum = 0.0;
  double get top3ConfidenceSum => _top3ConfidenceSum;

  List<String> _labels = [];

  Future<void> loadModel() async {
    if (_modelLoaded) return;
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/mobilenetv3_model.tflite',
      );
      _labels = await _loadLabels('assets/labels.txt');
      _modelLoaded = true;
      notifyListeners();
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<void> classifyImage(String imagePath) async {
    if (!_modelLoaded) await loadModel();
    _isProcessing = true;
    notifyListeners();

    try {
      final imageFile = File(imagePath);
      final image = img.decodeImage(await imageFile.readAsBytes());

      // Resize to 224x224 (or match your model input shape)
      final resized = img.copyResize(image!, width: 224, height: 224);

      // Normalize image to float32
      final input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(224, (x) {
            final pixel = resized.getPixel(x, y);
            final r = (pixel.r - 127.5) / 127.5;
            final g = (pixel.g - 127.5) / 127.5;
            final b = (pixel.b - 127.5) / 127.5;

            return [r, g, b];
          }),
        ),
      );

      // Prepare output buffer
      var output = List.filled(
        1 * _labels.length,
        0.0,
      ).reshape([1, _labels.length]);

      _interpreter.run(input, output);

      // Map outputs to labels
      final results = <Map<String, dynamic>>[];
      for (int i = 0; i < _labels.length; i++) {
        results.add({'label': _labels[i], 'confidence': output[0][i]});
      }

      results.sort(
        (a, b) =>
            (b['confidence'] as double).compareTo(a['confidence'] as double),
      );

      _predictions = List.from(results);

      // Simpan ke database
      final topResult = _predictions!.first;
      final top3ConfidenceSum = _predictions!
          .take(3)
          .fold(0.0, (sum, item) => sum + (item['confidence'] as double));

      _uuid = generateUuid();

      await DatabaseHelper.insertPrediction({
        'id': _uuid,
        'image_path': imagePath,
        'predicted_class': topResult['label'],
        'confidence': topResult['confidence'],
        'top3_confidence_sum': top3ConfidenceSum,
        'all_predictions': jsonEncode(_predictions),
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print("Classification error: $e");
      _predictions = [];
    }

    _isProcessing = false;
    notifyListeners();
  }

  Future<List<String>> _loadLabels(String assetPath) async {
    final raw = await rootBundle.loadString(assetPath);
    return raw.split('\n').where((line) => line.trim().isNotEmpty).toList();
  }

  Future<void> disposeModel() async {
    _interpreter.close();
    _modelLoaded = false;
    notifyListeners();
  }
}
