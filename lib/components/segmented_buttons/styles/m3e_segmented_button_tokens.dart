import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for Material 3 Expressive Segmented Buttons.
abstract class M3ESegmentedButtonTokens {
  /// The default height of a segmented button.
  static const double height = 40.0;

  /// The default icon size.
  static const double iconSize = 18.0;

  /// Resolves the foreground color for a segment based on selection.
  static Color foregroundColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) {
    return selected ? scheme.onSecondaryContainer : scheme.onSurface;
  }

  /// Resolves the background color for a segment based on selection.
  static Color? backgroundColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) {
    return selected ? scheme.secondaryContainer : null;
  }

  /// The border radius for the segmented button container.
  static BorderRadius borderRadius(BuildContext context) {
    return M3EShapes.resolve(height / 2);
  }

  /// The horizontal padding for each segment's label.
  static const double segmentHorizontalPadding = 12.0;

  /// The gap between the leading icon and the label.
  static const double iconLabelGap = 8.0;

  /// The width of the outer border and inter-segment dividers.
  static const double borderWidth = 1.0;
}
