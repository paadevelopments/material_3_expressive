import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ETimePicker`.
@immutable
class M3ETimePickerTheme extends M3EThemeExtension<M3ETimePickerTheme> {
  const M3ETimePickerTheme({
    this.padding = const EdgeInsets.all(24),
    this.dialSize = 256,
    this.dialKnobRadius = 20,
    this.dialCenterRadius = 4,
    this.dialRingInset = 4,
    this.dialHandWidth = 2,
    this.dialLabelFontSize = 16,
    this.fieldSize = const Size(96, 80),
    this.fieldMargin = const EdgeInsets.symmetric(horizontal: 4),
    this.periodOptionSize = const Size(48, 40),
    this.fieldPeriodGap = 12,
    this.headerDialGap = 24,
  });

  static const M3ETimePickerTheme defaults = M3ETimePickerTheme();

  final EdgeInsets padding;
  final double dialSize;
  final double dialKnobRadius;
  final double dialCenterRadius;
  final double dialRingInset;
  final double dialHandWidth;
  final double dialLabelFontSize;
  final Size fieldSize;
  final EdgeInsets fieldMargin;
  final Size periodOptionSize;
  final double fieldPeriodGap;
  final double headerDialGap;

  BorderRadius get borderRadius => M3EShapes.radiusExtraLarge;

  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  Color periodOptionBackgroundColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) {
    return selected ? scheme.tertiaryContainer : const Color(0x00000000);
  }

  Color periodOptionForegroundColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) {
    return selected ? scheme.onTertiaryContainer : scheme.onSurfaceVariant;
  }

  Color fieldBackgroundColor(
    M3EColorScheme scheme, {
    required bool active,
  }) {
    return active ? scheme.primaryContainer : scheme.surfaceContainerHighest;
  }

  Color fieldForegroundColor(
    M3EColorScheme scheme, {
    required bool active,
  }) {
    return active ? scheme.onPrimaryContainer : scheme.onSurface;
  }

  @override
  M3ETimePickerTheme copyWith({
    EdgeInsets? padding,
    double? dialSize,
    double? dialKnobRadius,
    double? dialCenterRadius,
    double? dialRingInset,
    double? dialHandWidth,
    double? dialLabelFontSize,
    Size? fieldSize,
    EdgeInsets? fieldMargin,
    Size? periodOptionSize,
    double? fieldPeriodGap,
    double? headerDialGap,
  }) {
    return M3ETimePickerTheme(
      padding: padding ?? this.padding,
      dialSize: dialSize ?? this.dialSize,
      dialKnobRadius: dialKnobRadius ?? this.dialKnobRadius,
      dialCenterRadius: dialCenterRadius ?? this.dialCenterRadius,
      dialRingInset: dialRingInset ?? this.dialRingInset,
      dialHandWidth: dialHandWidth ?? this.dialHandWidth,
      dialLabelFontSize: dialLabelFontSize ?? this.dialLabelFontSize,
      fieldSize: fieldSize ?? this.fieldSize,
      fieldMargin: fieldMargin ?? this.fieldMargin,
      periodOptionSize: periodOptionSize ?? this.periodOptionSize,
      fieldPeriodGap: fieldPeriodGap ?? this.fieldPeriodGap,
      headerDialGap: headerDialGap ?? this.headerDialGap,
    );
  }

  @override
  M3ETimePickerTheme lerp(M3ETimePickerTheme? other, double t) {
    if (other is! M3ETimePickerTheme) {
      return this;
    }
    return M3ETimePickerTheme(
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      dialSize: _lerpDouble(dialSize, other.dialSize, t)!,
      dialKnobRadius: _lerpDouble(dialKnobRadius, other.dialKnobRadius, t)!,
      dialCenterRadius:
          _lerpDouble(dialCenterRadius, other.dialCenterRadius, t)!,
      dialRingInset: _lerpDouble(dialRingInset, other.dialRingInset, t)!,
      dialHandWidth: _lerpDouble(dialHandWidth, other.dialHandWidth, t)!,
      dialLabelFontSize:
          _lerpDouble(dialLabelFontSize, other.dialLabelFontSize, t)!,
      fieldSize: Size.lerp(fieldSize, other.fieldSize, t)!,
      fieldMargin: EdgeInsets.lerp(fieldMargin, other.fieldMargin, t)!,
      periodOptionSize: Size.lerp(periodOptionSize, other.periodOptionSize, t)!,
      fieldPeriodGap: _lerpDouble(fieldPeriodGap, other.fieldPeriodGap, t)!,
      headerDialGap: _lerpDouble(headerDialGap, other.headerDialGap, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
