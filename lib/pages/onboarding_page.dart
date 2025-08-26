import 'package:derma_scan/controllers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final controller = Provider.of<OnboardingProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnboardingView(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                imagePath: 'assets/onboarding 1.png',
                title: 'Kulitmu Punya Cerita',
                subTitle:
                    'Kadang muncul bercak atau perubahan warna. Yuk, kenali lebih awal dengan DermaScan.',
              ),
              OnboardingView(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                imagePath: 'assets/onboarding 2.png',
                title: 'Cek Kesehatan Kulitmu dengan Mudah',
                subTitle:
                    'Cukup dengan sekali foto, DermaScan bantu mendeteksi 28 jenis masalah kulit secara cepat.',
              ),
              OnboardingView(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                imagePath: 'assets/onboarding 3.png',
                title: 'Teman Awal untuk Kulitmu',
                subTitle:
                    'Hasil hanya untuk screening awal. Untuk kepastian, tetap konsultasi ke dokter spesialis kulit.',
              ),
            ],
          ),
          Positioned(
            top: kToolbarHeight,
            right: 16,
            child: TextButton(
              onPressed: () {
                controller.skipPage(context);
              },
              child: Text('Skip', style: TextStyle(color: Colors.grey)),
            ),
          ),
          Positioned(
            bottom: kBottomNavigationBarHeight + 25,
            left: 16,

            child: SmoothPageIndicator(
              controller: controller.pageController,
              onDotClicked: controller.dotNavigationClick,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.black,
                dotHeight: 6,
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: kBottomNavigationBarHeight,
            child: ElevatedButton(
              onPressed: () {
                controller.nextPage(context);
              },

              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.black,
              ),
              child: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingView extends StatelessWidget {
  const OnboardingView({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.imagePath,
    required this.title,
    required this.subTitle,
  });

  final double screenWidth;
  final double screenHeight;
  final String imagePath;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Image(
            width: screenWidth * 0.8,
            height: screenHeight * 0.6,
            image: AssetImage(imagePath),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
