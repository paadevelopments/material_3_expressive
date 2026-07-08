import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';

/// Theme values for [M3ESlider].
@immutable
class M3ESliderTheme extends M3EThemeExtension<M3ESliderTheme> {
  const M3ESliderTheme({
    this.height = 44,
    this.trackHeight = 16,
    this.handleGap = 6,
    this.handleWidth = 4,
    this.handleHeight = 44,
  });

  static const M3ESliderTheme defaults = M3ESliderTheme();

  final double height;
  final double trackHeight;
  final double handleGap;
  final double handleWidth;
  final double handleHeight;

  Color color(
    M3EColorScheme scheme, {
    required Color enabledColor,
    required bool enabled,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return enabledColor;
  }

  @override
  M3ESliderTheme copyWith({
    double? height,
    double? trackHeight,
    double? handleGap,
    double? handleWidth,
    double? handleHeight,
  }) {
    return M3ESliderTheme(
      height: height ?? this.height,
      trackHeight: trackHeight ?? this.trackHeight,
      handleGap: handleGap ?? this.handleGap,
      handleWidth: handleWidth ?? this.handleWidth,
      handleHeight: handleHeight ?? this.handleHeight,
    );
  }

  @override
  M3ESliderTheme lerp(M3ESliderTheme? other, double t) {
    if (other is! M3ESliderTheme) {
      return this;
    }
    return M3ESliderTheme(
      height: _lerpDouble(height, other.height, t)!,
      trackHeight: _lerpDouble(trackHeight, other.trackHeight, t)!,
      handleGap: _lerpDouble(handleGap, other.handleGap, t)!,
      handleWidth: _lerpDouble(handleWidth, other.handleWidth, t)!,
      handleHeight: _lerpDouble(handleHeight, other.handleHeight, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
