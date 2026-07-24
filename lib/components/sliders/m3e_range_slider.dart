// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// RangeSlider

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_range_slider_track.dart';
import 'components/m3e_slider_dot_overlay.dart';
import 'components/m3e_slider_thumb.dart';
import 'components/m3e_slider_value_indicator.dart';
import 'enums/m3e_slider_enums.dart';
import 'models/m3e_slider_dot_builder.dart';
import 'models/m3e_slider_range.dart';
import 'models/m3e_slider_range_labels.dart';
import 'models/m3e_slider_track_icons.dart';
import 'styles/m3e_slider_theme.dart';
import 'utils/m3e_slider_math.dart';

/// Which thumb is being dragged on an [M3ERangeSlider].
enum _M3ERangeThumb { start, end }

/// A Material 3 Expressive range slider (Compose `RangeSlider`).
///
/// Horizontal only — Compose has no vertical range slider.
class M3ERangeSlider extends StatefulWidget {
  const M3ERangeSlider({
    required this.values,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.onChangeEnd,
    this.labels,
    this.semanticFormatterCallback,
    this.trackIcons,
    this.trackThickness,
    this.thumbLength,
    this.dotSize,
    this.dotSpacing,
    this.dotBuilder,
    super.key,
  })  : wavy = false,
        amplitude = null,
        amplitudeForProgress = null,
        wavelength = null,
        waveSpeed = null,
        assert(max > min, 'max must be greater than min.');

  /// Range slider whose active span is a traveling sine wave.
  ///
  /// Inactive track, thumbs, gaps, and interaction match [M3ERangeSlider];
  /// only the active value span uses the linear-wavy progress recipe.
  const M3ERangeSlider.wavy({
    required this.values,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.onChangeEnd,
    this.labels,
    this.semanticFormatterCallback,
    this.trackIcons,
    this.trackThickness,
    this.thumbLength,
    this.dotSize,
    this.dotSpacing,
    this.dotBuilder,
    this.amplitude,
    this.amplitudeForProgress,
    this.wavelength,
    this.waveSpeed,
    super.key,
  })  : wavy = true,
        assert(max > min, 'max must be greater than min.');

  /// Current start/end values within [min]..[max].
  final M3ESliderRange values;

  /// Called when either thumb moves. Null disables the slider.
  final ValueChanged<M3ESliderRange>? onChanged;

  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<M3ESliderRange>? onChangeEnd;

  /// Optional start/end value-indicator labels.
  final M3ESliderRangeLabels? labels;

  final String Function(M3ESliderRange values)? semanticFormatterCallback;

  /// Reserved for parity with [M3ESlider.trackIcons] (Compose sample pattern).
  final M3ESliderTrackIcons? trackIcons;

  /// When true, paints the active span as a traveling sine wave.
  final bool wavy;

  /// Fixed amplitude factor `0..1` for [wavy] tracks.
  final double? amplitude;

  /// Amplitude factor as a function of span progress for [wavy] tracks.
  final double Function(double progress)? amplitudeForProgress;

  /// Wave length in logical pixels ([wavy] only).
  final double? wavelength;

  /// Wave travel speed in logical pixels per second ([wavy] only).
  final double? waveSpeed;

  /// Thickness of both active and inactive tracks. Defaults to theme track height.
  final double? trackThickness;

  /// Length of each thumb along its long axis. Defaults to theme handle height.
  final double? thumbLength;

  /// Diameter of stop/tick markers. Defaults to theme stop indicator size.
  final double? dotSize;

  /// Clear space between each track end and the outer edge of the end dots.
  ///
  /// Defaults to theme [M3ESliderTheme.stopIndicatorTrailingSpace].
  final double? dotSpacing;

  /// Custom stop/tick markers. When null, default circular dots are painted.
  final M3ESliderDotBuilder? dotBuilder;

  @override
  State<M3ERangeSlider> createState() => _M3ERangeSliderState();
}

class _M3ERangeSliderState extends State<M3ERangeSlider>
    with SingleTickerProviderStateMixin {
  _M3ERangeThumb? _activeThumb;
  late final AnimationController _waveController;

  bool get _enabled => widget.onChanged != null;
  bool get _pressed => _activeThumb != null;

  double get _startFraction =>
      M3ESliderMath.fraction(widget.values.start, widget.min, widget.max);
  double get _endFraction =>
      M3ESliderMath.fraction(widget.values.end, widget.min, widget.max);

  List<double> get _ticks => M3ESliderMath.tickFractions(widget.divisions);

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: M3EMotion.extraLong2,
    );
    if (widget.wavy) {
      _waveController.repeat();
    }
  }

  @override
  void didUpdateWidget(M3ERangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.wavy) {
      if (!_waveController.isAnimating) {
        _waveController.repeat();
      }
    } else if (_waveController.isAnimating) {
      _waveController.stop();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  double _phase(double wavelength, double waveSpeed) {
    final Duration elapsed =
        _waveController.lastElapsedDuration ?? Duration.zero;
    final double seconds = elapsed.inMicroseconds / 1e6;
    if (wavelength <= 0) {
      return 0;
    }
    return seconds * waveSpeed / wavelength * 2 * math.pi;
  }

  double _amplitudeFactor(M3ESliderTheme theme) {
    final double progress = (_endFraction - _startFraction).clamp(0.0, 1.0);
    if (widget.amplitudeForProgress != null) {
      return widget.amplitudeForProgress!(progress).clamp(0.0, 1.0);
    }
    if (widget.amplitude != null) {
      return widget.amplitude!.clamp(0.0, 1.0);
    }
    return theme.amplitudeForProgress(progress).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ESliderTheme sliderTheme = theme.sliderTheme;
    final M3ESliderColors colors =
        sliderTheme.colors(theme.colorScheme, enabled: _enabled);
    final TextDirection direction = Directionality.of(context);
    final bool rtl = direction == TextDirection.rtl;

    final double handleThickness = _pressed
        ? sliderTheme.pressedHandleWidth
        : sliderTheme.handleWidth;

    final double wavelength = widget.wavelength ?? sliderTheme.wavelength;
    final double waveSpeed = widget.waveSpeed ?? wavelength;
    final double amplitudeFactor = _amplitudeFactor(sliderTheme);
    final double trackThickness =
        widget.trackThickness ?? sliderTheme.trackHeight;
    final double thumbLength =
        widget.thumbLength ?? sliderTheme.handleHeight;
    final double dotSize =
        widget.dotSize ?? sliderTheme.stopIndicatorSize;
    final double dotSpacing =
        widget.dotSpacing ?? sliderTheme.stopIndicatorTrailingSpace;
    final bool useCustomDots = widget.dotBuilder != null;

    return M3EComponentTheme(
      builder: (BuildContext context) {
        return Semantics(
          enabled: _enabled,
          value: widget.semanticFormatterCallback?.call(widget.values) ??
              '${widget.values.start} – ${widget.values.end}',
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.maxWidth;
              final double height =
                  math.max(sliderTheme.height, thumbLength);

              Widget buildTrack({required double phase}) {
                return M3ERangeSliderTrack(
                  startFraction: _startFraction,
                  endFraction: _endFraction,
                  tickFractions: _ticks,
                  colors: colors,
                  theme: sliderTheme,
                  axis: Axis.horizontal,
                  textDirection: direction,
                  handleThickness: handleThickness,
                  trackHeight: trackThickness,
                  stopIndicatorSize: dotSize,
                  tickSize: dotSize,
                  edgeInset: dotSpacing,
                  drawDots: !useCustomDots,
                  isWavy: widget.wavy,
                  waveAmplitude: sliderTheme.waveAmplitude,
                  wavelength: wavelength,
                  phase: phase,
                  amplitudeFactor: amplitudeFactor,
                );
              }

              Widget track = widget.wavy
                  ? AnimatedBuilder(
                      animation: _waveController,
                      builder: (BuildContext context, Widget? child) {
                        return buildTrack(
                          phase: _phase(wavelength, waveSpeed),
                        );
                      },
                    )
                  : buildTrack(phase: 0);

              if (useCustomDots) {
                track = Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    track,
                    M3ESliderDotOverlay(
                      builder: widget.dotBuilder!,
                      mode: M3ESliderPaintMode.range,
                      trackKind: M3ESliderTrackKind.standard,
                      activeStartFraction: _startFraction,
                      activeEndFraction: _endFraction,
                      tickFractions: _ticks,
                      colors: colors,
                      trackHeight: trackThickness,
                      handleGap: sliderTheme.handleGap,
                      handleThickness: handleThickness,
                      stopIndicatorSize: dotSize,
                      tickSize: dotSize,
                      edgeInset: dotSpacing,
                      axis: Axis.horizontal,
                      textDirection: direction,
                    ),
                  ],
                );
              }

              double thumbX(double fraction) {
                final double f = rtl ? 1.0 - fraction : fraction;
                return f * width;
              }

              final double startX = thumbX(_startFraction);
              final double endX = thumbX(_endFraction);

              Widget buildThumb({required bool pressed}) => M3ESliderThumb(
                    color: colors.thumb,
                    pressed: pressed,
                    width: sliderTheme.handleWidth,
                    height: thumbLength,
                    pressedThickness: sliderTheme.pressedHandleWidth,
                  );

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: !_enabled
                    ? null
                    : (DragStartDetails d) {
                        final double dx = d.localPosition.dx;
                        final double distStart = (dx - startX).abs();
                        final double distEnd = (dx - endX).abs();
                        setState(() {
                          _activeThumb = distStart <= distEnd
                              ? _M3ERangeThumb.start
                              : _M3ERangeThumb.end;
                        });
                      },
                onHorizontalDragUpdate: !_enabled
                    ? null
                    : (DragUpdateDetails d) =>
                        _update(d.localPosition.dx, width, rtl),
                onHorizontalDragEnd:
                    !_enabled ? null : (_) => _endInteraction(),
                onHorizontalDragCancel: !_enabled ? null : _endInteraction,
                onTapDown: !_enabled
                    ? null
                    : (TapDownDetails d) {
                        final double dx = d.localPosition.dx;
                        final double distStart = (dx - startX).abs();
                        final double distEnd = (dx - endX).abs();
                        setState(() {
                          _activeThumb = distStart <= distEnd
                              ? _M3ERangeThumb.start
                              : _M3ERangeThumb.end;
                        });
                        _update(dx, width, rtl);
                      },
                onTapUp: !_enabled ? null : (_) => _endInteraction(),
                onTapCancel: !_enabled ? null : _endInteraction,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned.fill(child: track),
                      Positioned(
                        left: startX - 12,
                        width: 24,
                        height: height,
                        child: Center(
                          child: buildThumb(
                            pressed: _activeThumb == _M3ERangeThumb.start,
                          ),
                        ),
                      ),
                      Positioned(
                        left: endX - 12,
                        width: 24,
                        height: height,
                        child: Center(
                          child: buildThumb(
                            pressed: _activeThumb == _M3ERangeThumb.end,
                          ),
                        ),
                      ),
                      if (_pressed)
                        Positioned(
                          left: (_activeThumb == _M3ERangeThumb.start
                                  ? startX
                                  : endX) -
                              24,
                          top: -sliderTheme.valueIndicatorBottomSpace - 24,
                          child: M3ESliderValueIndicator(
                            label: _indicatorLabel(),
                            colors: colors,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _indicatorLabel() {
    if (widget.labels != null) {
      return _activeThumb == _M3ERangeThumb.start
          ? widget.labels!.start
          : widget.labels!.end;
    }
    final double v = _activeThumb == _M3ERangeThumb.start
        ? widget.values.start
        : widget.values.end;
    return widget.divisions != null
        ? v.round().toString()
        : v.toStringAsFixed(2);
  }

  void _update(double dx, double width, bool rtl) {
    if (_activeThumb == null) {
      return;
    }
    final double next = M3ESliderMath.valueFromOffset(
      localPrimary: dx,
      extent: width,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      reverse: rtl,
    );

    final M3ESliderRange updated = _activeThumb == _M3ERangeThumb.start
        ? M3ESliderRange(
            next.clamp(widget.min, widget.values.end),
            widget.values.end,
          )
        : M3ESliderRange(
            widget.values.start,
            next.clamp(widget.values.start, widget.max),
          );
    if (updated != widget.values) {
      widget.onChanged!(updated);
    }
  }

  void _endInteraction() {
    if (_activeThumb != null) {
      setState(() => _activeThumb = null);
    }
    widget.onChangeEnd?.call(widget.values);
  }
}
