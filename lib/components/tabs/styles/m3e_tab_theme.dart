import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';
import '../enums/m3e_tabs_variant.dart';

/// Theme values for [M3ETabs].
@immutable
class M3ETabTheme extends M3EThemeExtension<M3ETabTheme> {
  const M3ETabTheme({
    this.height = 48,
    this.iconSize = 24,
    this.indicatorHeight = 3,
    this.primaryIndicatorWidth = 32,
    this.indicatorCornerRadius = 3,
  });

  static const M3ETabTheme defaults = M3ETabTheme();

  final double height;
  final double iconSize;
  final double indicatorHeight;
  final double primaryIndicatorWidth;
  final double indicatorCornerRadius;

  Color backgroundColor(M3EColorScheme scheme) => scheme.surface;

  Color dividerColor(M3EColorScheme scheme) => scheme.surfaceContainerHighest;

  Color tabColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) =>
      selected ? scheme.primary : scheme.onSurfaceVariant;

  TextStyle labelStyle(
    M3ETypeScale type,
    M3EColorScheme scheme, {
    required bool selected,
  }) =>
      type.titleSmall.copyWith(
        color: tabColor(scheme, selected: selected),
      );

  Color indicatorColor(M3EColorScheme scheme) => scheme.primary;

  bool indicatorFullWidth(M3ETabsVariant variant) =>
      variant == M3ETabsVariant.secondary;

  @override
  M3ETabTheme copyWith({
    double? height,
    double? iconSize,
    double? indicatorHeight,
    double? primaryIndicatorWidth,
    double? indicatorCornerRadius,
  }) {
    return M3ETabTheme(
      height: height ?? this.height,
      iconSize: iconSize ?? this.iconSize,
      indicatorHeight: indicatorHeight ?? this.indicatorHeight,
      primaryIndicatorWidth:
          primaryIndicatorWidth ?? this.primaryIndicatorWidth,
      indicatorCornerRadius:
          indicatorCornerRadius ?? this.indicatorCornerRadius,
    );
  }

  @override
  M3ETabTheme lerp(M3ETabTheme? other, double t) {
    if (other is! M3ETabTheme) {
      return this;
    }
    return M3ETabTheme(
      height: _lerpDouble(height, other.height, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      indicatorHeight: _lerpDouble(indicatorHeight, other.indicatorHeight, t)!,
      primaryIndicatorWidth:
          _lerpDouble(primaryIndicatorWidth, other.primaryIndicatorWidth, t)!,
      indicatorCornerRadius:
          _lerpDouble(indicatorCornerRadius, other.indicatorCornerRadius, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
