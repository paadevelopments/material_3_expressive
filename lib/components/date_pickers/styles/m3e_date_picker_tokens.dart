import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for Material 3 Expressive Date Pickers.
abstract class M3EDatePickerTokens {
  /// The default width of a date picker.
  static const double width = 328.0;

  /// The padding for the date picker container.
  static const EdgeInsets padding = EdgeInsets.all(12.0);

  /// The border radius for the date picker container.
  static BorderRadius get borderRadius => M3EShapes.radiusExtraLarge;

  /// The size of the day selection circle.
  static const double daySize = 40.0;

  /// The icon size for navigation arrows.
  static const double arrowIconSize = 24.0;

  /// The tap padding around a navigation arrow.
  static const EdgeInsets arrowPadding = EdgeInsets.all(8.0);

  /// The top padding of the day grid.
  static const EdgeInsets gridPadding = EdgeInsets.only(top: 4.0);

  /// The number of days shown per calendar row.
  static const int daysPerWeek = 7;

  /// Resolves the container background color.
  static Color containerColor(M3EColorScheme scheme) {
    return scheme.surfaceContainerHigh;
  }

  /// Resolves the day foreground color based on state.
  static Color dayForegroundColor(
    M3EColorScheme scheme, {
    required bool selected,
    required bool enabled,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return selected ? scheme.onPrimary : scheme.onSurface;
  }
}
