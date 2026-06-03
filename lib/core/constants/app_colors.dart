import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF000000);
  static const Color experienceBackground = Color(0xFF000000);
  static const Color timelineLine = Color(0xFF1E2030);
  static const Color bulletInactive = Color(0xFF334155);
  static const Color bulletActive = Color(0xFFCBD5E1);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceElevated = Color(0xFF1A2235);
  static const Color border = Color(0xFF1E2A3A);

  // Side nav dock & icons
  static const Color navDockBackground = Color(0xE614141C);
  static const Color navDockBorder = Color(0xFF2A2A38);
  static const Color navItemActiveBg = Color(0xFF252532);
  static const Color navIconDefault = Color(0xFF8B92A8);
  static const Color navIconHover = Color(0xFF3B82F6);
  static const Color navIconActive = Color(0xFF3B82F6);

  // Accents
  static const Color accentCyan = Color(0xFF3B82F6); // Vibrant Blue
  static const Color accentViolet = Color(0xFF7C3AED);
  static const Color accentCyanMuted = Color(0x4D3B82F6); // Muted Blue

  // Text
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF475569);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF000000), Color(0xFF000000)],
  );

  static const LinearGradient cyanGlow = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF0099CC)],
  );
}
