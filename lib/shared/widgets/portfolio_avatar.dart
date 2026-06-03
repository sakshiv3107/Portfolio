import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

/// Avatar image that works on Flutter Web ([web/images/]) and other platforms (assets).
ImageProvider portfolioAvatarProvider() {
  if (kIsWeb) {
    return NetworkImage(
      Uri.base.resolve(AppAssets.avatarWebPath).toString(),
    );
  }
  return const AssetImage(AppAssets.avatar);
}

class PortfolioAvatar extends StatelessWidget {
  final double size;
  final double borderRadius;

  const PortfolioAvatar({
    super.key,
    this.size = 72,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 1),
        child: Image(
          image: portfolioAvatarProvider(),
          width: size,
          height: size,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => ColoredBox(
            color: AppColors.surfaceElevated,
            child: Center(
              child: Text(
                'SV',
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.accentCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
