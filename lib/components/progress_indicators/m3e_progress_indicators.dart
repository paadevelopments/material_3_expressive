import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_circular_progress_painter.dart';
import 'components/m3e_circular_wavy_progress_painter.dart';
import 'components/m3e_linear_progress_painter.dart';
import 'enums/m3e_progress_enums.dart';
import 'styles/m3e_progress_indicator_theme.dart';

export 'enums/m3e_progress_enums.dart';
export 'styles/m3e_progress_indicator_theme.dart';

/// Which progress indicator layout an [M3EProgressIndicator] renders.
enum _M3EProgressKind { circular, circularWavy, linear, linearWavy }

/// Material 3 Expressive progress indicators.
///
/// Mirrors Compose Material 3:
/// - [M3EProgressIndicator.circular] → `CircularProgressIndicator`
/// - [M3EProgressIndicator.circularWavy] → `CircularWavyProgressIndicator`
/// - [M3EProgressIndicator.linear] → `LinearProgressIndicator`
/// - [M3EProgressIndicator.linearWavy] → `LinearWavyProgressIndicator`
///
/// Pass [value] in `0..1` for determinate progress, or leave it null for
/// indeterminate animation.
class M3EProgressIndicator extends StatefulWidget {
  /// Classic circular progress indicator.
  const M3EProgressIndicator.circular({
    super.key,
    this.value,
    this.size,
    this.strokeWidth,
    this.color,
    this.trackColor,
  })  : _kind = _M3EProgressKind.circular,
        linearSize = M3EProgressIndicatorSize.m,
        trackStrokeWidth = null,
        gapSize = null,
        stopSize = null,
        amplitude = null,
        amplitudeForProgress = null,
        wavelength = null,
        waveSpeed = null;

  /// Expressive circular wavy progress indicator.
  const M3EProgressIndicator.circularWavy({
    super.key,
    this.value,
    this.size,
    this.color,
    this.trackColor,
    this.strokeWidth,
    this.trackStrokeWidth,
    this.gapSize,
    this.amplitude,
    this.amplitudeForProgress,
    this.wavelength,
    this.waveSpeed,
  })  : _kind = _M3EProgressKind.circularWavy,
        linearSize = M3EProgressIndicatorSize.m,
        stopSize = null;

  /// Classic flat linear progress indicator.
  const M3EProgressIndicator.linear({
    super.key,
    this.value,
    this.linearSize = M3EProgressIndicatorSize.m,
    this.color,
    this.trackColor,
  })  : _kind = _M3EProgressKind.linear,
        size = null,
        strokeWidth = null,
        trackStrokeWidth = null,
        gapSize = null,
        stopSize = null,
        amplitude = null,
        amplitudeForProgress = null,
        wavelength = null,
        waveSpeed = null;

  /// Expressive linear wavy progress indicator.
  const M3EProgressIndicator.linearWavy({
    super.key,
    this.value,
    this.linearSize = M3EProgressIndicatorSize.m,
    this.color,
    this.trackColor,
    this.strokeWidth,
    this.trackStrokeWidth,
    this.gapSize,
    this.stopSize,
    this.amplitude,
    this.amplitudeForProgress,
    this.wavelength,
    this.waveSpeed,
  })  : _kind = _M3EProgressKind.linearWavy,
        size = null;

  final _M3EProgressKind _kind;

  /// Determinate progress in `0..1`, or null for indeterminate.
  final double? value;

  /// Diameter for circular variants.
  final double? size;

  /// Track thickness for linear classic size matrix.
  final M3EProgressIndicatorSize linearSize;

  /// Active indicator color.
  final Color? color;

  /// Track color.
  final Color? trackColor;

  /// Active stroke width.
  final double? strokeWidth;

  /// Track stroke width (wavy variants).
  final double? trackStrokeWidth;

  /// Gap between active indicator and track (wavy variants).
  final double? gapSize;

  /// End stop diameter for linear wavy.
  final double? stopSize;

  /// Fixed amplitude factor `0..1` (typically indeterminate).
  final double? amplitude;

  /// Amplitude factor as a function of progress (determinate wavy).
  final double Function(double progress)? amplitudeForProgress;

  /// Wave length in logical pixels.
  final double? wavelength;

  /// Wave travel speed in logical pixels per second.
  final double? waveSpeed;

  @override
  State<M3EProgressIndicator> createState() => _M3EProgressIndicatorState();
}

class _M3EProgressIndicatorState extends State<M3EProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool get _needsAnimation {
    switch (widget._kind) {
      case _M3EProgressKind.circular:
        return widget.value == null;
      case _M3EProgressKind.circularWavy:
      case _M3EProgressKind.linearWavy:
        return true;
      case _M3EProgressKind.linear:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: M3EMotion.extraLong2,
    );
    if (_needsAnimation) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(M3EProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_needsAnimation) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _phase(double wavelength, double waveSpeed) {
    final Duration elapsed =
        _controller.lastElapsedDuration ?? Duration.zero;
    final double seconds = elapsed.inMicroseconds / 1e6;
    if (wavelength <= 0) {
      return 0;
    }
    return seconds * waveSpeed / wavelength * 2 * math.pi;
  }

  double _amplitudeFactor({
    required double Function(double progress) themeAmplitude,
  }) {
    final double? value = widget.value;
    if (value == null) {
      return widget.amplitude ?? 1;
    }
    if (widget.amplitudeForProgress != null) {
      return widget.amplitudeForProgress!(value).clamp(0.0, 1.0);
    }
    if (widget.amplitude != null) {
      return widget.amplitude!.clamp(0.0, 1.0);
    }
    return themeAmplitude(value).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return M3EComponentTheme(
      builder: (BuildContext context) {
        return switch (widget._kind) {
          _M3EProgressKind.circular => _buildCircular(theme),
          _M3EProgressKind.circularWavy => _buildCircularWavy(theme),
          _M3EProgressKind.linear => _buildLinear(theme, wavy: false),
          _M3EProgressKind.linearWavy => _buildLinear(theme, wavy: true),
        };
      },
    );
  }

  Widget _buildCircular(M3EThemeData theme) {
    final M3ECircularProgressTheme circular =
        theme.progressIndicatorTheme.circular;
    final M3EColorScheme scheme = theme.colorScheme;
    final double resolvedSize = widget.size ?? circular.defaultSize;
    final double resolvedStroke =
        widget.strokeWidth ?? circular.defaultStrokeWidth;
    final double trackStroke =
        widget.trackStrokeWidth ?? circular.trackStrokeWidth;
    final double gap = widget.gapSize ?? circular.gapSize;
    final Color active = widget.color ?? circular.activeColor(scheme);
    final Color track = widget.trackColor ?? circular.trackColor(scheme);

    return RepaintBoundary(
      child: SizedBox(
        width: resolvedSize,
        height: resolvedSize,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            final _Arc arc = _resolveClassicArc();
            return CustomPaint(
              painter: M3ECircularProgressPainter(
                trackColor: track,
                activeColor: active,
                strokeWidth: resolvedStroke,
                trackStrokeWidth: trackStroke,
                startAngle: arc.start,
                sweepAngle: arc.sweep,
                gapSize: gap,
                progress: widget.value,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCircularWavy(M3EThemeData theme) {
    final M3ECircularProgressTheme circular =
        theme.progressIndicatorTheme.circular;
    final M3EColorScheme scheme = theme.colorScheme;
    final double resolvedSize = widget.size ?? circular.wavySize;
    final double stroke =
        widget.strokeWidth ?? circular.defaultStrokeWidth;
    final double trackStroke =
        widget.trackStrokeWidth ?? circular.trackStrokeWidth;
    final double gap = widget.gapSize ?? circular.gapSize;
    final double wavelength = widget.wavelength ?? circular.wavelength;
    final double waveSpeed = widget.waveSpeed ?? wavelength;
    final Color active = widget.color ?? circular.activeColor(scheme);
    final Color track = widget.trackColor ?? circular.trackColor(scheme);
    final double amplitudeFactor = _amplitudeFactor(
      themeAmplitude: circular.amplitudeForProgress,
    );

    return RepaintBoundary(
      child: SizedBox(
        width: resolvedSize,
        height: resolvedSize,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return CustomPaint(
              painter: M3ECircularWavyProgressPainter(
                progress: widget.value,
                activeColor: active,
                trackColor: track,
                strokeWidth: stroke,
                trackStrokeWidth: trackStroke,
                gapSize: gap,
                amplitudeFactor: amplitudeFactor,
                maxAmplitude: circular.waveAmplitude,
                wavelength: wavelength,
                phase: _needsAnimation
                    ? _phase(wavelength, waveSpeed)
                    : 0,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLinear(M3EThemeData theme, {required bool wavy}) {
    final M3ELinearProgressTheme linear = theme.progressIndicatorTheme.linear;
    final M3EColorScheme scheme = theme.colorScheme;
    final Color active = widget.color ?? scheme.primary;
    final Color track = widget.trackColor ?? scheme.surfaceContainerHighest;

    if (!wavy) {
      final M3ELinearProgressLayout layout =
          linear.resolveFlat(widget.linearSize);
      return RepaintBoundary(
        child: SizedBox(
          height: layout.trackHeight,
          width: double.infinity,
          child: CustomPaint(
            painter: M3ELinearProgressPainter(
              value: widget.value,
              active: active,
              track: track,
              strokeWidth: layout.trackHeight,
              trackStrokeWidth: math.max(2, layout.trackHeight / 2),
              gap: layout.gap,
              stopSize: layout.dotDiameter,
              isWavy: false,
              waveAmplitude: 0,
              wavelength: 40,
              phase: 0,
              amplitudeFactor: 0,
              flatLayout: layout,
            ),
          ),
        ),
      );
    }

    final double stroke = widget.strokeWidth ?? linear.strokeWidth;
    final double trackStroke =
        widget.trackStrokeWidth ?? linear.trackStrokeWidth;
    final double gap = widget.gapSize ?? linear.gapSize;
    final double stop = widget.stopSize ?? linear.stopSize;
    final bool indeterminate = widget.value == null;
    final double wavelength = widget.wavelength ??
        (indeterminate
            ? linear.indeterminateWavelength
            : linear.determinateWavelength);
    final double waveSpeed = widget.waveSpeed ?? wavelength;
    final double amplitudeFactor = _amplitudeFactor(
      themeAmplitude: linear.amplitudeForProgress,
    );
    final double height = math.max(
      linear.wavyContainerHeight,
      stroke + 2 * linear.waveAmplitude * amplitudeFactor,
    );

    return RepaintBoundary(
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return CustomPaint(
              painter: M3ELinearProgressPainter(
                value: widget.value,
                active: active,
                track: track,
                strokeWidth: stroke,
                trackStrokeWidth: trackStroke,
                gap: gap,
                stopSize: stop,
                isWavy: true,
                waveAmplitude: linear.waveAmplitude,
                wavelength: wavelength,
                phase: _needsAnimation
                    ? _phase(wavelength, waveSpeed)
                    : 0,
                amplitudeFactor: amplitudeFactor,
              ),
            );
          },
        ),
      ),
    );
  }

  _Arc _resolveClassicArc() {
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
