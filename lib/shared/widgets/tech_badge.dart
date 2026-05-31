import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../features/home/domain/models/skill.dart';

class TechBadge extends StatelessWidget {
  final Skill skill;

  const TechBadge({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppSpacing.badgeRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (skill.iconUrl != null) ...[
            SizedBox(
              width: 16,
              height: 16,
              child: SvgPicture.network(
                skill.iconUrl!,
                width: 16,
                height: 16,
                placeholderBuilder: (_) => const SizedBox(
                  width: 16,
                  height: 16,
                  child: Icon(
                    Icons.code,
                    size: 12,
                    color: AppColors.accentCyan,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Text(skill.name, style: AppTypography.badge),
        ],
      ),
    );
  }
}
