import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // Outfit — Display / Headings / Body
  static TextStyle get displayLarge => GoogleFonts.outfit(
        fontSize: 52,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -1.56, // -0.03em
        height: 1.1,
      );

  static TextStyle get displayMedium => GoogleFonts.outfit(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.88, // -0.02em
        height: 1.2,
      );

  static TextStyle get headlineLarge => GoogleFonts.outfit(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.88,
        height: 1.2,
      );

  static TextStyle get headlineMedium => GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w700, // Stat numbers
        color: AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineSmall => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle get titleMedium => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        height: 1.5,
      );

  // Body text
  static TextStyle get bodyLarge => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: AppColors.textSecondary,
        height: 1.75,
      );

  static TextStyle get bodyMedium => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: AppColors.textSecondary,
        height: 1.75,
      );

  static TextStyle get bodySmall => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: AppColors.textMuted,
        height: 1.5,
      );

  // Buttons
  static TextStyle get labelLarge => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: 0.24, // 0.02em
      );

  static TextStyle get labelSmall => GoogleFonts.dmMono(
        fontSize: 9,
        fontWeight: FontWeight.w400,
        color: AppColors.textDisabled,
        letterSpacing: 0.72, // 0.08em
      );

  // Overline / Section labels (DM Mono)
  static TextStyle get overline => GoogleFonts.dmMono(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        letterSpacing: 0.88, // 0.08em
      );

  // Accent / code text (DM Mono)
  static TextStyle get code => GoogleFonts.dmMono(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.accentCodeType,
        height: 1.8,
      );

  // Badge text (DM Mono)
  static TextStyle get badge => GoogleFonts.dmMono(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: 0.4, // 0.04em
      );
}
