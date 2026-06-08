import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/responsive.dart';
import '../../shared/widgets/section_header.dart';
import 'contact_form_widget.dart';
import 'contact_info_widget.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  void _onVisible(VisibilityInfo info) {
    if (_hasAnimated || info.visibleFraction < 0.1) return;
    _hasAnimated = true;
    _entryCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return VisibilityDetector(
      key: const Key('contact-section'),
      onVisibilityChanged: _onVisible,
      child: Container(
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
            child: AnimatedBuilder(
              animation: _entryCtrl,
              builder: (context, child) {
                final t = Curves.easeOutQuart.transform(
                  _entryCtrl.value.clamp(0.0, 1.0),
                );
                return Opacity(
                  opacity: t,
                  child: Transform.translate(
                    offset: Offset(0, 40 * (1 - t)),
                    child: child,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    overline: "Let's Talk",
                    title: 'Get In Touch.',
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Have a project in mind, or just want to say hi? My inbox is always open.',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 13,
                      color: const Color(0xFF6B7A8D),
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 56),
                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _staggered(
                              delay: 0.0,
                              child: const ContactInfoWidget(),
                            ),
                            const SizedBox(height: 48),
                            _staggered(
                              delay: 0.15,
                              child: const ContactFormWidget(),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: _staggered(
                                delay: 0.0,
                                child: const ContactInfoWidget(),
                              ),
                            ),
                            const SizedBox(width: 56),
                            Expanded(
                              flex: 6,
                              child: _staggered(
                                delay: 0.15,
                                child: const ContactFormWidget(),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Wraps a child with a staggered fade+slide animation driven by _entryCtrl.
  Widget _staggered({required double delay, required Widget child}) {
    return AnimatedBuilder(
      animation: _entryCtrl,
      builder: (context, _) {
        final rawT = (_entryCtrl.value - delay) / (1.0 - delay);
        final t = Curves.easeOutQuart
            .transform(rawT.clamp(0.0, 1.0));
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }
}
