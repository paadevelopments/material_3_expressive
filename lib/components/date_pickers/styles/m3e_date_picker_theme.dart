import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for M3E date pickers.
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
    this.elevation = 6,
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    this.headerPortraitHeight = 120,
    this.headerLandscapeWidth = 152,
    this.subHeaderHeight = 52,
    this.inputHorizontalPadding = 24,
    this.actionHorizontalPadding = 8,
    this.actionSpacing = 8,
  });

  static const M3EDatePickerTheme defaults = M3EDatePickerTheme();

  final double width;
  final EdgeInsets padding;
  final double daySize;
  final double arrowIconSize;
  final EdgeInsets arrowPadding;
  final EdgeInsets gridPadding;
  final int daysPerWeek;
  final double elevation;
  final EdgeInsets insetPadding;
  final double headerPortraitHeight;
  final double headerLandscapeWidth;
  final double subHeaderHeight;
  final double inputHorizontalPadding;
  final double actionHorizontalPadding;
  final double actionSpacing;

  BorderRadius get borderRadius => M3EShapes.radiusExtraLarge;
  BorderRadius get dialogShape => M3EShapes.radiusExtraLarge;

  Color backgroundColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  Color headerBackgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHigh;

  Color headerForegroundColor(M3EColorScheme scheme) => scheme.onSurfaceVariant;

  Color dividerColor(M3EColorScheme scheme) =>
      M3EColorUtils.withOpacity(scheme.onSurface, 0.12);

  Color weekdayColor(M3EColorScheme scheme) => scheme.onSurfaceVariant;

  Color todayColor(M3EColorScheme scheme) => scheme.primary;

  Color selectedDayBackgroundColor(M3EColorScheme scheme) => scheme.primary;

  Color selectedDayForegroundColor(M3EColorScheme scheme) => scheme.onPrimary;

  Color rangeStartBackgroundColor(M3EColorScheme scheme) => scheme.primary;

  Color rangeEndBackgroundColor(M3EColorScheme scheme) => scheme.primary;

  Color rangeSelectionColor(M3EColorScheme scheme) =>
      M3EColorUtils.withOpacity(scheme.primary, 0.12);

  Color rangeHighlightColor(M3EColorScheme scheme) =>
      M3EColorUtils.withOpacity(scheme.primary, 0.12);

  TextStyle headerHelpStyle(M3ETypeScale typeScale, M3EColorScheme scheme) {
    return typeScale.labelLarge.copyWith(color: headerForegroundColor(scheme));
  }

  TextStyle headerHeadlineStyle(M3ETypeScale typeScale, M3EColorScheme scheme) {
    return typeScale.headlineLarge.copyWith(color: scheme.onSurface);
  }

  TextStyle headerHeadlineShortStyle(
    M3ETypeScale typeScale,
    M3EColorScheme scheme,
  ) {
    return typeScale.headlineSmall.copyWith(color: scheme.onSurface);
  }

  TextStyle weekdayStyle(M3ETypeScale typeScale, M3EColorScheme scheme) {
    return typeScale.bodySmall.copyWith(color: weekdayColor(scheme));
  }

  TextStyle dayStyle(M3ETypeScale typeScale, M3EColorScheme scheme) {
    return typeScale.bodyMedium.copyWith(color: scheme.onSurface);
  }

  TextStyle yearStyle(M3ETypeScale typeScale, M3EColorScheme scheme) {
    return typeScale.titleMedium.copyWith(color: scheme.onSurface);
  }

  TextStyle selectedYearStyle(M3ETypeScale typeScale, M3EColorScheme scheme) {
    return typeScale.titleMedium.copyWith(color: scheme.onPrimary);
  }

  Color dayForegroundColor(
    M3EColorScheme scheme, {
    required bool selected,
    required bool enabled,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return selected ? selectedDayForegroundColor(scheme) : scheme.onSurface;
  }

  Color yearForegroundColor(
    M3EColorScheme scheme, {
    required bool selected,
    required bool enabled,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return selected ? selectedDayForegroundColor(scheme) : scheme.onSurface;
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
    double? elevation,
    EdgeInsets? insetPadding,
    double? headerPortraitHeight,
    double? headerLandscapeWidth,
    double? subHeaderHeight,
    double? inputHorizontalPadding,
    double? actionHorizontalPadding,
    double? actionSpacing,
  }) {
    return M3EDatePickerTheme(
      width: width ?? this.width,
      padding: padding ?? this.padding,
      daySize: daySize ?? this.daySize,
      arrowIconSize: arrowIconSize ?? this.arrowIconSize,
      arrowPadding: arrowPadding ?? this.arrowPadding,
      gridPadding: gridPadding ?? this.gridPadding,
      daysPerWeek: daysPerWeek ?? this.daysPerWeek,
      elevation: elevation ?? this.elevation,
      insetPadding: insetPadding ?? this.insetPadding,
      headerPortraitHeight: headerPortraitHeight ?? this.headerPortraitHeight,
      headerLandscapeWidth:
          headerLandscapeWidth ?? this.headerLandscapeWidth,
      subHeaderHeight: subHeaderHeight ?? this.subHeaderHeight,
      inputHorizontalPadding:
          inputHorizontalPadding ?? this.inputHorizontalPadding,
      actionHorizontalPadding:
          actionHorizontalPadding ?? this.actionHorizontalPadding,
      actionSpacing: actionSpacing ?? this.actionSpacing,
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
      elevation: _lerpDouble(elevation, other.elevation, t)!,
      insetPadding: EdgeInsets.lerp(insetPadding, other.insetPadding, t)!,
      headerPortraitHeight:
          _lerpDouble(headerPortraitHeight, other.headerPortraitHeight, t)!,
      headerLandscapeWidth:
          _lerpDouble(headerLandscapeWidth, other.headerLandscapeWidth, t)!,
      subHeaderHeight: _lerpDouble(subHeaderHeight, other.subHeaderHeight, t)!,
      inputHorizontalPadding: _lerpDouble(
        inputHorizontalPadding,
        other.inputHorizontalPadding,
        t,
      )!,
      actionHorizontalPadding: _lerpDouble(
        actionHorizontalPadding,
        other.actionHorizontalPadding,
        t,
      )!,
      actionSpacing: _lerpDouble(actionSpacing, other.actionSpacing, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
