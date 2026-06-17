import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text.dart';

class AppTheme {
  AppTheme._();

  static TextTheme get _baseTextTheme => TextTheme(
        displayLarge: AppText.h1,
        displayMedium: AppText.h2,
        bodyLarge: AppText.bodyLarge,
        bodyMedium: AppText.bodyMedium,
      );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.backgroundLight,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(_baseTextTheme),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.backgroundDark,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        _baseTextTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
    );
  }
}
