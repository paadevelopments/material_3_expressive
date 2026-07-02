// Vendored from the `navigation_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e/lib).
// The logic is kept identical to the reference `NavTokensAdapter`; theme tokens
// are read from this package's own `M3ETheme` instead of the external
// `m3e_design` package.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_nav_bar_enums.dart';

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

M3ENavMetrics _metricsFor(BuildContext context, M3ENavBarDensity density) {
  final m3e = M3ETheme.of(context);
  final sp = m3e.spacing;

  double hSmall = 64; // compact/phone-tight
  double hMedium = 80; // default M3 nav bar height
  double icon = 24;
  double underline = 3;

  if (density == M3ENavBarDensity.compact) {
    hSmall -= 4;
    hMedium -= 4;
    underline -= 1;
  }

  return M3ENavMetrics(
    heightSmall: hSmall,
    heightMedium: hMedium,
    iconSize: icon,
    padding: EdgeInsets.symmetric(horizontal: sp.md),
    indicatorThickness: underline,
  );
}

class M3ENavBarTokens {
  M3ENavBarTokens(this.context);
  final BuildContext context;

  M3EThemeData get _m3e => M3ETheme.of(context);

  M3ENavMetrics metrics(M3ENavBarDensity density) =>
      _metricsFor(context, density);

  // Container/background
  Color containerColor() => _m3e.colorScheme.surfaceContainerHigh;

  // Indicator
  Color indicatorColor() => _m3e.colorScheme.secondaryContainer;

  // Icon/label colors
  Color selectedColor() => _m3e.colorScheme.onSecondaryContainer;
  Color unselectedColor() => _m3e.colorScheme.onSurfaceVariant;

  // Typography
  TextStyle labelStyle() => _m3e.typeScale.labelMedium;

  // Shapes
  ShapeBorder containerShape(M3ENavBarShapeFamily family) {
    final set = family == M3ENavBarShapeFamily.round
        ? M3EShapes.roundSet
        : M3EShapes.squareSet;
    return RoundedRectangleBorder(borderRadius: set.lg);
  }

  ShapeBorder indicatorShapePill() => const StadiumBorder();

  // Underline decoration for selected.
  BoxDecoration underlineDecoration(Color color, double thickness) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(color: color, width: thickness),
      ),
    );
  }
}
