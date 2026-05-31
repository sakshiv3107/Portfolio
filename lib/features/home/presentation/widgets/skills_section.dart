import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/tech_badge.dart';
import '../../domain/data/portfolio_data.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Mobile Development',
      'State Management',
      'Backend & APIs',
      'AI & Integrations',
      'Architecture & Tooling',
      'Design & Other',
    ];

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
                overline: 'What I Work With',
                title: 'Skills & Stack.',
              ),
              const SizedBox(height: AppSpacing.xxl),
              ...categories.map((cat) => _SkillCategory(category: cat)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillCategory extends StatelessWidget {
  final String category;

  const _SkillCategory({required this.category});

  @override
  Widget build(BuildContext context) {
    final skills = PortfolioData.skillsByCategory(category);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category label
          Row(
            children: [
              Container(
                width: 3,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.accentCyan,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                category,
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Skill badges
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: skills.map((skill) => TechBadge(skill: skill)).toList(),
          ),
        ],
      ),
    );
  }
}

