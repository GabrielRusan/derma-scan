import 'package:derma_scan/constant/color.dart';
import 'package:derma_scan/controllers/diagnose_log_provider.dart';
import 'package:derma_scan/controllers/navigation_provider.dart';
import 'package:derma_scan/controllers/onboarding_provider.dart';
import 'package:derma_scan/controllers/tflite_provider_2.dart';
import 'package:derma_scan/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  initializeDateFormatting('id_ID');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => TFLiteProvider2()),
        ChangeNotifierProvider(create: (_) => DiagnoseLogProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DermaScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primary,
        scaffoldBackgroundColor: background,
        // textTheme: GoogleFonts.serif(),
        colorScheme: ColorScheme.light(
          primary: primary,
          secondary: secondary,
          surface: background,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: text,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: primary,
          surfaceTintColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
