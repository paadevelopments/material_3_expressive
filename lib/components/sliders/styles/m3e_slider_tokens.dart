import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for Material 3 Expressive Sliders.
abstract class M3ESliderTokens {
  /// The default height of the slider hit area.
  static const double height = 44.0;

  /// The default track height (expressive thick track).
  static const double trackHeight = 16.0;

  /// The gap around the vertical handle.
  static const double handleGap = 4.0;

  /// The width of the vertical handle.
  static const double handleWidth = 4.0;

  /// Resolves the color based on enabled state.
  static Color color(
    M3EColorScheme scheme, {
    required Color enabledColor,
    required bool enabled,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return enabledColor;
  }
}
