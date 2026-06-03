import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/resume_launcher.dart';
import '../../features/home/domain/data/portfolio_data.dart';

enum NavSection {
  about,
  skills,
  experience,
  projects,
  contact,
  resume,
}

class _NavEntry {
  final NavSection section;
  final int? sectionIndex;
  final IconData icon;
  final bool opensExternal;

  const _NavEntry({
    required this.section,
    required this.icon,
    this.sectionIndex,
    this.opensExternal = false,
  });
}

/// Fixed left vertical dock sidebar (desktop only).
class PortfolioSideNav extends StatefulWidget {
  final List<GlobalKey> sectionKeys;
  final ScrollController scrollController;

  const PortfolioSideNav({
    super.key,
    required this.sectionKeys,
    required this.scrollController,
  });

  @override
  State<PortfolioSideNav> createState() => _PortfolioSideNavState();
}

class _PortfolioSideNavState extends State<PortfolioSideNav> {
  static const double _dockWidth = 56;
  static const double _itemSize = 44;
  static const double _iconSize = 18;
  static const double _itemGap = 6;
  static const double _resumeGap = 10;

  static const List<_NavEntry> _mainEntries = [
    _NavEntry(
      section: NavSection.about,
      sectionIndex: 0,
      icon: FontAwesomeIcons.house,
    ),
    _NavEntry(
      section: NavSection.skills,
      sectionIndex: 2,
      icon: FontAwesomeIcons.code,
    ),
    _NavEntry(
      section: NavSection.experience,
      sectionIndex: 3,
      icon: FontAwesomeIcons.briefcase,
    ),
    _NavEntry(
      section: NavSection.projects,
      sectionIndex: 4,
      icon: FontAwesomeIcons.wandMagicSparkles,
    ),
    _NavEntry(
      section: NavSection.contact,
      sectionIndex: 8,
      icon: FontAwesomeIcons.envelope,
    ),
  ];

  static const _resumeEntry = _NavEntry(
    section: NavSection.resume,
    icon: FontAwesomeIcons.download,
  );

  NavSection? _activeSection = NavSection.about;
  NavSection? _hoveredItem;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    final next = _resolveActiveSection();
    if (next != _activeSection) {
      setState(() => _activeSection = next);
    }
  }

  NavSection? _resolveActiveSection() {
    final activationLine = MediaQuery.sizeOf(context).height * 0.35;

    NavSection? active;
    for (final entry in _mainEntries) {
      if (entry.opensExternal) continue;

      final index = entry.sectionIndex;
      if (index == null || index >= widget.sectionKeys.length) continue;

      final ctx = widget.sectionKeys[index].currentContext;
      if (ctx == null) continue;

      final renderObject = ctx.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) continue;

      final top = renderObject.localToGlobal(Offset.zero).dy;
      if (top <= activationLine) {
        active = entry.section;
      }
    }

    return active ?? NavSection.about;
  }

  bool _isActive(NavSection section) =>
      section != NavSection.resume && _activeSection == section;

  Color _getColor(NavSection item) {
    if (_isActive(item)) return AppColors.navIconActive;
    if (_hoveredItem == item) return AppColors.navIconHover;
    return AppColors.navIconDefault;
  }

  Future<void> _onItemTap(_NavEntry entry) async {
    if (entry.section == NavSection.resume) {
      await launchResume();
      return;
    }

    if (entry.opensExternal) {
      final uri = Uri.parse(
        'https://github.com/${PortfolioData.githubUsername}',
      );
      await launchUrl(uri, webOnlyWindowName: '_blank');
      return;
    }

    final index = entry.sectionIndex;
    if (index == null || index >= widget.sectionKeys.length) return;

    final ctx = widget.sectionKeys[index].currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return const SizedBox.shrink();
    }

    return Container(
      width: _dockWidth,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.navDockBackground,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.navDockBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < _mainEntries.length; i++) ...[
            _DockNavItem(
              icon: _mainEntries[i].icon,
              color: _getColor(_mainEntries[i].section),
              isActive: _isActive(_mainEntries[i].section),
              itemSize: _itemSize,
              iconSize: _iconSize,
              onTap: () => _onItemTap(_mainEntries[i]),
              onHoverChanged: (hovered) => setState(() {
                _hoveredItem = hovered ? _mainEntries[i].section : null;
              }),
            ),
            if (i < _mainEntries.length - 1) const SizedBox(height: _itemGap),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: _resumeGap),
            child: Container(
              width: 20,
              height: 1,
              color: AppColors.navDockBorder,
            ),
          ),
          _DockNavItem(
            icon: _resumeEntry.icon,
            color: _getColor(NavSection.resume),
            isActive: false,
            itemSize: _itemSize,
            iconSize: _iconSize,
            onTap: () => _onItemTap(_resumeEntry),
            onHoverChanged: (hovered) => setState(() {
              _hoveredItem = hovered ? NavSection.resume : null;
            }),
          ),
        ],
      ),
    );
  }
}

class _DockNavItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isActive;
  final double itemSize;
  final double iconSize;
  final VoidCallback onTap;
  final ValueChanged<bool> onHoverChanged;

  const _DockNavItem({
    required this.icon,
    required this.color,
    required this.isActive,
    required this.itemSize,
    required this.iconSize,
    required this.onTap,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
          width: itemSize,
          height: itemSize,
          decoration: BoxDecoration(
            color: isActive ? AppColors.navItemActiveBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<Color?>(
                duration: const Duration(milliseconds: 200),
                curve: Curves.ease,
                tween: ColorTween(end: color),
                builder: (context, animatedColor, _) => FaIcon(
                  icon,
                  size: iconSize,
                  color: animatedColor ?? AppColors.navIconDefault,
                ),
              ),
              if (isActive) ...[
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 14,
                  height: 2.5,
                  decoration: BoxDecoration(
                    color: AppColors.navIconActive,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
