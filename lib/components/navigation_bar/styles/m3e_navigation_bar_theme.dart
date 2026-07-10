import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_nav_bar_enums.dart';
import '../models/m3e_nav_metrics.dart';

/// Theme values for `M3ENavigationBar`.
@immutable
class M3ENavigationBarTheme extends M3EThemeExtension<M3ENavigationBarTheme> {
  const M3ENavigationBarTheme({
    this.heightSmall = 64,
    this.heightMedium = 80,
    this.iconSize = 24,
    this.indicatorThickness = 3,
    this.compactHeightReduction = 4,
    this.compactIndicatorReduction = 1,
  });

  static const M3ENavigationBarTheme defaults = M3ENavigationBarTheme();

  final double heightSmall;
  final double heightMedium;
  final double iconSize;
  final double indicatorThickness;
  final double compactHeightReduction;
  final double compactIndicatorReduction;

  M3ENavMetrics metrics(M3ENavBarDensity density, M3ESpacing spacing) {
    var hSmall = heightSmall;
    var hMedium = heightMedium;
    var icon = iconSize;
    var underline = indicatorThickness;

    if (density == M3ENavBarDensity.compact) {
      hSmall -= compactHeightReduction;
      hMedium -= compactHeightReduction;
      underline -= compactIndicatorReduction;
    }

    return M3ENavMetrics(
      heightSmall: hSmall,
      heightMedium: hMedium,
      iconSize: icon,
      padding: EdgeInsets.symmetric(horizontal: spacing.md),
      indicatorThickness: underline,
    );
  }

  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  Color indicatorColor(M3EColorScheme scheme) => scheme.secondaryContainer;

  Color selectedColor(M3EColorScheme scheme) => scheme.onSecondaryContainer;

  Color unselectedColor(M3EColorScheme scheme) => scheme.onSurfaceVariant;

  TextStyle labelStyle(M3ETypeScale type) => type.labelMedium;

  ShapeBorder containerShape(M3ENavBarShapeFamily family) {
    if (family == M3ENavBarShapeFamily.round) {
      return RoundedRectangleBorder(borderRadius: M3EShapes.roundSet.lg);
    }
    return const RoundedRectangleBorder();
  }

  ShapeBorder indicatorShapePill() => const StadiumBorder();

  BoxDecoration underlineDecoration(Color color, double thickness) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(color: color, width: thickness),
      ),
    );
  }

  @override
  M3ENavigationBarTheme copyWith({
    double? heightSmall,
    double? heightMedium,
    double? iconSize,
    double? indicatorThickness,
    double? compactHeightReduction,
    double? compactIndicatorReduction,
  }) {
    return M3ENavigationBarTheme(
      heightSmall: heightSmall ?? this.heightSmall,
      heightMedium: heightMedium ?? this.heightMedium,
      iconSize: iconSize ?? this.iconSize,
      indicatorThickness: indicatorThickness ?? this.indicatorThickness,
      compactHeightReduction:
          compactHeightReduction ?? this.compactHeightReduction,
      compactIndicatorReduction:
          compactIndicatorReduction ?? this.compactIndicatorReduction,
    );
  }

  @override
  M3ENavigationBarTheme lerp(M3ENavigationBarTheme? other, double t) {
    if (other is! M3ENavigationBarTheme) {
      return this;
    }
    return M3ENavigationBarTheme(
      heightSmall: _lerpDouble(heightSmall, other.heightSmall, t)!,
      heightMedium: _lerpDouble(heightMedium, other.heightMedium, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      indicatorThickness:
          _lerpDouble(indicatorThickness, other.indicatorThickness, t)!,
      compactHeightReduction:
          _lerpDouble(compactHeightReduction, other.compactHeightReduction, t)!,
      compactIndicatorReduction: _lerpDouble(
        compactIndicatorReduction,
        other.compactIndicatorReduction,
        t,
      )!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
