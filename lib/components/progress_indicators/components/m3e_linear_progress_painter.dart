import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../styles/m3e_progress_indicator_theme.dart';

/// Paints flat or wavy linear progress tracks.
class M3ELinearProgressPainter extends CustomPainter {
  const M3ELinearProgressPainter({
    required this.value,
    required this.active,
    required this.track,
    required this.strokeWidth,
    required this.trackStrokeWidth,
    required this.gap,
    required this.stopSize,
    required this.isWavy,
    required this.waveAmplitude,
    required this.wavelength,
    required this.phase,
    required this.amplitudeFactor,
    this.inset = 4,
    this.flatLayout,
  });

  final double? value;
  final Color active;
  final Color track;
  final double strokeWidth;
  final double trackStrokeWidth;
  final double gap;
  final double stopSize;
  final bool isWavy;
  final double waveAmplitude;
  final double wavelength;
  final double phase;
  final double amplitudeFactor;
  final double inset;
  final M3ELinearProgressLayout? flatLayout;

  /// Inflates [gap] so round stroke caps leave a visible empty space.
  double _visualGap(double activeStroke, double trackStroke) {
    return gap + (activeStroke + trackStroke) / 2;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (isWavy) {
      _paintWavy(canvas, size);
    } else {
      _paintFlat(canvas, size);
    }
  }

  void _paintFlat(Canvas canvas, Size size) {
    final M3ELinearProgressLayout spec = flatLayout!;
    final double activeStroke = strokeWidth;
    final double trackStroke = trackStrokeWidth;
    final double visualGap = _visualGap(activeStroke, trackStroke);
    final double left = inset;
    final double stopCenterX =
        size.width - math.max(spec.dotOffset, stopSize / 2);
    final double trackEndX = stopCenterX - stopSize / 2 - gap;
    final double right = math.max(left, trackEndX);
    final double width = math.max(0.0, right - left);
    final double cy = size.height / 2;
    final double p = (value ?? 0).clamp(0.0, 1.0);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final bool indeterminate = value == null;
    final double activeEndX = indeterminate ? right : (left + width * p);
    final double trackStartX = indeterminate
        ? left
        : math.min(right, activeEndX + visualGap);

    if (!indeterminate && trackStartX < right) {
      canvas.drawLine(
        Offset(trackStartX, cy),
        Offset(right, cy),
        paint
          ..color = track
          ..strokeWidth = trackStroke,
      );
    }

    final double end = indeterminate ? right : activeEndX;
    if (end > left) {
      canvas.drawLine(
        Offset(left, cy),
        Offset(end, cy),
        paint
          ..color = active
          ..strokeWidth = activeStroke,
      );
    }

    if (!indeterminate) {
      canvas.drawCircle(
        Offset(stopCenterX, cy),
        stopSize / 2,
        Paint()..color = active,
      );
    }
  }

  void _paintWavy(Canvas canvas, Size size) {
    final double visualGap = _visualGap(strokeWidth, trackStrokeWidth);
    final double left = inset;
    final double stopCenterX = size.width - stopSize / 2 - 2;
    final double trackEndX = stopCenterX - stopSize / 2 - gap;
    final double right = math.max(left, trackEndX);
    final double width = math.max(0.0, right - left);
    final double cy = size.height / 2;
    final double p = (value ?? 0).clamp(0.0, 1.0);
    final double amplitude =
        waveAmplitude * amplitudeFactor.clamp(0.0, 1.0);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final bool waveOnly = value == null || p >= 1.0;
    final double activeEndX = value == null ? right : (left + width * p);
    final double trackStartX =
        value == null ? left : math.min(right, activeEndX + visualGap);

    if (!waveOnly && trackStartX < right) {
      canvas.drawLine(
        Offset(trackStartX, cy),
        Offset(right, cy),
        paint
          ..color = track
          ..strokeWidth = trackStrokeWidth,
      );
    }

    final double start = left;
    final double end = value == null ? right : activeEndX;
    final Path path = Path();
    const double step = 1.5;
    final double k = 2 * math.pi / wavelength;

    double x = start;
    double y = cy + amplitude * math.sin(phase + (x - start) * k);
    path.moveTo(x, y);
    for (x = start + step; x <= end; x += step) {
      y = cy + amplitude * math.sin(phase + (x - start) * k);
      path.lineTo(x, y);
    }
    y = cy + amplitude * math.sin(phase + (end - start) * k);
    path.lineTo(end, y);

    canvas.drawPath(
      path,
      paint
        ..color = active
        ..strokeWidth = strokeWidth,
    );

    if (!waveOnly && stopSize > 0) {
      canvas.drawCircle(
        Offset(stopCenterX, cy),
        stopSize / 2,
        Paint()..color = active,
      );
    }
  }

  @override
  bool shouldRepaint(M3ELinearProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.active != active ||
        oldDelegate.track != track ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackStrokeWidth != trackStrokeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.stopSize != stopSize ||
        oldDelegate.isWavy != isWavy ||
        oldDelegate.waveAmplitude != waveAmplitude ||
        oldDelegate.wavelength != wavelength ||
        oldDelegate.phase != phase ||
        oldDelegate.amplitudeFactor != amplitudeFactor ||
        oldDelegate.inset != inset ||
        oldDelegate.flatLayout != flatLayout;
  }
}
