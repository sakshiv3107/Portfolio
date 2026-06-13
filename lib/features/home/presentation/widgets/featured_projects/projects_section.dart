import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'project_card.dart';
import 'projects_data.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/responsive.dart';
class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _pulseController;
  bool _hasFired = false;
  String _activeFilter = 'All';

  final List<String> _filters = ['All', 'Flutter', 'AI', 'Web'];

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // Covers max delay + duration
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _entryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('projects-section'),
      onVisibilityChanged: (info) {
        if (!_hasFired && info.visibleFraction > 0.1) {
          _hasFired = true;
          _entryController.forward();
        }
      },
      child: Container(
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
                _buildHeader(),
                const SizedBox(height: 48),
                Stack(
            children: [
              _buildAmbientPulse(),
              IntrinsicHeight(
                child: Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ProjectCard(
                              data: codeSphere,
                              animationDelay: const Duration(milliseconds: 200),
                              entryAnimation: _entryController,
                              activeFilter: _activeFilter,
                            ),
                          ),
                          Container(width: 1, color: const Color(0x0FFFFFFF)),
                          Expanded(
                            child: ProjectCard(
                              data: mediAuth,
                              animationDelay: const Duration(milliseconds: 350),
                              entryAnimation: _entryController,
                              activeFilter: _activeFilter,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 1, color: const Color(0x0FFFFFFF)),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ProjectCard(
                              data: darkCommerce,
                              animationDelay: const Duration(milliseconds: 450),
                              entryAnimation: _entryController,
                              activeFilter: _activeFilter,
                            ),
                          ),
                          Container(width: 1, color: const Color(0x0FFFFFFF)),
                          Expanded(
                            child: ProjectCard(
                              data: financeTracker,
                              animationDelay: const Duration(milliseconds: 550),
                              entryAnimation: _entryController,
                              activeFilter: _activeFilter,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildBottomRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedBuilder(
          animation: _entryController,
          builder: (context, child) {
            final curve = CurvedAnimation(
              parent: _entryController,
              curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic), // 600ms
            );
            return Transform.translate(
              offset: Offset(0, 40 * (1 - curve.value)),
              child: Opacity(
                opacity: curve.value,
                child: child,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '// selected work'.toUpperCase(),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 11,
                  color: const Color(0x993B82F6),
                  letterSpacing: 2.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Featured Projects.',
                style: GoogleFonts.syne(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1.04,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _entryController,
          builder: (context, child) {
            final curve = CurvedAnimation(
              parent: _entryController,
              curve: const Interval(0.25, 0.58, curve: Curves.easeOut), // 300ms delay, 400ms duration
            );
            return Container(
              height: 3,
              width: 40 * curve.value,
              color: const Color(0xFF3B82F6),
            );
          },
        ),
        const SizedBox(height: 32),
        Row(
          children: List.generate(_filters.length, (index) {
            final filter = _filters[index];
            final isActive = _activeFilter == filter;
            return AnimatedBuilder(
              animation: _entryController,
              builder: (context, child) {
                // start delay 400ms (0.33), stagger 80ms (0.066)
                final start = 0.33 + (index * 0.066);
                final end = (start + 0.3).clamp(0.0, 1.0);
                final curve = CurvedAnimation(
                  parent: _entryController,
                  curve: Interval(start, end, curve: Curves.easeOut),
                );
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - curve.value)),
                  child: Opacity(
                    opacity: curve.value,
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => setState(() => _activeFilter = filter),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFF3B82F6) : Colors.transparent,
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                          color: isActive ? const Color(0xFF3B82F6) : const Color(0x1EFFFFFF),
                        ),
                      ),
                      child: Text(
                        filter.toUpperCase(),
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                          color: isActive ? const Color(0xFF080C11) : const Color(0x73FFFFFF),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildAmbientPulse() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Opacity(
              opacity: lerpDouble(0.03, 0.07, _pulseController.value)!,
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(
                  width: 600,
                  height: 300,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Color(0xFF3B82F6), Colors.transparent],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '04 projects · 2024–2025',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: const Color(0x40FFFFFF), // rgba(255,255,255,0.25)
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: _HoverText(
            text: '── View all on GitHub →',
            baseColor: const Color(0xB33B82F6), // #3B82F6 at 70% opacity
            hoverColor: const Color(0xFF3B82F6), // 100% opacity
          ),
        ),
      ],
    );
  }
}

class _HoverText extends StatefulWidget {
  final String text;
  final Color baseColor;
  final Color hoverColor;

  const _HoverText({
    required this.text,
    required this.baseColor,
    required this.hoverColor,
  });

  @override
  State<_HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<_HoverText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          color: _isHovered ? widget.hoverColor : widget.baseColor,
        ),
        child: Text(widget.text),
      ),
    );
  }
}
