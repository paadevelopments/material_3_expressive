import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ESearchBar`.
@immutable
class M3ESearchBarTheme extends M3EThemeExtension<M3ESearchBarTheme> {
  const M3ESearchBarTheme({
    this.height = 56,
    this.horizontalPadding = 16,
    this.cornerRadius = 28,
    this.iconSize = 24,
    this.leadingGap = 16,
    this.elevation = M3EElevation.level1,
    this.selectionOpacity = 0.4,
  });

  static const M3ESearchBarTheme defaults = M3ESearchBarTheme();

  final double height;
  final double horizontalPadding;
  final double cornerRadius;
  final double iconSize;
  final double leadingGap;
  final double elevation;
  final double selectionOpacity;

  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  Color iconColor(M3EColorScheme scheme) => scheme.onSurfaceVariant;

  TextStyle hintStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurfaceVariant);

  TextStyle inputStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurface);

  Color cursorColor(M3EColorScheme scheme) => scheme.primary;

  Color selectionColor(M3EColorScheme scheme) =>
      scheme.primary.withValues(alpha: selectionOpacity);

  @override
  M3ESearchBarTheme copyWith({
    double? height,
    double? horizontalPadding,
    double? cornerRadius,
    double? iconSize,
    double? leadingGap,
    double? elevation,
    double? selectionOpacity,
  }) {
    return M3ESearchBarTheme(
      height: height ?? this.height,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      iconSize: iconSize ?? this.iconSize,
      leadingGap: leadingGap ?? this.leadingGap,
      elevation: elevation ?? this.elevation,
      selectionOpacity: selectionOpacity ?? this.selectionOpacity,
    );
  }

  @override
  M3ESearchBarTheme lerp(M3ESearchBarTheme? other, double t) {
    if (other is! M3ESearchBarTheme) {
      return this;
    }
    return M3ESearchBarTheme(
      height: _lerpDouble(height, other.height, t)!,
      horizontalPadding:
          _lerpDouble(horizontalPadding, other.horizontalPadding, t)!,
      cornerRadius: _lerpDouble(cornerRadius, other.cornerRadius, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      leadingGap: _lerpDouble(leadingGap, other.leadingGap, t)!,
      elevation: _lerpDouble(elevation, other.elevation, t)!,
      selectionOpacity:
          _lerpDouble(selectionOpacity, other.selectionOpacity, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
