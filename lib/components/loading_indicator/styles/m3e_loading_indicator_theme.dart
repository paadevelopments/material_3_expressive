import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_loading_indicator_variant.dart';

/// Theme values for `M3ELoadingIndicator`.
@immutable
class M3ELoadingIndicatorTheme
    extends M3EThemeExtension<M3ELoadingIndicatorTheme> {
  /// M3ELoadingIndicatorTheme.
  const M3ELoadingIndicatorTheme({
    this.containerWidth = 48,
    this.containerHeight = 48,
    this.activeIndicatorSize = 38,
  });

  /// defaults.

  static const M3ELoadingIndicatorTheme defaults = M3ELoadingIndicatorTheme();

  /// containerWidth.

  final double containerWidth;

  /// containerHeight.
  final double containerHeight;

  /// activeIndicatorSize.
  final double activeIndicatorSize;

  /// The containerRadius.

  BorderRadius get containerRadius => BorderRadius.circular(999);

  /// activeColor.

  Color activeColor(M3EColorScheme scheme) => scheme.primary;

  /// containerColorDefault.

  Color containerColorDefault() => const Color(0x00000000);

  /// containedContainerColor.

  Color containedContainerColor(M3EColorScheme scheme) =>
      scheme.primaryContainer;

  /// containedActiveColor.

  Color containedActiveColor(M3EColorScheme scheme) =>
      scheme.onPrimaryContainer;

  /// resolveActiveColor.

  Color resolveActiveColor(
    M3EColorScheme scheme,
    M3ELoadingIndicatorVariant variant,
  ) {
    return switch (variant) {
      M3ELoadingIndicatorVariant.defaultStyle => activeColor(scheme),
      M3ELoadingIndicatorVariant.contained => containedActiveColor(scheme),
    };
  }

  /// resolveContainerColor.

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
      activeIndicatorSize: _lerpDouble(
        activeIndicatorSize,
        other.activeIndicatorSize,
        t,
      )!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
