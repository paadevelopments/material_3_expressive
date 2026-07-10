import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for [M3EDropdownMenu].
@immutable
class M3EDropdownMenuTheme extends M3EThemeExtension<M3EDropdownMenuTheme> {
  const M3EDropdownMenuTheme({
    this.containerRadius = 28,
    this.panelElevation = M3EElevation.level2,
    this.panelMaxHeight = 350,
    this.panelMarginTop = 4,
    this.itemOuterRadius = 12,
    this.itemInnerRadius = 4,
    this.openSpring = M3EMotion.expressiveSpatialDefault,
    this.closeSpring = M3EMotion.expressiveSpatialDefault,
    this.disabledOpacity = 0.38,
  });

  static const M3EDropdownMenuTheme defaults = M3EDropdownMenuTheme();

  final double containerRadius;
  final double panelElevation;
  final double panelMaxHeight;
  final double panelMarginTop;
  final double itemOuterRadius;
  final double itemInnerRadius;
  final M3ESpring openSpring;
  final M3ESpring closeSpring;
  final double disabledOpacity;

  Color fieldBackgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

  Color fieldForegroundColor(M3EColorScheme scheme) => scheme.onSurface;

  Color panelBackgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

  Color chipBackgroundColor(M3EColorScheme scheme) => scheme.secondaryContainer;

  Color chipForegroundColor(M3EColorScheme scheme) =>
      scheme.onSecondaryContainer;

  Color itemBackgroundColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  Color itemSelectedBackgroundColor(M3EColorScheme scheme) =>
      scheme.secondaryContainer;

  Color itemForegroundColor(M3EColorScheme scheme) => scheme.onSurface;

  Color itemSelectedForegroundColor(M3EColorScheme scheme) =>
      scheme.onSecondaryContainer;

  TextStyle hintTextStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(
        color: M3EColorUtils.withOpacity(scheme.onSurface, 0.6),
      );

  TextStyle selectedTextStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurface);

  TextStyle chipLabelStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.labelMedium.copyWith(color: scheme.onSecondaryContainer);

  TextStyle itemTextStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurface);

  @override
  M3EDropdownMenuTheme copyWith({
    double? containerRadius,
    double? panelElevation,
    double? panelMaxHeight,
    double? panelMarginTop,
    double? itemOuterRadius,
    double? itemInnerRadius,
    M3ESpring? openSpring,
    M3ESpring? closeSpring,
    double? disabledOpacity,
  }) {
    return M3EDropdownMenuTheme(
      containerRadius: containerRadius ?? this.containerRadius,
      panelElevation: panelElevation ?? this.panelElevation,
      panelMaxHeight: panelMaxHeight ?? this.panelMaxHeight,
      panelMarginTop: panelMarginTop ?? this.panelMarginTop,
      itemOuterRadius: itemOuterRadius ?? this.itemOuterRadius,
      itemInnerRadius: itemInnerRadius ?? this.itemInnerRadius,
      openSpring: openSpring ?? this.openSpring,
      closeSpring: closeSpring ?? this.closeSpring,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }

  @override
  M3EDropdownMenuTheme lerp(M3EDropdownMenuTheme? other, double t) {
    if (other is! M3EDropdownMenuTheme) {
      return this;
    }
    return M3EDropdownMenuTheme(
      containerRadius: _lerpDouble(containerRadius, other.containerRadius, t)!,
      panelElevation: _lerpDouble(panelElevation, other.panelElevation, t)!,
      panelMaxHeight: _lerpDouble(panelMaxHeight, other.panelMaxHeight, t)!,
      panelMarginTop: _lerpDouble(panelMarginTop, other.panelMarginTop, t)!,
      itemOuterRadius: _lerpDouble(itemOuterRadius, other.itemOuterRadius, t)!,
      itemInnerRadius: _lerpDouble(itemInnerRadius, other.itemInnerRadius, t)!,
      openSpring: t < 0.5 ? openSpring : other.openSpring,
      closeSpring: t < 0.5 ? closeSpring : other.closeSpring,
      disabledOpacity: _lerpDouble(disabledOpacity, other.disabledOpacity, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
