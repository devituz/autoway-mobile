import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF1E293B);
  static const Color accent = Color(0xFFFFFFFF);
  
  // Background Colors
  static const Color backgroundDark = Color(0xFF282828);
  static const Color backgroundLight = Color(0xFFF1F5F9);
  
  // Neutral Colors
  static const Color grey = Color(0xFF5B6065);
  static const Color lightGrey = Color(0xFFE2E8F0);

  // Onboarding / Register flow
  static const Color onboardingDark = Color(0xFF171E31); // screen 1 navy bg
  static const Color mutedButton = Color(0xFF64748B); // screen 1 "Davom etish"
  static const Color fieldFill = Color(0xFFF1F5F9); // inputs & unselected cards
  static const Color accentYellow = Color(0xFFFFC727); // avatar / highlights

  // Text
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Borders
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSelected = Color(0xFF1E293B);

  // Specific UI Colors
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
}
