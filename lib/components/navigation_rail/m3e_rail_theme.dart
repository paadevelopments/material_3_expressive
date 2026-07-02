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
  /// Creates a [M3ENavigationRailTheme] with default token values.
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
  });

  /// Width of the rail when collapsed.
  final double collapsedWidth;

  /// Minimum width of the rail when expanded.
  final double expandedMinWidth;

  /// Maximum width of the rail when expanded.
  final double expandedMaxWidth;

  /// Default height of an item.
  final double itemExpandedHeight;

  /// Short item height variant.
  final double itemCollapsedHeight;

  /// Default icon size used for items.
  final double iconSize;

  /// Leading inset for the active indicator in expanded mode.
  final double indicatorLeading;

  /// Trailing inset for the active indicator in expanded mode.
  final double indicatorTrailing;

  /// Gap between icon and label.
  final double iconLabelGap;

  /// Vertical gap between items.
  final double itemVerticalGap;

  /// Minimum spacing between the top and the first header.
  final double headerMinSpace;

  /// Top spacing around a section header.
  final double sectionHeaderSpacingTop;

  /// Bottom spacing around a section header.
  final double sectionHeaderSpacingBottom;

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
    );
  }
}
