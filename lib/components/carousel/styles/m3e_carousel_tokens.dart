import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for Material 3 Expressive Carousels.
abstract class M3ECarouselTokens {
  /// The default item extent for an uncontained carousel.
  static const double uncontainedItemExtent = 270.0;

  /// The minimum allowable extent (size) for carousel items during transitions.
  static const double uncontainedShrinkExtent = 150.0;

  /// The default border radius for carousel items.
  static const double borderRadiusValue = 28.0;

  /// The default border radius for carousel items as a [BorderRadius].
  static const BorderRadius borderRadius =
      BorderRadius.all(Radius.circular(borderRadiusValue));

  /// The default shape for carousel items.
  static const ShapeBorder shape = RoundedRectangleBorder(
    borderRadius: borderRadius,
  );

  /// Resolves the background color for a carousel item.
  static Color backgroundColor(BuildContext context) {
    return M3ETheme.of(context).colorScheme.surface;
  }

  /// The default animation duration for automatic scrolling in milliseconds.
  static const int scrollAnimationDuration = 500;

  /// The default swipe sensitivity for automatic scrolling.
  static const int singleSwipeGestureSensitivityRange = 300;
}
