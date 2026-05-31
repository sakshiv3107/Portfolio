import 'dart:async';
import 'package:flutter/material.dart';

/// Rolling slot-machine text cycler (Animation 1)
class RollingText extends StatefulWidget {
  final List<String> texts;
  final TextStyle style;
  final Duration switchInterval;
  final Duration animDuration;

  const RollingText({
    super.key,
    required this.texts,
    required this.style,
    this.switchInterval = const Duration(seconds: 2),
    this.animDuration = const Duration(milliseconds: 380),
  });

  @override
  State<RollingText> createState() => _RollingTextState();
}

class _RollingTextState extends State<RollingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _outAnim;
  late Animation<Offset> _inAnim;
  late Animation<double> _fadeOut;
  late Animation<double> _fadeIn;

  int _currentIndex = 0;
  int _nextIndex = 1;
  Timer? _timer;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.animDuration);

    _outAnim = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _inAnim = Tween<Offset>(begin: const Offset(0, 1.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeOut = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(widget.switchInterval, (_) => _roll());
  }

  Future<void> _roll() async {
    if (_isAnimating || !mounted) return;
    _isAnimating = true;
    _nextIndex = (_currentIndex + 1) % widget.texts.length;
    await _controller.forward();
    if (mounted) setState(() => _currentIndex = _nextIndex);
    _controller.reset();
    _isAnimating = false;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lineHeight = (widget.style.fontSize ?? 20) * 1.4;
    return SizedBox(
      height: lineHeight,
      child: ClipRect(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Outgoing text
            SlideTransition(
              position: _outAnim,
              child: FadeTransition(
                opacity: _fadeOut,
                child: Text(widget.texts[_currentIndex], style: widget.style),
              ),
            ),
            // Incoming text
            SlideTransition(
              position: _inAnim,
              child: FadeTransition(
                opacity: _fadeIn,
                child: Text(widget.texts[_nextIndex], style: widget.style),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
