import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';

/// Theme values for [M3ESwitch].
@immutable
class M3ESwitchTheme extends M3EThemeExtension<M3ESwitchTheme> {
  const M3ESwitchTheme({
    this.trackWidth = 52,
    this.trackHeight = 32,
    this.trackPadding = 4,
    this.thumbSizePressed = 28,
    this.thumbSizeSelected = 24,
    this.thumbSizeUnselected = 16,
    this.iconSize = 16,
    this.borderWidth = 2,
    this.disabledTrackOpacity = 0.12,
    this.disabledThumbOpacity = 0.38,
    this.disabledOutlineOpacity = 0.12,
  });

  static const M3ESwitchTheme defaults = M3ESwitchTheme();

  final double trackWidth;
  final double trackHeight;
  final double trackPadding;
  final double thumbSizePressed;
  final double thumbSizeSelected;
  final double thumbSizeUnselected;
  final double iconSize;
  final double borderWidth;
  final double disabledTrackOpacity;
  final double disabledThumbOpacity;
  final double disabledOutlineOpacity;

  double thumbSize({
    required bool pressed,
    required bool grown,
  }) {
    if (pressed) {
      return thumbSizePressed;
    }
    return grown ? thumbSizeSelected : thumbSizeUnselected;
  }

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

  Color outlineColor(M3EColorScheme scheme, {required bool enabled}) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledOutlineOpacity);
    }
    return scheme.outline;
  }

  Color iconColor(M3EColorScheme scheme, {required bool value}) =>
      value ? scheme.onPrimaryContainer : scheme.surfaceContainerHighest;

  @override
  M3ESwitchTheme copyWith({
    double? trackWidth,
    double? trackHeight,
    double? trackPadding,
    double? thumbSizePressed,
    double? thumbSizeSelected,
    double? thumbSizeUnselected,
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
      thumbSizePressed:
          _lerpDouble(thumbSizePressed, other.thumbSizePressed, t)!,
      thumbSizeSelected:
          _lerpDouble(thumbSizeSelected, other.thumbSizeSelected, t)!,
      thumbSizeUnselected:
          _lerpDouble(thumbSizeUnselected, other.thumbSizeUnselected, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      borderWidth: _lerpDouble(borderWidth, other.borderWidth, t)!,
      disabledTrackOpacity:
          _lerpDouble(disabledTrackOpacity, other.disabledTrackOpacity, t)!,
      disabledThumbOpacity:
          _lerpDouble(disabledThumbOpacity, other.disabledThumbOpacity, t)!,
      disabledOutlineOpacity:
          _lerpDouble(disabledOutlineOpacity, other.disabledOutlineOpacity, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
