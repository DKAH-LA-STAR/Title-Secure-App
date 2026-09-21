import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';

/// Animated shield icon with amber glow — shown for verified land titles.
class ShieldVerifiedBadge extends StatelessWidget {
  final double size;
  final bool animate;
  final String? label;

  const ShieldVerifiedBadge({
    super.key,
    this.size = 80,
    this.animate = true,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    Widget shield = Stack(
      alignment: Alignment.center,
      children: [
        // Glow backdrop
        Container(
          width: size * 1.4,
          height: size * 1.4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: size * 0.5,
                spreadRadius: size * 0.1,
              ),
            ],
          ),
        ),
        // Shield background
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFF1F2937), Color(0xFF111827)],
            ),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.verified_user_rounded,
            color: AppColors.primary,
            size: size * 0.5,
          ),
        ),
      ],
    );

    if (animate) {
      shield = shield
          .animate(onPlay: (c) => c.repeat())
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.04, 1.04),
            duration: 1500.ms,
            curve: Curves.easeInOut,
          )
          .then()
          .scale(
            begin: const Offset(1.04, 1.04),
            end: const Offset(1.0, 1.0),
            duration: 1500.ms,
            curve: Curves.easeInOut,
          );
    }

    if (label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          shield,
          const SizedBox(height: 8),
          Text(
            label!,
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return shield;
  }
}
