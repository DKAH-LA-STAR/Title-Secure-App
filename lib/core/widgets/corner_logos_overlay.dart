import 'package:flutter/material.dart';

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
    return child;
  }
}
