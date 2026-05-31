import 'package:flutter/material.dart';

/// Infinite horizontal scrolling marquee (Animation 4)
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
  double _contentWidth = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this);
    // Compute duration after layout
    WidgetsBinding.instance.addPostFrameCallback((_) => _startMarquee());
  }

  void _startMarquee() {
    if (!mounted || _contentWidth <= 0) return;
    final durationMs = (_contentWidth / widget.speed * 1000).toInt();
    _ctrl.duration = Duration(milliseconds: durationMs);
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              // Build full content row (duplicated for seamless loop)
              final items = [
                ...widget.children,
                ...widget.children,
              ];

              // Measure one set content width
              final singleWidth = items.length / 2 *
                  (constraints.maxWidth / widget.children.length +
                      widget.gap);
              _contentWidth = singleWidth;

              final offset = -_ctrl.value * singleWidth;

              return SizedBox(
                height: 44, // badge height
                child: Transform.translate(
                  offset: Offset(offset, 0),
                  child: OverflowBox(
                    maxWidth: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: items
                          .map((c) => Padding(
                                padding: EdgeInsets.only(right: widget.gap),
                                child: c,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
