import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/count_up_text.dart';
import '../../../../shared/widgets/scroll_reveal.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../domain/data/portfolio_data.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = PortfolioData.achievements;

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScrollReveal(
                key: const ValueKey('achievements-header'),
                child: const SectionHeader(
                  overline: 'Wins & Recognition',
                  title: 'Achievements.',
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Stats row (count-up numbers)
              ScrollReveal(
                key: const ValueKey('achievements-stats'),
                delay: const Duration(milliseconds: 100),
                child: _buildStatsRow(context),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Achievement tiles
              ...achievements.asMap().entries.map((e) => ScrollReveal(
                    key: ValueKey('achievement-${e.key}'),
                    delay: Duration(milliseconds: 100 + e.key * 70),
                    child: _AchievementTile(data: e.value),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final stats = [
      {'label': 'Hackathons Won', 'value': 3.0, 'suffix': '+'},
      {'label': 'Projects Built', 'value': 12.0, 'suffix': '+'},
      {'label': 'Apps Published', 'value': 2.0, 'suffix': ''},
      {'label': 'GitHub Stars', 'value': 80.0, 'suffix': '+'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.lg, horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: isMobile
          ? Wrap(
              spacing: AppSpacing.xl,
              runSpacing: AppSpacing.lg,
              alignment: WrapAlignment.center,
              children: stats
                  .asMap()
                  .entries
                  .map((e) => _StatItem(
                        label: e.value['label'] as String,
                        end: e.value['value'] as double,
                        suffix: e.value['suffix'] as String,
                        index: e.key,
                      ))
                  .toList(),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: stats
                  .asMap()
                  .entries
                  .map((e) => Expanded(
                        child: _StatItem(
                          label: e.value['label'] as String,
                          end: e.value['value'] as double,
                          suffix: e.value['suffix'] as String,
                          index: e.key,
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final double end;
  final String suffix;
  final int index;

  const _StatItem({
    required this.label,
    required this.end,
    required this.suffix,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CountUpText(
          key: ValueKey('stat-count-$index'),
          end: end,
          suffix: suffix,
          style: AppTypography.displayMedium.copyWith(
            color: AppColors.accentCyan,
            fontWeight: FontWeight.w800,
          ),
          duration: const Duration(milliseconds: 1400),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _AchievementTile extends StatefulWidget {
  final Map<String, String> data;
  const _AchievementTile({required this.data});

  @override
  State<_AchievementTile> createState() => _AchievementTileState();
}

class _AchievementTileState extends State<_AchievementTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.accentCyan.withOpacity(0.04)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? AppColors.accentCyanMuted : AppColors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accentCyan.withOpacity(0.08),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Emoji icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _hovered
                    ? AppColors.accentCyan.withOpacity(0.1)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color:
                        _hovered ? AppColors.accentCyanMuted : AppColors.border),
              ),
              child: Center(
                child: Text(
                  widget.data['icon'] ?? '🏆',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data['title'] ?? '',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.data['detail'] ?? '',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: _hovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.accentCyan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
