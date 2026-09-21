import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';

/// Animated linear progress bar that colors based on risk level.
///
/// - Green   : score < 0.4
/// - Amber   : score 0.4 – 0.7
/// - Red     : score > 0.7
class RiskScoreBar extends StatelessWidget {
  final double score; // 0.0 – 1.0
  final bool showLabel;
  final double height;
  final String? label;

  const RiskScoreBar({
    super.key,
    required this.score,
    this.showLabel = true,
    this.height = 8,
    this.label,
  });

  Color get _barColor {
    if (score > 0.7) return AppColors.danger;
    if (score > 0.4) return AppColors.warning;
    return AppColors.success;
  }

  String get _riskLabel {
    if (score > 0.7) return 'High Risk';
    if (score > 0.4) return 'Medium Risk';
    return 'Low Risk';
  }

  @override
  Widget build(BuildContext context) {
    final clamped = score.clamp(0.0, 1.0);
    final percent = (clamped * 100).toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label ?? _riskLabel,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$percent%',
                  style: TextStyle(
                    color: _barColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: height,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(_barColor),
          ),
        ).animate().slideX(
              begin: -0.3,
              end: 0,
              duration: 600.ms,
              curve: Curves.easeOut,
            ),
      ],
    );
  }
}
