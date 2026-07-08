import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';

/// Theme values for [M3ECarousel].
@immutable
class M3ECarouselTheme extends M3EThemeExtension<M3ECarouselTheme> {
  static const double defaultUncontainedItemExtent = 270;
  static const double defaultUncontainedShrinkExtent = 150;
  static const double defaultBorderRadiusValue = 28;
  static const int defaultScrollAnimationDuration = 500;
  static const int defaultSingleSwipeGestureSensitivityRange = 300;

  const M3ECarouselTheme({
    this.uncontainedItemExtent = defaultUncontainedItemExtent,
    this.uncontainedShrinkExtent = defaultUncontainedShrinkExtent,
    this.borderRadiusValue = defaultBorderRadiusValue,
    this.scrollAnimationDuration = defaultScrollAnimationDuration,
    this.singleSwipeGestureSensitivityRange =
        defaultSingleSwipeGestureSensitivityRange,
  });

  static const M3ECarouselTheme defaults = M3ECarouselTheme();

  final double uncontainedItemExtent;
  final double uncontainedShrinkExtent;
  final double borderRadiusValue;
  final int scrollAnimationDuration;
  final int singleSwipeGestureSensitivityRange;

  BorderRadius get borderRadius =>
      BorderRadius.all(Radius.circular(borderRadiusValue));

  ShapeBorder get shape => RoundedRectangleBorder(borderRadius: borderRadius);

  Color backgroundColor(M3EColorScheme scheme) => scheme.surface;

  @override
  M3ECarouselTheme copyWith({
    double? uncontainedItemExtent,
    double? uncontainedShrinkExtent,
    double? borderRadiusValue,
    int? scrollAnimationDuration,
    int? singleSwipeGestureSensitivityRange,
  }) {
    return M3ECarouselTheme(
      uncontainedItemExtent:
          uncontainedItemExtent ?? this.uncontainedItemExtent,
      uncontainedShrinkExtent:
          uncontainedShrinkExtent ?? this.uncontainedShrinkExtent,
      borderRadiusValue: borderRadiusValue ?? this.borderRadiusValue,
      scrollAnimationDuration:
          scrollAnimationDuration ?? this.scrollAnimationDuration,
      singleSwipeGestureSensitivityRange: singleSwipeGestureSensitivityRange ??
          this.singleSwipeGestureSensitivityRange,
    );
  }

  @override
  M3ECarouselTheme lerp(M3ECarouselTheme? other, double t) {
    if (other is! M3ECarouselTheme) {
      return this;
    }
    return M3ECarouselTheme(
      uncontainedItemExtent:
          _lerpDouble(uncontainedItemExtent, other.uncontainedItemExtent, t)!,
      uncontainedShrinkExtent: _lerpDouble(
        uncontainedShrinkExtent,
        other.uncontainedShrinkExtent,
        t,
      )!,
      borderRadiusValue:
          _lerpDouble(borderRadiusValue, other.borderRadiusValue, t)!,
      scrollAnimationDuration: _lerpInt(
        scrollAnimationDuration,
        other.scrollAnimationDuration,
        t,
      ),
      singleSwipeGestureSensitivityRange: _lerpInt(
        singleSwipeGestureSensitivityRange,
        other.singleSwipeGestureSensitivityRange,
        t,
      ),
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  int _lerpInt(int a, int b, double t) => (a + (b - a) * t).round();
}
