import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3ESwitch`, following the Material 3 switch specs.
///
/// See https://m3.material.io/components/switch/specs.
class M3ESwitchTokens {
  const M3ESwitchTokens._();

  /// Track dimensions.
  static const double trackWidth = 52;
  static const double trackHeight = 32;

  /// Inset between the track edge and the thumb.
  static const double trackPadding = 4;

  /// Thumb diameters for the pressed / selected / unselected states.
  static const double thumbSizePressed = 28;
  static const double thumbSizeSelected = 24;
  static const double thumbSizeUnselected = 16;

  /// Thumb icon glyph size.
  static const double iconSize = 16;

  /// Track outline width (unselected).
  static const double borderWidth = 2;

  /// Disabled-state opacities.
  static const double disabledTrackOpacity = 0.12;
  static const double disabledThumbOpacity = 0.38;
  static const double disabledOutlineOpacity = 0.12;

  /// Thumb diameter for the current state.
  static double thumbSize({
    required bool pressed,
    required bool grown,
  }) {
    if (pressed) {
      return thumbSizePressed;
    }
    return grown ? thumbSizeSelected : thumbSizeUnselected;
  }

  /// Track fill color.
  static Color trackColor(
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

  /// Thumb fill color.
  static Color thumbColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool value,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledThumbOpacity);
    }
    return value ? scheme.onPrimary : scheme.outline;
  }

  /// Track outline color (unselected only).
  static Color outlineColor(M3EColorScheme scheme, {required bool enabled}) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledOutlineOpacity);
    }
    return scheme.outline;
  }

  /// Thumb icon color.
  static Color iconColor(M3EColorScheme scheme, {required bool value}) =>
      value ? scheme.onPrimaryContainer : scheme.surfaceContainerHighest;
}
