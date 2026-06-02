import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../domain/data/portfolio_data.dart';
import '../providers/github_provider.dart';

class GitHubSection extends ConsumerStatefulWidget {
  const GitHubSection({super.key});

  @override
  ConsumerState<GitHubSection> createState() => _GitHubSectionState();
}

class _GitHubSectionState extends ConsumerState<GitHubSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
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

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final heatmapAsync = ref.watch(githubHeatmapProvider(PortfolioData.githubUsername));
    final repoStatsAsync = ref.watch(githubRepoStatsProvider(PortfolioData.githubUsername));

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          PortfolioData.githubUsername,
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
                        heatmapAsync.when(
                          data: (data) => Text(
                            '${data.totalContributions} contributions in the last year',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          loading: () => const SizedBox(width: 100, height: 14),
                          error: (_, __) => const SizedBox(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Heatmap Grid
                    heatmapAsync.when(
                      data: (data) => _buildHeatmapGrid(data.weeks),
                      loading: () => const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.accentCyan),
                        ),
                      ),
                      error: (err, _) => SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(
                            'Failed to load heatmap data.',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Less', style: AppTypography.bodySmall),
                        const SizedBox(width: 6),
                        _buildLegendBox('#ebedf0'),
                        const SizedBox(width: 4),
                        _buildLegendBox('#9be9a8'),
                        const SizedBox(width: 4),
                        _buildLegendBox('#40c463'),
                        const SizedBox(width: 4),
                        _buildLegendBox('#30a14e'),
                        const SizedBox(width: 4),
                        _buildLegendBox('#216e39'),
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
                            Expanded(child: _buildCommitsStatsCard(heatmapAsync, repoStatsAsync)),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(child: _buildLanguagesStatsCard(repoStatsAsync)),
                          ],
                        )
                      : Column(
                          children: [
                            _buildCommitsStatsCard(heatmapAsync, repoStatsAsync),
                            const SizedBox(height: AppSpacing.md),
                            _buildLanguagesStatsCard(repoStatsAsync),
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

  Widget _buildHeatmapGrid(List<dynamic> weeks) {
    return SingleChildScrollView(
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
                children: List.generate(weeks.length, (colIndex) {
                  final days = weeks[colIndex];
                  return Padding(
                    padding: const EdgeInsets.only(right: 3.5),
                    child: Column(
                      children: List.generate(days.length, (rowIndex) {
                        final day = days[rowIndex];
                        final hexColor = day.color;
                        
                        // Calculate animated size / color factors
                        final delayFactor = (colIndex + rowIndex) / (weeks.length + 7);
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

                        // Dark mode adjustments for GitHub's light default colors
                        Color cellColor = _hexToColor(hexColor);
                        if (hexColor.toLowerCase() == '#ebedf0') {
                           cellColor = AppColors.border.withValues(alpha: 0.3);
                        } else {
                           // For dark mode, we might want to blend the light colors 
                           // with cyan to match the theme if they are just standard GitHub green.
                           // Actually the Deno API returns standard github colors. Let's tint them cyan!
                           if (hexColor == '#9be9a8') cellColor = AppColors.accentCyan.withValues(alpha: 0.3);
                           else if (hexColor == '#40c463') cellColor = AppColors.accentCyan.withValues(alpha: 0.5);
                           else if (hexColor == '#30a14e') cellColor = AppColors.accentCyan.withValues(alpha: 0.7);
                           else if (hexColor == '#216e39') cellColor = AppColors.accentCyan.withValues(alpha: 0.9);
                        }

                        return Container(
                          width: 10 * scale,
                          height: 10 * scale,
                          margin: const EdgeInsets.only(bottom: 3.5),
                          decoration: BoxDecoration(
                            color: cellColor,
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
    );
  }

  Widget _buildLegendBox(String hexColor) {
    Color cellColor = _hexToColor(hexColor);
    if (hexColor.toLowerCase() == '#ebedf0') cellColor = AppColors.border.withValues(alpha: 0.3);
    else if (hexColor == '#9be9a8') cellColor = AppColors.accentCyan.withValues(alpha: 0.3);
    else if (hexColor == '#40c463') cellColor = AppColors.accentCyan.withValues(alpha: 0.5);
    else if (hexColor == '#30a14e') cellColor = AppColors.accentCyan.withValues(alpha: 0.7);
    else if (hexColor == '#216e39') cellColor = AppColors.accentCyan.withValues(alpha: 0.9);

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  // Animated Commits & PRs Stats Card
  Widget _buildCommitsStatsCard(AsyncValue heatmapAsync, AsyncValue repoStatsAsync) {
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
          
          // Total Contributions
          heatmapAsync.when(
            data: (data) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildStatRow('Total Contributions', '${data.totalContributions}', (data.totalContributions / 500).clamp(0.0, 1.0)),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: SizedBox(height: 20, width: double.infinity, child: LinearProgressIndicator(color: AppColors.accentCyan)),
            ),
            error: (_, __) => const SizedBox(),
          ),

          // Pull requests (still static for now, or removed if you prefer, leaving static)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildStatRow('Pull Requests', PortfolioData.githubStats['Pull Requests']?['value'] ?? '50+', PortfolioData.githubStats['Pull Requests']?['percent'] ?? 0.65),
          ),

          // Repositories
          repoStatsAsync.when(
            data: (data) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildStatRow('Public Repositories', '${data.totalRepos}', (data.totalRepos / 50).clamp(0.0, 1.0)),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: SizedBox(height: 20, width: double.infinity, child: LinearProgressIndicator(color: AppColors.accentCyan)),
            ),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  // Languages Stats Card
  Widget _buildLanguagesStatsCard(AsyncValue repoStatsAsync) {
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
          
          repoStatsAsync.when(
            data: (data) {
              final langs = data.topLanguages;
              if (langs.isEmpty) {
                return Text('No languages found', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary));
              }
              return Column(
                children: langs.entries.map<Widget> ((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildStatRow(
                      e.key, 
                      e.value['value'], 
                      e.value['percent'], 
                      color: Color(int.parse(e.value['color'])),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: AppColors.accentCyan))),
            error: (_, __) => const Text('Error loading languages'),
          ),
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
