import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/project_card.dart';
import '../../domain/data/portfolio_data.dart';
import '../../domain/models/project.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  String _activeFilter = 'All';
  final List<String> _filters = ['All', 'Flutter', 'AI', 'Web'];

  List<Project> get _filteredProjects {
    if (_activeFilter == 'All') return PortfolioData.projects;
    return PortfolioData.projects
        .where((p) => p.category == _activeFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final projects = _filteredProjects;

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
                overline: 'What I\'ve Built',
                title: 'Featured Projects.',
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isActive = _activeFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: GestureDetector(
                        onTap: () => setState(() => _activeFilter = filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.accentCyan
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(
                                AppSpacing.pillRadius),
                            border: Border.all(
                              color: isActive
                                  ? AppColors.accentCyan
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            filter,
                            style: AppTypography.bodySmall.copyWith(
                              color: isActive
                                  ? AppColors.background
                                  : AppColors.textSecondary,
                              fontWeight: isActive
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // Projects grid
              if (projects.isEmpty)
                Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                    child: Text(
                      'No projects in this category yet.',
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                )
              else if (isMobile)
                Column(
                  children: projects
                      .map((p) => Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppSpacing.lg),
                            child: ProjectCard(project: p),
                          ))
                      .toList(),
                )
              else
                _buildDesktopGrid(projects),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopGrid(List<Project> projects) {
    // Build 2-column grid manually
    final rows = <Widget>[];
    for (int i = 0; i < projects.length; i += 2) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: ProjectCard(project: projects[i])),
              const SizedBox(width: AppSpacing.lg),
              if (i + 1 < projects.length)
                Expanded(child: ProjectCard(project: projects[i + 1]))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}

