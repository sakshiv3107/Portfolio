import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/github_contribution_heatmap.dart';
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

              // Contribution heatmap
              BentoCard(
                padding: const EdgeInsets.all(24),
                child: heatmapAsync.when(
                  data: (data) => GitHubContributionHeatmap(
                    weeks: data.weeks,
                    totalContributions: data.totalContributions,
                    username: PortfolioData.githubUsername,
                  ),
                  loading: () => const SizedBox(
                    height: 160,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF39D353),
                      ),
                    ),
                  ),
                  error: (_, __) => SizedBox(
                    height: 120,
                    child: Center(
                      child: Text(
                        'Failed to load contribution data.',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
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
