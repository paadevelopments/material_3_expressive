import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3ECheckbox`, following the Material 3 checkbox specs.
///
/// See https://m3.material.io/components/checkbox/specs.
class M3ECheckboxTokens {
  const M3ECheckboxTokens._();

  /// Size of the checkbox container.
  static const double boxSize = 18;

  /// Size of the surrounding state layer / touch target.
  static const double hitSize = 40;

  /// Size of the check glyph.
  static const double markSize = 16;

  /// Dimensions of the indeterminate bar.
  static const double indeterminateWidth = 10;
  static const double indeterminateHeight = 2;

  /// Outline width of the container.
  static const double borderWidth = 2;

  /// Container corner radius (M3 extra-small shape).
  static BorderRadius get borderRadius => M3EShapes.radiusExtraSmall;

  /// Opacity applied to disabled elements.
  static const double disabledOpacity = 0.38;

  static const Color _transparent = Color(0x00000000);

  /// Base color of the state layer.
  static Color stateLayerColor(
    M3EColorScheme scheme, {
    required bool active,
    required bool error,
  }) {
    if (error) {
      return scheme.error;
    }
    return active ? scheme.primary : scheme.onSurface;
  }

  /// Fill color of the container.
  static Color fillColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool active,
    required bool error,
  }) {
    if (!enabled) {
      return active
          ? M3EColorUtils.withOpacity(scheme.onSurface, disabledOpacity)
          : _transparent;
    }
    if (!active) {
      return _transparent;
    }
    return error ? scheme.error : scheme.primary;
  }

  /// Outline color of the container.
  static Color borderColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool active,
    required bool error,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledOpacity);
    }
    if (active) {
      return error ? scheme.error : scheme.primary;
    }
    return error ? scheme.error : scheme.onSurfaceVariant;
  }

  /// Color of the check mark / indeterminate bar.
  static Color markColor(M3EColorScheme scheme, {required bool error}) =>
      error ? scheme.onError : scheme.onPrimary;
}
