// Vendored from the `navigation_rail_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_rail_m3e/lib).
// The logic is kept identical to the reference `NavigationRailM3ETheme`; only
// the public class name carries the `M3E` prefix.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Theme extension for M3ENavigationRail token values.
class M3ENavigationRailTheme extends ThemeExtension<M3ENavigationRailTheme> {
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

  final double collapsedWidth;
  final double expandedMinWidth;
  final double expandedMaxWidth;
  final double itemExpandedHeight;
  final double itemCollapsedHeight;
  final double iconSize;
  final double indicatorLeading;
  final double indicatorTrailing;
  final double iconLabelGap;
  final double itemVerticalGap;
  final double headerMinSpace;
  final double sectionHeaderSpacingTop;
  final double sectionHeaderSpacingBottom;

  final Color? containerColor;
  final Color? activeIndicatorColor;
  final Color? activeIconAndLabel;
  final Color? inactiveIconAndLabel;
  final Color? menuColor;
  final Color? badgeBackground;
  final Color? badgeLargeLabel;
  final ShapeBorder? indicatorShapeFull;

  @override
  M3ENavigationRailTheme copyWith({
    double? collapsedWidth,
    double? expandedMinWidth,
    double? expandedMaxWidth,
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
      itemExpandedHeight: itemHeight ?? this.itemExpandedHeight,
      itemCollapsedHeight: itemShortHeight ?? this.itemCollapsedHeight,
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
  ThemeExtension<M3ENavigationRailTheme> lerp(
      ThemeExtension<M3ENavigationRailTheme>? other, double t) {
    if (other is! M3ENavigationRailTheme) return this;
    return M3ENavigationRailTheme(
      collapsedWidth: lerpDouble(collapsedWidth, other.collapsedWidth, t)!,
      expandedMinWidth:
          lerpDouble(expandedMinWidth, other.expandedMinWidth, t)!,
      expandedMaxWidth:
          lerpDouble(expandedMaxWidth, other.expandedMaxWidth, t)!,
      itemExpandedHeight:
          lerpDouble(itemExpandedHeight, other.itemExpandedHeight, t)!,
      itemCollapsedHeight:
          lerpDouble(itemCollapsedHeight, other.itemCollapsedHeight, t)!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
      indicatorLeading:
          lerpDouble(indicatorLeading, other.indicatorLeading, t)!,
      indicatorTrailing:
          lerpDouble(indicatorTrailing, other.indicatorTrailing, t)!,
      iconLabelGap: lerpDouble(iconLabelGap, other.iconLabelGap, t)!,
      itemVerticalGap: lerpDouble(itemVerticalGap, other.itemVerticalGap, t)!,
      headerMinSpace: lerpDouble(headerMinSpace, other.headerMinSpace, t)!,
      sectionHeaderSpacingTop: lerpDouble(
          sectionHeaderSpacingTop, other.sectionHeaderSpacingTop, t)!,
      sectionHeaderSpacingBottom: lerpDouble(
          sectionHeaderSpacingBottom, other.sectionHeaderSpacingBottom, t)!,
      containerColor: Color.lerp(containerColor, other.containerColor, t),
      activeIndicatorColor:
          Color.lerp(activeIndicatorColor, other.activeIndicatorColor, t),
      activeIconAndLabel:
          Color.lerp(activeIconAndLabel, other.activeIconAndLabel, t),
      inactiveIconAndLabel:
          Color.lerp(inactiveIconAndLabel, other.inactiveIconAndLabel, t),
      menuColor: Color.lerp(menuColor, other.menuColor, t),
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t),
      badgeLargeLabel: Color.lerp(badgeLargeLabel, other.badgeLargeLabel, t),
      indicatorShapeFull: ShapeBorder.lerp(indicatorShapeFull, other.indicatorShapeFull, t),
    );
  }
}
