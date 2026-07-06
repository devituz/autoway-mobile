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

  // Driver dark stat tiles / balance card on dark headers.
  static const Color softDark = Color(0xFF334155);

  // Onboarding / Register flow
  static const Color onboardingDark = Color(0xFF171E31); // screen 1 navy bg
  static const Color mutedButton = Color(0xFF64748B); // screen 1 "Davom etish"
  static const Color fieldFill = Color(0xFFF1F5F9); // inputs & unselected cards
  static const Color softGrey = Color(0xFFF6F6F6); // payment option rows
  static const Color accentYellow = Color(0xFFFFC727); // avatar / highlights

  // Home / status accents
  static const Color blue = Color(0xFF2F6BFF); // CTA banner, "driver coming"
  // Home page (Figma 2231:6225) exact palette
  static const Color homeBg = Color(0xFF0F172A); // page / header background
  static const Color homePanel = Color(0xFF1E293B); // wallet panel
  static const Color dashDark = Color(0xFF475569); // dashed divider on dark
  static const Color logoWay = Color(0xFFBFD1FF); // "Way" in AutoWay logo
  static const Color cardLight = Color(0xFFF8FAFC); // featured card / icon circle
  static const Color orderBlue = Color(0xFF3B82F6); // order card header (blue)
  static const Color orderGreen = Color(0xFF22C55E); // order card header (green)
  static const Color iconAmber = Color(0xFFD97706); // compact "Yuk yetkazma" icon
  static const Color iconTeal = Color(0xFF14B8A6); // compact "Energy" icon
  static const Color ctaBlue = Color(0xFF2563EB); // Figma Blue/60 — Davom etish
  static const Color selectBlue = Color(0xFF3761E9); // Figma Brand/60 — "Tanlash"
  static const Color brand30 = Color(0xFFA4B8F8); // Figma Brand/30 — slot count badge
  static const Color statusGreen = Color(0xFF2FBF71); // "accepted"
  static const Color statusOrange = Color(0xFFF5A623); // "pending"
  static const Color orange = Color(0xFFF59E0B); // cargo illustration
  static const Color pink = Color(0xFFEF4444); // route illustration
  static const Color headerDark = Color(0xFF1E293B); // home dark header

  // Text
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textDark = Color(0xFF0F172A); // Figma Gray/90
  static const Color textMuted = Color(0xFF64748B); // Figma Gray/50
  static const Color textSecondary = Color(0xFF94A3B8); // Figma Gray/40
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color danger = Color(0xFFBE123C); // Figma Destructive/70
  static const Color logoutRed = Color(0xFFE11D48); // Figma Destructive/60
  static const Color badgeRed = Color(0xFFF43F5E); // Figma Destructive/50
  static const Color rose40 = Color(0xFFFB7185); // Figma Destructive/40 — online pill/button border
  static const Color gray30 = Color(0xFFCBD5E1); // Figma Gray/30 — inactive dots / disabled icons
  static const Color purpleStat = Color(0xFFA855F7); // driver "Faollik" stat value
  static const Color switchOff = Color(0xFFDBDFE0); // settings toggle track (off)
  static const Color creditGreen = Color(0xFF16A34A); // Figma Success/60
  static const Color warningBg = Color(0xFFFFFBEB); // Figma Warning/5 — note banner

  // Borders
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSelected = Color(0xFF1E293B);

  // Specific UI Colors
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
}
