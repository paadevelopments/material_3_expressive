import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3ESearchBar`, following the Material 3 search specs.
///
/// See https://m3.material.io/components/search/specs.
class M3ESearchBarTokens {
  const M3ESearchBarTokens._();

  /// Height of the search bar container.
  static const double height = 56;

  /// Horizontal padding of the container.
  static const double horizontalPadding = 16;

  /// Corner radius (fully rounded at this height).
  static const double cornerRadius = 28;

  /// Icon glyph size for leading and trailing actions.
  static const double iconSize = 24;

  /// Gap between the leading icon and the input area.
  static const double leadingGap = 16;

  /// Elevation when `M3ESearchBar.elevated` is true.
  static const double elevation = M3EElevation.level1;

  /// Opacity applied to the text selection highlight.
  static const double selectionOpacity = 0.4;

  /// Container color of the search bar.
  static Color containerColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHigh;

  /// Icon color for leading and trailing actions.
  static Color iconColor(M3EColorScheme scheme) => scheme.onSurfaceVariant;

  /// Hint and placeholder text style.
  static TextStyle hintStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurfaceVariant);

  /// Input text style.
  static TextStyle inputStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurface);

  /// Cursor color.
  static Color cursorColor(M3EColorScheme scheme) => scheme.primary;

  /// Selection highlight color.
  static Color selectionColor(M3EColorScheme scheme) =>
      scheme.primary.withValues(alpha: selectionOpacity);
}
