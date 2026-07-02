// Vendored verbatim from the `progress_indicator_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/blob/main/packages/progress_indicator_m3e/lib/src/linear_progress_m3e.dart).
// The logic is kept identical to the reference `LinearProgressIndicatorM3E`;
// only the public class name carries the `M3E` prefix and colors are read from
// this package's own `M3ETheme` instead of the external `m3e_design` package.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'enums/m3e_progress_enums.dart';
import 'styles/m3e_progress_tokens.dart';

/// Linear indicator that renders two **separate lanes** (active above, track below)
/// with a fixed vertical gap. Lanes never overlap.
class M3ELinearProgress extends StatefulWidget {
  const M3ELinearProgress({
    super.key,
    this.value, // null => indeterminate
    this.size = M3ELinearProgressSize.m,
    this.shape = M3EProgressShape.wavy,
    this.activeColor,
    this.trackColor,
    this.phase = 0.0, // radians for wavy animation (external override)
    this.inset = 4.0, // horizontal left inset
  });

  final double? value;
  final M3ELinearProgressSize size;
  final M3EProgressShape shape;
  final Color? activeColor;
  final Color? trackColor;
  final double phase;
  final double inset;

  @override
  State<M3ELinearProgress> createState() => _M3ELinearProgressState();
}

class _M3ELinearProgressState extends State<M3ELinearProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _shouldAnimate {
    final v = widget.value;
    return widget.shape == M3EProgressShape.wavy &&
        (v == null || (v >= 1.0)) &&
        widget.phase == 0.0;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..addListener(() {
      if (mounted && _shouldAnimate) setState(() {});
    });
    if (_shouldAnimate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant M3ELinearProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldAnimate) {
      if (!_controller.isAnimating) _controller.repeat();
    } else {
      if (_controller.isAnimating) _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = M3ETheme.of(context).colorScheme;

    // Colors sourced from the ambient theme (overridable per props).
    final active = widget.activeColor ?? colors.primary;
    final track = widget.trackColor ?? colors.surfaceContainerHighest;

    final spec = M3ELinearProgressTokens.resolve(size: widget.size, shape: widget.shape);

    // Total height equals the taller of the two strokes sharing the same baseline.
    // For wavy, add vertical amplitude; for flat, it's just the trackHeight.
    final activeHeight = spec.isWavy
        ? (spec.trackHeight + 2 * spec.waveAmplitude)
        : spec.trackHeight;
    final totalHeight = activeHeight;

    final double phaseValue = widget.phase != 0.0
        ? widget.phase
        : (_shouldAnimate ? _controller.value * 2 * math.pi : 0.0);

    return RepaintBoundary(
      child: SizedBox(
        height: totalHeight,
        width: double.infinity,
        child: CustomPaint(
          painter: _LinearPainter(
            value: widget.value,
            spec: spec,
            active: widget.activeColor ?? active,
            track: widget.trackColor ?? track,
            phase: phaseValue,
            inset: widget.inset,
          ),
        ),
      ),
    );
  }
}

class _LinearPainter extends CustomPainter {
  _LinearPainter({
    required this.value,
    required this.spec,
    required this.active,
    required this.track,
    required this.phase,
    required this.inset,
  });

  final double? value;
  final M3ELinearProgressTokens spec;
  final Color active;
  final Color track;
  final double phase;
  final double inset;

  @override
  void paint(Canvas canvas, Size size) {
    final left = inset;
    final right = size.width - spec.trailingMargin;
    final width = math.max(0.0, right - left);

    // both strokes share the same baseline (centerline)
    final cy = size.height / 2;
    final trackCy = cy;
    final activeCy = cy;

    // --- Draw track lane (flat pill) ---
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = spec.trackHeight
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // compute progress fraction early for both lanes
    final double p = (value ?? 0).clamp(0.0, 1.0);

    // Wave-only mode: in wavy shape, when indeterminate or full (100%),
    // hide the track and end-dot; show only the wave which is animated via phase.
    final bool waveOnly = spec.isWavy && (value == null || p >= 1.0);

    // Track occupies the remaining segment to the right of the active,
    // leaving a fixed inter-stroke gap. For indeterminate, fill full width.
    final double activeEndX = value == null ? right : (left + width * p);
    final double trackStartX =
    value == null ? left : math.min(right, activeEndX + spec.gap);

    if (!waveOnly) {
      canvas.drawLine(Offset(trackStartX, trackCy), Offset(right, trackCy),
          base..color = track);
    }

    // --- Active lane ---
    if (spec.isWavy) {
      // wavy centerline
      final start = left;
      final end = value == null ? right : (left + width * p);
      final path = Path();
      const step = 1.5;
      final k = 2 * math.pi / spec.wavePeriod;

      double x = start;
      double y =
          activeCy + spec.waveAmplitude * math.sin(phase + (x - start) * k);
      path.moveTo(x, y);
      for (x = start + step; x <= end; x += step) {
        y = activeCy + spec.waveAmplitude * math.sin(phase + (x - start) * k);
        path.lineTo(x, y);
      }
      // precise end point
      y = activeCy + spec.waveAmplitude * math.sin(phase + (end - start) * k);
      path.lineTo(end, y);

      canvas.drawPath(
          path,
          base
            ..color = active
            ..strokeWidth = spec.trackHeight);

      // end dot: accent at far right end of the track (shared baseline)
      if (!waveOnly) {
        final dotCenterX = math.max(left, right - spec.dotOffset);
        canvas.drawCircle(Offset(dotCenterX, trackCy), spec.dotDiameter / 2,
            Paint()..color = active);
      }
    } else {
      // flat active pill + end dot
      final start = left;
      final end = value == null ? right : (left + width * p);
      canvas.drawLine(
          Offset(start, activeCy),
          Offset(end, activeCy),
          base
            ..color = active
            ..strokeWidth = spec.trackHeight);
      final dotCenterX = math.max(left, right - spec.dotOffset);
      canvas.drawCircle(Offset(dotCenterX, trackCy), spec.dotDiameter / 2,
          Paint()..color = active);
    }
  }

  @override
  bool shouldRepaint(covariant _LinearPainter old) =>
      value != old.value ||
          spec != old.spec ||
          active != old.active ||
          track != old.track ||
          phase != old.phase ||
          inset != old.inset;
}


/// A Material 3 Expressive circular progress indicator.
///
/// Pass a [value] in 0..1 for a determinate arc, or leave it null for the
/// spinning indeterminate indicator.
class M3ECircularProgress extends StatefulWidget {
  const M3ECircularProgress({
    this.value,
    this.size = M3ECircularProgressTokens.defaultSize,
    this.strokeWidth = M3ECircularProgressTokens.defaultStrokeWidth,
    super.key,
  });

  final double? value;
  final double size;
  final double strokeWidth;

  @override
  State<M3ECircularProgress> createState() => _M3ECircularProgressState();
}

class _M3ECircularProgressState extends State<M3ECircularProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: M3EMotion.extraLong2,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(M3ECircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final _Arc arc = _resolveArc();
          return CustomPaint(
            painter: M3ECircularProgressPainter(
              trackColor: M3ECircularProgressTokens.trackColor(scheme),
              activeColor: M3ECircularProgressTokens.activeColor(scheme),
              strokeWidth: widget.strokeWidth,
              startAngle: arc.start,
              sweepAngle: arc.sweep,
            ),
          );
        },
      ),
    );
  }

  _Arc _resolveArc() {
    const double tau = 2 * math.pi;
    final double? value = widget.value;
    if (value != null) {
      return _Arc(-math.pi / 2, value.clamp(0, 1).toDouble() * tau);
    }
    final double t = _controller.value;
    final double rotation = t * tau * 2;
    final double sweep = (math.sin(t * math.pi) * 0.75 + 0.15) * tau;
    return _Arc(rotation, sweep);
  }
}

@immutable
class _Arc {
  const _Arc(this.start, this.sweep);

  final double start;
  final double sweep;
}

/// Paints the track and active arc of a circular progress indicator.
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
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    if (sweepAngle == 0) {
      return;
    }
    final active = Paint()
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
        oldDelegate.trackColor != trackColor;
  }

  /// A full turn in radians, exposed for callers computing sweeps.
  static const double tau = 2 * math.pi;
}
