import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ============================================================
  // BRAND
  // ============================================================

  static const Color primary = Color(0xFF5A52E0);
  static const Color secondary = Color(0xFF8B5CF6);

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);

  static const Color lightText = Color(0xFF0F172A);
  static const Color lightSubtitle = Color(0xFF64748B);

  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightInput = Color(0xFFF8FAFC);
  static const Color lightHint = Color(0xFF94A3B8);

  // ============================================================
  // DARK THEME
  // ============================================================

  static const Color darkBackground = Color(0xFF0F1117);
  static const Color darkSurface = Color(0xFF181B23);

  static const Color darkText = Color(0xFFF8FAFC);
  static const Color darkSubtitle = Color(0xFF94A3B8);

  static const Color darkBorder = Color(0xFF2A2F3A);
  static const Color darkInput = Color(0xFF1C2029);
  static const Color darkHint = Color(0xFF64748B);

  // ============================================================
  // STATUS
  // ============================================================

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // ============================================================
  // OTHER
  // ============================================================

  static const Color onboarding = Color(0xFF1A1A2E);

  // Keep this for existing project code.
  static const Color needthis = Color(0xFF5A52E0);

  // Old name kept so other files don't break.
  static const Color textFieldColor = lightInput;
}
