import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';

class SectionHeader extends StatelessWidget {
  final String overline;
  final String title;

  const SectionHeader({
    super.key,
    required this.overline,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '// $overline'.toUpperCase(),
          style: AppTypography.overline,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppTypography.headlineLarge,
        ),
        const SizedBox(height: 16),
        Container(
          width: 32,
          height: 2,
          color: AppColors.accentPrimary,
        ),
      ],
    );
  }
}
