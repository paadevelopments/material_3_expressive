// Vendored from the `navigation_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e/lib).
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';

/// Resolved height/padding/icon metrics for the navigation bar.
@immutable
class M3ENavMetrics {
  final double heightSmall;
  final double heightMedium;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final double indicatorThickness; // for underline
  const M3ENavMetrics({
    required this.heightSmall,
    required this.heightMedium,
    required this.iconSize,
    required this.padding,
    required this.indicatorThickness,
  });
}
