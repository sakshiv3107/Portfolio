import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../features/home/domain/models/skill.dart';

/// Accent colors for skills without an explicit [Skill.iconColor].
const List<Color> kSkillAccentPalette = [
  AppColors.accentCyan,
  AppColors.accentViolet,
  AppColors.success,
  AppColors.warning,
  Color(0xFFEC4899),
  Color(0xFF06B6D4),
];

Color skillAccentColor(Skill skill, {int? paletteIndex}) {
  final hex = skill.iconColor;
  if (hex != null && hex.isNotEmpty) {
    final normalized = hex.replaceFirst('#', '').replaceFirst('0x', '');
    final value = int.tryParse(normalized, radix: 16);
    if (value != null) {
      return Color(0xFF000000 | value);
    }
  }
  if (paletteIndex != null) {
    return kSkillAccentPalette[paletteIndex % kSkillAccentPalette.length];
  }
  return AppColors.accentCyan;
}

class TechBadge extends StatefulWidget {
  final Skill skill;
  final int? paletteIndex;

  const TechBadge({
    super.key,
    required this.skill,
    this.paletteIndex,
  });

  @override
  State<TechBadge> createState() => _TechBadgeState();
}

class _TechBadgeState extends State<TechBadge> {
  bool _hovered = false;
  bool _focused = false;

  bool get _active => _hovered || _focused;

  Color get _accent =>
      skillAccentColor(widget.skill, paletteIndex: widget.paletteIndex);

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _focused = focused),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: Semantics(
          button: true,
          label: widget.skill.name,
          child: AnimatedScale(
            scale: _active ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            alignment: Alignment.center,
            filterQuality: FilterQuality.medium,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _active
                    ? AppColors.textPrimary.withValues(alpha: 0.04)
                    : AppColors.textPrimary.withValues(alpha: 0.04),
                border: Border.all(
                  color: _active ? AppColors.accentPrimary.withValues(alpha: 0.25) : AppColors.textPrimary.withValues(alpha: 0.08),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(6),
                boxShadow: _active
                    ? [
                        BoxShadow(
                          color: _accent.withValues(alpha: 0.25),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.skill.iconUrl != null) ...[
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: SvgPicture.network(
                        widget.skill.iconUrl!,
                        width: 16,
                        height: 16,
                        placeholderBuilder: (_) => Icon(
                          Icons.code,
                          size: 12,
                          color: _active ? AppColors.accentPrimary : AppColors.accentPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Text(
                    widget.skill.name,
                    style: AppTypography.badge.copyWith(
                      color: _active ? AppColors.accentPrimary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
