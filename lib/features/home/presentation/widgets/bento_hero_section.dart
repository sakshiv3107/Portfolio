import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/resume_launcher.dart';
import '../../../../shared/widgets/bento_card.dart';
import '../../../../shared/widgets/count_up_text.dart';
import '../../../../shared/widgets/portfolio_avatar.dart';
import '../../../../shared/widgets/rolling_text.dart';
import '../../../../shared/widgets/tech_badge.dart';
import '../../domain/data/portfolio_data.dart';
import '../../domain/models/skill.dart';

class BentoHeroSection extends StatefulWidget {
  final VoidCallback? onViewProjects;

  const BentoHeroSection({super.key, this.onViewProjects});

  @override
  State<BentoHeroSection> createState() => _BentoHeroSectionState();
}

class _BentoHeroSectionState extends State<BentoHeroSection>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

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
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );

    _itemOpacities = _itemControllers
        .map(
          (c) => Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: c, curve: Curves.easeOut),
          ),
        )
        .toList();

    _itemSlides = _itemControllers
        .map(
          (c) => Tween<Offset>(
            begin: const Offset(0, 0.1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: c, curve: Curves.easeOutCubic),
          ),
        )
        .toList();

    _fadeController.forward();
    for (int i = 0; i < 3; i++) {
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
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: AppSpacing.section,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeTransition(
                opacity: _fadeAnim,
                child: _buildIntroHeader(context),
              ),
              SizedBox(height: isMobile ? AppSpacing.xl : AppSpacing.xxl),
              if (isDesktop)
                _buildStaggeredCard(0, _buildBentoRow())
              else ...[
                _buildStaggeredCard(0, _buildAboutCard()),
                const SizedBox(height: AppSpacing.lg),
                _buildStaggeredCard(1, _buildConnectCard()),
              ],
              const SizedBox(height: AppSpacing.lg),
              _buildStaggeredCard(isDesktop ? 1 : 2, _buildStatsBar()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroHeader(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _StatusPill(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PulsingDot(),
                  SizedBox(width: 8),
                  Text(
                    'Available for Internships',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              borderColor: AppColors.success,
              backgroundColor: Color(0x1410B981),
            ),
          ],
        ),
        SizedBox(height: isMobile ? AppSpacing.lg : AppSpacing.xl),
        Text(
          "Hi, I'm Sakshi —",
          style: AppTypography.displayLarge.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.12,
            fontSize: isMobile ? 32 : 44,
          ),
        ),
        const SizedBox(height: 6),
        RollingText(
          texts: const [
            'Flutter Developer.',
            'Mobile Engineer.',
            'Clean Arch Enthusiast.',
            'UI Craftsperson.',
          ],
          style: AppTypography.displayLarge.copyWith(
            color: AppColors.accentCyan,
            fontWeight: FontWeight.w700,
            height: 1.12,
            fontSize: isMobile ? 32 : 44,
          ),
          switchInterval: const Duration(seconds: 2),
          animDuration: const Duration(milliseconds: 420),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Turning ideas into beautiful, responsive apps where thoughtful design meets clean code.',
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
            fontSize: isMobile ? 15 : 17,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _HeroOutlinedButton(
              label: "Let's Connect",
              icon: Icons.arrow_outward_rounded,
              accent: true,
              onPressed: () =>
                  _launchUrl('mailto:sakshi.vishnoi3107@gmail.com'),
            ),
            _HeroOutlinedButton(
              label: 'View Projects',
              onPressed: widget.onViewProjects,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildAboutCard()),
        const SizedBox(width: AppSpacing.lg),
        Expanded(flex: 2, child: _buildConnectCard()),
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

  Widget _sectionLabel(String index, String title) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '[ $index ] ',
            style: AppTypography.overline.copyWith(
              color: AppColors.textMuted,
              fontSize: 11,
              letterSpacing: 1.4,
            ),
          ),
          TextSpan(
            text: title,
            style: AppTypography.overline.copyWith(
              color: AppColors.textMuted,
              fontSize: 11,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Skill _aboutSkill(String name) => PortfolioData.skills.firstWhere(
        (s) => s.name == name,
        orElse: () => Skill(name: name, category: 'Mobile Development'),
      );

  Widget _buildAboutCard() {
    final isDesktop = Responsive.isDesktop(context);
    final avatarSize = isDesktop ? 88.0 : 72.0;

    final aboutChips = [
      _aboutSkill('Flutter'),
      _aboutSkill('Dart'),
      _aboutSkill('Riverpod'),
      _aboutSkill('Firebase'),
      _aboutSkill('Clean Architecture'),
    ];

    return BentoCard(
      padding: EdgeInsets.all(isDesktop ? 32 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PortfolioAvatar(
            size: avatarSize,
            borderRadius: isDesktop ? 18 : 16,
          ),
          SizedBox(height: isDesktop ? 24 : 20),
          Text(
            'About me.',
            style: AppTypography.headlineLarge.copyWith(
              fontSize: isDesktop ? 30 : 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          SizedBox(height: isDesktop ? 20 : 16),
          _AboutBioParagraph(chips: aboutChips, isDesktop: isDesktop),
          SizedBox(height: isDesktop ? 28 : 24),
          _AboutConnectButton(
            onPressed: () =>
                _launchUrl('mailto:sakshi.vishnoi3107@gmail.com'),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectCard() {
    final isDesktop = Responsive.isDesktop(context);

    return BentoCard(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _sectionLabel('02', 'CONNECT'),
          const SizedBox(height: AppSpacing.lg),
          _buildConnectGrid(isDesktop: isDesktop),
        ],
      ),
    );
  }

  Widget _buildConnectGrid({required bool isDesktop}) {
    const gridSpacing = 10.0;
    final maxCellSize = isDesktop ? 68.0 : 80.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;

        final cellByWidth = (maxW - gridSpacing) / 2;
        final cellSize = cellByWidth > maxCellSize ? maxCellSize : cellByWidth;

        if (cellSize <= 0) {
          return const SizedBox.shrink();
        }

        final gridExtent = cellSize * 2 + gridSpacing;

        return Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: gridExtent,
            height: gridExtent,
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: gridSpacing,
              mainAxisSpacing: gridSpacing,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisExtent: cellSize,
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
                    'https://www.linkedin.com/in/sakshi-vishnoi-7770b2315/',
                  ),
                ),
                _buildSocialTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  color: AppColors.accentCyan,
                  onTap: () =>
                      _launchUrl('mailto:sakshi.vishnoi3107@gmail.com'),
                ),
                _buildSocialTile(
                  icon: Icons.description_outlined,
                  label: 'Resume',
                  color: AppColors.accentViolet,
                  onTap: launchResume,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsBar() {
    final isMobile = Responsive.isMobile(context);
    final projectCount = PortfolioData.projects.length;

    final stats = [
      _StatItem(
        value: CountUpText(
          end: 400,
          suffix: '+',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        label: 'LEETCODE PROBLEMS',
      ),
      _StatItem(
        value: CountUpText(
          end: 9.0,
          decimals: 1,
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.accentCyan,
          ),
        ),
        label: 'CGPA',
      ),
      _StatItem(
        value: CountUpText(
          end: projectCount.toDouble(),
          suffix: '+',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        label: 'LIVE PROJECTS',
      ),
      _StatItem(
        value: Text(
          'Ghaziabad, IN',
          style: AppTypography.titleMedium.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        label: 'GMT +5:30',
      ),
    ];

    return BentoCard(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 20 : 28,
        horizontal: isMobile ? 12 : 8,
      ),
      child: isMobile
          ? Column(
              children: [
                for (var i = 0; i < stats.length; i++) ...[
                  if (i > 0)
                    Divider(
                      color: AppColors.border.withValues(alpha: 0.6),
                      height: 28,
                    ),
                  stats[i],
                ],
              ],
            )
          : Row(
              children: [
                for (var i = 0; i < stats.length; i++) ...[
                  if (i > 0)
                    Container(
                      width: 1,
                      height: 56,
                      color: AppColors.border.withValues(alpha: 0.7),
                    ),
                  Expanded(child: stats[i]),
                ],
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

class _StatItem extends StatelessWidget {
  final Widget value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          value,
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.overline.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final Widget? child;
  final String? label;
  final Color borderColor;
  final Color backgroundColor;
  final Color? labelColor;

  const _StatusPill({
    this.child,
    this.label,
    required this.borderColor,
    required this.backgroundColor,
    this.labelColor,
  }) : assert(child != null || label != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
        border: Border.all(color: borderColor.withValues(alpha: 0.45)),
      ),
      child: child ??
          Text(
            label!,
            style: TextStyle(
              color: labelColor ?? AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
    );
  }
}

class _AboutBioParagraph extends StatelessWidget {
  final List<Skill> chips;
  final bool isDesktop;

  const _AboutBioParagraph({
    required this.chips,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final base = AppTypography.bodyLarge.copyWith(
      color: AppColors.textPrimary,
      fontSize: isDesktop ? 16 : 15,
      height: 1.65,
      fontWeight: FontWeight.w400,
    );
    final bold = base.copyWith(fontWeight: FontWeight.w700);

    return Wrap(
      spacing: 6,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('I build production-ready ', style: base),
        Text('mobile', style: bold),
        Text(' and ', style: base),
        Text('AI', style: bold),
        Text(' apps using ', style: base),
        for (var i = 0; i < chips.length; i++) ...[
          _InlineTechChip(skill: chips[i], paletteIndex: i),
        ],
        Text(' — focused on clean UX and real user impact.', style: base),
      ],
    );
  }
}

class _InlineTechChip extends StatelessWidget {
  final Skill skill;
  final int paletteIndex;

  const _InlineTechChip({
    required this.skill,
    required this.paletteIndex,
  });

  @override
  Widget build(BuildContext context) {
    final accent = skillAccentColor(skill, paletteIndex: paletteIndex);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A22),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (skill.iconUrl != null) ...[
            SizedBox(
              width: 14,
              height: 14,
              child: SvgPicture.network(
                skill.iconUrl!,
                width: 14,
                height: 14,
                placeholderBuilder: (_) => Icon(
                  Icons.code,
                  size: 12,
                  color: accent,
                ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            skill.name,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutConnectButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const _AboutConnectButton({this.onPressed});

  @override
  State<_AboutConnectButton> createState() => _AboutConnectButtonState();
}

class _AboutConnectButtonState extends State<_AboutConnectButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFE8E8E8) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.send_rounded,
                size: 16,
                color: Colors.black.withValues(alpha: _hovered ? 0.75 : 1),
              ),
              const SizedBox(width: 10),
              Text(
                "Let's Connect",
                style: AppTypography.labelLarge.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroOutlinedButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool accent;
  final VoidCallback? onPressed;

  const _HeroOutlinedButton({
    required this.label,
    this.icon,
    this.accent = false,
    this.onPressed,
  });

  @override
  State<_HeroOutlinedButton> createState() => _HeroOutlinedButtonState();
}

class _HeroOutlinedButtonState extends State<_HeroOutlinedButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        widget.accent ? AppColors.accentCyan : AppColors.border;
    final fgColor =
        widget.accent ? AppColors.accentCyan : AppColors.textPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered
                ? (widget.accent
                    ? AppColors.accentCyan.withValues(alpha: 0.1)
                    : AppColors.surfaceElevated.withValues(alpha: 0.6))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered && widget.accent
                  ? AppColors.accentCyan
                  : borderColor.withValues(alpha: 0.8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: AppTypography.labelLarge.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.icon != null) ...[
                const SizedBox(width: 8),
                Icon(widget.icon, size: 16, color: fgColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

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
            width: 7,
            height: 7,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 72;
        final iconSize = compact ? 18.0 : 22.0;
        final labelSize = compact ? 10.0 : 11.0;

        return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              width: double.infinity,
              height: double.infinity,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: _hovered
                    ? widget.color.withValues(alpha: 0.1)
                    : AppColors.background.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(compact ? 10 : 14),
                border: Border.all(
                  color: _hovered
                      ? widget.color.withValues(alpha: 0.35)
                      : AppColors.border.withValues(alpha: 0.55),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color:
                        _hovered ? widget.color : AppColors.textSecondary,
                    size: iconSize,
                  ),
                  SizedBox(height: compact ? 4 : 6),
                  Text(
                    widget.label,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: labelSize,
                      fontWeight: FontWeight.w600,
                      color: _hovered ? widget.color : AppColors.textMuted,
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
