import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../domain/data/portfolio_data.dart';
import '../../domain/models/experience.dart';

// ── Timing constants (ms) ───────────────────────────────────────────────────

const _kHeaderDelay = 0;
const _kHeaderDuration = 400;
const _kLineDelay = 100;
const _kLineDuration = 600;
const _kDotDelay = 200;
const _kDotDuration = 300;
const _kTitleDelay = 300;
const _kTitleDuration = 350;
const _kCompanyDelay = 400;
const _kCompanyDuration = 350;
const _kDateDelay = 400;
const _kDateDuration = 350;
const _kDescDelay = 500;
const _kDescDuration = 400;
const _kBulletBaseDelay = 650;
const _kBulletStagger = 150;
const _kBulletDuration = 300;
const _kItemStagger = 950;

double _intervalT({
  required double controllerValue,
  required int delayMs,
  required int durationMs,
  required int totalMs,
  Curve curve = Curves.linear,
}) {
  final start = delayMs / totalMs;
  final end = (delayMs + durationMs) / totalMs;
  if (controllerValue <= start) return 0;
  if (controllerValue >= end) return 1;
  return curve.transform((controllerValue - start) / (end - start));
}

// ── Section ─────────────────────────────────────────────────────────────────

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with TickerProviderStateMixin {
  bool _hasAnimated = false;
  double _timelineHeight = 0;

  late AnimationController _masterCtrl;
  final GlobalKey _timelineKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final itemCount = PortfolioData.experiences.length;
    final totalMs = (itemCount - 1) * _kItemStagger +
        _kBulletBaseDelay +
        _kBulletStagger * 2 +
        _kBulletDuration +
        100;
    _masterCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: totalMs),
    );
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    super.dispose();
  }

  void _onSectionVisible(VisibilityInfo info) {
    if (_hasAnimated || info.visibleFraction < 0.15) return;
    _hasAnimated = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box =
          _timelineKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        setState(() => _timelineHeight = box.size.height);
      }
      _masterCtrl.forward();
    });
  }

  int _itemBaseDelay(int index) => index * _kItemStagger;

  @override
  Widget build(BuildContext context) {
    final items = PortfolioData.experiences;
    final horizontal = Responsive.horizontalPadding(context);

    return VisibilityDetector(
      key: const Key('experience-section'),
      onVisibilityChanged: _onSectionVisible,
      child: Container(
        width: double.infinity,
        color: AppColors.background,
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: AppSpacing.section,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AnimatedEntry(
                  controller: _masterCtrl,
                  delayMs: _kHeaderDelay,
                  durationMs: _kHeaderDuration,
                  curve: Curves.easeOut,
                  slideY: 20,
                  totalMs: _masterCtrl.duration!.inMilliseconds,
                  child: const _ExperienceSectionHeader(),
                ),
                const SizedBox(height: AppSpacing.xxl),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 32,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 15,
                              top: 0,
                              child: _AnimatedEntry(
                                controller: _masterCtrl,
                                delayMs: _kLineDelay,
                                durationMs: _kLineDuration,
                                curve: Curves.easeInOut,
                                totalMs:
                                    _masterCtrl.duration!.inMilliseconds,
                                builder: (t) {
                                  return Container(
                                    width: 2,
                                    height: _timelineHeight * t,
                                    color: AppColors.timelineLine,
                                  );
                                },
                                child: const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          key: _timelineKey,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < items.length; i++)
                              _AnimatedExperienceEntry(
                                item: items[i],
                                index: i,
                                controller: _masterCtrl,
                                itemBaseDelay: _itemBaseDelay(i),
                                isLast: i == items.length - 1,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Section header ──────────────────────────────────────────────────────────

class _ExperienceSectionHeader extends StatelessWidget {
  const _ExperienceSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.work_outline_rounded,
          size: 28,
          color: AppColors.accentCyan.withValues(alpha: 0.9),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'Experience',
          style: AppTypography.headlineMedium.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Single timeline entry ───────────────────────────────────────────────────

class _AnimatedExperienceEntry extends StatelessWidget {
  final ExperienceItem item;
  final int index;
  final AnimationController controller;
  final int itemBaseDelay;
  final bool isLast;

  const _AnimatedExperienceEntry({
    required this.item,
    required this.index,
    required this.controller,
    required this.itemBaseDelay,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final totalMs = controller.duration!.inMilliseconds;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xxl),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -32,
            top: 6,
            child: _TimelineDotWithPulse(
              controller: controller,
              delayMs: itemBaseDelay + _kDotDelay,
              durationMs: _kDotDuration,
              totalMs: totalMs,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMobile) ...[
                _AnimatedEntry(
                  controller: controller,
                  delayMs: itemBaseDelay + _kTitleDelay,
                  durationMs: _kTitleDuration,
                  totalMs: totalMs,
                  curve: Curves.easeOut,
                  slideX: -16,
                  child: Text(
                    item.role,
                    style: AppTypography.headlineMedium.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                _AnimatedEntry(
                  controller: controller,
                  delayMs: itemBaseDelay + _kCompanyDelay,
                  durationMs: _kCompanyDuration,
                  totalMs: totalMs,
                  curve: Curves.easeOut,
                  slideX: -16,
                  child: _CompanyRow(item: item),
                ),
                const SizedBox(height: AppSpacing.xs),
                _AnimatedEntry(
                  controller: controller,
                  delayMs: itemBaseDelay + _kDateDelay,
                  durationMs: _kDateDuration,
                  totalMs: totalMs,
                  curve: Curves.easeOut,
                  slideX: 16,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.dateRange,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 14,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ),
                ),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _AnimatedEntry(
                            controller: controller,
                            delayMs: itemBaseDelay + _kTitleDelay,
                            durationMs: _kTitleDuration,
                            totalMs: totalMs,
                            curve: Curves.easeOut,
                            slideX: -16,
                            child: Text(
                              item.role,
                              style: AppTypography.headlineMedium.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          _AnimatedEntry(
                            controller: controller,
                            delayMs: itemBaseDelay + _kCompanyDelay,
                            durationMs: _kCompanyDuration,
                            totalMs: totalMs,
                            curve: Curves.easeOut,
                            slideX: -16,
                            child: _CompanyRow(item: item),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _AnimatedEntry(
                      controller: controller,
                      delayMs: itemBaseDelay + _kDateDelay,
                      durationMs: _kDateDuration,
                      totalMs: totalMs,
                      curve: Curves.easeOut,
                      slideX: 16,
                      child: Text(
                        item.dateRange,
                        textAlign: TextAlign.right,
                        style: AppTypography.bodyMedium.copyWith(
                          fontSize: 14,
                          color: AppColors.accentCyan,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: AppSpacing.md),
              _AnimatedEntry(
                controller: controller,
                delayMs: itemBaseDelay + _kDescDelay,
                durationMs: _kDescDuration,
                totalMs: totalMs,
                curve: Curves.easeOut,
                slideY: 8,
                child: Text(
                  item.description,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              for (var b = 0; b < item.bullets.length; b++)
                _AnimatedBullet(
                  text: item.bullets[b],
                  controller: controller,
                  delayMs: itemBaseDelay + _kBulletBaseDelay + b * _kBulletStagger,
                  durationMs: _kBulletDuration,
                  totalMs: totalMs,
                  ghostReveal: b == 2,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Reusable stagger entry ──────────────────────────────────────────────────

class _AnimatedEntry extends StatelessWidget {
  final AnimationController controller;
  final int delayMs;
  final int durationMs;
  final int totalMs;
  final Curve curve;
  final Widget child;
  final double slideX;
  final double slideY;
  final Widget Function(double t)? builder;

  const _AnimatedEntry({
    required this.controller,
    required this.delayMs,
    required this.durationMs,
    required this.totalMs,
    required this.curve,
    required this.child,
    this.slideX = 0,
    this.slideY = 0,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = _intervalT(
          controllerValue: controller.value,
          delayMs: delayMs,
          durationMs: durationMs,
          totalMs: totalMs,
          curve: curve,
        );
        if (builder != null) {
          return builder!(t);
        }
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(
              slideX * (1 - t),
              slideY * (1 - t),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

// ── Timeline dot + sonar pulse ──────────────────────────────────────────────

class _TimelineDotWithPulse extends StatefulWidget {
  final AnimationController controller;
  final int delayMs;
  final int durationMs;
  final int totalMs;

  const _TimelineDotWithPulse({
    required this.controller,
    required this.delayMs,
    required this.durationMs,
    required this.totalMs,
  });

  @override
  State<_TimelineDotWithPulse> createState() => _TimelineDotWithPulseState();
}

class _TimelineDotWithPulseState extends State<_TimelineDotWithPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  bool _pulseStarted = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    widget.controller.addListener(_maybeStartPulse);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_maybeStartPulse);
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _maybeStartPulse() {
    if (_pulseStarted) return;
    final endMs = widget.delayMs + widget.durationMs;
    if (widget.controller.value >= endMs / widget.totalMs) {
      _pulseStarted = true;
      _pulseCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.controller, _pulseCtrl]),
      builder: (context, _) {
        final scale = _intervalT(
          controllerValue: widget.controller.value,
          delayMs: widget.delayMs,
          durationMs: widget.durationMs,
          totalMs: widget.totalMs,
          curve: Curves.easeOutBack,
        ).clamp(0.0, 1.0);
        final pulseT = _pulseCtrl.value;

        return SizedBox(
          width: 32,
          height: 32,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (pulseT > 0)
                Opacity(
                  opacity: (0.4 * (1 - pulseT)).clamp(0.0, 0.4),
                  child: Transform.scale(
                    scale: 1 + pulseT * 1.5,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentCyan.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              Opacity(
                opacity: scale,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.accentCyan,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Company row ─────────────────────────────────────────────────────────────

class _CompanyRow extends StatefulWidget {
  final ExperienceItem item;

  const _CompanyRow({required this.item});

  @override
  State<_CompanyRow> createState() => _CompanyRowState();
}

class _CompanyRowState extends State<_CompanyRow> {
  bool _hovered = false;

  Future<void> _openUrl(String? url) async {
    if (url == null) return;
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          cursor: item.companyUrl != null
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: () => _openUrl(item.companyUrl),
            child: Text(
              item.company,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 14,
                color: AppColors.accentCyan,
                decoration: _hovered && item.companyUrl != null
                    ? TextDecoration.underline
                    : TextDecoration.none,
                decorationColor: AppColors.accentCyan,
              ),
            ),
          ),
        ),
        if (item.companyUrl != null)
          _LinkIcon(
            icon: Icons.language_rounded,
            onTap: () => _openUrl(item.companyUrl),
          ),
        if (item.linkedInUrl != null)
          _LinkIcon(
            icon: FontAwesomeIcons.linkedin,
            onTap: () => _openUrl(item.linkedInUrl),
            size: 14,
          ),
        if (item.isCurrent) const _CurrentBadge(),
      ],
    );
  }
}

class _LinkIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _LinkIcon({
    required this.icon,
    required this.onTap,
    this.size = 16,
  });

  @override
  State<_LinkIcon> createState() => _LinkIconState();
}

class _LinkIconState extends State<_LinkIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Icon(
          widget.icon,
          size: widget.size,
          color: _hovered
              ? AppColors.accentCyan
              : AppColors.accentCyan.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

class _CurrentBadge extends StatelessWidget {
  const _CurrentBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accentCyan.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.accentCyan.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        'CURRENT',
        style: AppTypography.labelSmall.copyWith(
          fontSize: 11,
          letterSpacing: 0.8,
          color: AppColors.accentCyan,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Bullet reveal ───────────────────────────────────────────────────────────

class _AnimatedBullet extends StatelessWidget {
  final String text;
  final AnimationController controller;
  final int delayMs;
  final int durationMs;
  final int totalMs;
  final bool ghostReveal;

  const _AnimatedBullet({
    required this.text,
    required this.controller,
    required this.delayMs,
    required this.durationMs,
    required this.totalMs,
    this.ghostReveal = false,
  });

  double _textOpacity(double t) {
    if (!ghostReveal) return t.clamp(0.0, 1.0);
    if (t <= 0.7) return (t / 0.7 * 0.3).clamp(0.0, 0.3);
    return (0.3 + ((t - 0.7) / 0.3) * 0.7).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = _intervalT(
          controllerValue: controller.value,
          delayMs: delayMs,
          durationMs: durationMs,
          totalMs: totalMs,
          curve: Curves.easeOut,
        );
        final textOpacity = _textOpacity(t);
        final dotColor = Color.lerp(
          AppColors.bulletInactive,
          AppColors.bulletActive,
          t.clamp(0.0, 1.0),
        )!;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Opacity(
            opacity: textOpacity,
            child: Transform.translate(
              offset: Offset(0, 6 * (1 - t)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      text,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
