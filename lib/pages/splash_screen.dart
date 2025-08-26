import 'package:derma_scan/constant/color.dart';
import 'package:derma_scan/controllers/tflite_provider_2.dart';
import 'package:derma_scan/pages/main_page.dart';
import 'package:derma_scan/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.microtask(() async {
      if (mounted) {
        await Provider.of<TFLiteProvider2>(
          context,
          listen: false,
        ).loadAllModels();

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final prefs = await SharedPreferences.getInstance();
          String? nama = prefs.getString('nama');
          await Future.delayed(Duration(seconds: 2));
          if (nama != null) {
            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          } else {
            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => OnboardingPage()),
            );
          }
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            SizedBox(height: 16),

            Text(
              'DermaScan',
              style: GoogleFonts.eduNswActFoundation(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
