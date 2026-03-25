import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'book_experience.dart';

class ClickBookDemoApp extends StatelessWidget {
  const ClickBookDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: const Color(0xFF20E3C4),
            brightness: Brightness.dark,
          ).copyWith(
            surface: const Color(0xFF0D1428),
            primary: const Color(0xFF31F6D0),
            secondary: const Color(0xFFFF8A5B),
          ),
      scaffoldBackgroundColor: const Color(0xFF04060F),
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
