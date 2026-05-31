import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../domain/data/portfolio_data.dart';
import '../../domain/models/article.dart';

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = PortfolioData.articles;
    final isMobile = Responsive.isMobile(context);

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
                overline: 'Writing & Thoughts',
                title: 'Latest Writings.',
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Technical deep-dives on Flutter, Dart, and mobile engineering.',
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.xxl),
              isMobile
                  ? Column(
                      children: articles
                          .map((a) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: AppSpacing.lg),
                                child: _ArticleCard(article: a),
                              ))
                          .toList(),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: articles
                          .map(
                            (a) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: a == articles.last
                                      ? 0
                                      : AppSpacing.lg,
                                ),
                                child: _ArticleCard(article: a),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleCard extends StatefulWidget {
  final Article article;
  const _ArticleCard({required this.article});

  @override
  State<_ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<_ArticleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: _hovered ? AppColors.accentCyanMuted : AppColors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accentCyan.withOpacity(0.06),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coming soon badge
            if (widget.article.isPlaceholder)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentViolet.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
                  border: Border.all(
                    color: AppColors.accentViolet.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Coming Soon',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.accentViolet,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.md),

            // Title
            Text(
              widget.article.title,
              style: AppTypography.headlineSmall.copyWith(fontSize: 17),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Excerpt
            Text(
              widget.article.excerpt,
              style: AppTypography.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.lg),

            // Footer row
            Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  size: 13,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.article.datePublished,
                  style: AppTypography.bodySmall,
                ),
                const Spacer(),
                if (!widget.article.isPlaceholder)
                  Row(
                    children: [
                      Text(
                        'Read more',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.accentCyan,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: AppColors.accentCyan,
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

