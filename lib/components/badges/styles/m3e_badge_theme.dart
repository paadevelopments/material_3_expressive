import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3EBadge`.
@immutable
class M3EBadgeTheme extends M3EThemeExtension<M3EBadgeTheme> {
  const M3EBadgeTheme({
    this.dotSize = 8,
    this.defaultOffset = const Offset(8, -6),
    this.labelHorizontalPadding = 6,
    this.labelVerticalPadding = 2,
    this.labelMinSize = 18,
    this.labelCornerRadius = 10,
    this.labelFontSize = 10,
    this.labelFontWeight = FontWeight.w600,
  });

  static const M3EBadgeTheme defaults = M3EBadgeTheme();

  final double dotSize;
  final Offset defaultOffset;
  final double labelHorizontalPadding;
  final double labelVerticalPadding;
  final double labelMinSize;
  final double labelCornerRadius;
  final double labelFontSize;
  final FontWeight labelFontWeight;

  BorderRadius get labelBorderRadius =>
      BorderRadius.circular(labelCornerRadius);

  Color containerColor(M3EColorScheme scheme) => scheme.errorContainer;

  Color labelColor(M3EColorScheme scheme) => scheme.onErrorContainer;

  TextStyle labelStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.labelSmall.copyWith(
        fontSize: labelFontSize,
        fontWeight: labelFontWeight,
        color: labelColor(scheme),
      );

  @override
  M3EBadgeTheme copyWith({
    double? dotSize,
    Offset? defaultOffset,
    double? labelHorizontalPadding,
    double? labelVerticalPadding,
    double? labelMinSize,
    double? labelCornerRadius,
    double? labelFontSize,
    FontWeight? labelFontWeight,
  }) {
    return M3EBadgeTheme(
      dotSize: dotSize ?? this.dotSize,
      defaultOffset: defaultOffset ?? this.defaultOffset,
      labelHorizontalPadding:
          labelHorizontalPadding ?? this.labelHorizontalPadding,
      labelVerticalPadding: labelVerticalPadding ?? this.labelVerticalPadding,
      labelMinSize: labelMinSize ?? this.labelMinSize,
      labelCornerRadius: labelCornerRadius ?? this.labelCornerRadius,
      labelFontSize: labelFontSize ?? this.labelFontSize,
      labelFontWeight: labelFontWeight ?? this.labelFontWeight,
    );
  }

  @override
  M3EBadgeTheme lerp(M3EBadgeTheme? other, double t) {
    if (other is! M3EBadgeTheme) {
      return this;
    }
    return M3EBadgeTheme(
      dotSize: _lerpDouble(dotSize, other.dotSize, t)!,
      defaultOffset: Offset.lerp(defaultOffset, other.defaultOffset, t)!,
      labelHorizontalPadding:
          _lerpDouble(labelHorizontalPadding, other.labelHorizontalPadding, t)!,
      labelVerticalPadding:
          _lerpDouble(labelVerticalPadding, other.labelVerticalPadding, t)!,
      labelMinSize: _lerpDouble(labelMinSize, other.labelMinSize, t)!,
      labelCornerRadius:
          _lerpDouble(labelCornerRadius, other.labelCornerRadius, t)!,
      labelFontSize: _lerpDouble(labelFontSize, other.labelFontSize, t)!,
      labelFontWeight: t < 0.5 ? labelFontWeight : other.labelFontWeight,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
