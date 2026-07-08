import 'package:flutter/widgets.dart';

import '../../../foundations/m3e_theme_extension.dart';

/// Theme values for [M3EToggleButton].
@immutable
class M3EToggleButtonTheme extends M3EThemeExtension<M3EToggleButtonTheme> {
  const M3EToggleButtonTheme({
    this.labelSlideDistance = 10,
  });

  static const M3EToggleButtonTheme defaults = M3EToggleButtonTheme();

  final double labelSlideDistance;

  @override
  M3EToggleButtonTheme copyWith({double? labelSlideDistance}) {
    return M3EToggleButtonTheme(
      labelSlideDistance: labelSlideDistance ?? this.labelSlideDistance,
    );
  }

  @override
  M3EToggleButtonTheme lerp(M3EToggleButtonTheme? other, double t) {
    if (other is! M3EToggleButtonTheme) {
      return this;
    }
    return M3EToggleButtonTheme(
      labelSlideDistance:
          _lerpDouble(labelSlideDistance, other.labelSlideDistance, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
