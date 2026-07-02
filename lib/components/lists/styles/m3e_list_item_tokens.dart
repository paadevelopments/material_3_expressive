import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3EListItem`, following the Material 3 list specs.
///
/// See https://m3.material.io/components/lists/specs.
class M3EListItemTokens {
  const M3EListItemTokens._();

  /// Horizontal padding of the row.
  static const double horizontalPadding = 16;

  /// Vertical padding for one/two-line and three-line rows.
  static const double verticalPadding = 8;
  static const double threeLineVerticalPadding = 12;

  /// Minimum row height.
  static const double minHeight = 40;

  /// Leading/trailing icon size.
  static const double iconSize = 24;

  /// Gap between leading/trailing widgets and the text block.
  static const double gap = 16;

  /// Background color of a selected row.
  static Color selectedColor(M3EColorScheme scheme) =>
      scheme.secondaryContainer;

  /// Color of leading/trailing icons.
  static Color iconColor(M3EColorScheme scheme) => scheme.onSurfaceVariant;

  /// Text styles for the three text slots.
  static TextStyle overlineStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.labelSmall.copyWith(color: scheme.onSurfaceVariant);

  static TextStyle headlineStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurface);

  static TextStyle supportingStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyMedium.copyWith(color: scheme.onSurfaceVariant);
}
