import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3EFabMenu`.
@immutable
class M3EFabMenuTheme extends M3EThemeExtension<M3EFabMenuTheme> {
  /// M3EFabMenuTheme.
  const M3EFabMenuTheme({
    this.menuOffset = 12,
    this.scrimOpacity = 0.0,
    this.itemGap = 12,
    this.itemHeight = 56,
    this.itemHorizontalPadding = 20,
    this.iconSize = 24,
    this.iconLabelGap = 12,
    this.itemElevation = M3EElevation.level3,
    this.closedFabContainer = 80,
    this.openFabContainer = 56,
  });

  /// defaults.

  static const M3EFabMenuTheme defaults = M3EFabMenuTheme();

  /// Vertical gap between the FAB and the nearest menu item.
  ///
  /// Independent of [itemGap] (spacing between items). Defaults to 12.
  final double menuOffset;

  /// scrimOpacity.
  final double scrimOpacity;

  /// Spacing between adjacent menu items. Not applied below the last item.
  final double itemGap;

  /// itemHeight.
  final double itemHeight;

  /// itemHorizontalPadding.
  final double itemHorizontalPadding;

  /// iconSize.
  final double iconSize;

  /// iconLabelGap.
  final double iconLabelGap;

  /// itemElevation.
  final double itemElevation;

  /// FAB outer size when the menu is closed (matches toolbar FAB medium).
  final double closedFabContainer;

  /// FAB outer size when the menu is open (matches toolbar FAB baseline).
  final double openFabContainer;

  /// scrimColor.

  Color scrimColor(M3EColorScheme scheme) =>
      scheme.scrim.withValues(alpha: scrimOpacity);

  /// itemContainerColor.

  Color itemContainerColor(M3EColorScheme scheme) => scheme.primaryContainer;

  /// itemForegroundColor.

  Color itemForegroundColor(M3EColorScheme scheme) => scheme.onPrimaryContainer;

  /// itemLabelStyle.

  TextStyle itemLabelStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.titleMedium.copyWith(color: itemForegroundColor(scheme));

  @override
  M3EFabMenuTheme copyWith({
    double? menuOffset,
    double? scrimOpacity,
    double? itemGap,
    double? itemHeight,
    double? itemHorizontalPadding,
    double? iconSize,
    double? iconLabelGap,
    double? itemElevation,
    double? closedFabContainer,
    double? openFabContainer,
  }) {
    return M3EFabMenuTheme(
      menuOffset: menuOffset ?? this.menuOffset,
      scrimOpacity: scrimOpacity ?? this.scrimOpacity,
      itemGap: itemGap ?? this.itemGap,
      itemHeight: itemHeight ?? this.itemHeight,
      itemHorizontalPadding:
          itemHorizontalPadding ?? this.itemHorizontalPadding,
      iconSize: iconSize ?? this.iconSize,
      iconLabelGap: iconLabelGap ?? this.iconLabelGap,
      itemElevation: itemElevation ?? this.itemElevation,
      closedFabContainer: closedFabContainer ?? this.closedFabContainer,
      openFabContainer: openFabContainer ?? this.openFabContainer,
    );
  }

  @override
  M3EFabMenuTheme lerp(M3EFabMenuTheme? other, double t) {
    if (other is! M3EFabMenuTheme) {
      return this;
    }
    return M3EFabMenuTheme(
      menuOffset: _lerpDouble(menuOffset, other.menuOffset, t)!,
      scrimOpacity: _lerpDouble(scrimOpacity, other.scrimOpacity, t)!,
      itemGap: _lerpDouble(itemGap, other.itemGap, t)!,
      itemHeight: _lerpDouble(itemHeight, other.itemHeight, t)!,
      itemHorizontalPadding: _lerpDouble(
        itemHorizontalPadding,
        other.itemHorizontalPadding,
        t,
      )!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      iconLabelGap: _lerpDouble(iconLabelGap, other.iconLabelGap, t)!,
      itemElevation: _lerpDouble(itemElevation, other.itemElevation, t)!,
      closedFabContainer: _lerpDouble(
        closedFabContainer,
        other.closedFabContainer,
        t,
      )!,
      openFabContainer: _lerpDouble(
        openFabContainer,
        other.openFabContainer,
        t,
      )!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
