import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3ERadio`, following the Material 3 radio button specs.
///
/// See https://m3.material.io/components/radio-button/specs.
class M3ERadioTokens {
  const M3ERadioTokens._();

  /// Diameter of the outer ring.
  static const double ringSize = 20;

  /// Diameter of the surrounding state layer / touch target.
  static const double hitSize = 40;

  /// Diameter of the selected inner dot.
  static const double dotSize = 10;

  /// Ring stroke width.
  static const double borderWidth = 2;

  /// Opacity applied to disabled elements.
  static const double disabledOpacity = 0.38;

  /// Base color of the state layer.
  static Color stateLayerColor(M3EColorScheme scheme, {required bool selected}) =>
      selected ? scheme.primary : scheme.onSurface;

  /// Resolved ring and dot color.
  static Color color(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool error,
    required bool selected,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledOpacity);
    }
    if (error) {
      return scheme.error;
    }
    return selected ? scheme.primary : scheme.onSurfaceVariant;
  }
}
