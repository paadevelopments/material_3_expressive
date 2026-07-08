import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';

/// Theme values for [M3ERadio].
@immutable
class M3ERadioTheme extends M3EThemeExtension<M3ERadioTheme> {
  const M3ERadioTheme({
    this.ringSize = 20,
    this.hitSize = 40,
    this.dotSize = 10,
    this.borderWidth = 2,
    this.disabledOpacity = 0.38,
  });

  static const M3ERadioTheme defaults = M3ERadioTheme();

  final double ringSize;
  final double hitSize;
  final double dotSize;
  final double borderWidth;
  final double disabledOpacity;

  Color stateLayerColor(M3EColorScheme scheme, {required bool selected}) =>
      selected ? scheme.primary : scheme.onSurface;

  Color color(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool error,
    required bool selected,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledOpacity);
    }
    if (error) {
      return scheme.error;
    }
    return selected ? scheme.primary : scheme.onSurfaceVariant;
  }

  @override
  M3ERadioTheme copyWith({
    double? ringSize,
    double? hitSize,
    double? dotSize,
    double? borderWidth,
    double? disabledOpacity,
  }) {
    return M3ERadioTheme(
      ringSize: ringSize ?? this.ringSize,
      hitSize: hitSize ?? this.hitSize,
      dotSize: dotSize ?? this.dotSize,
      borderWidth: borderWidth ?? this.borderWidth,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }

  @override
  M3ERadioTheme lerp(M3ERadioTheme? other, double t) {
    if (other is! M3ERadioTheme) {
      return this;
    }
    return M3ERadioTheme(
      ringSize: _lerpDouble(ringSize, other.ringSize, t)!,
      hitSize: _lerpDouble(hitSize, other.hitSize, t)!,
      dotSize: _lerpDouble(dotSize, other.dotSize, t)!,
      borderWidth: _lerpDouble(borderWidth, other.borderWidth, t)!,
      disabledOpacity: _lerpDouble(disabledOpacity, other.disabledOpacity, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
