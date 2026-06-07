import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pagePaddingDesktop,
        vertical: AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialIcon(
                icon: FontAwesomeIcons.github,
                tooltip: 'GitHub',
                onTap: () => _launch('https://github.com/sakshiv3107'),
              ),
              const SizedBox(width: AppSpacing.lg),
              _SocialIcon(
                icon: FontAwesomeIcons.linkedin,
                tooltip: 'LinkedIn',
                onTap: () => _launch(
                    'https://www.linkedin.com/in/sakshi-vishnoi-7770b2315/'),
              ),
              const SizedBox(width: AppSpacing.lg),
              _SocialIcon(
                icon: Icons.email_outlined,
                tooltip: 'Email',
                onTap: () =>
                    _launch('mailto:sakshi.vishnoi3107@gmail.com'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '© 2025 Sakshi Vishnoi — Built with Flutter ❤️',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Designed with the Dark Precision theme',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMuted.withOpacity(0.6),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialIcon({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Tooltip(
        message: widget.tooltip,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.accentCyan.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _hovered ? AppColors.accentCyanMuted : Colors.transparent,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: _hovered ? AppColors.accentCyan : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
