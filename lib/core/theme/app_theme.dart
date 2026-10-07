import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final textTheme = GoogleFonts.cairoTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: GoogleFonts.cairo().fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.turquoise,
        secondary: AppColors.navy,
        surface: AppColors.white,
        onPrimary: AppColors.white,
        onSecondary: AppColors.white,
        onSurface: AppColors.textDark,
      ),
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(color: AppColors.textDark,fontWeight: FontWeight.w900),
        titleLarge: textTheme.titleLarge?.copyWith(color: AppColors.textDark,fontWeight: FontWeight.w800),
        bodyLarge: textTheme.bodyLarge?.copyWith(color: AppColors.textDark),
        bodyMedium: textTheme.bodyMedium?.copyWith(color: AppColors.textMutedDark),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.turquoise,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16),borderSide: const BorderSide(color: Color(0xFFE2EAF0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),borderSide: const BorderSide(color: Color(0xFFE2EAF0))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16),borderSide: const BorderSide(color: AppColors.turquoise,width: 1.5)),
      ),
    );
  }
}
