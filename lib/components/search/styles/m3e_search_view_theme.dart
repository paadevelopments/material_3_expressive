import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for [M3ESearchAnchor] search views.
@immutable
class M3ESearchViewTheme extends M3EThemeExtension<M3ESearchViewTheme> {
  const M3ESearchViewTheme({
    this.elevation = 6,
    this.cornerRadius = 28,
    this.headerHeight = 72,
    this.minWidth = 360,
    this.minHeight = 240,
    this.barHorizontalPadding = 8,
    this.shrinkWrap = false,
  });

  static const M3ESearchViewTheme defaults = M3ESearchViewTheme();

  final double elevation;
  final double cornerRadius;
  final double headerHeight;
  final double minWidth;
  final double minHeight;
  final double barHorizontalPadding;
  final bool shrinkWrap;

  Color backgroundColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  Color surfaceTintColor(M3EColorScheme scheme) => scheme.surfaceTint;

  Color dividerColor(M3EColorScheme scheme) => scheme.outline;

  TextStyle headerTextStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurface);

  TextStyle headerHintStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurfaceVariant);

  ShapeBorder dockedShape(double radius) =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

  ShapeBorder fullScreenShape() => const RoundedRectangleBorder();

  BoxConstraints constraints({double? maxWidth, double? maxHeight}) {
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth ?? double.infinity,
      minHeight: minHeight,
      maxHeight: maxHeight ?? double.infinity,
    );
  }

  EdgeInsetsGeometry barPadding() =>
      EdgeInsets.symmetric(horizontal: barHorizontalPadding);

  @override
  M3ESearchViewTheme copyWith({
    double? elevation,
    double? cornerRadius,
    double? headerHeight,
    double? minWidth,
    double? minHeight,
    double? barHorizontalPadding,
    bool? shrinkWrap,
  }) {
    return M3ESearchViewTheme(
      elevation: elevation ?? this.elevation,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      headerHeight: headerHeight ?? this.headerHeight,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      barHorizontalPadding:
          barHorizontalPadding ?? this.barHorizontalPadding,
      shrinkWrap: shrinkWrap ?? this.shrinkWrap,
    );
  }

  @override
  M3ESearchViewTheme lerp(M3ESearchViewTheme? other, double t) {
    if (other is! M3ESearchViewTheme) {
      return this;
    }
    return M3ESearchViewTheme(
      elevation: _lerpDouble(elevation, other.elevation, t)!,
      cornerRadius: _lerpDouble(cornerRadius, other.cornerRadius, t)!,
      headerHeight: _lerpDouble(headerHeight, other.headerHeight, t)!,
      minWidth: _lerpDouble(minWidth, other.minWidth, t)!,
      minHeight: _lerpDouble(minHeight, other.minHeight, t)!,
      barHorizontalPadding:
          _lerpDouble(barHorizontalPadding, other.barHorizontalPadding, t)!,
      shrinkWrap: t < 0.5 ? shrinkWrap : other.shrinkWrap,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
