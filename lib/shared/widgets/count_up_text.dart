import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Animated count-up number display (Animation 5)
class CountUpText extends StatefulWidget {
  final double end;
  final String suffix;
  final String prefix;
  final int decimals;
  final TextStyle style;
  final Duration duration;

  const CountUpText({
    super.key,
    required this.end,
    this.suffix = '',
    this.prefix = '',
    this.decimals = 0,
    required this.style,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<CountUpText> createState() => _CountUpTextState();
}

class _CountUpTextState extends State<CountUpText>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: 0, end: widget.end)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_started) {
          _started = true;
          _ctrl.forward();
        }
      },
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) {
          final val = _anim.value.toStringAsFixed(widget.decimals);
          return Text(
            '${widget.prefix}$val${widget.suffix}',
            style: widget.style,
          );
        },
      ),
    );
  }
}
