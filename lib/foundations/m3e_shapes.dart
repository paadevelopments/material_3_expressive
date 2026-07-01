import 'package:flutter/widgets.dart';

/// Material 3 Expressive shape (corner radius) tokens.
///
/// The expressive shape scale extends the baseline scale with the
/// `largeIncreased`, `extraLargeIncreased` and `extraExtraLarge` steps used by
/// the new large components (FAB menu, toolbars, expressive buttons).
abstract final class M3EShapes {
  const M3EShapes._();

  static const double none = 0;
  static const double extraSmall = 4;
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double largeIncreased = 20;
  static const double extraLarge = 28;
  static const double extraLargeIncreased = 32;
  static const double extraExtraLarge = 48;

  /// Sentinel radius that resolves to a fully rounded (stadium) shape.
  static const double full = 9999;

  static const BorderRadius radiusNone = BorderRadius.zero;
  static const BorderRadius radiusExtraSmall =
      BorderRadius.all(Radius.circular(extraSmall));
  static const BorderRadius radiusSmall =
      BorderRadius.all(Radius.circular(small));
  static const BorderRadius radiusMedium =
      BorderRadius.all(Radius.circular(medium));
  static const BorderRadius radiusLarge =
      BorderRadius.all(Radius.circular(large));
  static const BorderRadius radiusLargeIncreased =
      BorderRadius.all(Radius.circular(largeIncreased));
  static const BorderRadius radiusExtraLarge =
      BorderRadius.all(Radius.circular(extraLarge));
  static const BorderRadius radiusExtraLargeIncreased =
      BorderRadius.all(Radius.circular(extraLargeIncreased));
  static const BorderRadius radiusExtraExtraLarge =
      BorderRadius.all(Radius.circular(extraExtraLarge));
  static const StadiumBorder stadium = StadiumBorder();

  /// Resolves a corner radius token to a [BorderRadius].
  ///
  /// The [full] sentinel produces a very large radius that reads as a stadium
  /// for any realistic component height.
  static BorderRadius resolve(double token) {
    return BorderRadius.all(Radius.circular(token));
  }
}
