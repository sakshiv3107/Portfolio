import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/constants/app_spacing.dart';

class SectionHeader extends StatelessWidget {
  final String overline;
  final String title;

  const SectionHeader({
    super.key,
    required this.overline,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '// $overline'.toUpperCase(),
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11,
            color: const Color(0x993B82F6),
            letterSpacing: 2.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.syne(
            fontSize: 52,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -1.04,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 40,
          height: 3,
          color: AppColors.accentCyan,
        ),
      ],
    );
  }
}
