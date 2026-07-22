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
  double _visualGap(double stroke) => gap + stroke;

  /// Stop diameter and center so the dot sits inside the track end with equal
  /// padding on all sides.
  ({double diameter, double centerX}) _stopPlacement({
    required double trackRight,
    required double trackStroke,
  }) {
    final double pad = math.max(1.0, trackStroke / 4);
    final double maxDiameter = math.max(1.0, trackStroke - 2 * pad);
    final double diameter = math.min(stopSize, maxDiameter);
    final double actualPad = (trackStroke - diameter) / 2;
    // Nestle in the round end-cap: equal pad from the visual tip.
    final double centerX =
        trackRight + trackStroke / 2 - actualPad - diameter / 2;
    return (diameter: diameter, centerX: centerX);
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
    // Active and track share the same thickness.
    final double stroke = strokeWidth;
    final double visualGap = _visualGap(stroke);
    final double left = inset;
    final double trackRight = size.width - spec.trailingMargin;
    final ({double diameter, double centerX}) stop =
        _stopPlacement(trackRight: trackRight, trackStroke: stroke);
    final double width = math.max(0.0, trackRight - left);
    final double cy = size.height / 2;
    final double p = (value ?? 0).clamp(0.0, 1.0);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..isAntiAlias = true;

    final bool indeterminate = value == null;
    final bool complete = !indeterminate && p >= 1.0;

    if (indeterminate) {
      canvas.drawLine(
        Offset(left, cy),
        Offset(trackRight, cy),
        paint..color = active,
      );
      return;
    }

    if (complete) {
      canvas.drawLine(
        Offset(left, cy),
        Offset(trackRight, cy),
        paint..color = active,
      );
    } else {
      final double activeEndX = left + width * p;
      final double trackStartX = math.min(trackRight, activeEndX + visualGap);

      if (trackStartX < trackRight) {
        canvas.drawLine(
          Offset(trackStartX, cy),
          Offset(trackRight, cy),
          paint..color = track,
        );
      }

      if (activeEndX > left) {
        canvas.drawLine(
          Offset(left, cy),
          Offset(activeEndX, cy),
          paint..color = active,
        );
      }
    }

    canvas.drawCircle(
      Offset(stop.centerX, cy),
      stop.diameter / 2,
      Paint()..color = active,
    );
  }

  void _paintWavy(Canvas canvas, Size size) {
    // Active and track share the same thickness.
    final double stroke = strokeWidth;
    final double visualGap = _visualGap(stroke);
    final double left = inset;
    final double trailing = math.max(gap, 4);
    final double trackRight = size.width - trailing;
    final ({double diameter, double centerX}) stop =
        _stopPlacement(trackRight: trackRight, trackStroke: stroke);
    final double width = math.max(0.0, trackRight - left);
    final double cy = size.height / 2;
    final double p = (value ?? 0).clamp(0.0, 1.0);
    final double amplitude =
        waveAmplitude * amplitudeFactor.clamp(0.0, 1.0);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..isAntiAlias = true;

    final bool indeterminate = value == null;
    final bool complete = !indeterminate && p >= 1.0;
    final bool waveOnly = indeterminate || complete;

    void drawWave(double start, double end, double amp) {
      if (end <= start) {
        return;
      }
      final Path path = Path();
      const double step = 1.5;
      final double k = 2 * math.pi / wavelength;
      double x = start;
      double y = cy + amp * math.sin(phase + (x - start) * k);
      path.moveTo(x, y);
      for (x = start + step; x <= end; x += step) {
        y = cy + amp * math.sin(phase + (x - start) * k);
        path.lineTo(x, y);
      }
      y = cy + amp * math.sin(phase + (end - start) * k);
      path.lineTo(end, y);
      canvas.drawPath(path, paint..color = active);
    }

    if (waveOnly) {
      drawWave(left, trackRight, amplitude);
      if (complete) {
        canvas.drawCircle(
          Offset(stop.centerX, cy),
          stop.diameter / 2,
          Paint()..color = active,
        );
      }
      return;
    }

    final double activeEndX = left + width * p;
    final double trackStartX = math.min(trackRight, activeEndX + visualGap);

    if (trackStartX < trackRight) {
      canvas.drawLine(
        Offset(trackStartX, cy),
        Offset(trackRight, cy),
        paint..color = track,
      );
    }

    drawWave(left, activeEndX, amplitude);

    canvas.drawCircle(
      Offset(stop.centerX, cy),
      stop.diameter / 2,
      Paint()..color = active,
    );
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
