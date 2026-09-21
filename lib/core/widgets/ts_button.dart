import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum TsButtonVariant { primary, secondary, danger, ghost, gold }

/// Full-width gradient or solid button with loading state.
///
/// - [primary]: amber/gold gradient (default)
/// - [gold]: rich metallic gold gradient or solid
/// - [secondary]: teal gradient
/// - [danger]: red gradient
/// - [ghost]: transparent with primary border
class TsButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final TsButtonVariant variant;
  final double height;
  final double borderRadius;
  final double? width;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color? textColor;

  const TsButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = TsButtonVariant.primary,
    this.height = 52,
    this.borderRadius = 50,
    this.width,
    this.backgroundColor,
    this.gradient,
    this.textColor,
  });

  const TsButton.primary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double height = 52,
    double borderRadius = 50,
    double? width,
    Color? backgroundColor,
    Gradient? gradient,
    Color? textColor,
  }) : this(
          key: key,
          text: label,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
          variant: TsButtonVariant.primary,
          height: height,
          borderRadius: borderRadius,
          width: width,
          backgroundColor: backgroundColor,
          gradient: gradient,
          textColor: textColor,
        );

  const TsButton.gold({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double height = 52,
    double borderRadius = 50,
    double? width,
    Color? backgroundColor,
    Gradient? gradient,
    Color? textColor,
  }) : this(
          key: key,
          text: label,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
          variant: TsButtonVariant.gold,
          height: height,
          borderRadius: borderRadius,
          width: width,
          backgroundColor: backgroundColor,
          gradient: gradient,
          textColor: textColor,
        );

  const TsButton.secondary({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double height = 52,
    double borderRadius = 50,
    double? width,
    Color? backgroundColor,
    Gradient? gradient,
    Color? textColor,
  }) : this(
          key: key,
          text: label,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
          variant: TsButtonVariant.secondary,
          height: height,
          borderRadius: borderRadius,
          width: width,
          backgroundColor: backgroundColor,
          gradient: gradient,
          textColor: textColor,
        );

  const TsButton.outline({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    double height = 52,
    double borderRadius = 50,
    double? width,
  }) : this(
          key: key,
          text: label,
          onPressed: onPressed,
          isLoading: isLoading,
          icon: icon,
          variant: TsButtonVariant.ghost,
          height: height,
          borderRadius: borderRadius,
          width: width,
        );

  Gradient get _effectiveGradient {
    if (gradient != null) return gradient!;
    switch (variant) {
      case TsButtonVariant.secondary:
        return AppColors.secondaryGradient;
      case TsButtonVariant.danger:
        return AppColors.dangerGradient;
      case TsButtonVariant.gold:
        return AppColors.goldGradient;
      case TsButtonVariant.primary:
      case TsButtonVariant.ghost:
        return AppColors.primaryGradient;
    }
  }

  Color get _effectiveTextColor {
    if (textColor != null) return textColor!;
    switch (variant) {
      case TsButtonVariant.ghost:
        return AppColors.primary;
      case TsButtonVariant.gold:
        return AppColors.onGold;
      default:
        return AppColors.onPrimary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = isLoading || onPressed == null;

    if (variant == TsButtonVariant.ghost) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: isDisabled
                  ? AppColors.textDisabled
                  : (backgroundColor ?? AppColors.primary),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          child: _buildChild(),
        ),
      );
    }

    final effectiveColor = gradient == null && backgroundColor != null ? backgroundColor : null;
    final effectiveGrad = backgroundColor == null ? _effectiveGradient : gradient;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: effectiveColor,
            gradient: effectiveGrad,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: isDisabled
                ? null
                : [
                    BoxShadow(
                      color: (backgroundColor ?? AppColors.gold).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: ElevatedButton(
            onPressed: isDisabled ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              foregroundColor: _effectiveTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              minimumSize: Size(width ?? double.infinity, height),
              padding: EdgeInsets.zero,
            ),
            child: _buildChild(),
          ),
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: variant == TsButtonVariant.ghost
              ? AppColors.primary
              : _effectiveTextColor,
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: _effectiveTextColor),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _effectiveTextColor,
          ),
        ),
      ],
    );
  }
}
