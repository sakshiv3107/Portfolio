import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/utils/responsive.dart';
import '../../../shared/widgets/nav_bar.dart';
import '../../../shared/widgets/footer.dart';
import 'widgets/bento_hero_section.dart';
import 'widgets/skills_section.dart';
import 'widgets/experience_section.dart';
import 'widgets/projects_section.dart';
import 'widgets/github_section.dart';

import 'widgets/contact_section.dart';

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

  bool _showMobileMenu = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = !Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Ambient atmospheric glow orbs ─────────────────────────────────
          Positioned(
            top: -120,
            left: -100,
            child: RepaintBoundary(
              child: IgnorePointer(
                child: _GlowOrb(
                  size: 500,
                  color: AppColors.accentViolet.withValues(alpha: 0.10),
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            right: -150,
            child: RepaintBoundary(
              child: IgnorePointer(
                child: _GlowOrb(
                  size: 420,
                  color: AppColors.accentCyan.withValues(alpha: 0.07),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 300,
            left: -80,
            child: RepaintBoundary(
              child: IgnorePointer(
                child: _GlowOrb(
                  size: 360,
                  color: AppColors.accentCyan.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),

          // ── Main UI column ─────────────────────────────────────────────────
          Column(
            children: [
              NavBar(
                sectionKeys: _sectionKeys,
                scrollController: _scrollController,
                isMenuOpen: _showMobileMenu,
                onMenuToggle: () =>
                    setState(() => _showMobileMenu = !_showMobileMenu),
              ),

              // Mobile nav drawer
              if (isMobile && _showMobileMenu) _buildMobileMenu(),

              // Main scroll content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: Column(
                    children: [
                      // Bento Hero (replaces old HeroSection + AboutSection)
                      SizedBox(
                        key: _sectionKeys[0],
                        child: const RepaintBoundary(child: BentoHeroSection()),
                      ),

                      // Skills
                      SizedBox(
                        key: _sectionKeys[2],
                        child: const RepaintBoundary(child: SkillsSection()),
                      ),

                      // Experience
                      SizedBox(
                        key: _sectionKeys[3],
                        child: const RepaintBoundary(child: ExperienceSection()),
                      ),

                      // Projects
                      SizedBox(
                        key: _sectionKeys[4],
                        child: const RepaintBoundary(child: ProjectsSection()),
                      ),

                      // GitHub
                      SizedBox(
                        key: _sectionKeys[5],
                        child: const RepaintBoundary(child: GitHubSection()),
                      ),


                      // Contact
                      SizedBox(
                        key: _sectionKeys[8],
                        child: const RepaintBoundary(child: ContactSection()),
                      ),

                      // Footer
                      const Footer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileMenu() {
    final navItems = [
      ('About', 1),
      ('Skills', 2),
      ('Experience', 3),
      ('Projects', 4),
      ('GitHub', 5),
      ('Contact', 8),
    ];

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: navItems.map((item) {
          return InkWell(
            onTap: () {
              setState(() => _showMobileMenu = false);
              final key = _sectionKeys[item.$2];
              final ctx = key.currentContext;
              if (ctx != null) {
                Scrollable.ensureVisible(
                  ctx,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppSpacing.sm + 4),
              child: Text(
                item.$1,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

