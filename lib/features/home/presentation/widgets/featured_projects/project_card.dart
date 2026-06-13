import 'dart:ui';
import 'package:flutter/material.dart';
import 'projects_data.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_typography.dart';

class ProjectCard extends StatefulWidget {
  final ProjectData data;
  final bool isHero;
  final Duration animationDelay;
  final Animation<double> entryAnimation;
  final String activeFilter;

  const ProjectCard({
    super.key,
    required this.data,
    this.isHero = false,
    required this.animationDelay,
    required this.entryAnimation,
    required this.activeFilter,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool _isGithubHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  Color _getBadgeBgColor() {
    switch (widget.data.badgeType) {
      case 'Flutter': return AppColors.accentPrimary.withValues(alpha: 0.1);
      case 'AI': return AppColors.accentSecondary.withValues(alpha: 0.1);
      case 'Web': return AppColors.accentSuccess.withValues(alpha: 0.1);
      default: return Colors.transparent;
    }
  }

  Color _getBadgeTextColor() {
    switch (widget.data.badgeType) {
      case 'Flutter': return AppColors.accentPrimary;
      case 'AI': return AppColors.accentSecondary;
      case 'Web': return AppColors.accentSuccess;
      default: return Colors.white;
    }
  }

  Color _getBadgeBorderColor() {
    switch (widget.data.badgeType) {
      case 'Flutter': return AppColors.accentPrimary.withValues(alpha: 0.2);
      case 'AI': return AppColors.accentSecondary.withValues(alpha: 0.2);
      case 'Web': return AppColors.accentSuccess.withValues(alpha: 0.2);
      default: return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool matchesFilter = widget.activeFilter == 'All' || widget.activeFilter == widget.data.badgeType;
    final double targetOpacity = matchesFilter ? 1.0 : 0.20;
    final double targetScale = matchesFilter ? 1.0 : 0.97;

    return AnimatedBuilder(
      animation: widget.entryAnimation,
      builder: (context, child) {
        final curve = CurvedAnimation(
          parent: widget.entryAnimation,
          curve: Interval(
            (widget.animationDelay.inMilliseconds / 1000).clamp(0.0, 1.0),
            1.0,
            curve: Curves.easeOutQuart,
          ),
        );
        final double yOffset = (1 - curve.value) * 60;
        return Transform.translate(
          offset: Offset(0, yOffset),
          child: Opacity(
            opacity: curve.value,
            child: child,
          ),
        );
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: targetOpacity,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 300),
          scale: targetScale,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: AnimatedBuilder(
              animation: _hoverController,
              builder: (context, child) {
                return Container(
                  height: widget.isHero ? double.infinity : null,
                  decoration: BoxDecoration(
                    color: Color.lerp(AppColors.surface, AppColors.surfaceHover, _hoverController.value),
                    borderRadius: BorderRadius.zero, // NO border-radius on cards. Sharp corners only.
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Stack(
                    children: [
                      // Glow
                      Positioned(
                        right: -50,
                        bottom: -50,
                        child: Opacity(
                          opacity: _hoverController.value,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [AppColors.accentPrimary.withValues(alpha: 0.08), Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getBadgeBgColor(),
                                    borderRadius: BorderRadius.circular(2),
                                    border: Border.all(color: _getBadgeBorderColor()),
                                  ),
                                  child: Text(
                                    widget.data.badgeType.toUpperCase(),
                                    style: AppTypography.code.copyWith(
                                      fontSize: 10,
                                      color: _getBadgeTextColor(),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Transform.translate(
                                  offset: Offset.lerp(const Offset(0, 0), const Offset(2, -2), _hoverController.value)!,
                                  child: Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Color.lerp(AppColors.border, AppColors.accentPrimary, _hoverController.value)!,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.arrow_outward,
                                      size: 14,
                                      color: Color.lerp(AppColors.textMuted, AppColors.accentPrimary, _hoverController.value),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              widget.data.number,
                              style: AppTypography.code.copyWith(
                                fontSize: 11,
                                color: AppColors.accentPrimary.withValues(alpha: lerpDouble(0.35, 0.70, _hoverController.value)!),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.data.title,
                              style: AppTypography.displayMedium.copyWith(
                                fontSize: widget.isHero ? 34 : 26,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.data.subtitle,
                              style: AppTypography.code.copyWith(
                                fontSize: 11,
                                color: AppColors.accentPrimary.withValues(alpha: 0.55),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              flex: widget.isHero ? 1 : 0,
                              child: Text(
                                widget.data.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.code.copyWith(
                                  fontSize: 12,
                                  height: 1.75,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            if (widget.isHero && widget.data.githubUrl != null) ...[
                              const Spacer(),
                              MouseRegion(
                                onEnter: (_) => setState(() => _isGithubHovered = true),
                                onExit: (_) => setState(() => _isGithubHovered = false),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _isGithubHovered ? AppColors.accentPrimary.withValues(alpha: 0.4) : AppColors.border,
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.code,
                                        size: 24,
                                        color: _isGithubHovered ? AppColors.accentPrimary : AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'GitHub',
                                        style: AppTypography.code.copyWith(
                                          fontSize: 11,
                                          color: _isGithubHovered ? AppColors.accentPrimary : AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                            if (!widget.isHero) const SizedBox(height: 24),
                            Container(
                              height: 1,
                              color: AppColors.border,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.data.tags.join(' · '),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.code.copyWith(
                                      fontSize: 10,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: widget.data.isLive ? const Color(0xFF4ADE80) : const Color(0xFFFBBF24),
                                        boxShadow: widget.data.isLive
                                            ? [
                                                BoxShadow(
                                                  color: const Color(0xFF4ADE80).withOpacity(0.4),
                                                  blurRadius: 4,
                                                  spreadRadius: 1,
                                                )
                                              ]
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      widget.data.status,
                                      style: AppTypography.code.copyWith(
                                        fontSize: 10,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
