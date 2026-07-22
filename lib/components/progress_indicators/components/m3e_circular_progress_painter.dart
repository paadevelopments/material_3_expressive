import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Paints the track and active arc of a classic circular progress indicator.
class M3ECircularProgressPainter extends CustomPainter {
  const M3ECircularProgressPainter({
    required this.trackColor,
    required this.activeColor,
    required this.strokeWidth,
    required this.startAngle,
    required this.sweepAngle,
  });

  final Color trackColor;
  final Color activeColor;
  final double strokeWidth;
  final double startAngle;
  final double sweepAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = (size.shortestSide - strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    if (sweepAngle == 0) {
      return;
    }
    final Paint active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = activeColor;
    canvas.drawArc(rect, startAngle, sweepAngle, false, active);
  }

  @override
  bool shouldRepaint(M3ECircularProgressPainter oldDelegate) {
    return oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }

  /// A full turn in radians.
  static const double tau = 2 * math.pi;
}
