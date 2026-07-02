import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_toolbar_color.dart';

/// Design tokens for `M3EToolbar`, following the Material 3 toolbar specs.
///
/// See https://m3.material.io/components/toolbars/specs.
class M3EToolbarTokens {
  const M3EToolbarTokens._();

  /// Inner padding of the toolbar surface.
  static const EdgeInsets padding = EdgeInsets.all(8);

  /// Icon glyph size for toolbar actions.
  static const double iconSize = 24;

  /// Elevation of the floating toolbar.
  static const double elevation = M3EElevation.level2;

  /// Background color for `M3EToolbarColor`.
  static Color backgroundColor(
    M3EColorScheme scheme,
    M3EToolbarColor color,
  ) {
    switch (color) {
      case M3EToolbarColor.standard:
        return scheme.surfaceContainer;
      case M3EToolbarColor.vibrant:
        return scheme.primaryContainer;
    }
  }

  /// Foreground (icon) color for `M3EToolbarColor`.
  static Color foregroundColor(
    M3EColorScheme scheme,
    M3EToolbarColor color,
  ) {
    switch (color) {
      case M3EToolbarColor.standard:
        return scheme.onSurfaceVariant;
      case M3EToolbarColor.vibrant:
        return scheme.onPrimaryContainer;
    }
  }
}
