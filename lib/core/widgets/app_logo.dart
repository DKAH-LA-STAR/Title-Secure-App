import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// App logo widget for Title Secure.
/// Displays the official gold shield logo badge with subtle glow and rounded corners.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showGlow;
  final BorderRadius? borderRadius;

  const AppLogo({
    super.key,
    this.size = 80,
    this.showGlow = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(size * 0.22);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: showGlow
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: isDark ? 0.35 : 0.25),
                  blurRadius: size * 0.3,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Image.asset(
          'assets/images/app_logo.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildVectorLogoFallback(isDark),
        ),
      ),
    );
  }

  /// Elegant vector shield fallback if the image asset is not loaded in unit tests.
  Widget _buildVectorLogoFallback(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F172A), const Color(0xFF0A0E1A)]
              : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.shield_rounded,
              color: AppColors.primary,
              size: size * 0.65,
            ),
            Positioned(
              bottom: size * 0.22,
              right: size * 0.22,
              child: Container(
                padding: EdgeInsets.all(size * 0.04),
                decoration: const BoxDecoration(
                  color: AppColors.primaryDark,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: size * 0.26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
