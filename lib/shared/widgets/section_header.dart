import 'package:flutter/material.dart';
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
        Text(overline.toUpperCase(), style: AppTypography.overline),
        const SizedBox(height: AppSpacing.sm),
        Text(title, style: AppTypography.headlineLarge),
        const SizedBox(height: AppSpacing.md),
        // Cyan accent underline
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.accentCyan,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
