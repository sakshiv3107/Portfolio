import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class BentoCard extends StatefulWidget {
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const BentoCard({
    super.key,
    required this.child,
    this.height,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
  });

  @override
  State<BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<BentoCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hasTap = widget.onTap != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: hasTap ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.015 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: widget.height,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: _isHovered
                    ? AppColors.accentCyan.withValues(alpha: 0.4)
                    : AppColors.border.withValues(alpha: 0.7),
                width: 1.5,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.accentCyan.withValues(alpha: 0.08),
                        blurRadius: 36,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: AppColors.accentViolet.withValues(alpha: 0.04),
                        blurRadius: 24,
                        spreadRadius: -2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // Fading linear gradient that shines on hover
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: _isHovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF3B82F6).withValues(alpha: 0.05), // blue-500/5
                            Colors.transparent,
                            const Color(0xFF8B5CF6).withValues(alpha: 0.05), // purple-500/5
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Main card content
                Padding(
                  padding: widget.padding,
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
