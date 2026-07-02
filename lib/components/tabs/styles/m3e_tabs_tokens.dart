import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_tabs_variant.dart';

/// Design tokens for `M3ETabs`, following the Material 3 tabs specs.
///
/// See https://m3.material.io/components/tabs/specs.
class M3ETabsTokens {
  const M3ETabsTokens._();

  /// Height of the tab bar.
  static const double height = 48;

  /// Icon glyph size within a tab.
  static const double iconSize = 24;

  /// Height of the active indicator.
  static const double indicatorHeight = 3;

  /// Width of the primary variant indicator.
  static const double primaryIndicatorWidth = 32;

  /// Corner radius of the indicator top edge.
  static const double indicatorCornerRadius = 3;

  /// Background color of the tab bar.
  static Color backgroundColor(M3EColorScheme scheme) => scheme.surface;

  /// Bottom divider color of the tab bar.
  static Color dividerColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

  /// Foreground color of a tab label/icon.
  static Color tabColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) =>
      selected ? scheme.primary : scheme.onSurfaceVariant;

  /// Label text style for a tab.
  static TextStyle labelStyle(
    M3ETypeScale type,
    M3EColorScheme scheme, {
    required bool selected,
  }) =>
      type.titleSmall.copyWith(
        color: tabColor(scheme, selected: selected),
      );

  /// Active indicator color.
  static Color indicatorColor(M3EColorScheme scheme) => scheme.primary;

  /// Whether the indicator spans the full tab width for `M3ETabsVariant`.
  static bool indicatorFullWidth(M3ETabsVariant variant) =>
      variant == M3ETabsVariant.secondary;
}
