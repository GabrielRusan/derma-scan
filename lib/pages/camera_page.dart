// ignore: unused_import
import 'dart:convert';
import 'dart:io';
import 'package:derma_scan/controllers/diagnose_log_provider.dart';
import 'package:derma_scan/controllers/tflite_provider_2.dart';
import 'package:derma_scan/custom_widgets/custom_text.dart';
import 'package:derma_scan/models/diagnose_result_model.dart';
import 'package:derma_scan/pages/detail_diagnose_page.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  final picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.veryHigh,
    );
    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) return;

    final picture = await _controller!.takePicture();
    final file = File(picture.path);

    final correctedImage = await _flipImageIfFrontCamera(file);

    setState(() {
      _image = correctedImage;
    });
  }

  Future<File> _flipImageIfFrontCamera(File imageFile) async {
    // Jika kamera yang digunakan adalah kamera depan, flip horizontal
    final isFrontCamera =
        _cameras[_selectedCameraIndex].lensDirection ==
        CameraLensDirection.front;

    if (!isFrontCamera) return imageFile;

    final bytes = await imageFile.readAsBytes();
    final originalImage = img.decodeImage(bytes);
    if (originalImage == null) return imageFile;

    final flippedImage = img.flipHorizontal(originalImage);

    final tempDir = await getTemporaryDirectory();
    final flippedPath =
        '${tempDir.path}/flipped_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final flippedFile = File(flippedPath)
      ..writeAsBytesSync(img.encodeJpg(flippedImage));
    return flippedFile;
  }

  Future<void> _pickFromGallery() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2) return; // tidak ada kamera kedua

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;

    await _controller?.dispose(); // matikan kamera sebelumnya

    _controller = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.medium,
    );

    await _controller!.initialize();
    // Setelah selesai, setState / notifyListeners
    setState(() {});
  }

  void _resetImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _confirmAndClassify(BuildContext context) async {
    if (_image == null) {
      return;
    }
    final tfliteProvider = Provider.of<TFLiteProvider2>(context, listen: false);
    final logProvider = Provider.of<DiagnoseLogProvider>(
      context,
      listen: false,
    );

    final predictions = await tfliteProvider.classifyImage(
      imagePath: _image!.path,
      saveToDb: true,
    );
    if (predictions == null) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              title: Text(
                'Gagal mendeteksi penyakit!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              content: PoppinsText(
                'Silahkan gunakan gambar yang lain atau ambil ulang gambar speisifik ke area kulit yang mau kamu cek dengan jelas.',
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup dialog
                    _resetImage();
                  },
                  child: PoppinsText(
                    'Oke',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
      );
      return;
    }

    await logProvider.fetchLogs();

    DiagnoseResultModel diagnoseResult = DiagnoseResultModel(
      id: tfliteProvider.uuid,
      imagePath: _image!.path,
      predictedClass: '',
      confidence: 0,
      top3ConfidenceSum: 0.0,
      timeStamp: DateTime.now(),
      allPredictions:
          predictions.map((e) => AllPrediction.fromJson(e)).toList(),
    );

    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (_) => DetailDiagnosePage(result: diagnoseResult),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body:
          _image == null
              ? Column(
                children: [
                  Stack(
                    children: [
                      _controller != null && _controller!.value.isInitialized
                          ? SizedBox(
                            height: screenHeight * 0.75,
                            width: double.infinity,
                            child: AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio,
                              child: CameraPreview(_controller!),
                            ),
                          )
                          : Center(child: CircularProgressIndicator()),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, top: 32),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(24, 5),
                          topRight: Radius.elliptical(24, 5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () => _pickFromGallery(),
                              child: Container(
                                padding: EdgeInsets.all(5),

                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey.shade500,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: InkWell(
                              onTap: () => _takePicture(),
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.grey,
                                  ),
                                ),
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: InkWell(
                              onTap: () => switchCamera(),
                              child: Container(
                                padding: EdgeInsets.all(5),

                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Icons.cameraswitch,
                                  color: Colors.grey.shade500,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
              : Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.75,
                    child: Image.file(_image!, fit: BoxFit.fill),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: _resetImage,
                          icon: Icon(Icons.close, size: 40, color: Colors.grey),
                        ),
                        IconButton(
                          onPressed: () => _confirmAndClassify(context),
                          icon: Icon(Icons.check, size: 40, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
