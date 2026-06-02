import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Scroll-triggered fade + slide-up reveal wrapper (Animation 3)
/// Fixed: UniqueKey() was being created in build() causing detector re-registration
/// on every rebuild. Now uses a stable key passed in or derived from widget.key.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideOffset;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.slideOffset = 24.0,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.slideOffset / 400),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  void _trigger() {
    if (_triggered) return;
    _triggered = true;
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the widget's own key (stable) instead of UniqueKey() which recreates every build
    final visibilityKey = widget.key ?? ValueKey(widget.hashCode);
    return VisibilityDetector(
      key: visibilityKey,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.05) _trigger();
      },
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(position: _slide, child: widget.child),
      ),
    );
  }
}
