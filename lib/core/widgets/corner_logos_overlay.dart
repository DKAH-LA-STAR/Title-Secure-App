import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Overlays the Title Secure official logo watermark in all four corners of the screen:
/// - Top-Left
/// - Top-Right
/// - Bottom-Left
/// - Bottom-Right
///
/// Designed with [IgnorePointer] so it never intercepts user touch events.
/// Uses smooth rounded corners and visible opacity tailored for dark and light modes.
class CornerLogosOverlay extends StatelessWidget {
  final Widget child;
  final double logoSize;
  final double? opacity;
  final EdgeInsets padding;

  const CornerLogosOverlay({
    super.key,
    required this.child,
    this.logoSize = 68,
    this.opacity,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveOpacity = opacity ?? (isDark ? 0.22 : 0.18);

    final cornerLogo = IgnorePointer(
      child: Opacity(
        opacity: effectiveOpacity,
        child: Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/app_logo.png',
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/app_logo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(
                Icons.shield_rounded,
                size: logoSize,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ),
    );

    return Stack(
      children: [
        // Screen content
        child,

        // ── Top-Left Corner ──────────────────────────────────────────
        Positioned(
          top: padding.top,
          left: padding.left,
          child: cornerLogo,
        ),

        // ── Top-Right Corner ─────────────────────────────────────────
        Positioned(
          top: padding.top,
          right: padding.right,
          child: cornerLogo,
        ),

        // ── Bottom-Left Corner ───────────────────────────────────────
        Positioned(
          bottom: padding.bottom,
          left: padding.left,
          child: cornerLogo,
        ),

        // ── Bottom-Right Corner ──────────────────────────────────────
        Positioned(
          bottom: padding.bottom,
          right: padding.right,
          child: cornerLogo,
        ),
      ],
    );
  }
}
