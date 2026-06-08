import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoWidget extends StatefulWidget {
  const ContactInfoWidget({super.key});

  @override
  State<ContactInfoWidget> createState() => _ContactInfoWidgetState();
}

class _ContactInfoWidgetState extends State<ContactInfoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static const _links = [
    (
      icon: FontAwesomeIcons.github,
      label: 'GitHub',
      value: 'sakshiv3107',
      url: 'https://github.com/sakshiv3107',
    ),
    (
      icon: FontAwesomeIcons.linkedin,
      label: 'LinkedIn',
      value: 'sakshi-vishnoi',
      url: 'https://www.linkedin.com/in/sakshi-vishnoi-7770b2315/',
    ),
    (
      icon: Icons.email_outlined,
      label: 'Email',
      value: 'vishnoisakshi31@gmail.com',
      url: 'mailto:vishnoisakshi31@gmail.com',
    ),
    (
      icon: Icons.code_rounded,
      label: 'LeetCode',
      value: 'sakshiv31',
      url: 'https://leetcode.com/u/sakshiv31/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Terminal-style heading
        Text(
          "// let's connect",
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            color: const Color(0xFF3B82F6),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Open to internship opportunities, freelance projects, and collabs.',
          style: GoogleFonts.jetBrainsMono(
            fontSize: 13,
            color: const Color(0xFF6B7A8D),
            height: 1.7,
          ),
        ),
        const SizedBox(height: 36),

        // Social links
        for (int i = 0; i < _links.length; i++) ...[
          _SocialLinkTile(
            icon: _links[i].icon,
            label: _links[i].label,
            value: _links[i].value,
            onTap: () => _launch(_links[i].url),
          ),
          if (i < _links.length - 1) const SizedBox(height: 12),
        ],

        const SizedBox(height: 36),

        // Availability badge
        AnimatedBuilder(
          animation: _pulseCtrl,
          builder: (context, child) {
            final glowOpacity = 0.08 + 0.12 * _pulseCtrl.value;
            final dotOpacity = 0.6 + 0.4 * _pulseCtrl.value;
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F1318),
                border: Border.all(
                  color: Color.lerp(
                    const Color(0x1A3B82F6),
                    const Color(0x553B82F6),
                    _pulseCtrl.value,
                  )!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(59, 130, 246, glowOpacity),
                    blurRadius: 20,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulsing ring
                      Opacity(
                        opacity: 0.3 * _pulseCtrl.value,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF00FF88),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      // Core dot
                      Opacity(
                        opacity: dotOpacity,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF00FF88),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available for Opportunities',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 12,
                            color: const Color(0xFFE8EDF5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Summer / Fall 2025 · Flutter & Mobile',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            color: const Color(0xFF6B7A8D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SocialLinkTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SocialLinkTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  State<_SocialLinkTile> createState() => _SocialLinkTileState();
}

class _SocialLinkTileState extends State<_SocialLinkTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0x0D3B82F6)
                : const Color(0xFF0F1318),
            border: Border.all(
              color: _hovered
                  ? const Color(0x663B82F6)
                  : const Color(0xFF1A2030),
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.icon,
                  size: 16,
                  color: _hovered
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF6B7A8D),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        color: const Color(0xFF6B7A8D),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.value,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 12,
                        color: _hovered
                            ? const Color(0xFF3B82F6)
                            : const Color(0xFFE8EDF5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.arrow_outward,
                  size: 13,
                  color: _hovered
                      ? const Color(0xFF3B82F6)
                      : const Color(0x4DE8EDF5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
