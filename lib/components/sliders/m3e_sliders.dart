// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// Slider / VerticalSlider / SliderDefaults.CenteredTrack
//
// build.gradle.kts (Module level)
// dependencies {
//   implementation("androidx.compose.material3:material3:1.4.0-alpha01") // or 1.3.x stable
// }

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_slider_centered_track.dart';
import 'components/m3e_slider_dot_overlay.dart';
import 'components/m3e_slider_thumb.dart';
import 'components/m3e_slider_track.dart';
import 'components/m3e_slider_value_indicator.dart';
import 'enums/m3e_slider_enums.dart';
import 'models/m3e_slider_dot_builder.dart';
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
export 'models/m3e_slider_dot_builder.dart';
export 'models/m3e_slider_range.dart';
export 'models/m3e_slider_range_labels.dart';
export 'models/m3e_slider_track_icons.dart';
export 'styles/m3e_slider_theme.dart';

/// A Material 3 Expressive slider.
///
/// Mirrors Compose Material 3:
/// - [M3ESlider] → `Slider` + `SliderDefaults.Track`
/// - [M3ESlider.centered] → `Slider` + `SliderDefaults.CenteredTrack`
/// - [M3ESlider.wavy] → `Slider` with a wavy active value (linear track)
/// - [M3ESlider.vertical] → `VerticalSlider`
/// - [M3ESlider.verticalCentered] → `VerticalSlider` + `CenteredTrack`
///
/// Selects a single value from a continuous or, when `divisions` is set,
/// discrete range. Disable by setting `enabled` to `false` or passing a null
/// `onChanged`.

part 'components/m3e_slider_track_icons_overlay.dart';
part 'components/m3e_slider_build.dart';

/// M3ESlider.

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
    this.trackThickness,
    this.thumbLength,
    this.dotSize,
    this.dotSpacing,
    this.dotBuilder,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.haptic = M3EHapticFeedback.none,
    this.icon,
    this.iconPosition = M3ESliderIconPosition.end,
    this.iconSize,
    super.key,
  }) : axis = Axis.horizontal,
       trackKind = M3ESliderTrackKind.standard,
       topToBottom = true,
       wavy = false,
       amplitude = null,
       amplitudeForProgress = null,
       wavelength = null,
       waveSpeed = null,
       assert(max > min, 'max must be greater than min.'),
       assert(
         icon == null || divisions == null,
         'icon requires divisions to be null.',
       );

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
    this.trackThickness,
    this.thumbLength,
    this.dotSize,
    this.dotSpacing,
    this.dotBuilder,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.haptic = M3EHapticFeedback.none,
    super.key,
  }) : axis = Axis.horizontal,
       trackKind = M3ESliderTrackKind.centered,
       topToBottom = true,
       wavy = false,
       amplitude = null,
       amplitudeForProgress = null,
       wavelength = null,
       waveSpeed = null,
       icon = null,
       iconPosition = M3ESliderIconPosition.end,
       iconSize = null,
       assert(max > min, 'max must be greater than min.');

  /// Horizontal slider whose active value is a traveling sine wave.
  ///
  /// Inactive track, thumb, gaps, ticks, and interaction match [M3ESlider];
  /// only the active value segment uses the linear-wavy progress recipe.
  const M3ESlider.wavy({
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
    this.trackThickness,
    this.thumbLength,
    this.dotSize,
    this.dotSpacing,
    this.dotBuilder,
    this.amplitude,
    this.amplitudeForProgress,
    this.wavelength,
    this.waveSpeed,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.haptic = M3EHapticFeedback.none,
    this.icon,
    this.iconPosition = M3ESliderIconPosition.end,
    this.iconSize,
    super.key,
  }) : axis = Axis.horizontal,
       trackKind = M3ESliderTrackKind.standard,
       topToBottom = true,
       wavy = true,
       assert(max > min, 'max must be greater than min.'),
       assert(
         icon == null || divisions == null,
         'icon requires divisions to be null.',
       );

  /// Horizontal centered slider with a wavy active value segment.
  const M3ESlider.wavyCentered({
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
    this.trackThickness,
    this.thumbLength,
    this.dotSize,
    this.dotSpacing,
    this.dotBuilder,
    this.amplitude,
    this.amplitudeForProgress,
    this.wavelength,
    this.waveSpeed,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.haptic = M3EHapticFeedback.none,
    super.key,
  }) : axis = Axis.horizontal,
       trackKind = M3ESliderTrackKind.centered,
       topToBottom = true,
       wavy = true,
       icon = null,
       iconPosition = M3ESliderIconPosition.end,
       iconSize = null,
       assert(max > min, 'max must be greater than min.');

  /// Vertical slider (Compose `VerticalSlider`).
  ///
  /// By default [topToBottom] is `false`: [min] is at the bottom and [max] at
  /// the top (slide up to increase).
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
    this.trackThickness,
    this.thumbLength,
    this.dotSize,
    this.dotSpacing,
    this.dotBuilder,
    this.topToBottom = false,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.haptic = M3EHapticFeedback.none,
    this.icon,
    this.iconPosition = M3ESliderIconPosition.end,
    this.iconSize,
    super.key,
  }) : axis = Axis.vertical,
       trackKind = M3ESliderTrackKind.standard,
       wavy = false,
       amplitude = null,
       amplitudeForProgress = null,
       wavelength = null,
       waveSpeed = null,
       assert(max > min, 'max must be greater than min.'),
       assert(
         icon == null || divisions == null,
         'icon requires divisions to be null.',
       );

  /// Vertical slider with a centered active track.
  ///
  /// By default [topToBottom] is `false`: [min] is at the bottom and [max] at
  /// the top (slide up to increase).
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
    this.trackThickness,
    this.thumbLength,
    this.dotSize,
    this.dotSpacing,
    this.dotBuilder,
    this.topToBottom = false,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.haptic = M3EHapticFeedback.none,
    super.key,
  }) : axis = Axis.vertical,
       trackKind = M3ESliderTrackKind.centered,
       wavy = false,
       amplitude = null,
       amplitudeForProgress = null,
       wavelength = null,
       waveSpeed = null,
       icon = null,
       iconPosition = M3ESliderIconPosition.end,
       iconSize = null,
       assert(max > min, 'max must be greater than min.');

  /// Current value in [min]..[max].
  final double value;

  /// Called when the value changes. Null disables the slider.
  final ValueChanged<double>? onChanged;

  /// min.

  final double min;

  /// max.
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
  })?
  thumbBuilder;

  /// Replaces the default track painter widget.
  final Widget Function({
    required BuildContext context,
    required M3ESliderColors colors,
    required M3ESliderTheme theme,
    required double fraction,
    required List<double> tickFractions,
    required double handleThickness,
  })?
  trackBuilder;

  /// axis.

  final Axis axis;

  /// trackKind.
  final M3ESliderTrackKind trackKind;

  /// When [axis] is vertical, `true` maps the top edge to [min].
  ///
  /// Defaults to `false` on vertical constructors so [min] is at the bottom
  /// and sliding up increases the value.
  final bool topToBottom;

  /// When true, paints the active value as a traveling sine wave.
  final bool wavy;

  /// Fixed amplitude factor `0..1` for [wavy] tracks.
  final double? amplitude;

  /// Amplitude factor as a function of progress for [wavy] tracks.
  final double Function(double progress)? amplitudeForProgress;

  /// Wave length in logical pixels ([wavy] only).
  final double? wavelength;

  /// Wave travel speed in logical pixels per second ([wavy] only).
  final double? waveSpeed;

  /// Thickness of both active and inactive tracks. Defaults to theme track height.
  final double? trackThickness;

  /// Length of the thumb along its long axis. Defaults to theme handle height.
  final double? thumbLength;

  /// Diameter of stop/tick markers. Defaults to theme stop indicator size.
  final double? dotSize;

  /// Clear space between each track end and the outer edge of the end dots.
  ///
  /// Defaults to theme [M3ESliderTheme.stopIndicatorTrailingSpace].
  final double? dotSpacing;

  /// Custom stop/tick markers. When null, default circular dots are painted.
  final M3ESliderDotBuilder? dotBuilder;

  /// Whether the slider responds to user interaction.
  ///
  /// The slider is also disabled when [onChanged] is null.
  final bool enabled;

  /// Focus node for keyboard/traditional focus.
  final FocusNode? focusNode;

  /// Whether this slider should be focused initially.
  final bool autofocus;

  /// Haptic feedback intensity fired on discrete value changes.
  final M3EHapticFeedback haptic;

  /// Optional icon rendered on the relocating track end.
  ///
  /// Mutually exclusive with [divisions].
  final Widget? icon;

  /// Resting edge for [icon] along the track.
  final M3ESliderIconPosition iconPosition;

  /// Size of [icon]. Defaults to 24 logical pixels when null.
  final double? iconSize;

  @override
  State<M3ESlider> createState() => _M3ESliderState();
}

class _M3ESliderState extends State<M3ESlider> with TickerProviderStateMixin {
  bool _pressed = false;
  bool _dragging = false;
  bool _isFocusedFromPointer = false;
  bool _iconDocked = false;
  bool _ownsFocusNode = false;
  late FocusNode _focusNode;
  late final AnimationController _waveController;
  late final SingleMotionController _dockController;
  final Stopwatch _hapticStopwatch = Stopwatch();

  bool get _enabled => widget.enabled && widget.onChanged != null;
  bool get _vertical => widget.axis == Axis.vertical;

  /// Shows a focus outline for keyboard/traditional focus, matching desktop
  /// convention of hiding it after a pointer-driven focus grab.
  bool get _showFocusOutline {
    if (!_focusNode.hasFocus) {
      return false;
    }
    if (FocusManager.instance.highlightMode == FocusHighlightMode.traditional) {
      return true;
    }
    return !_isFocusedFromPointer;
  }

  double get _fraction =>
      M3ESliderMath.fraction(widget.value, widget.min, widget.max);

  List<double> get _ticks => M3ESliderMath.tickFractions(widget.divisions);

  @override
  void initState() {
    super.initState();
    _attachFocusNode(widget.focusNode);
    _waveController = AnimationController(
      vsync: this,
      duration: M3EMotion.extraLong2,
    );
    _dockController = SingleMotionController(
      motion: const MaterialSpringMotion.expressiveSpatialFast(),
      vsync: this,
    )..addListener(_handleDockTick);
    if (widget.wavy) {
      _waveController.repeat();
    }
  }

  void _attachFocusNode(FocusNode? external) {
    _focusNode = external ?? FocusNode();
    _ownsFocusNode = external == null;
    _focusNode.addListener(_handleFocusChange);
  }

  void _detachFocusNode() {
    _focusNode.removeListener(_handleFocusChange);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      _isFocusedFromPointer = false;
    }
    setState(() {});
  }

  void _handleDockTick() => setState(() {});

  @override
  void didUpdateWidget(M3ESlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _detachFocusNode();
      _attachFocusNode(widget.focusNode);
    }
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
    _detachFocusNode();
    _waveController.dispose();
    _dockController.dispose();
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
    if (widget.amplitudeForProgress != null) {
      return widget.amplitudeForProgress!(_fraction).clamp(0.0, 1.0);
    }
    if (widget.amplitude != null) {
      return widget.amplitude!.clamp(0.0, 1.0);
    }
    return theme.amplitudeForProgress(_fraction).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final _M3ESliderResolved resolved = _resolve(context);
    return M3EComponentTheme(
      builder: (BuildContext context) {
        return Semantics(
          slider: true,
          enabled: _enabled,
          value:
              widget.semanticFormatterCallback?.call(widget.value) ??
              resolved.indicatorLabel,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return _buildLayout(context, constraints, resolved);
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
    _setValue(next);
  }

  void _setValue(double raw) {
    if (!_enabled) {
      return;
    }
    final double next = widget.divisions != null
        ? M3ESliderMath.snap(
            raw.clamp(widget.min, widget.max),
            widget.min,
            widget.max,
            widget.divisions,
          )
        : raw.clamp(widget.min, widget.max);
    if (next == widget.value) {
      return;
    }
    if (widget.divisions != null) {
      if (widget.haptic != M3EHapticFeedback.none) {
        M3EHaptics.trigger(widget.haptic);
      }
    } else if (widget.haptic != M3EHapticFeedback.none && _dragging) {
      _maybeContinuousHaptic();
    }
    widget.onChanged!(next);
  }

  void _maybeContinuousHaptic() {
    if (!_hapticStopwatch.isRunning ||
        _hapticStopwatch.elapsedMilliseconds >= 60) {
      M3EHaptics.selection();
      _hapticStopwatch
        ..reset()
        ..start();
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!_enabled || !M3ESliderMath.isNavigationKey(event.logicalKey)) {
      return KeyEventResult.ignored;
    }
    if (event is KeyUpEvent) {
      widget.onChangeEnd?.call(widget.value);
      return KeyEventResult.handled;
    }
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      final double step = M3ESliderMath.stepSize(
        widget.min,
        widget.max,
        widget.divisions,
      );
      final double? next = _keyboardDelta(event.logicalKey, step);
      if (next != null) {
        _setValue(next);
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  double? _keyboardDelta(LogicalKeyboardKey key, double step) {
    switch (key) {
      case LogicalKeyboardKey.arrowRight:
      case LogicalKeyboardKey.arrowUp:
        return widget.value + step;
      case LogicalKeyboardKey.arrowLeft:
      case LogicalKeyboardKey.arrowDown:
        return widget.value - step;
      case LogicalKeyboardKey.pageUp:
        return widget.value + M3ESliderMath.pageStep(step, widget.divisions);
      case LogicalKeyboardKey.pageDown:
        return widget.value - M3ESliderMath.pageStep(step, widget.divisions);
      case LogicalKeyboardKey.home:
        return widget.min;
      case LogicalKeyboardKey.end:
        return widget.max;
      default:
        return null;
    }
  }

  void _endInteraction() {
    _dragging = false;
    if (_pressed) {
      setState(() => _pressed = false);
    }
    widget.onChangeEnd?.call(widget.value);
  }
}

/// Overlays optional track icons when segment space allows.
