import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/responsive.dart';

class NavBar extends StatefulWidget {
  final List<GlobalKey> sectionKeys;
  final ScrollController scrollController;
  final bool isMenuOpen;
  final VoidCallback onMenuToggle;

  const NavBar({
    super.key,
    required this.sectionKeys,
    required this.scrollController,
    required this.isMenuOpen,
    required this.onMenuToggle,
  });

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final List<_NavItem> _items = const [
    _NavItem(label: 'About', index: 1),
    _NavItem(label: 'Skills', index: 2),
    _NavItem(label: 'Experience', index: 3),
    _NavItem(label: 'Projects', index: 4),
    _NavItem(label: 'GitHub', index: 5),
    _NavItem(label: 'Contact', index: 8),
  ];

  void _scrollToSection(int index) {
    if (index < widget.sectionKeys.length) {
      final key = widget.sectionKeys[index];
      final ctx = key.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    }
    if (widget.isMenuOpen) widget.onMenuToggle();
  }

  Future<void> _downloadResume() async {
    const url = '/assets/resume_sakshi_verma.pdf';
    // [CUSTOMIZE: update with actual hosted resume URL]
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = !Responsive.isDesktop(context);

    return Container(
      height: AppSpacing.navHeight,
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.85),
        border: const Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: ClipRect(
        child: Stack(
          children: [
            // Blur effect simulation via semi-transparent overlay
            Container(color: AppColors.background.withOpacity(0.85)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.horizontalPadding(context),
              ),
              child: Row(
                children: [
                  // Logo / Name
                  GestureDetector(
                    onTap: () => widget.scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'sakshi',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextSpan(
                            text: '.dev',
                            style: AppTypography.titleMedium.copyWith(
                              color: AppColors.accentCyan,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),

                  if (!isMobile) ...[
                    // Desktop nav links
                    ..._items.map(
                      (item) => _NavLink(
                        label: item.label,
                        onTap: () => _scrollToSection(item.index),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    // Resume button
                    OutlinedButton.icon(
                      onPressed: _downloadResume,
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: const Text('Resume'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accentCyan,
                        side: const BorderSide(color: AppColors.accentCyan),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        textStyle: AppTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ] else ...[
                    // Mobile hamburger
                    IconButton(
                      icon: Icon(
                        widget.isMenuOpen ? Icons.close : Icons.menu,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: widget.onMenuToggle,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _underlineWidth;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _underlineWidth =
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _ctrl.forward(),
      onExit: (_) => _ctrl.reverse(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _ctrl,
                builder: (_, __) => Text(
                  widget.label,
                  style: AppTypography.labelLarge.copyWith(
                    color: Color.lerp(
                      AppColors.textSecondary,
                      AppColors.accentCyan,
                      _ctrl.value,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              AnimatedBuilder(
                animation: _underlineWidth,
                builder: (_, __) => Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 2,
                    width: 48 * _underlineWidth.value,
                    decoration: BoxDecoration(
                      color: AppColors.accentCyan,
                      borderRadius: BorderRadius.circular(2),
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

class _NavItem {
  final String label;
  final int index;

  const _NavItem({required this.label, required this.index});
}

// Mobile drawer menu
class MobileNavMenu extends StatelessWidget {
  final List<String> items;
  final ValueChanged<int> onItemTap;

  const MobileNavMenu({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Column(
        children: items
            .asMap()
            .entries
            .map(
              (e) => ListTile(
                title: Text(e.value, style: AppTypography.bodyMedium),
                onTap: () => onItemTap(e.key),
              ),
            )
            .toList(),
      ),
    );
  }
}
