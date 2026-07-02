import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for Material 3 Expressive Time Pickers.
abstract class M3ETimePickerTokens {
  /// The padding for the time picker container.
  static const EdgeInsets padding = EdgeInsets.all(24.0);

  /// The border radius for the time picker container.
  static BorderRadius get borderRadius => M3EShapes.radiusExtraLarge;

  /// The size of the dial.
  static const double dialSize = 256.0;

  /// The size of the time unit field.
  static const Size fieldSize = Size(96, 80);

  /// The margin for the time unit field.
  static const EdgeInsets fieldMargin = EdgeInsets.symmetric(horizontal: 4.0);

  /// The size of the period toggle option.
  static const Size periodOptionSize = Size(48, 40);

  /// The gap between fields and period toggle.
  static const double fieldPeriodGap = 12.0;

  /// The gap between header and dial.
  static const double headerDialGap = 24.0;

  /// Resolves the container background color.
  static Color containerColor(M3EColorScheme scheme) {
    return scheme.surfaceContainerHigh;
  }

  /// Resolves the period option background color based on selection.
  static Color periodOptionBackgroundColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) {
    return selected ? scheme.tertiaryContainer : const Color(0x00000000);
  }

  /// Resolves the period option foreground color based on selection.
  static Color periodOptionForegroundColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) {
    return selected ? scheme.onTertiaryContainer : scheme.onSurfaceVariant;
  }

  /// Resolves the unit field background color based on active state.
  static Color fieldBackgroundColor(
    M3EColorScheme scheme, {
    required bool active,
  }) {
    return active ? scheme.primaryContainer : scheme.surfaceContainerHighest;
  }

  /// Resolves the unit field foreground color based on active state.
  static Color fieldForegroundColor(
    M3EColorScheme scheme, {
    required bool active,
  }) {
    return active ? scheme.onPrimaryContainer : scheme.onSurface;
  }
}
