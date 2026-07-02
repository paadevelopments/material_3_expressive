import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3EFabMenu`, following the Material 3 FAB menu specs.
///
/// See https://m3.material.io/components/fab-menu/specs.
class M3EFabMenuTokens {
  const M3EFabMenuTokens._();

  /// Vertical offset between the trigger FAB and the first menu item.
  static const double menuOffset = 16;

  /// Scrim opacity behind the open menu.
  static const double scrimOpacity = 0.32;

  /// Vertical gap between menu items.
  static const double itemGap = 12;

  /// Height and horizontal padding of each menu item surface.
  static const double itemHeight = 56;
  static const double itemHorizontalPadding = 20;

  /// Icon glyph size within a menu item.
  static const double iconSize = 24;

  /// Gap between icon and label within a menu item.
  static const double iconLabelGap = 12;

  /// Elevation of each menu item surface.
  static const double itemElevation = M3EElevation.level3;

  /// Scrim color behind the open menu.
  static Color scrimColor(M3EColorScheme scheme) =>
      scheme.scrim.withValues(alpha: scrimOpacity);

  /// Container color of a menu item.
  static Color itemContainerColor(M3EColorScheme scheme) =>
      scheme.primaryContainer;

  /// Foreground color of a menu item (icon + label).
  static Color itemForegroundColor(M3EColorScheme scheme) =>
      scheme.onPrimaryContainer;

  /// Label text style for a menu item.
  static TextStyle itemLabelStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.titleMedium.copyWith(color: itemForegroundColor(scheme));
}
