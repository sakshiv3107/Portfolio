import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../features/home/domain/models/project.dart';
import 'bento_card.dart';

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BentoCard(
      onTap: (widget.project.liveUrl?.isNotEmpty == true)
          ? () => _launchUrl(widget.project.liveUrl!)
          : (widget.project.githubUrl?.isNotEmpty == true)
              ? () => _launchUrl(widget.project.githubUrl!)
              : null,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
              border: Border.all(color: AppColors.borderAccent),
            ),
            child: Text(
              widget.project.category,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.accentPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Title
          Text(widget.project.title, style: AppTypography.headlineSmall),
          const SizedBox(height: AppSpacing.xs),

          // Subtitle
          Text(
            widget.project.subtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.accentPrimary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Description
          Text(
            widget.project.description,
            style: AppTypography.bodyMedium,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Tech chips — scrollable row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.project.technologies.map((tech) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.5),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.pillRadius),
                      border: Border.all(
                        color: AppColors.accentPrimary.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      tech,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.accentPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Action buttons
          Row(
            children: [
              if (widget.project.githubUrl?.isNotEmpty == true)
                _ActionButton(
                  icon: FontAwesomeIcons.github,
                  label: 'GitHub',
                  onTap: () => _launchUrl(widget.project.githubUrl!),
                ),
              if (widget.project.githubUrl?.isNotEmpty == true &&
                  widget.project.liveUrl?.isNotEmpty == true)
                const SizedBox(width: AppSpacing.md),
              if (widget.project.liveUrl?.isNotEmpty == true)
                _ActionButton(
                  icon: Icons.open_in_new_rounded,
                  label: 'Live Demo',
                  onTap: () => _launchUrl(widget.project.liveUrl!),
                  isFilled: true,
                ),
              if (widget.project.githubUrl?.isEmpty != false &&
                  widget.project.liveUrl?.isEmpty != false)
                Text(
                  'In Development',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isFilled;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isFilled ? AppColors.accentCyan : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isFilled ? AppColors.accentCyan : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isFilled ? AppColors.background : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: isFilled ? AppColors.background : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
