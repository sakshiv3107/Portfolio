import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/widgets/section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(overline: 'Who I Am', title: 'About Me.'),
              const SizedBox(height: AppSpacing.xxl),

              isMobile
                  ? _buildMobileLayout()
                  : _buildDesktopLayout(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _buildBio()),
        const SizedBox(width: AppSpacing.xxxl),
        Expanded(flex: 2, child: _buildSidebar()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBio(),
        const SizedBox(height: AppSpacing.xxl),
        _buildSidebar(),
      ],
    );
  }

  Widget _buildBio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I build cross-platform mobile and web applications with Flutter and Dart, '
          'focusing on clean architecture, intuitive UX, and real-world impact.',
          style: AppTypography.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Currently pursuing B.Tech IT at ABES Engineering College (CGPA 9.0), '
          'graduating July 2027. I love turning complex problems into elegant, '
          'performant mobile experiences.',
          style: AppTypography.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'When I\'m not coding, you\'ll find me solving DSA problems, '
          'designing graphics for GDG/CodeChef events, or exploring new AI integrations '
          'in Flutter.',
          style: AppTypography.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _InfoRow(
          icon: Icons.location_on_outlined,
          label: 'Ghaziabad, India',
        ),
        const SizedBox(height: AppSpacing.md),
        _InfoRow(
          icon: Icons.school_outlined,
          label: 'ABES Engineering College',
        ),
        const SizedBox(height: AppSpacing.md),
        _InfoRow(
          icon: Icons.star_outline_rounded,
          label: 'CGPA: 9.0 | Jul 2027',
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'FIND ME ON',
          style: AppTypography.overline,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _SocialChip(
              icon: FontAwesomeIcons.github,
              label: 'sakshiv3107',
              onTap: () => _launch('https://github.com/sakshiv3107'),
            ),
            _SocialChip(
              icon: FontAwesomeIcons.linkedin,
              label: 'LinkedIn',
              onTap: () => _launch(
                  'https://www.linkedin.com/in/sakshi-vishnoi-7770b2315/'),
            ),
            _SocialChip(
              icon: Icons.code_rounded,
              label: 'LeetCode',
              onTap: () =>
                  _launch('https://leetcode.com/u/sakshiv31/'),
            ),
            _SocialChip(
              icon: Icons.email_outlined,
              label: 'Email',
              onTap: () =>
                  _launch('mailto:sakshi.vishnoi3107@gmail.com'),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accentCyan),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodyMedium,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}

class _SocialChip extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip> {
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accentCyan.withOpacity(0.1)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? AppColors.accentCyan : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: _hovered ? AppColors.accentCyan : AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: AppTypography.bodySmall.copyWith(
                  color: _hovered
                      ? AppColors.accentCyan
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

