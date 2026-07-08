import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';
import '../enums/m3e_loading_indicator_variant.dart';

/// Theme values for [M3ELoadingIndicator].
@immutable
class M3ELoadingIndicatorTheme
    extends M3EThemeExtension<M3ELoadingIndicatorTheme> {
  const M3ELoadingIndicatorTheme({
    this.containerWidth = 48,
    this.containerHeight = 48,
    this.activeIndicatorSize = 38,
  });

  static const M3ELoadingIndicatorTheme defaults = M3ELoadingIndicatorTheme();

  final double containerWidth;
  final double containerHeight;
  final double activeIndicatorSize;

  BorderRadius get containerRadius => BorderRadius.circular(999);

  Color activeColor(M3EColorScheme scheme) => scheme.primary;

  Color containerColorDefault() => const Color(0x00000000);

  Color containedContainerColor(M3EColorScheme scheme) =>
      scheme.primaryContainer;

  Color containedActiveColor(M3EColorScheme scheme) =>
      scheme.onPrimaryContainer;

  Color resolveActiveColor(
    M3EColorScheme scheme,
    M3ELoadingIndicatorVariant variant,
  ) {
    return switch (variant) {
      M3ELoadingIndicatorVariant.defaultStyle => activeColor(scheme),
      M3ELoadingIndicatorVariant.contained => containedActiveColor(scheme),
    };
  }

  Color resolveContainerColor(
    M3EColorScheme scheme,
    M3ELoadingIndicatorVariant variant,
  ) {
    return switch (variant) {
      M3ELoadingIndicatorVariant.defaultStyle => containerColorDefault(),
      M3ELoadingIndicatorVariant.contained => containedContainerColor(scheme),
    };
  }

  @override
  M3ELoadingIndicatorTheme copyWith({
    double? containerWidth,
    double? containerHeight,
    double? activeIndicatorSize,
  }) {
    return M3ELoadingIndicatorTheme(
      containerWidth: containerWidth ?? this.containerWidth,
      containerHeight: containerHeight ?? this.containerHeight,
      activeIndicatorSize: activeIndicatorSize ?? this.activeIndicatorSize,
    );
  }

  @override
  M3ELoadingIndicatorTheme lerp(M3ELoadingIndicatorTheme? other, double t) {
    if (other is! M3ELoadingIndicatorTheme) {
      return this;
    }
    return M3ELoadingIndicatorTheme(
      containerWidth: _lerpDouble(containerWidth, other.containerWidth, t)!,
      containerHeight: _lerpDouble(containerHeight, other.containerHeight, t)!,
      activeIndicatorSize:
          _lerpDouble(activeIndicatorSize, other.activeIndicatorSize, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
