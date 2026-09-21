import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Circular gauge displaying an OCR confidence percentage.
///
/// The arc is drawn using [CustomPainter] and animates from 0 to [score]
/// on first build.
class ConfidenceIndicator extends StatefulWidget {
  final double score; // 0.0 – 1.0
  final double size;
  final bool showLabel;

  const ConfidenceIndicator({
    super.key,
    required this.score,
    this.size = 80,
    this.showLabel = true,
  });

  @override
  State<ConfidenceIndicator> createState() => _ConfidenceIndicatorState();
}

class _ConfidenceIndicatorState extends State<ConfidenceIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = Tween<double>(begin: 0, end: widget.score.clamp(0.0, 1.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _color {
    final s = widget.score;
    if (s >= 0.8) return AppColors.success;
    if (s >= 0.5) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (_, __) => CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _GaugePainter(
              value: _animation.value,
              color: _color,
              trackColor: AppColors.surfaceVariant,
            ),
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Center(
                child: Text(
                  '${(_animation.value * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: _color,
                    fontSize: widget.size * 0.22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (widget.showLabel) ...[
          const SizedBox(height: 6),
          const Text(
            'Confidence',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final Color trackColor;

  _GaugePainter({
    required this.value,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const startAngle = -math.pi / 2;
    const fullSweep = 2 * math.pi;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = trackColor;

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..color = color;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fullSweep,
      false,
      trackPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fullSweep * value,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value || old.color != color;
}
