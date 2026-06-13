import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFF0F0D09);
  static const Color experienceBackground = Color(0xFF0F0D09);
  static const Color timelineLine = Color(0x0AFAF6EE);
  static const Color bulletInactive = Color(0xFF3A3328);
  static const Color bulletActive = Color(0xFFFB923C);
  static const Color surface = Color(0xFF141109);
  static const Color surfaceElevated = Color(0xFF1A1510);
  static const Color surfaceHover = Color(0xFF201A10);
  static const Color border = Color(0x0FFAF6EE); // rgba(250,246,238,0.06)
  static const Color borderAccent = Color(0x33FB923C); // rgba(251,146,60,0.20)
  static const Color borderSubtle = Color(0x0AFAF6EE); // rgba(250,246,238,0.04)

  // Side nav dock & icons
  static const Color navDockBackground = Color(0xFF0C0A07);
  static const Color navDockBorder = Color(0x0AFAF6EE);
  static const Color navItemActiveBg = Color(0xFF201A10);
  static const Color navIconDefault = Color(0xFF3A3328);
  static const Color navIconHover = Color(0xFF8A7F72);
  static const Color navIconActive = Color(0xFFFB923C);

  // Accents
  static const Color accentPrimary = Color(0xFFFB923C); 
  static const Color accentSecondary = Color(0xFFFCD34D); 
  static const Color accentSuccess = Color(0xFF86EFAC); 
  static const Color accentCodeType = Color(0xFFA5F3FC); 

  // Compatibility (if used elsewhere, map to new values)
  static const Color accentCyan = Color(0xFFFB923C);
  static const Color accentViolet = Color(0xFFFCD34D);
  static const Color accentCyanMuted = Color(0x33FB923C);

  // Text
  static const Color textPrimary = Color(0xFFFAF6EE);
  static const Color textSecondary = Color(0xFF8A7F72);
  static const Color textMuted = Color(0xFF6B6455);
  static const Color textDisabled = Color(0xFF3A3328);

  // Semantic
  static const Color success = Color(0xFF86EFAC);
  static const Color warning = Color(0xFFFCD34D);
  static const Color error = Color(0xFFEF4444);

  // Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F0D09), Color(0xFF0F0D09)],
  );

  static const LinearGradient cyanGlow = LinearGradient(
    colors: [Color(0xFFFB923C), Color(0x00FB923C)],
  );
}
