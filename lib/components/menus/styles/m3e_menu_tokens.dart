import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3EMenu`, following the Material 3 menu specs.
///
/// See https://m3.material.io/components/menus/specs.
class M3EMenuTokens {
  const M3EMenuTokens._();

  /// Width constraints of the menu surface.
  static const double minWidth = 112;
  static const double maxWidth = 280;

  /// Vertical padding of the menu container.
  static const double verticalPadding = 8;

  /// Offset between the anchor and the menu surface.
  static const double anchorOffset = 4;

  /// Height and horizontal padding of each menu entry.
  static const double entryHeight = 48;
  static const double entryHorizontalPadding = 12;

  /// Icon glyph size within an entry.
  static const double iconSize = 24;

  /// Gap between leading/trailing icons and the label.
  static const double iconGap = 12;

  /// Elevation of the menu surface.
  static const double elevation = M3EElevation.level2;

  /// Opacity applied to disabled entry text and icons.
  static const double disabledOpacity = 0.38;

  /// Container corner radius (M3 extra-small shape).
  static BorderRadius get borderRadius => M3EShapes.radiusExtraSmall;

  /// Container color of the menu surface.
  static Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainer;

  /// Foreground color of an entry.
  static Color entryForegroundColor(
    M3EColorScheme scheme, {
    required bool enabled,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledOpacity);
    }
    return scheme.onSurface;
  }

  /// Label text style for an entry.
  static TextStyle entryLabelStyle(
    M3ETypeScale type,
    M3EColorScheme scheme, {
    required bool enabled,
  }) =>
      type.labelLarge.copyWith(
        color: entryForegroundColor(scheme, enabled: enabled),
      );
}
