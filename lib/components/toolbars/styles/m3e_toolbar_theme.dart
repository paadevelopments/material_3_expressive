import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';
import '../enums/m3e_toolbar_color.dart';

/// Theme values for [M3EToolbar].
@immutable
class M3EToolbarTheme extends M3EThemeExtension<M3EToolbarTheme> {
  const M3EToolbarTheme({
    this.padding = const EdgeInsets.all(8),
    this.iconSize = 24,
    this.elevation = M3EElevation.level2,
  });

  static const M3EToolbarTheme defaults = M3EToolbarTheme();

  final EdgeInsets padding;
  final double iconSize;
  final double elevation;

  Color backgroundColor(
    M3EColorScheme scheme,
    M3EToolbarColor color,
  ) {
    switch (color) {
      case M3EToolbarColor.standard:
        return scheme.surfaceContainer;
      case M3EToolbarColor.vibrant:
        return scheme.primaryContainer;
    }
  }

  Color foregroundColor(
    M3EColorScheme scheme,
    M3EToolbarColor color,
  ) {
    switch (color) {
      case M3EToolbarColor.standard:
        return scheme.onSurfaceVariant;
      case M3EToolbarColor.vibrant:
        return scheme.onPrimaryContainer;
    }
  }

  @override
  M3EToolbarTheme copyWith({
    EdgeInsets? padding,
    double? iconSize,
    double? elevation,
  }) {
    return M3EToolbarTheme(
      padding: padding ?? this.padding,
      iconSize: iconSize ?? this.iconSize,
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  M3EToolbarTheme lerp(M3EToolbarTheme? other, double t) {
    if (other is! M3EToolbarTheme) {
      return this;
    }
    return M3EToolbarTheme(
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      elevation: _lerpDouble(elevation, other.elevation, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
