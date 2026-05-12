import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'book_experience.dart';
import 'design/app_colors.dart';

class ClickBookDemoApp extends StatelessWidget {
  const ClickBookDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: AppColors.brandMint,
            brightness: Brightness.dark,
          ).copyWith(
            surface: AppColors.surface,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
          ),
      scaffoldBackgroundColor: AppColors.scaffold,
    );

    return MaterialApp(
      title: 'Cinematic Click Book',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: GoogleFonts.exo2TextTheme(base.textTheme).copyWith(
          headlineLarge: GoogleFonts.orbitron(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
          headlineMedium: GoogleFonts.orbitron(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          titleLarge: GoogleFonts.exo2(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
          bodyLarge: GoogleFonts.exo2(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: GoogleFonts.exo2(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: GoogleFonts.exo2(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.7,
          ),
        ),
      ),
      home: const BookExperienceScreen(),
    );
  }
}
