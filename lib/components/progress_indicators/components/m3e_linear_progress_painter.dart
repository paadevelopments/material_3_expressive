import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../styles/m3e_progress_indicator_theme.dart';
import '../utils/m3e_progress_indicator_utils.dart';

/// Paints flat or wavy linear progress tracks.
class M3ELinearProgressPainter extends CustomPainter {
  /// M3ELinearProgressPainter.
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
    this.animationValue = 0,
    this.inset = 4,
    this.flatLayout,
  });

  /// Determinate progress, or null for indeterminate.
  final double? value;

  /// Indeterminate cycle progress in `0..1` (ignored when [value] is set).
  final double animationValue;

  /// active.
  final Color active;

  /// track.
  final Color track;

  /// strokeWidth.
  final double strokeWidth;

  /// trackStrokeWidth.
  final double trackStrokeWidth;

  /// gap.
  final double gap;

  /// stopSize.
  final double stopSize;

  /// isWavy.
  final bool isWavy;

  /// waveAmplitude.
  final double waveAmplitude;

  /// wavelength.
  final double wavelength;

  /// phase.
  final double phase;

  /// amplitudeFactor.
  final double amplitudeFactor;

  /// inset.
  final double inset;

  /// flatLayout.
  final M3ELinearProgressLayout? flatLayout;

  static const Curve _lineEasing = Cubic(0.3, 0, 0.8, 0.15);

  /// Inflates [gap] so round stroke caps leave a visible empty space.
  double _visualGap(double stroke) => gap + stroke;

  /// Stop diameter and center so the dot sits inside the track end with equal
  /// padding on all sides.
  ({double diameter, double centerX}) _stopPlacement({
    required double trackRight,
    required double trackStroke,
  }) {
    final double pad = math.max(1, trackStroke / 4);
    final double maxDiameter = math.max(1, trackStroke - 2 * pad);
    final double diameter = math.min(stopSize, maxDiameter);
    final double actualPad = (trackStroke - diameter) / 2;
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
    final double stroke = strokeWidth;
    final double visualGap = _visualGap(stroke);
    final double left = inset;
    final double trackRight = size.width - spec.trailingMargin;
    final ({double diameter, double centerX}) stop = _stopPlacement(
      trackRight: trackRight,
      trackStroke: stroke,
    );
    final double width = math.max(0, trackRight - left);
    final double cy = size.height / 2;
    final double p = (value ?? 0).clamp(0.0, 1.0);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..isAntiAlias = true;

    final indeterminate = value == null;
    final bool complete = !indeterminate && p >= 1.0;

    if (indeterminate) {
      _paintFlatIndeterminate(
        canvas,
        paint: paint,
        left: left,
        trackRight: trackRight,
        width: width,
        cy: cy,
        visualGap: visualGap,
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

  void _paintFlatIndeterminate(
    Canvas canvas, {
    required Paint paint,
    required double left,
    required double trackRight,
    required double width,
    required double cy,
    required double visualGap,
  }) {
    final ({
      double firstHead,
      double firstTail,
      double secondHead,
      double secondTail,
    })
    segs = _indetSegments();
    final double gapFrac = width > 0 ? visualGap / width : 0;

    void drawSeg(double startF, double endF, Color color) {
      if (endF - startF <= 0) {
        return;
      }
      final double x0 = left + width * startF.clamp(0.0, 1.0);
      final double x1 = left + width * endF.clamp(0.0, 1.0);
      if (x1 <= x0) {
        return;
      }
      canvas.drawLine(Offset(x0, cy), Offset(x1, cy), paint..color = color);
    }

    // Track after first line (with gap).
    if (segs.firstHead < 1.0 - gapFrac) {
      final double start = segs.firstHead > 0 ? segs.firstHead + gapFrac : 0;
      drawSeg(start, 1, track);
    }

    if (segs.firstHead - segs.firstTail > 0) {
      drawSeg(segs.firstTail, segs.firstHead, active);
    }

    // Track between second and first (with gaps).
    if (segs.firstTail > gapFrac) {
      final double start = segs.secondHead > 0 ? segs.secondHead + gapFrac : 0;
      final double end = segs.firstTail < 1.0 ? segs.firstTail - gapFrac : 1.0;
      if (start < end) {
        drawSeg(start, end, track);
      }
    }

    if (segs.secondHead - segs.secondTail > 0) {
      drawSeg(segs.secondTail, segs.secondHead, active);
    }

    // Track before second line (with gap).
    if (segs.secondTail > gapFrac) {
      final double end = segs.secondTail < 1.0
          ? segs.secondTail - gapFrac
          : 1.0;
      drawSeg(0, end, track);
    }
  }

  void _paintWavy(Canvas canvas, Size size) {
    final double stroke = strokeWidth;
    final double visualGap = _visualGap(stroke);
    final double left = inset;
    final double trailing = math.max(gap, 4);
    final double trackRight = size.width - trailing;
    final ({double diameter, double centerX}) stop = _stopPlacement(
      trackRight: trackRight,
      trackStroke: stroke,
    );
    final double width = math.max(0, trackRight - left);
    final double cy = size.height / 2;
    final double p = (value ?? 0).clamp(0.0, 1.0);
    final double amplitude = waveAmplitude * amplitudeFactor.clamp(0.0, 1.0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..isAntiAlias = true;

    final indeterminate = value == null;
    final bool complete = !indeterminate && p >= 1.0;
    if (indeterminate) {
      _paintWavyIndeterminate(
        canvas,
        paint: paint,
        left: left,
        trackRight: trackRight,
        width: width,
        cy: cy,
        visualGap: visualGap,
        amplitude: amplitude,
      );
      return;
    }
    if (complete) {
      _drawWave(canvas, paint, left, trackRight, cy, amplitude);
      canvas.drawCircle(
        Offset(stop.centerX, cy),
        stop.diameter / 2,
        Paint()..color = active,
      );
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
    _drawWave(canvas, paint, left, activeEndX, cy, amplitude);
    canvas.drawCircle(
      Offset(stop.centerX, cy),
      stop.diameter / 2,
      Paint()..color = active,
    );
  }

  void _paintWavyIndeterminate(
    Canvas canvas, {
    required Paint paint,
    required double left,
    required double trackRight,
    required double width,
    required double cy,
    required double visualGap,
    required double amplitude,
  }) {
    final ({
      double firstHead,
      double firstTail,
      double secondHead,
      double secondTail,
    })
    segs = _indetSegments();
    final double strokeCap = math.max(strokeWidth, trackStrokeWidth) / 2;
    final double adjustedGap = visualGap + strokeCap;

    void drawTrack(double x0, double x1) {
      if (x1 <= x0) {
        return;
      }
      canvas.drawLine(Offset(x0, cy), Offset(x1, cy), paint..color = track);
    }

    void drawActive(double startF, double endF) {
      if (endF - startF <= 0) {
        return;
      }
      final double x0 = left + width * startF.clamp(0.0, 1.0);
      final double x1 = left + width * endF.clamp(0.0, 1.0);
      _drawWave(canvas, paint, x0, x1, cy, amplitude);
    }

    // Gap / track segments around the two traveling waves.
    final double firstTrackEnd = segs.secondTail * width + left - adjustedGap;
    if (firstTrackEnd > left + strokeCap) {
      drawTrack(left + strokeCap, firstTrackEnd);
    }

    drawActive(segs.secondTail, segs.secondHead);

    final double secondTrackStart =
        segs.secondHead * width + left + adjustedGap;
    final double secondTrackEnd = segs.firstTail * width + left - adjustedGap;
    if (secondTrackStart < secondTrackEnd) {
      drawTrack(secondTrackStart, secondTrackEnd);
    }

    drawActive(segs.firstTail, segs.firstHead);

    final double thirdTrackStart = segs.firstHead * width + left + adjustedGap;
    if (thirdTrackStart < trackRight - strokeCap) {
      drawTrack(thirdTrackStart, trackRight - strokeCap);
    }
  }

  ({double firstHead, double firstTail, double secondHead, double secondTail})
  _indetSegments() {
    final double t = animationValue;
    return (
      firstHead: M3EProgressIndicatorUtils.evaluateIndeterminateSegment(
        t: t,
        delayMs: 0,
        durationMs: 1000,
        easing: _lineEasing,
      ),
      firstTail: M3EProgressIndicatorUtils.evaluateIndeterminateSegment(
        t: t,
        delayMs: 250,
        durationMs: 1000,
        easing: _lineEasing,
      ),
      secondHead: M3EProgressIndicatorUtils.evaluateIndeterminateSegment(
        t: t,
        delayMs: 650,
        durationMs: 850,
        easing: _lineEasing,
      ),
      secondTail: M3EProgressIndicatorUtils.evaluateIndeterminateSegment(
        t: t,
        delayMs: 900,
        durationMs: 850,
        easing: _lineEasing,
      ),
    );
  }

  void _drawWave(
    Canvas canvas,
    Paint paint,
    double start,
    double end,
    double cy,
    double amp,
  ) {
    if (end <= start) {
      return;
    }
    final path = Path();
    const step = 1.5;
    final double k = 2 * math.pi / math.max(wavelength, 1);
    var x = start;
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

  @override
  bool shouldRepaint(M3ELinearProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.animationValue != animationValue ||
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
