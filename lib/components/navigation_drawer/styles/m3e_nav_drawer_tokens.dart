import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for Material 3 Expressive Navigation Drawers.
abstract class M3ENavDrawerTokens {
  /// The default width of a navigation drawer.
  static const double width = 360.0;

  /// The height of a single destination item.
  static const double destinationHeight = 56.0;

  /// The horizontal padding for the headline.
  static const double headlineHorizontalPadding = 28.0;

  /// The vertical padding for the headline.
  static const double headlineVerticalPadding = 16.0;

  /// The icon size for destination items.
  static const double iconSize = 24.0;

  /// Resolves the container background color.
  static Color containerColor(M3EColorScheme scheme) {
    return scheme.surfaceContainerLow;
  }

  /// Resolves the foreground color for a destination item based on selection.
  static Color destinationForegroundColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) {
    return selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;
  }

  /// Resolves the background color for a destination item based on selection.
  static Color destinationBackgroundColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) {
    return selected ? scheme.secondaryContainer : const Color(0x00000000);
  }

  /// The shape of the destination item.
  static ShapeBorder destinationShape(BuildContext context) {
    return RoundedRectangleBorder(borderRadius: M3EShapes.resolve(28));
  }
}
