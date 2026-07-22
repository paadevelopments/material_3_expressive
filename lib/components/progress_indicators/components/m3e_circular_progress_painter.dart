import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Paints the track and active arc of a classic circular progress indicator.
class M3ECircularProgressPainter extends CustomPainter {
  const M3ECircularProgressPainter({
    required this.trackColor,
    required this.activeColor,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.startAngle,
    required this.sweepAngle,
    required this.gapSize,
    this.progress,
    this.stopSize,
  });

  final Color trackColor;
  final Color activeColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double startAngle;
  final double sweepAngle;
  final double gapSize;

  /// When non-null, paints determinate dual-gap track. Null = indeterminate.
  final double? progress;
  final double? stopSize;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double maxStroke = math.max(strokeWidth, trackStrokeWidth);
    final double radius = (size.shortestSide - maxStroke) / 2;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackStrokeWidth
      ..strokeCap = StrokeCap.round
      ..color = trackColor;

    final Paint activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = activeColor;

    final double? p = progress;
    if (p == null) {
      // Indeterminate: full track + spinning active arc.
      canvas.drawCircle(center, radius, trackPaint);
      if (sweepAngle != 0) {
        canvas.drawArc(rect, startAngle, sweepAngle, false, activePaint);
      }
      return;
    }

    // Determinate: stop at 12 o'clock, back gap, active, front gap, track.
    const double tau = 2 * math.pi;
    final double adjustedGap =
        gapSize + (strokeWidth + trackStrokeWidth) / 2;
    final double gapAngle = adjustedGap / radius;
    final double available = math.max(0.0, tau - 2 * gapAngle);
    final double activeSweep = p.clamp(0.0, 1.0) * available;
    final double activeStart = startAngle + gapAngle;
    final double trackStart = activeStart + activeSweep + gapAngle;
    final double trackSweep = available - activeSweep;

    if (trackSweep > 0) {
      canvas.drawArc(rect, trackStart, trackSweep, false, trackPaint);
    }
    if (activeSweep > 0) {
      canvas.drawArc(rect, activeStart, activeSweep, false, activePaint);
    }

    final double? stop = stopSize;
    if (stop != null && stop > 0 && p < 1.0) {
      final Offset stopCenter = Offset(
        center.dx + radius * math.cos(startAngle),
        center.dy + radius * math.sin(startAngle),
      );
      canvas.drawCircle(
        stopCenter,
        stop / 2,
        Paint()..color = activeColor,
      );
    }
  }

  @override
  bool shouldRepaint(M3ECircularProgressPainter oldDelegate) {
    return oldDelegate.startAngle != startAngle ||
        oldDelegate.sweepAngle != sweepAngle ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackStrokeWidth != trackStrokeWidth ||
        oldDelegate.gapSize != gapSize ||
        oldDelegate.progress != progress ||
        oldDelegate.stopSize != stopSize;
  }

  /// A full turn in radians.
  static const double tau = 2 * math.pi;
}
