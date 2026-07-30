import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ESwitch`.
@immutable
class M3ESwitchTheme extends M3EThemeExtension<M3ESwitchTheme> {
  /// M3ESwitchTheme.
  const M3ESwitchTheme({
    this.trackWidth = 52,
    this.trackHeight = 32,
    this.trackPadding = 4,
    this.thumbSizePressed = 28,
    this.thumbSizeSelected = 24,
    this.thumbSizeUnselected = 16,
    this.stateLayerSize = 48,
    this.iconSize = 16,
    this.borderWidth = 2,
    this.disabledTrackOpacity = 0.12,
    this.disabledThumbOpacity = 0.38,
    this.disabledOutlineOpacity = 0.12,
  });

  /// defaults.

  static const M3ESwitchTheme defaults = M3ESwitchTheme();

  /// trackWidth.

  final double trackWidth;

  /// trackHeight.
  final double trackHeight;

  /// trackPadding.
  final double trackPadding;

  /// thumbSizePressed.
  final double thumbSizePressed;

  /// thumbSizeSelected.
  final double thumbSizeSelected;

  /// thumbSizeUnselected.
  final double thumbSizeUnselected;

  /// Diameter of the thumb-centered hover/focus/press state layer.
  final double stateLayerSize;

  /// iconSize.
  final double iconSize;

  /// borderWidth.
  final double borderWidth;

  /// disabledTrackOpacity.
  final double disabledTrackOpacity;

  /// disabledThumbOpacity.
  final double disabledThumbOpacity;

  /// disabledOutlineOpacity.
  final double disabledOutlineOpacity;

  /// thumbSize.

  double thumbSize({required bool pressed, required bool grown}) {
    if (pressed) {
      return thumbSizePressed;
    }
    return grown ? thumbSizeSelected : thumbSizeUnselected;
  }

  /// trackColor.

  Color trackColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool value,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(
        value ? scheme.onSurface : scheme.surfaceContainerHighest,
        disabledTrackOpacity,
      );
    }
    return value ? scheme.primary : scheme.surfaceContainerHighest;
  }

  /// thumbColor.

  Color thumbColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool value,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledThumbOpacity);
    }
    return value ? scheme.onPrimary : scheme.outline;
  }

  /// outlineColor.

  Color outlineColor(M3EColorScheme scheme, {required bool enabled}) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(
        scheme.onSurface,
        disabledOutlineOpacity,
      );
    }
    return scheme.outline;
  }

  /// iconColor.

  Color iconColor(M3EColorScheme scheme, {required bool value}) =>
      value ? scheme.onPrimaryContainer : scheme.surfaceContainerHighest;

  /// stateLayerColor.

  Color stateLayerColor(M3EColorScheme scheme, {required bool value}) =>
      value ? scheme.primary : scheme.onSurface;

  @override
  M3ESwitchTheme copyWith({
    double? trackWidth,
    double? trackHeight,
    double? trackPadding,
    double? thumbSizePressed,
    double? thumbSizeSelected,
    double? thumbSizeUnselected,
    double? stateLayerSize,
    double? iconSize,
    double? borderWidth,
    double? disabledTrackOpacity,
    double? disabledThumbOpacity,
    double? disabledOutlineOpacity,
  }) {
    return M3ESwitchTheme(
      trackWidth: trackWidth ?? this.trackWidth,
      trackHeight: trackHeight ?? this.trackHeight,
      trackPadding: trackPadding ?? this.trackPadding,
      thumbSizePressed: thumbSizePressed ?? this.thumbSizePressed,
      thumbSizeSelected: thumbSizeSelected ?? this.thumbSizeSelected,
      thumbSizeUnselected: thumbSizeUnselected ?? this.thumbSizeUnselected,
      stateLayerSize: stateLayerSize ?? this.stateLayerSize,
      iconSize: iconSize ?? this.iconSize,
      borderWidth: borderWidth ?? this.borderWidth,
      disabledTrackOpacity: disabledTrackOpacity ?? this.disabledTrackOpacity,
      disabledThumbOpacity: disabledThumbOpacity ?? this.disabledThumbOpacity,
      disabledOutlineOpacity:
          disabledOutlineOpacity ?? this.disabledOutlineOpacity,
    );
  }

  @override
  M3ESwitchTheme lerp(M3ESwitchTheme? other, double t) {
    if (other is! M3ESwitchTheme) {
      return this;
    }
    return M3ESwitchTheme(
      trackWidth: _lerpDouble(trackWidth, other.trackWidth, t)!,
      trackHeight: _lerpDouble(trackHeight, other.trackHeight, t)!,
      trackPadding: _lerpDouble(trackPadding, other.trackPadding, t)!,
      thumbSizePressed: _lerpDouble(
        thumbSizePressed,
        other.thumbSizePressed,
        t,
      )!,
      thumbSizeSelected: _lerpDouble(
        thumbSizeSelected,
        other.thumbSizeSelected,
        t,
      )!,
      thumbSizeUnselected: _lerpDouble(
        thumbSizeUnselected,
        other.thumbSizeUnselected,
        t,
      )!,
      stateLayerSize: _lerpDouble(stateLayerSize, other.stateLayerSize, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      borderWidth: _lerpDouble(borderWidth, other.borderWidth, t)!,
      disabledTrackOpacity: _lerpDouble(
        disabledTrackOpacity,
        other.disabledTrackOpacity,
        t,
      )!,
      disabledThumbOpacity: _lerpDouble(
        disabledThumbOpacity,
        other.disabledThumbOpacity,
        t,
      )!,
      disabledOutlineOpacity: _lerpDouble(
        disabledOutlineOpacity,
        other.disabledOutlineOpacity,
        t,
      )!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
