import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────────────────────────────────────
// IntroOverlay
// A cinematic full-screen "Hello in every language" animation that runs once
// on first visit, then fades out to reveal the portfolio.
// ─────────────────────────────────────────────────────────────────────────────

class IntroOverlay extends StatefulWidget {
  /// Called after the overlay fully fades out.
  final VoidCallback onComplete;

  /// If true, only the single English "Hello" word is shown (repeat-visit mode).
  final bool shortMode;

  const IntroOverlay({
    super.key,
    required this.onComplete,
    this.shortMode = false,
  });

  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

// ─── Data ─────────────────────────────────────────────────────────────────────

class _LangWord {
  final String word;
  final String language;

  /// True for CJK / Devanagari scripts — affects font weight & letter spacing.
  final bool isCJK;

  const _LangWord(this.word, this.language, {this.isCJK = false});
}

const List<_LangWord> _allWords = [
  _LangWord('Hello', 'English'),
  _LangWord('नमस्ते', 'Hindi', isCJK: true),
  _LangWord('Hola', 'Spanish'),
  _LangWord('こんにちは', 'Japanese', isCJK: true),
  _LangWord('Bonjour', 'French'),
  _LangWord('你好', 'Chinese', isCJK: true),
  _LangWord('Ciao', 'Italian'),
  _LangWord('Merhaba', 'Turkish'),
  _LangWord('Привет', 'Russian'),
  _LangWord('Olá', 'Portuguese'),
  _LangWord('안녕하세요', 'Korean', isCJK: true),
  _LangWord('Hallo', 'German'),
];

// ─── Timing constants ──────────────────────────────────────────────────────────

/// ms each word is fully visible (hold phase).
const int _holdMs = 280;

/// ms for the entry + exit transition per word.
const int _transitionMs = 120;

/// Total per-word slot in ms.
const int _wordSlotMs = _holdMs + _transitionMs;

/// ms for the overlay fade-out at the end.
const int _exitFadeMs = 600;

/// Short-mode: only show "Hello" for 800 ms then fade.
const int _shortHoldMs = 800;

// ─── State ─────────────────────────────────────────────────────────────────────

class _IntroOverlayState extends State<IntroOverlay>
    with TickerProviderStateMixin {
  // ── Word cycling controller ──────────────────────────────────────────────────
  // Drives the entire word-cycling sequence. Value: 0.0 → 1.0 over all words.
  late final AnimationController _cycleController;

  // ── Overlay fade-out controller ──────────────────────────────────────────────
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  // ── Pulsing glow controller (independent loop) ───────────────────────────────
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  // ── Skip-hint visibility ─────────────────────────────────────────────────────
  bool _showSkipHint = false;

  // ── Flags ────────────────────────────────────────────────────────────────────
  bool _isCompleting = false;

  List<_LangWord> get _words =>
      widget.shortMode ? [_allWords.first] : _allWords;

  int get _totalCycleDurationMs =>
      widget.shortMode ? _shortHoldMs : (_words.length * _wordSlotMs);

  @override
  void initState() {
    super.initState();

    // ── Glow pulse (1.2 s loop, independent) ──────────────────────────────────
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.04, end: 0.08).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // ── Word cycle (runs once, total duration covers all words) ───────────────
    _cycleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _totalCycleDurationMs),
    );

    // ── Overlay fade (starts at 1.0, will animate to 0.0 on exit) ────────────
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _exitFadeMs),
      value: 1.0, // fully visible initially
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    // ── Start sequence ────────────────────────────────────────────────────────
    _start();
  }

  Future<void> _start() async {
    // Small delay to let the first frame paint cleanly.
    await Future.delayed(const Duration(milliseconds: 80));
    if (!mounted) return;

    _cycleController.forward();

    // Show skip hint after 600 ms (after 2nd word).
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && !_isCompleting) {
        setState(() => _showSkipHint = true);
      }
    });

    // Wait for the entire word cycle to complete.
    await _cycleController.forward().orCancel.catchError((_) {});
    if (!mounted) return;

    // Natural completion — fade out.
    _triggerExit();
  }

  /// Triggers the final fade-out and calls onComplete.
  Future<void> _triggerExit() async {
    if (_isCompleting) return;
    _isCompleting = true;
    setState(() => _showSkipHint = false);

    // Animate overlay to transparent.
    await _fadeController.reverse().orCancel.catchError((_) {});
    if (mounted) widget.onComplete();
  }

  /// Called when user taps anywhere — skips with 300 ms fast fade.
  void _skip() {
    if (_isCompleting) return;
    _isCompleting = true;
    setState(() => _showSkipHint = false);

    _cycleController.stop();
    _glowController.stop();

    // Fast 300 ms exit.
    _fadeController
        .animateTo(0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn)
        .orCancel
        .catchError((_) {})
        .then((_) {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _cycleController.dispose();
    _fadeController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────────

  /// Returns the responsive font size.
  double _fontSize(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 600) return 36;
    if (w < 1024) return 56;
    return 72;
  }

  /// Returns the current word index and per-word local progress [0..1]
  /// based on the global cycle controller value.
  ({int index, double localProgress, double wordProgress}) _wordState() {
    if (widget.shortMode) {
      return (index: 0, localProgress: _cycleController.value, wordProgress: 1.0);
    }
    final total = _words.length;
    final slotFraction = 1.0 / total;
    final raw = (_cycleController.value / slotFraction).clamp(0.0, total.toDouble());
    final index = raw.floor().clamp(0, total - 1);
    final localProgress = (raw - index).clamp(0.0, 1.0);
    return (index: index, localProgress: localProgress, wordProgress: raw);
  }

  /// Given localProgress [0..1] within a word slot, compute entry/exit opacity & offset.
  ({double opacity, double offsetY, double scale}) _wordAnimValues(double lp) {
    // Slot fractions:
    //  entry: 0.0 → 0.30 (enters over first 30% of slot)
    //  hold:  0.30 → 0.85
    //  exit:  0.85 → 1.0 (exits over last 15% of slot)

    const entryEnd = 0.30;
    const exitStart = 0.85;

    double opacity, offsetY, scale;

    if (lp <= entryEnd) {
      // ── Entry phase ──
      final t = Curves.easeOutCubic.transform(lp / entryEnd);
      opacity = t;
      offsetY = 30.0 * (1.0 - t);
      scale = 0.92 + 0.08 * t;
    } else if (lp <= exitStart) {
      // ── Hold phase ──
      opacity = 1.0;
      offsetY = 0.0;
      scale = 1.0;
    } else {
      // ── Exit phase ──
      final t = Curves.easeInCubic.transform((lp - exitStart) / (1.0 - exitStart));
      opacity = 1.0 - t;
      offsetY = -30.0 * t;
      scale = 1.0;
    }

    return (opacity: opacity, offsetY: offsetY, scale: scale);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTap: _skip,
        behavior: HitTestBehavior.opaque,
        child: SizedBox.expand(
          child: Stack(
            children: [
              // ── 1. Background ──────────────────────────────────────────────
              const ColoredBox(color: Color(0xFF0A0E14), child: SizedBox.expand()),

              // ── 2. Pulsing radial glow behind the word ─────────────────────
              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (_, __) => Center(
                  child: Container(
                    width: 600,
                    height: 600,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          // ignore: prefer_const_constructors — value is runtime
                          Color(0xFF00D9FF).withValues(alpha: _glowAnimation.value),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // ── 3. Noise grain overlay (subtle depth) ──────────────────────
              const _NoiseLayer(),

              // ── 4. Word + Language label (centered) ───────────────────────
              AnimatedBuilder(
                animation: _cycleController,
                builder: (context, _) {
                  final state = _wordState();
                  final word = _words[state.index];
                  final anim = _wordAnimValues(state.localProgress);
                  final fs = _fontSize(context);

                  // Label fades in 40 ms after word (lp > 0.07)
                  final labelOpacity =
                      (anim.opacity * (state.localProgress > 0.07 ? 1.0 : 0.0))
                          .clamp(0.0, 1.0);

                  return Center(
                    child: Transform.translate(
                      offset: Offset(0, anim.offsetY),
                      child: Transform.scale(
                        scale: anim.scale,
                        child: Opacity(
                          opacity: anim.opacity.clamp(0.0, 1.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ── Main word ──────────────────────────────────
                              Text(
                                word.word,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.jetBrainsMono(
                                  fontSize: fs,
                                  fontWeight: word.isCJK
                                      ? FontWeight.w400
                                      : FontWeight.w300,
                                  color: Colors.white,
                                  letterSpacing: word.isCJK
                                      ? fs * 0.02
                                      : fs * 0.08,
                                  height: 1.2,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // ── Language label ─────────────────────────────
                              Opacity(
                                opacity: labelOpacity,
                                child: Text(
                                  word.language.toUpperCase(),
                                  style: GoogleFonts.jetBrainsMono(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF00D9FF)
                                        .withValues(alpha: 0.6),
                                    letterSpacing: 2.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // ── 5. Progress bar ────────────────────────────────────────────
              Positioned(
                bottom: 48,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _cycleController,
                    builder: (_, __) => _ProgressBar(
                      progress: _cycleController.value,
                    ),
                  ),
                ),
              ),

              // ── 6. "tap to skip →" hint ────────────────────────────────────
              Positioned(
                bottom: 32,
                right: 32,
                child: AnimatedOpacity(
                  opacity: _showSkipHint ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    'tap to skip →',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ProgressBar — thin 120×1.5 px cyan fill bar via CustomPainter
// ─────────────────────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final double progress; // 0.0 → 1.0

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(120, 1.5),
      painter: _ProgressBarPainter(progress: progress.clamp(0.0, 1.0)),
    );
  }
}

class _ProgressBarPainter extends CustomPainter {
  final double progress;
  const _ProgressBarPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Track
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.white.withValues(alpha: 0.10),
    );
    // Fill
    if (progress > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width * progress, size.height),
        Paint()..color = const Color(0xFF00D9FF),
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressBarPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// _NoiseLayer — procedural grain texture at ~3% opacity
// ─────────────────────────────────────────────────────────────────────────────

class _NoiseLayer extends StatefulWidget {
  const _NoiseLayer();

  @override
  State<_NoiseLayer> createState() => _NoiseLayerState();
}

class _NoiseLayerState extends State<_NoiseLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ticker;

  @override
  void initState() {
    super.initState();
    // Animate at ~12 fps to animate the grain slightly.
    _ticker = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    )..repeat();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ticker,
      builder: (_, __) => SizedBox.expand(
        child: CustomPaint(
          painter: _NoisePainter(seed: _ticker.lastElapsedDuration?.inMilliseconds ?? 0),
        ),
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  final int seed;
  const _NoisePainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(seed ~/ 80); // change every ~80ms for subtle flicker
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.022);
    // Draw ~1200 random 1.5×1.5 px dots across the screen.
    for (int i = 0; i < 1200; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      canvas.drawRect(Rect.fromLTWH(x, y, 1.5, 1.5), paint);
    }
  }

  @override
  bool shouldRepaint(_NoisePainter old) => old.seed != seed;
}
