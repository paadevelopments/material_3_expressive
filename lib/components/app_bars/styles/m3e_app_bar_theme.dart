import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_app_bar_enums.dart';

/// Resolved height/padding/icon metrics for an app bar.
@immutable
class M3EAppBarMetrics {
  const M3EAppBarMetrics({
    required this.smallHeight,
    required this.collapsedHeight,
    required this.mediumExpanded,
    required this.largeExpanded,
    required this.horizontalPadding,
    required this.iconSize,
    required this.elevation,
  });

  final double smallHeight;
  final double collapsedHeight;
  final double mediumExpanded;
  final double largeExpanded;
  final EdgeInsetsGeometry horizontalPadding;
  final double iconSize;
  final double elevation;
}

/// Theme values for `M3EAppBar`.
@immutable
class M3EAppBarTheme extends M3EThemeExtension<M3EAppBarTheme> {
  const M3EAppBarTheme({
    this.horizontalPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.iconSize = 24,
    this.elevation = 0,
    this.compactHeightReduction = 8,
    this.smallHeight = 64,
    this.collapsedHeight = 64,
    this.mediumExpanded = 112,
    this.largeExpanded = 152,
    this.bottomHeight = 80,
    this.bottomIconSize = 24,
    this.bottomPadding = const EdgeInsets.symmetric(horizontal: 4),
  });

  static const M3EAppBarTheme defaults = M3EAppBarTheme();

  final EdgeInsetsGeometry horizontalPadding;
  final double iconSize;
  final double elevation;
  final double compactHeightReduction;
  final double smallHeight;
  final double collapsedHeight;
  final double mediumExpanded;
  final double largeExpanded;
  final double bottomHeight;
  final double bottomIconSize;
  final EdgeInsetsGeometry bottomPadding;

  M3EAppBarMetrics metrics(M3EAppBarDensity density) {
    var small = smallHeight;
    var collapsed = collapsedHeight;
    var medium = mediumExpanded;
    var large = largeExpanded;

    if (density == M3EAppBarDensity.compact) {
      small -= compactHeightReduction;
      collapsed -= compactHeightReduction;
      medium -= compactHeightReduction;
      large -= compactHeightReduction;
    }

    return M3EAppBarMetrics(
      smallHeight: small,
      collapsedHeight: collapsed,
      mediumExpanded: medium,
      largeExpanded: large,
      horizontalPadding: horizontalPadding,
      iconSize: iconSize,
      elevation: elevation,
    );
  }

  Color backgroundColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  Color bottomBackgroundColor(M3EColorScheme scheme) => scheme.surfaceContainer;

  TextStyle titleStyle(M3ETypeScale type, {bool collapsed = true}) =>
      collapsed ? type.titleLarge : type.headlineSmall;

  ShapeBorder shape(M3EAppBarShapeFamily family) {
    final radius = family == M3EAppBarShapeFamily.round
        ? M3EShapes.radiusSmall
        : M3EShapes.radiusNone;
    return RoundedRectangleBorder(borderRadius: radius);
  }

  @override
  M3EAppBarTheme copyWith({
    EdgeInsetsGeometry? horizontalPadding,
    double? iconSize,
    double? elevation,
    double? compactHeightReduction,
    double? smallHeight,
    double? collapsedHeight,
    double? mediumExpanded,
    double? largeExpanded,
    double? bottomHeight,
    double? bottomIconSize,
    EdgeInsetsGeometry? bottomPadding,
  }) {
    return M3EAppBarTheme(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      iconSize: iconSize ?? this.iconSize,
      elevation: elevation ?? this.elevation,
      compactHeightReduction:
          compactHeightReduction ?? this.compactHeightReduction,
      smallHeight: smallHeight ?? this.smallHeight,
      collapsedHeight: collapsedHeight ?? this.collapsedHeight,
      mediumExpanded: mediumExpanded ?? this.mediumExpanded,
      largeExpanded: largeExpanded ?? this.largeExpanded,
      bottomHeight: bottomHeight ?? this.bottomHeight,
      bottomIconSize: bottomIconSize ?? this.bottomIconSize,
      bottomPadding: bottomPadding ?? this.bottomPadding,
    );
  }

  @override
  M3EAppBarTheme lerp(M3EAppBarTheme? other, double t) {
    if (other is! M3EAppBarTheme) {
      return this;
    }
    return M3EAppBarTheme(
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      elevation: _lerpDouble(elevation, other.elevation, t)!,
      compactHeightReduction:
          _lerpDouble(compactHeightReduction, other.compactHeightReduction, t)!,
      smallHeight: _lerpDouble(smallHeight, other.smallHeight, t)!,
      collapsedHeight: _lerpDouble(collapsedHeight, other.collapsedHeight, t)!,
      mediumExpanded: _lerpDouble(mediumExpanded, other.mediumExpanded, t)!,
      largeExpanded: _lerpDouble(largeExpanded, other.largeExpanded, t)!,
      bottomHeight: _lerpDouble(bottomHeight, other.bottomHeight, t)!,
      bottomIconSize: _lerpDouble(bottomIconSize, other.bottomIconSize, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
