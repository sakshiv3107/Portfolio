import 'package:flutter/material.dart';

/// Infinite horizontal scrolling marquee (Animation 4)
/// Performance-optimised: LayoutBuilder is outside AnimatedBuilder so it
/// only runs on resize, not every frame.
class InfiniteMarquee extends StatefulWidget {
  final List<Widget> children;
  final double speed; // pixels per second
  final double gap;

  const InfiniteMarquee({
    super.key,
    required this.children,
    this.speed = 50.0,
    this.gap = 16.0,
  });

  @override
  State<InfiniteMarquee> createState() => _InfiniteMarqueeState();
}

class _InfiniteMarqueeState extends State<InfiniteMarquee>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  double _singleWidth = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this);
  }

  void _startMarquee(double singleWidth) {
    if (singleWidth <= 0) return;
    if (_singleWidth == singleWidth && _ctrl.isAnimating) return; // no-op on same width
    _singleWidth = singleWidth;
    final durationMs = (singleWidth / widget.speed * 1000).toInt();
    _ctrl.duration = Duration(milliseconds: durationMs);
    if (!_ctrl.isAnimating) _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder is outside AnimatedBuilder — runs only on constraint changes
    return RepaintBoundary(
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Estimate item width evenly across the viewport
            final itemWidth = constraints.maxWidth / widget.children.length;
            final singleWidth =
                widget.children.length * (itemWidth + widget.gap);

            // Schedule marquee start after this frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _startMarquee(singleWidth);
            });

            // Duplicate children for seamless loop
            final List<Widget> items = [
              ...widget.children,
              ...widget.children,
            ];

            return AnimatedBuilder(
              animation: _ctrl,
              builder: (context, child) {
                final offset = -_ctrl.value * singleWidth;
                return Transform.translate(
                  offset: Offset(offset, 0),
                  child: child,
                );
              },
              child: OverflowBox(
                maxWidth: double.infinity,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: items
                      .map(
                        (c) => Padding(
                          padding: EdgeInsets.only(right: widget.gap),
                          child: c,
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
