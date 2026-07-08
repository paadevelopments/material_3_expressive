import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';

/// Theme values for [M3EDivider].
@immutable
class M3EDividerTheme extends M3EThemeExtension<M3EDividerTheme> {
  const M3EDividerTheme({
    this.thickness = 1,
  });

  static const M3EDividerTheme defaults = M3EDividerTheme();

  final double thickness;

  Color color(M3EColorScheme scheme) => scheme.outlineVariant;

  @override
  M3EDividerTheme copyWith({double? thickness}) {
    return M3EDividerTheme(
      thickness: thickness ?? this.thickness,
    );
  }

  @override
  M3EDividerTheme lerp(M3EDividerTheme? other, double t) {
    if (other is! M3EDividerTheme) {
      return this;
    }
    return M3EDividerTheme(
      thickness: _lerpDouble(thickness, other.thickness, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
