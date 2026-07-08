import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';

/// Theme values for [M3EBadge].
@immutable
class M3EBadgeTheme extends M3EThemeExtension<M3EBadgeTheme> {
  const M3EBadgeTheme({
    this.dotSize = 6,
    this.largeSize = 16,
    this.largeHorizontalPadding = 4,
    this.largeCornerRadius = 8,
    this.defaultAlignment = const Alignment(0.75, -0.75),
  });

  static const M3EBadgeTheme defaults = M3EBadgeTheme();

  final double dotSize;
  final double largeSize;
  final double largeHorizontalPadding;
  final double largeCornerRadius;
  final Alignment defaultAlignment;

  BorderRadius get largeBorderRadius => M3EShapes.resolve(largeCornerRadius);

  Color containerColor(M3EColorScheme scheme) => scheme.error;

  TextStyle labelStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.labelSmall.copyWith(color: scheme.onError);

  @override
  M3EBadgeTheme copyWith({
    double? dotSize,
    double? largeSize,
    double? largeHorizontalPadding,
    double? largeCornerRadius,
    Alignment? defaultAlignment,
  }) {
    return M3EBadgeTheme(
      dotSize: dotSize ?? this.dotSize,
      largeSize: largeSize ?? this.largeSize,
      largeHorizontalPadding:
          largeHorizontalPadding ?? this.largeHorizontalPadding,
      largeCornerRadius: largeCornerRadius ?? this.largeCornerRadius,
      defaultAlignment: defaultAlignment ?? this.defaultAlignment,
    );
  }

  @override
  M3EBadgeTheme lerp(M3EBadgeTheme? other, double t) {
    if (other is! M3EBadgeTheme) {
      return this;
    }
    return M3EBadgeTheme(
      dotSize: _lerpDouble(dotSize, other.dotSize, t)!,
      largeSize: _lerpDouble(largeSize, other.largeSize, t)!,
      largeHorizontalPadding:
          _lerpDouble(largeHorizontalPadding, other.largeHorizontalPadding, t)!,
      largeCornerRadius:
          _lerpDouble(largeCornerRadius, other.largeCornerRadius, t)!,
      defaultAlignment: Alignment.lerp(defaultAlignment, other.defaultAlignment, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
