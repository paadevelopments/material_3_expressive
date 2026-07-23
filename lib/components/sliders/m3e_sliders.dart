// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// Slider / VerticalSlider / SliderDefaults.CenteredTrack
//
// build.gradle.kts (Module level)
// dependencies {
//   implementation("androidx.compose.material3:material3:1.4.0-alpha01") // or 1.3.x stable
// }

import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_slider_centered_track.dart';
import 'components/m3e_slider_thumb.dart';
import 'components/m3e_slider_track.dart';
import 'components/m3e_slider_value_indicator.dart';
import 'enums/m3e_slider_enums.dart';
import 'models/m3e_slider_track_icons.dart';
import 'res/m3e_slider_tokens.dart';
import 'styles/m3e_slider_theme.dart';
import 'utils/m3e_slider_math.dart';

export 'components/m3e_slider_centered_track.dart';
export 'components/m3e_slider_thumb.dart';
export 'components/m3e_slider_track.dart';
export 'components/m3e_slider_value_indicator.dart';
export 'enums/m3e_slider_enums.dart';
export 'm3e_range_slider.dart';
export 'models/m3e_slider_range.dart';
export 'models/m3e_slider_range_labels.dart';
export 'models/m3e_slider_track_icons.dart';
export 'styles/m3e_slider_theme.dart';

/// A Material 3 Expressive slider.
///
/// Mirrors Compose Material 3:
/// - [M3ESlider] → `Slider` + `SliderDefaults.Track`
/// - [M3ESlider.centered] → `Slider` + `SliderDefaults.CenteredTrack`
/// - [M3ESlider.vertical] → `VerticalSlider`
/// - [M3ESlider.verticalCentered] → `VerticalSlider` + `CenteredTrack`
///
/// Selects a single value from a continuous or, when [divisions] is set,
/// discrete range. Pass a null [onChanged] to disable.
class M3ESlider extends StatefulWidget {
  /// Standard horizontal slider (active track from start → thumb).
  const M3ESlider({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.onChangeEnd,
    this.label,
    this.semanticFormatterCallback,
    this.trackIcons,
    this.thumbBuilder,
    this.trackBuilder,
    super.key,
  })  : axis = Axis.horizontal,
        trackKind = M3ESliderTrackKind.standard,
        topToBottom = true,
        assert(max > min, 'max must be greater than min.');

  /// Horizontal slider with a centered active track.
  const M3ESlider.centered({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.onChangeEnd,
    this.label,
    this.semanticFormatterCallback,
    this.trackIcons,
    this.thumbBuilder,
    this.trackBuilder,
    super.key,
  })  : axis = Axis.horizontal,
        trackKind = M3ESliderTrackKind.centered,
        topToBottom = true,
        assert(max > min, 'max must be greater than min.');

  /// Vertical slider (Compose `VerticalSlider`).
  const M3ESlider.vertical({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.onChangeEnd,
    this.label,
    this.semanticFormatterCallback,
    this.trackIcons,
    this.thumbBuilder,
    this.trackBuilder,
    this.topToBottom = true,
    super.key,
  })  : axis = Axis.vertical,
        trackKind = M3ESliderTrackKind.standard,
        assert(max > min, 'max must be greater than min.');

  /// Vertical slider with a centered active track.
  const M3ESlider.verticalCentered({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.onChangeEnd,
    this.label,
    this.semanticFormatterCallback,
    this.trackIcons,
    this.thumbBuilder,
    this.trackBuilder,
    this.topToBottom = true,
    super.key,
  })  : axis = Axis.vertical,
        trackKind = M3ESliderTrackKind.centered,
        assert(max > min, 'max must be greater than min.');

  /// Current value in [min]..[max].
  final double value;

  /// Called when the value changes. Null disables the slider.
  final ValueChanged<double>? onChanged;

  final double min;
  final double max;

  /// Discrete steps between [min] and [max] (Flutter Material [divisions]).
  final int? divisions;

  /// Called when the user finishes interacting.
  final ValueChanged<double>? onChangeEnd;

  /// Static value-indicator text. When null, a numeric label is derived.
  final String? label;

  /// Formats the semantic value announced to accessibility services.
  final String Function(double value)? semanticFormatterCallback;

  /// Optional inset icons for active / inactive track segments.
  final M3ESliderTrackIcons? trackIcons;

  /// Replaces the default [M3ESliderThumb].
  final Widget Function({
    required BuildContext context,
    required M3ESliderColors colors,
    required bool pressed,
  })? thumbBuilder;

  /// Replaces the default track painter widget.
  final Widget Function({
    required BuildContext context,
    required M3ESliderColors colors,
    required M3ESliderTheme theme,
    required double fraction,
    required List<double> tickFractions,
    required double handleThickness,
  })? trackBuilder;

  final Axis axis;
  final M3ESliderTrackKind trackKind;

  /// When [axis] is vertical, `true` maps top → [min] (Compose `topToBottom`).
  final bool topToBottom;

  @override
  State<M3ESlider> createState() => _M3ESliderState();
}

class _M3ESliderState extends State<M3ESlider> {
  bool _pressed = false;

  bool get _enabled => widget.onChanged != null;
  bool get _vertical => widget.axis == Axis.vertical;

  double get _fraction =>
      M3ESliderMath.fraction(widget.value, widget.min, widget.max);

  List<double> get _ticks => M3ESliderMath.tickFractions(widget.divisions);

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ESliderTheme sliderTheme = theme.sliderTheme;
    final M3ESliderColors colors =
        sliderTheme.colors(theme.colorScheme, enabled: _enabled);
    final TextDirection direction = Directionality.of(context);
    final bool rtl = !_vertical && direction == TextDirection.rtl;
    final bool reverse = _vertical ? !widget.topToBottom : rtl;

    final double handleThickness = _pressed
        ? sliderTheme.pressedHandleWidth
        : (_vertical
            ? M3ESliderTokens.verticalHandleHeight
            : sliderTheme.handleWidth);

    final String indicatorLabel = widget.label ??
        (widget.divisions != null
            ? widget.value.round().toString()
            : widget.value.toStringAsFixed(2));

    return M3EComponentTheme(
      builder: (BuildContext context) {
        return Semantics(
          slider: true,
          enabled: _enabled,
          value: widget.semanticFormatterCallback?.call(widget.value) ??
              indicatorLabel,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final double extent = _vertical
                  ? constraints.maxHeight
                  : constraints.maxWidth;
              final double cross = _vertical
                  ? (constraints.maxWidth.isFinite
                      ? constraints.maxWidth
                      : sliderTheme.height)
                  : sliderTheme.height;

              Widget track = widget.trackBuilder?.call(
                    context: context,
                    colors: colors,
                    theme: sliderTheme,
                    fraction: _fraction,
                    tickFractions: _ticks,
                    handleThickness: handleThickness,
                  ) ??
                  (widget.trackKind == M3ESliderTrackKind.centered
                      ? M3ESliderCenteredTrack(
                          fraction: _fraction,
                          tickFractions: _ticks,
                          colors: colors,
                          theme: sliderTheme,
                          axis: widget.axis,
                          textDirection: direction,
                          handleThickness: handleThickness,
                        )
                      : M3ESliderTrack(
                          fraction: _fraction,
                          tickFractions: _ticks,
                          colors: colors,
                          theme: sliderTheme,
                          axis: widget.axis,
                          textDirection: direction,
                          handleThickness: handleThickness,
                        ));

              if (widget.trackIcons != null && widget.trackIcons!.hasAny) {
                track = _TrackIconsOverlay(
                  icons: widget.trackIcons!,
                  fraction: _fraction,
                  trackKind: widget.trackKind,
                  axis: widget.axis,
                  child: track,
                );
              }

              final Widget thumb = widget.thumbBuilder?.call(
                    context: context,
                    colors: colors,
                    pressed: _pressed,
                  ) ??
                  M3ESliderThumb(
                    color: colors.thumb,
                    pressed: _pressed,
                    axis: widget.axis,
                    width: _vertical
                        ? M3ESliderTokens.verticalHandleWidth
                        : sliderTheme.handleWidth,
                    height: _vertical
                        ? M3ESliderTokens.verticalHandleHeight
                        : sliderTheme.handleHeight,
                    pressedThickness: sliderTheme.pressedHandleWidth,
                  );

              final double thumbPrimary = reverse
                  ? (1.0 - _fraction) * extent
                  : _fraction * extent;

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onHorizontalDragStart: !_enabled || _vertical
                    ? null
                    : (_) => setState(() => _pressed = true),
                onHorizontalDragUpdate: !_enabled || _vertical
                    ? null
                    : (DragUpdateDetails d) =>
                        _update(d.localPosition.dx, extent, reverse),
                onHorizontalDragEnd: !_enabled || _vertical
                    ? null
                    : (_) => _endInteraction(),
                onHorizontalDragCancel: !_enabled || _vertical
                    ? null
                    : _endInteraction,
                onVerticalDragStart: !_enabled || !_vertical
                    ? null
                    : (_) => setState(() => _pressed = true),
                onVerticalDragUpdate: !_enabled || !_vertical
                    ? null
                    : (DragUpdateDetails d) =>
                        _update(d.localPosition.dy, extent, reverse),
                onVerticalDragEnd: !_enabled || !_vertical
                    ? null
                    : (_) => _endInteraction(),
                onVerticalDragCancel:
                    !_enabled || !_vertical ? null : _endInteraction,
                onTapDown: !_enabled
                    ? null
                    : (TapDownDetails d) {
                        setState(() => _pressed = true);
                        final double primary =
                            _vertical ? d.localPosition.dy : d.localPosition.dx;
                        _update(primary, extent, reverse);
                      },
                onTapUp: !_enabled ? null : (_) => _endInteraction(),
                onTapCancel: !_enabled ? null : _endInteraction,
                child: SizedBox(
                  width: _vertical ? cross : extent,
                  height: _vertical ? extent : cross,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned.fill(child: track),
                      Positioned(
                        left: _vertical ? null : thumbPrimary - 12,
                        top: _vertical ? thumbPrimary - 12 : null,
                        width: _vertical ? cross : 24,
                        height: _vertical ? 24 : cross,
                        child: Center(child: thumb),
                      ),
                      if (_pressed)
                        Positioned(
                          left: _vertical ? cross + 8 : thumbPrimary - 24,
                          top: _vertical
                              ? thumbPrimary - 12
                              : -sliderTheme.valueIndicatorBottomSpace - 24,
                          child: M3ESliderValueIndicator(
                            label: indicatorLabel,
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

  void _update(double primary, double extent, bool reverse) {
    final double next = M3ESliderMath.valueFromOffset(
      localPrimary: primary,
      extent: extent,
      min: widget.min,
      max: widget.max,
      divisions: widget.divisions,
      reverse: reverse,
    );
    if (next != widget.value) {
      widget.onChanged!(next);
    }
  }

  void _endInteraction() {
    if (_pressed) {
      setState(() => _pressed = false);
    }
    widget.onChangeEnd?.call(widget.value);
  }
}

/// Overlays optional track icons when segment space allows.
class _TrackIconsOverlay extends StatelessWidget {
  const _TrackIconsOverlay({
    required this.icons,
    required this.fraction,
    required this.trackKind,
    required this.axis,
    required this.child,
  });

  final M3ESliderTrackIcons icons;
  final double fraction;
  final M3ESliderTrackKind trackKind;
  final Axis axis;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        Positioned.fill(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints c) {
              final bool vertical = axis == Axis.vertical;
              final double extent = vertical ? c.maxHeight : c.maxWidth;
              final double icon = icons.size;
              final List<Widget> placed = <Widget>[];

              void place(Widget? w, double primary, {required bool active}) {
                if (w == null) {
                  return;
                }
                // Hide when the segment cannot fit the icon.
                final double activeLen = fraction * extent;
                final double inactiveLen = (1 - fraction) * extent;
                if (active && activeLen < icon + 8) {
                  return;
                }
                if (!active && inactiveLen < icon + 8) {
                  return;
                }
                placed.add(
                  Positioned(
                    left: vertical ? (c.maxWidth - icon) / 2 : primary,
                    top: vertical ? primary : (c.maxHeight - icon) / 2,
                    width: icon,
                    height: icon,
                    child: IconTheme.merge(
                      data: IconThemeData(size: icon),
                      child: w,
                    ),
                  ),
                );
              }

              if (trackKind == M3ESliderTrackKind.centered) {
                final double mid = extent / 2;
                place(icons.activeStart, mid - icon - 4, active: true);
                place(icons.activeEnd, fraction * extent + 4, active: true);
              } else {
                place(icons.activeStart, 4, active: true);
                place(
                  icons.activeEnd,
                  fraction * extent - icon - 4,
                  active: true,
                );
                place(
                  icons.inactiveStart,
                  fraction * extent + 4,
                  active: false,
                );
                place(
                  icons.inactiveEnd,
                  extent - icon - 4,
                  active: false,
                );
              }

              return Stack(children: placed);
            },
          ),
        ),
      ],
    );
  }
}
