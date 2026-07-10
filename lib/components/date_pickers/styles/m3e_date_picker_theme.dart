import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3EDatePicker`.
@immutable
class M3EDatePickerTheme extends M3EThemeExtension<M3EDatePickerTheme> {
  const M3EDatePickerTheme({
    this.width = 328,
    this.padding = const EdgeInsets.all(12),
    this.daySize = 40,
    this.arrowIconSize = 24,
    this.arrowPadding = const EdgeInsets.all(8),
    this.gridPadding = const EdgeInsets.only(top: 4),
    this.daysPerWeek = 7,
  });

  static const M3EDatePickerTheme defaults = M3EDatePickerTheme();

  final double width;
  final EdgeInsets padding;
  final double daySize;
  final double arrowIconSize;
  final EdgeInsets arrowPadding;
  final EdgeInsets gridPadding;
  final int daysPerWeek;

  BorderRadius get borderRadius => M3EShapes.radiusExtraLarge;

  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  Color dayForegroundColor(
    M3EColorScheme scheme, {
    required bool selected,
    required bool enabled,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return selected ? scheme.onPrimary : scheme.onSurface;
  }

  @override
  M3EDatePickerTheme copyWith({
    double? width,
    EdgeInsets? padding,
    double? daySize,
    double? arrowIconSize,
    EdgeInsets? arrowPadding,
    EdgeInsets? gridPadding,
    int? daysPerWeek,
  }) {
    return M3EDatePickerTheme(
      width: width ?? this.width,
      padding: padding ?? this.padding,
      daySize: daySize ?? this.daySize,
      arrowIconSize: arrowIconSize ?? this.arrowIconSize,
      arrowPadding: arrowPadding ?? this.arrowPadding,
      gridPadding: gridPadding ?? this.gridPadding,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
    );
  }

  @override
  M3EDatePickerTheme lerp(M3EDatePickerTheme? other, double t) {
    if (other is! M3EDatePickerTheme) {
      return this;
    }
    return M3EDatePickerTheme(
      width: _lerpDouble(width, other.width, t)!,
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      daySize: _lerpDouble(daySize, other.daySize, t)!,
      arrowIconSize: _lerpDouble(arrowIconSize, other.arrowIconSize, t)!,
      arrowPadding: EdgeInsets.lerp(arrowPadding, other.arrowPadding, t)!,
      gridPadding: EdgeInsets.lerp(gridPadding, other.gridPadding, t)!,
      daysPerWeek: daysPerWeek + ((other.daysPerWeek - daysPerWeek) * t).round(),
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
