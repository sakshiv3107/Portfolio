import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _opacities;
  late List<Animation<Offset>> _slides;

  final int _itemCount = 5;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _itemCount,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
    _opacities = _controllers
        .map(
          (c) => Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(parent: c, curve: Curves.easeOut),
          ),
        )
        .toList();
    _slides = _controllers
        .map(
          (c) => Tween<Offset>(
            begin: const Offset(0, 0.15),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: c, curve: Curves.easeOut),
          ),
        )
        .toList();

    // Staggered delays
    for (int i = 0; i < _itemCount; i++) {
      Future.delayed(Duration(milliseconds: 100 + i * 120), () {
        if (mounted) _controllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _launchEmail() async {
    final uri = Uri.parse('mailto:sakshi.vishnoi3107@gmail.com');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _downloadResume() async {
    // [CUSTOMIZE: replace with real hosted URL]
    final uri = Uri.parse('assets/resume_sakshi_verma.pdf');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Widget _animated(int index, Widget child) {
    return FadeTransition(
      opacity: _opacities[index],
      child: SlideTransition(
        position: _slides[index],
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding(context),
        vertical: AppSpacing.section,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0D1526), AppColors.background],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: isMobile
              ? _buildMobileLayout()
              : _buildDesktopLayout(),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _buildTextContent()),
        const SizedBox(width: AppSpacing.xxl),
        _buildAvatar(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAvatar(),
        const SizedBox(height: AppSpacing.xxl),
        _buildTextContent(centered: true),
      ],
    );
  }

  Widget _buildTextContent({bool centered = false}) {
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        // Greeting
        _animated(
          0,
          Text(
            '// Hello, world.',
            style: AppTypography.code.copyWith(fontSize: 14),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Name
        _animated(
          1,
          Text(
            "I'm Sakshi Vishnoi.",
            style: AppTypography.displayLarge,
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Tagline
        _animated(
          2,
          Text(
            'Building polished Flutter apps —\none widget at a time.',
            style: AppTypography.bodyLarge.copyWith(fontSize: 18),
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Badge
        _animated(
          3,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accentCyan.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppSpacing.pillRadius),
              border: Border.all(color: AppColors.accentCyan.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accentCyan,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Open to Internships',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.accentCyan,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // CTA Buttons
        _animated(
          4,
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            alignment: centered ? WrapAlignment.center : WrapAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: _launchEmail,
                icon: const Icon(Icons.arrow_outward_rounded, size: 18),
                label: const Text("Let's Connect"),
              ),
              OutlinedButton.icon(
                onPressed: _downloadResume,
                icon: const Icon(Icons.download_rounded, size: 18),
                label: const Text('Download Resume'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return _animated(
      0,
      Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.accentCyan, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentCyan.withOpacity(0.2),
              blurRadius: 24,
              spreadRadius: 4,
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 72,
          backgroundColor: AppColors.surface,
          child: Text(
            'SV',
            style: AppTypography.displayMedium.copyWith(
              color: AppColors.accentCyan,
              fontSize: 36,
            ),
          ),
          // [CUSTOMIZE: Replace with actual image]
          // backgroundImage: AssetImage('assets/images/avatar.jpg'),
        ),
      ),
    );
  }
}

