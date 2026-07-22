import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Paints a Compose-style circular wavy progress ring.
class M3ECircularWavyProgressPainter extends CustomPainter {
  const M3ECircularWavyProgressPainter({
    required this.progress,
    required this.activeColor,
    required this.trackColor,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.gapSize,
    required this.amplitudeFactor,
    required this.maxAmplitude,
    required this.wavelength,
    required this.phase,
  });

  /// Null means indeterminate (full ring wave).
  final double? progress;
  final Color activeColor;
  final Color trackColor;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double gapSize;
  final double amplitudeFactor;
  final double maxAmplitude;
  final double wavelength;
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double maxStroke = math.max(strokeWidth, trackStrokeWidth);
    final double amplitude = maxAmplitude * amplitudeFactor.clamp(0.0, 1.0);
    final double radius =
        (size.shortestSide - maxStroke) / 2 - amplitude;

    if (radius <= 0) {
      return;
    }

    const double tau = 2 * math.pi;
    final double circumference = tau * radius;
    final int waveCount =
        math.max(1, (circumference / wavelength).round());
    final double waveK = waveCount * tau / circumference;

    final double gapAngle = gapSize / radius;
    final bool indeterminate = progress == null;
    final double p = (progress ?? 1).clamp(0.0, 1.0);
    final double activeSweep =
        indeterminate ? tau - gapAngle : p * tau;
    const double startAngle = -math.pi / 2;

    final Paint trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackStrokeWidth
      ..strokeCap = StrokeCap.round
      ..color = trackColor
      ..isAntiAlias = true;

    final Paint activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = activeColor
      ..isAntiAlias = true;

    final bool waveOnly = indeterminate || p >= 1.0;

    if (!waveOnly) {
      final double trackStart = startAngle + activeSweep + gapAngle;
      final double trackSweep = tau - activeSweep - gapAngle;
      if (trackSweep > 0) {
        canvas.drawPath(
          _wavyArc(
            center: center,
            radius: radius,
            startAngle: trackStart,
            sweepAngle: trackSweep,
            amplitude: 0,
            waveK: waveK,
            phase: phase,
          ),
          trackPaint,
        );
      }
    }

    if (activeSweep > 0) {
      canvas.drawPath(
        _wavyArc(
          center: center,
          radius: radius,
          startAngle: startAngle,
          sweepAngle: activeSweep,
          amplitude: amplitude,
          waveK: waveK,
          phase: phase,
        ),
        activePaint,
      );
    }
  }

  Path _wavyArc({
    required Offset center,
    required double radius,
    required double startAngle,
    required double sweepAngle,
    required double amplitude,
    required double waveK,
    required double phase,
  }) {
    final Path path = Path();
    const int steps = 120;
    for (int i = 0; i <= steps; i++) {
      final double t = i / steps;
      final double angle = startAngle + sweepAngle * t;
      final double arcLength = radius * (angle - startAngle).abs();
      final double r =
          radius + amplitude * math.sin(phase + arcLength * waveK);
      final Offset point = Offset(
        center.dx + r * math.cos(angle),
        center.dy + r * math.sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(M3ECircularWavyProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackStrokeWidth != trackStrokeWidth ||
        oldDelegate.gapSize != gapSize ||
        oldDelegate.amplitudeFactor != amplitudeFactor ||
        oldDelegate.maxAmplitude != maxAmplitude ||
        oldDelegate.wavelength != wavelength ||
        oldDelegate.phase != phase;
  }
}
