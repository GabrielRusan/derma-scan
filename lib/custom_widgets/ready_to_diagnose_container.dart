import 'package:derma_scan/custom_widgets/custom_button.dart';
import 'package:derma_scan/custom_widgets/custom_text.dart';
import 'package:derma_scan/pages/camera_page.dart';
import 'package:flutter/material.dart';

class ReadyToDiagnoseContainer extends StatelessWidget {
  const ReadyToDiagnoseContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            spreadRadius: 2,
            blurRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PoppinsText.headlineSmall(
                      'Siap untuk Scanning?',
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 16),
                    PoppinsText(
                      'Ambil foto kulit anda secara spesifik untuk mulai scanning',
                      size: 14,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Image.asset('assets/asset_1.png'),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          CustomButton(
            text: 'Mulai Scan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraPage()),
              );
            },
            margin: EdgeInsets.zero,
            icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
