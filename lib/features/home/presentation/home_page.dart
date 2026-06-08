import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/portfolio_side_nav.dart';
import '../../../shared/widgets/footer.dart';
import 'widgets/bento_hero_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/experience_section.dart';
import 'widgets/github_section.dart';
import 'widgets/featured_projects/projects_section.dart' as featured;
import '../../../features/contact/contact_section.dart' as contact;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  // Section keys for scroll-to navigation
  final List<GlobalKey> _sectionKeys = List.generate(10, (_) => GlobalKey());

  // 0: hero, 1: about, 2: skills, 3: experience, 4: projects,
  // 5: github, 6: achievements, 7: blog, 8: contact

  void _scrollToSection(int index) {
    if (index >= _sectionKeys.length) return;
    final ctx = _sectionKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Main scroll content ───────────────────────────────────────────
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Column(
              children: [
                SizedBox(
                  key: _sectionKeys[0],
                  child: RepaintBoundary(
                    child: BentoHeroSection(
                      onViewProjects: () => _scrollToSection(4),
                    ),
                  ),
                ),
                SizedBox(
                  key: _sectionKeys[2],
                  child: const RepaintBoundary(child: SkillsSection()),
                ),
                SizedBox(
                  key: _sectionKeys[3],
                  child: const RepaintBoundary(child: ExperienceSection()),
                ),
                SizedBox(
                  key: _sectionKeys[4],
                  child: const RepaintBoundary(child: featured.ProjectsSection()),
                ),
                SizedBox(
                  key: _sectionKeys[5],
                  child: const RepaintBoundary(child: GitHubSection()),
                ),
                SizedBox(
                  key: _sectionKeys[8],
                  child: const RepaintBoundary(child: contact.ContactSection()),
                ),
                const Footer(),
              ],
            ),
          ),

          // ── Fixed left dock sidebar (desktop only) ────────────────────────
          Positioned(
            left: 20,
            top: 0,
            bottom: 0,
            child: IgnorePointer(
              ignoring: Responsive.isMobile(context),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  type: MaterialType.transparency,
                  child: PortfolioSideNav(
                    sectionKeys: _sectionKeys,
                    scrollController: _scrollController,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

