import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ENavigationRail`.
@immutable
class M3ENavigationRailTheme extends M3EThemeExtension<M3ENavigationRailTheme> {
  /// M3ENavigationRailTheme.
  const M3ENavigationRailTheme({
    this.collapsedWidth = 96.0,
    this.expandedMinWidth = 220.0,
    this.expandedMaxWidth = 360.0,
    this.itemExpandedHeight = 40.0,
    this.itemCollapsedHeight = 66.0,
    this.iconSize = 24.0,
    this.indicatorLeading = 16.0,
    this.indicatorTrailing = 16.0,
    this.iconLabelGap = 8.0,
    this.itemVerticalGap = 4.0,
    this.headerMinSpace = 40.0,
    this.sectionHeaderSpacingTop = 12.0,
    this.sectionHeaderSpacingBottom = 8.0,
    this.containerColor,
    this.activeIndicatorColor,
    this.activeIconAndLabel,
    this.inactiveIconAndLabel,
    this.menuColor,
    this.badgeBackground,
    this.badgeLargeLabel,
    this.indicatorShapeFull,
  });

  /// defaults.

  static const M3ENavigationRailTheme defaults = M3ENavigationRailTheme();

  /// collapsedWidth.

  final double collapsedWidth;

  /// expandedMinWidth.
  final double expandedMinWidth;

  /// expandedMaxWidth.
  final double expandedMaxWidth;

  /// itemExpandedHeight.
  final double itemExpandedHeight;

  /// itemCollapsedHeight.
  final double itemCollapsedHeight;

  /// iconSize.
  final double iconSize;

  /// indicatorLeading.
  final double indicatorLeading;

  /// indicatorTrailing.
  final double indicatorTrailing;

  /// iconLabelGap.
  final double iconLabelGap;

  /// itemVerticalGap.
  final double itemVerticalGap;

  /// headerMinSpace.
  final double headerMinSpace;

  /// sectionHeaderSpacingTop.
  final double sectionHeaderSpacingTop;

  /// sectionHeaderSpacingBottom.
  final double sectionHeaderSpacingBottom;

  /// containerColor.

  final Color? containerColor;

  /// activeIndicatorColor.
  final Color? activeIndicatorColor;

  /// activeIconAndLabel.
  final Color? activeIconAndLabel;

  /// inactiveIconAndLabel.
  final Color? inactiveIconAndLabel;

  /// menuColor.
  final Color? menuColor;

  /// badgeBackground.
  final Color? badgeBackground;

  /// badgeLargeLabel.
  final Color? badgeLargeLabel;

  /// indicatorShapeFull.
  final ShapeBorder? indicatorShapeFull;

  /// activeIconAndLabelColor.

  Color activeIconAndLabelColor(M3EColorScheme scheme) =>
      activeIconAndLabel ?? scheme.onSecondaryContainer;

  /// inactiveIconAndLabelColor.

  Color inactiveIconAndLabelColor(M3EColorScheme scheme) =>
      inactiveIconAndLabel ?? scheme.onSurfaceVariant;

  /// activeIndicatorColorResolved.

  Color activeIndicatorColorResolved(M3EColorScheme scheme) =>
      activeIndicatorColor ?? scheme.secondaryContainer;

  /// containerColorResolved.

  Color containerColorResolved(M3EColorScheme scheme) =>
      containerColor ?? scheme.surface;

  @override
  M3ENavigationRailTheme copyWith({
    double? collapsedWidth,
    double? expandedMinWidth,
    double? expandedMaxWidth,
    double? itemExpandedHeight,
    double? itemCollapsedHeight,
    double? itemHeight,
    double? itemShortHeight,
    double? iconSize,
    double? indicatorLeading,
    double? indicatorTrailing,
    double? iconLabelGap,
    double? itemVerticalGap,
    double? headerMinSpace,
    double? sectionHeaderSpacingTop,
    double? sectionHeaderSpacingBottom,
    Color? containerColor,
    Color? activeIndicatorColor,
    Color? activeIconAndLabel,
    Color? inactiveIconAndLabel,
    Color? menuColor,
    Color? badgeBackground,
    Color? badgeLargeLabel,
    ShapeBorder? indicatorShapeFull,
  }) {
    return M3ENavigationRailTheme(
      collapsedWidth: collapsedWidth ?? this.collapsedWidth,
      expandedMinWidth: expandedMinWidth ?? this.expandedMinWidth,
      expandedMaxWidth: expandedMaxWidth ?? this.expandedMaxWidth,
      itemExpandedHeight:
          itemHeight ?? itemExpandedHeight ?? this.itemExpandedHeight,
      itemCollapsedHeight:
          itemShortHeight ?? itemCollapsedHeight ?? this.itemCollapsedHeight,
      iconSize: iconSize ?? this.iconSize,
      indicatorLeading: indicatorLeading ?? this.indicatorLeading,
      indicatorTrailing: indicatorTrailing ?? this.indicatorTrailing,
      iconLabelGap: iconLabelGap ?? this.iconLabelGap,
      itemVerticalGap: itemVerticalGap ?? this.itemVerticalGap,
      headerMinSpace: headerMinSpace ?? this.headerMinSpace,
      sectionHeaderSpacingTop:
          sectionHeaderSpacingTop ?? this.sectionHeaderSpacingTop,
      sectionHeaderSpacingBottom:
          sectionHeaderSpacingBottom ?? this.sectionHeaderSpacingBottom,
      containerColor: containerColor ?? this.containerColor,
      activeIndicatorColor: activeIndicatorColor ?? this.activeIndicatorColor,
      activeIconAndLabel: activeIconAndLabel ?? this.activeIconAndLabel,
      inactiveIconAndLabel: inactiveIconAndLabel ?? this.inactiveIconAndLabel,
      menuColor: menuColor ?? this.menuColor,
      badgeBackground: badgeBackground ?? this.badgeBackground,
      badgeLargeLabel: badgeLargeLabel ?? this.badgeLargeLabel,
      indicatorShapeFull: indicatorShapeFull ?? this.indicatorShapeFull,
    );
  }

  @override
  M3ENavigationRailTheme lerp(M3ENavigationRailTheme? other, double t) {
    if (other is! M3ENavigationRailTheme) {
      return this;
    }
    return M3ENavigationRailTheme(
      collapsedWidth: _ld(collapsedWidth, other.collapsedWidth, t),
      expandedMinWidth: _ld(expandedMinWidth, other.expandedMinWidth, t),
      expandedMaxWidth: _ld(expandedMaxWidth, other.expandedMaxWidth, t),
      itemExpandedHeight: _ld(itemExpandedHeight, other.itemExpandedHeight, t),
      itemCollapsedHeight: _ld(
        itemCollapsedHeight,
        other.itemCollapsedHeight,
        t,
      ),
      iconSize: _ld(iconSize, other.iconSize, t),
      indicatorLeading: _ld(indicatorLeading, other.indicatorLeading, t),
      indicatorTrailing: _ld(indicatorTrailing, other.indicatorTrailing, t),
      iconLabelGap: _ld(iconLabelGap, other.iconLabelGap, t),
      itemVerticalGap: _ld(itemVerticalGap, other.itemVerticalGap, t),
      headerMinSpace: _ld(headerMinSpace, other.headerMinSpace, t),
      sectionHeaderSpacingTop: _ld(
        sectionHeaderSpacingTop,
        other.sectionHeaderSpacingTop,
        t,
      ),
      sectionHeaderSpacingBottom: _ld(
        sectionHeaderSpacingBottom,
        other.sectionHeaderSpacingBottom,
        t,
      ),
      containerColor: Color.lerp(containerColor, other.containerColor, t),
      activeIndicatorColor: Color.lerp(
        activeIndicatorColor,
        other.activeIndicatorColor,
        t,
      ),
      activeIconAndLabel: Color.lerp(
        activeIconAndLabel,
        other.activeIconAndLabel,
        t,
      ),
      inactiveIconAndLabel: Color.lerp(
        inactiveIconAndLabel,
        other.inactiveIconAndLabel,
        t,
      ),
      menuColor: Color.lerp(menuColor, other.menuColor, t),
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t),
      badgeLargeLabel: Color.lerp(badgeLargeLabel, other.badgeLargeLabel, t),
      indicatorShapeFull: ShapeBorder.lerp(
        indicatorShapeFull,
        other.indicatorShapeFull,
        t,
      ),
    );
  }

  double _ld(double a, double b, double t) => a + (b - a) * t;
}
