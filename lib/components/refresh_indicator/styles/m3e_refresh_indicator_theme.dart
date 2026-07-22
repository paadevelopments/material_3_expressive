import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ERefreshIndicator`.
@immutable
class M3ERefreshIndicatorTheme
    extends M3EThemeExtension<M3ERefreshIndicatorTheme> {
  static const double kDefaultDisplacement = 40;
  static const double kDefaultEdgeOffset = 0;
  static const double kDefaultElevation = 2;
  static const double kDragContainerExtentPercentage = 0.25;
  static const double kDragSizeFactorLimit = 1.5;

  const M3ERefreshIndicatorTheme({
    this.defaultDisplacement = kDefaultDisplacement,
    this.defaultEdgeOffset = kDefaultEdgeOffset,
    this.defaultElevation = kDefaultElevation,
    this.dragContainerExtentPercentage = kDragContainerExtentPercentage,
    this.dragSizeFactorLimit = kDragSizeFactorLimit,
    this.indicatorSnapDuration = const Duration(milliseconds: 150),
    this.indicatorScaleDuration = const Duration(milliseconds: 200),
  });

  static const M3ERefreshIndicatorTheme defaults = M3ERefreshIndicatorTheme();

  final double defaultDisplacement;
  final double defaultEdgeOffset;
  final double defaultElevation;
  final double dragContainerExtentPercentage;
  final double dragSizeFactorLimit;
  final Duration indicatorSnapDuration;
  final Duration indicatorScaleDuration;

  Color activeColor(M3EColorScheme scheme) => scheme.primary;

  Color containerColorDefault() => const Color(0x00000000);

  Color containedContainerColor(M3EColorScheme scheme) =>
      scheme.primaryContainer;

  Color containedActiveColor(M3EColorScheme scheme) =>
      scheme.onPrimaryContainer;

  @override
  M3ERefreshIndicatorTheme copyWith({
    double? defaultDisplacement,
    double? defaultEdgeOffset,
    double? defaultElevation,
    double? dragContainerExtentPercentage,
    double? dragSizeFactorLimit,
    Duration? indicatorSnapDuration,
    Duration? indicatorScaleDuration,
  }) {
    return M3ERefreshIndicatorTheme(
      defaultDisplacement: defaultDisplacement ?? this.defaultDisplacement,
      defaultEdgeOffset: defaultEdgeOffset ?? this.defaultEdgeOffset,
      defaultElevation: defaultElevation ?? this.defaultElevation,
      dragContainerExtentPercentage: dragContainerExtentPercentage ??
          this.dragContainerExtentPercentage,
      dragSizeFactorLimit: dragSizeFactorLimit ?? this.dragSizeFactorLimit,
      indicatorSnapDuration:
          indicatorSnapDuration ?? this.indicatorSnapDuration,
      indicatorScaleDuration:
          indicatorScaleDuration ?? this.indicatorScaleDuration,
    );
  }

  @override
  M3ERefreshIndicatorTheme lerp(M3ERefreshIndicatorTheme? other, double t) {
    if (other is! M3ERefreshIndicatorTheme) {
      return this;
    }
    return M3ERefreshIndicatorTheme(
      defaultDisplacement: _lerpDouble(
        defaultDisplacement,
        other.defaultDisplacement,
        t,
      )!,
      defaultEdgeOffset:
          _lerpDouble(defaultEdgeOffset, other.defaultEdgeOffset, t)!,
      defaultElevation:
          _lerpDouble(defaultElevation, other.defaultElevation, t)!,
      dragContainerExtentPercentage: _lerpDouble(
        dragContainerExtentPercentage,
        other.dragContainerExtentPercentage,
        t,
      )!,
      dragSizeFactorLimit: _lerpDouble(
        dragSizeFactorLimit,
        other.dragSizeFactorLimit,
        t,
      )!,
      indicatorSnapDuration:
          t < 0.5 ? indicatorSnapDuration : other.indicatorSnapDuration,
      indicatorScaleDuration:
          t < 0.5 ? indicatorScaleDuration : other.indicatorScaleDuration,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
