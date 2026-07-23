// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// RangeSlider

import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_range_slider_track.dart';
import 'components/m3e_slider_thumb.dart';
import 'components/m3e_slider_value_indicator.dart';
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
    super.key,
  }) : assert(max > min, 'max must be greater than min.');

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

  @override
  State<M3ERangeSlider> createState() => _M3ERangeSliderState();
}

class _M3ERangeSliderState extends State<M3ERangeSlider> {
  _M3ERangeThumb? _activeThumb;
  bool get _enabled => widget.onChanged != null;
  bool get _pressed => _activeThumb != null;

  double get _startFraction =>
      M3ESliderMath.fraction(widget.values.start, widget.min, widget.max);
  double get _endFraction =>
      M3ESliderMath.fraction(widget.values.end, widget.min, widget.max);

  List<double> get _ticks => M3ESliderMath.tickFractions(widget.divisions);

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

    return M3EComponentTheme(
      builder: (BuildContext context) {
        return Semantics(
          enabled: _enabled,
          value: widget.semanticFormatterCallback?.call(widget.values) ??
              '${widget.values.start} – ${widget.values.end}',
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double width = constraints.maxWidth;
              final double height = sliderTheme.height;

              final Widget track = M3ERangeSliderTrack(
                startFraction: _startFraction,
                endFraction: _endFraction,
                tickFractions: _ticks,
                colors: colors,
                theme: sliderTheme,
                axis: Axis.horizontal,
                textDirection: direction,
                handleThickness: handleThickness,
              );

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
                    height: sliderTheme.handleHeight,
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
