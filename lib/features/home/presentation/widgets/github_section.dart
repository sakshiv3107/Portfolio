import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/bento_card.dart';

class GitHubSection extends StatefulWidget {
  const GitHubSection({super.key});

  @override
  State<GitHubSection> createState() => _GitHubSectionState();
}

class _GitHubSectionState extends State<GitHubSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<int> _contributionGrid = [];
  final String _username = 'sakshiv3107';

  @override
  void initState() {
    super.initState();
    // Generate simulated contribution data (0 = empty, 1 = low, 2 = medium, 3 = high)
    final random = Random(42); // Seed for consistency
    for (int i = 0; i < 53 * 7; i++) {
      // Create natural-looking clusters
      final weekday = i % 7;
      final isWeekend = weekday == 0 || weekday == 6;
      if (isWeekend && random.nextDouble() > 0.3) {
        _contributionGrid.add(0);
      } else {
        final val = random.nextDouble();
        if (val < 0.35) {
          _contributionGrid.add(0);
        } else if (val < 0.70) {
          _contributionGrid.add(1);
        } else if (val < 0.90) {
          _contributionGrid.add(2);
        } else {
          _contributionGrid.add(3);
        }
      }
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getContributionColor(int level) {
    switch (level) {
      case 1:
        return AppColors.accentCyan.withValues(alpha: 0.25);
      case 2:
        return AppColors.accentCyan.withValues(alpha: 0.60);
      case 3:
        return AppColors.accentCyan;
      case 0:
      default:
        return AppColors.border.withValues(alpha: 0.3);
    }
  }

  @override
  Widget build(BuildContext context) {

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
              const SectionHeader(
                overline: 'Open Source',
                title: 'GitHub Activity.',
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Username chip
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.alternate_email,
                          size: 14,
                          color: AppColors.accentCyan,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _username,
                          style: AppTypography.code.copyWith(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // 1. Heatmap Card
              BentoCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Contribution Heatmap',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '854 contributions in the last year',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Responsive Grid View Wrapper
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Weekdays labels column
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Text('Mon', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                              SizedBox(height: 12),
                              Text('Wed', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                              SizedBox(height: 12),
                              Text('Fri', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                            ],
                          ),
                          const SizedBox(width: 12),
                          // Heatmap grid using AnimatedBuilder
                          AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Row(
                                children: List.generate(53, (colIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 3.5),
                                    child: Column(
                                      children: List.generate(7, (rowIndex) {
                                        final index = colIndex * 7 + rowIndex;
                                        final level = _contributionGrid[index];
                                        // Calculate animated size / color factors
                                        final delayFactor = (colIndex + rowIndex) / (53 + 7);
                                        final scale = Tween<double>(begin: 0.0, end: 1.0)
                                            .animate(
                                              CurvedAnimation(
                                                parent: _animationController,
                                                curve: Interval(
                                                  (delayFactor * 0.7).clamp(0.0, 1.0),
                                                  (delayFactor * 0.7 + 0.3).clamp(0.0, 1.0),
                                                  curve: Curves.easeOutBack,
                                                ),
                                              ),
                                            )
                                            .value;

                                        return Container(
                                          width: 10 * scale,
                                          height: 10 * scale,
                                          margin: const EdgeInsets.only(bottom: 3.5),
                                          decoration: BoxDecoration(
                                            color: _getContributionColor(level),
                                            borderRadius: BorderRadius.circular(2),
                                          ),
                                        );
                                      }),
                                    ),
                                  );
                                }),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Less', style: AppTypography.bodySmall),
                        const SizedBox(width: 6),
                        _buildLegendBox(0),
                        const SizedBox(width: 4),
                        _buildLegendBox(1),
                        const SizedBox(width: 4),
                        _buildLegendBox(2),
                        const SizedBox(width: 4),
                        _buildLegendBox(3),
                        const SizedBox(width: 6),
                        Text('More', style: AppTypography.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // 2. Stats cards row
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  return isWide
                      ? Row(
                          children: [
                            Expanded(child: _buildCommitsStatsCard()),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(child: _buildLanguagesStatsCard()),
                          ],
                        )
                      : Column(
                          children: [
                            _buildCommitsStatsCard(),
                            const SizedBox(height: AppSpacing.md),
                            _buildLanguagesStatsCard(),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendBox(int level) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: _getContributionColor(level),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // Animated Commits & PRs Stats Card
  Widget _buildCommitsStatsCard() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.insights_rounded, color: AppColors.accentCyan, size: 20),
              SizedBox(width: 8),
              Text(
                'GitHub Stats Summary',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStatRow('Total Commits (2025)', '800+', 0.85),
          const SizedBox(height: 16),
          _buildStatRow('Pull Requests', '50+', 0.65),
          const SizedBox(height: 16),
          _buildStatRow('Repositories Contributed', '18', 0.50),
        ],
      ),
    );
  }

  // Languages Stats Card
  Widget _buildLanguagesStatsCard() {
    return BentoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.pie_chart_outline_rounded, color: AppColors.accentCyan, size: 20),
              SizedBox(width: 8),
              Text(
                'Top Languages',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildStatRow('Dart & Flutter', '74.2%', 0.74, color: AppColors.accentCyan),
          const SizedBox(height: 16),
          _buildStatRow('C++', '18.5%', 0.18, color: AppColors.accentViolet),
          const SizedBox(height: 16),
          _buildStatRow('Python', '7.3%', 0.07, color: Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, double percent, {Color color = AppColors.accentCyan}) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final progress = Tween<double>(begin: 0.0, end: percent)
            .animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeInOutCubic,
              ),
            )
            .value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                Text(
                  value,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.border.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4 * progress,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.25),
                        blurRadius: 6,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
