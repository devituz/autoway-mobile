import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography design tokens (sizes/weights from Figma).
///
/// Font sizes use `.sp` (flutter_screenutil) so text scales responsively with
/// the device. The font family is applied centrally in [AppTheme] via
/// `google_fonts` (Poppins, bundled offline).
///
/// These are getters (not `const`) because `.sp` resolves at runtime against
/// the active ScreenUtil configuration.
class AppText {
  AppText._();

  static TextStyle get h1 => TextStyle(
        fontSize: 56.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get h2 => TextStyle(
        fontSize: 40.sp,
        fontWeight: FontWeight.w500,
        height: 1.5,
      );

  static TextStyle get bodyLarge => TextStyle(
        fontSize: 23.sp,
        fontWeight: FontWeight.w500,
        height: 1.25,
      );

  static TextStyle get bodyMedium => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      );

  // Register / onboarding flow
  static TextStyle get welcomeTitle => TextStyle(
        fontSize: 34.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get screenTitle => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get subtitle => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.4,
      );

  static TextStyle get button => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get label => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get input => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      );

  // Unbounded family — home header & cards (Figma 2231:6225)
  static TextStyle get logo => GoogleFonts.unbounded(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        height: 16 / 14,
      );

  static TextStyle get balance => GoogleFonts.unbounded(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        height: 17.36 / 14,
      );

  static TextStyle get serviceTitle => GoogleFonts.unbounded(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        height: 26 / 16,
      );
}
