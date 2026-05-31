import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/bento_card.dart';

class BentoHeroSection extends StatefulWidget {
  const BentoHeroSection({super.key});

  @override
  State<BentoHeroSection> createState() => _BentoHeroSectionState();
}

class _BentoHeroSectionState extends State<BentoHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  // Staggered items animations
  late List<AnimationController> _itemControllers;
  late List<Animation<double>> _itemOpacities;
  late List<Animation<Offset>> _itemSlides;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    _itemControllers = List.generate(
      4,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _itemOpacities = _itemControllers
        .map((c) => Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(parent: c, curve: Curves.easeOut),
            ))
        .toList();

    _itemSlides = _itemControllers
        .map((c) => Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
              CurvedAnimation(parent: c, curve: Curves.easeOutCubic),
            ))
        .toList();

    _fadeController.forward();
    for (int i = 0; i < 4; i++) {
      Future.delayed(Duration(milliseconds: 150 + i * 150), () {
        if (mounted) _itemControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    for (final c in _itemControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
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
              // 1. Sleek Intro Header Block
              FadeTransition(
                opacity: _fadeAnim,
                child: _buildIntroHeader(context),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // 2. Responsive Bento Grid Layout
              isDesktop ? _buildDesktopGrid() : _buildMobileStack(),
            ],
          ),
        ),
      ),
    );
  }

  // Header Block with Pulsing Pulse Dot indicator
  Widget _buildIntroHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Hi, I'm Sakshi —\n",
                style: AppTypography.displayLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              TextSpan(
                text: "Flutter & Mobile Developer.",
                style: AppTypography.displayLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            const _PulsingDot(),
            const SizedBox(width: 8),
            Text(
              'Available for Internships · Summer / Fall 2025',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Desktop Bento Layout (Column nesting for perfect 3-column height-match)
  Widget _buildDesktopGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column (spans 2/3 of desktop width)
        Expanded(
          flex: 2,
          child: Column(
            children: [
              // Card 1: About Me
              _buildStaggeredCard(0, _buildAboutCard()),
              const SizedBox(height: AppSpacing.lg),
              // Sub-row containing Card 3 (Location) and Card 4 (Social Grid)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildStaggeredCard(2, _buildLocationCard(height: 220)),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: _buildStaggeredCard(3, _buildSocialsCard(height: 220)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        // Right Column (spans 1/3 of desktop width, equal height to the left column contents)
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 480, // matches height of Card 1 (240) + Spacing (20) + Card 3/4 (220)
            child: _buildStaggeredCard(1, _buildSkillsCard()),
          ),
        ),
      ],
    );
  }

  // Mobile / Tablet Bento Layout (stacks vertically)
  Widget _buildMobileStack() {
    return Column(
      children: [
        _buildStaggeredCard(0, _buildAboutCard()),
        const SizedBox(height: AppSpacing.lg),
        _buildStaggeredCard(1, _buildSkillsCard()),
        const SizedBox(height: AppSpacing.lg),
        _buildStaggeredCard(2, _buildLocationCard(height: 200)),
        const SizedBox(height: AppSpacing.lg),
        _buildStaggeredCard(3, _buildSocialsCard(height: 200)),
      ],
    );
  }

  Widget _buildStaggeredCard(int index, Widget card) {
    return FadeTransition(
      opacity: _itemOpacities[index],
      child: SlideTransition(
        position: _itemSlides[index],
        child: card,
      ),
    );
  }

  // ── BENTO CARD 1: ABOUT ME ──────────────────────────────────────────────────
  Widget _buildAboutCard() {
    final isMobile = Responsive.isMobile(context);

    return BentoCard(
      height: isMobile ? null : 240,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Modern rounded square avatar container
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.surfaceElevated,
                  border: Border.all(
                    color: AppColors.border.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'SV',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.accentCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About me.',
                      style: AppTypography.headlineSmall.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'B.Tech Information Technology Student',
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.accentCyan,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Text(
              'I build clean, production-ready mobile and web applications with Flutter and Dart, focusing on robust architectures (Clean Architecture + Riverpod) and smooth visual experiences.',
              style: AppTypography.bodyMedium.copyWith(
                height: 1.5,
              ),
              maxLines: isMobile ? null : 3,
              overflow: isMobile ? null : TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomLeft,
            child: ElevatedButton.icon(
              onPressed: () => _launchUrl('mailto:sakshi.vishnoi3107@gmail.com'),
              icon: const Icon(Icons.arrow_outward_rounded, size: 16),
              label: const Text("Let's Connect"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── BENTO CARD 2: SKILLS & STACK ────────────────────────────────────────────
  Widget _buildSkillsCard() {
    final categories = [
      ('Mobile', ['Flutter', 'Dart', 'Android', 'iOS']),
      ('State / DB', ['Riverpod', 'Firebase', 'Supabase']),
      ('AI & APIs', ['Gemini API', 'REST API', 'GraphQL']),
      ('Architecture', ['Clean Arch', 'MVVM', 'Git']),
    ];

    return BentoCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.terminal_rounded,
                color: AppColors.accentCyan,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Skills & Stack',
                style: AppTypography.labelLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat.$1.toUpperCase(),
                          style: AppTypography.overline.copyWith(
                            color: AppColors.textMuted,
                            fontSize: 9,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: cat.$2.map((skill) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.border.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                skill,
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── BENTO CARD 3: LOCATION (With pulsing radar map element) ─────────────────
  Widget _buildLocationCard({required double height}) {
    return BentoCard(
      height: height,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Simulated Radar Background Grid
          Positioned.fill(
            child: Opacity(
              opacity: 0.12,
              child: CustomPaint(
                painter: _RadarBackgroundPainter(),
              ),
            ),
          ),
          // Pulsing Map pin marker centered
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 60,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const _PulsingCircle(radius: 64, color: AppColors.accentCyan),
                  const _PulsingCircle(radius: 36, color: AppColors.accentCyan),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: AppColors.accentCyan,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Location text anchored at the bottom
          Positioned(
            bottom: 16,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ghaziabad, India',
                  style: AppTypography.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'GMT +5:30 (Asia/Kolkata)',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BENTO CARD 4: SOCIALS GRID (2x2 flat grid) ──────────────────────────────
  Widget _buildSocialsCard({required double height}) {
    return BentoCard(
      height: height,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CONNECT',
            style: AppTypography.overline.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildSocialTile(
                  icon: FontAwesomeIcons.github,
                  label: 'GitHub',
                  color: Colors.white,
                  onTap: () => _launchUrl('https://github.com/sakshiv3107'),
                ),
                _buildSocialTile(
                  icon: FontAwesomeIcons.linkedin,
                  label: 'LinkedIn',
                  color: const Color(0xFF0A66C2),
                  onTap: () => _launchUrl(
                      'https://www.linkedin.com/in/sakshi-vishnoi-7770b2315/'),
                ),
                _buildSocialTile(
                  icon: Icons.code_rounded,
                  label: 'LeetCode',
                  color: const Color(0xFFFFA116),
                  onTap: () => _launchUrl('https://leetcode.com/u/sakshiv31/'),
                ),
                _buildSocialTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  color: AppColors.accentCyan,
                  onTap: () => _launchUrl('mailto:sakshi.vishnoi3107@gmail.com'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return _SocialTile(
      icon: icon,
      label: label,
      color: color,
      onTap: onTap,
    );
  }
}

// ── CUSTOM RADAR GRAPHIC PAINTER ──────────────────────────────────────────────
class _RadarBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentCyan.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final center = Offset(size.width / 2, (size.height - 60) / 2);

    // Draw concentric circles
    canvas.drawCircle(center, 24, paint);
    canvas.drawCircle(center, 54, paint);
    canvas.drawCircle(center, 84, paint);

    // Draw grid lines
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height - 60), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ── PULSING ANCHOR RING ANIMATION ─────────────────────────────────────────────
class _PulsingCircle extends StatefulWidget {
  final double radius;
  final Color color;

  const _PulsingCircle({required this.radius, required this.color});

  @override
  State<_PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<_PulsingCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _scale = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCirc),
    );

    _opacity = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutExpo),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Container(
            width: widget.radius * _scale.value,
            height: widget.radius * _scale.value,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: widget.color, width: 1.5),
            ),
          ),
        );
      },
    );
  }
}

// ── PULSING GREEN/INTERNSHIP DOT ──────────────────────────────────────────────
class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

// ── HOVER SOCIAL NETWORK GRID TILE ────────────────────────────────────────────
class _SocialTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SocialTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_SocialTile> createState() => _SocialTileState();
}

class _SocialTileState extends State<_SocialTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withValues(alpha: 0.1)
                : AppColors.surfaceElevated.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? widget.color.withValues(alpha: 0.4)
                  : AppColors.border.withValues(alpha: 0.5),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: _hovered ? widget.color : AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(height: 6),
              Text(
                widget.label,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _hovered ? widget.color : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
