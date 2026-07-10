import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ECheckbox`.
@immutable
class M3ECheckboxTheme extends M3EThemeExtension<M3ECheckboxTheme> {
  const M3ECheckboxTheme({
    this.boxSize = 18,
    this.hitSize = 40,
    this.markSize = 16,
    this.indeterminateWidth = 10,
    this.indeterminateHeight = 2,
    this.borderWidth = 2,
    this.disabledOpacity = 0.38,
  });

  static const M3ECheckboxTheme defaults = M3ECheckboxTheme();

  final double boxSize;
  final double hitSize;
  final double markSize;
  final double indeterminateWidth;
  final double indeterminateHeight;
  final double borderWidth;
  final double disabledOpacity;

  BorderRadius get borderRadius => M3EShapes.radiusExtraSmall;

  static const Color _transparent = Color(0x00000000);

  Color stateLayerColor(
    M3EColorScheme scheme, {
    required bool active,
    required bool error,
  }) {
    if (error) {
      return scheme.error;
    }
    return active ? scheme.primary : scheme.onSurface;
  }

  Color fillColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool active,
    required bool error,
  }) {
    if (!enabled) {
      return active
          ? M3EColorUtils.withOpacity(scheme.onSurface, disabledOpacity)
          : _transparent;
    }
    if (!active) {
      return _transparent;
    }
    return error ? scheme.error : scheme.primary;
  }

  Color borderColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool active,
    required bool error,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledOpacity);
    }
    if (active) {
      return error ? scheme.error : scheme.primary;
    }
    return error ? scheme.error : scheme.onSurfaceVariant;
  }

  Color markColor(M3EColorScheme scheme, {required bool error}) =>
      error ? scheme.onError : scheme.onPrimary;

  @override
  M3ECheckboxTheme copyWith({
    double? boxSize,
    double? hitSize,
    double? markSize,
    double? indeterminateWidth,
    double? indeterminateHeight,
    double? borderWidth,
    double? disabledOpacity,
  }) {
    return M3ECheckboxTheme(
      boxSize: boxSize ?? this.boxSize,
      hitSize: hitSize ?? this.hitSize,
      markSize: markSize ?? this.markSize,
      indeterminateWidth: indeterminateWidth ?? this.indeterminateWidth,
      indeterminateHeight: indeterminateHeight ?? this.indeterminateHeight,
      borderWidth: borderWidth ?? this.borderWidth,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }

  @override
  M3ECheckboxTheme lerp(M3ECheckboxTheme? other, double t) {
    if (other is! M3ECheckboxTheme) {
      return this;
    }
    return M3ECheckboxTheme(
      boxSize: _lerpDouble(boxSize, other.boxSize, t)!,
      hitSize: _lerpDouble(hitSize, other.hitSize, t)!,
      markSize: _lerpDouble(markSize, other.markSize, t)!,
      indeterminateWidth:
          _lerpDouble(indeterminateWidth, other.indeterminateWidth, t)!,
      indeterminateHeight:
          _lerpDouble(indeterminateHeight, other.indeterminateHeight, t)!,
      borderWidth: _lerpDouble(borderWidth, other.borderWidth, t)!,
      disabledOpacity: _lerpDouble(disabledOpacity, other.disabledOpacity, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
