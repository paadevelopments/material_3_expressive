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

  /// The expressive *round* shape set (mirrors `m3e_design`'s round family).
  static const M3EShapeSet roundSet = M3EShapeSet(
    xs: BorderRadius.all(Radius.circular(999)),
    sm: BorderRadius.all(Radius.circular(20)),
    md: BorderRadius.all(Radius.circular(28)),
    lg: BorderRadius.all(Radius.circular(44)),
    xl: BorderRadius.all(Radius.circular(64)),
  );

  /// The expressive *square* shape set (mirrors `m3e_design`'s square family).
  static const M3EShapeSet squareSet = M3EShapeSet(
    xs: BorderRadius.all(Radius.circular(6)),
    sm: BorderRadius.all(Radius.circular(8)),
    md: BorderRadius.all(Radius.circular(12)),
    lg: BorderRadius.all(Radius.circular(16)),
    xl: BorderRadius.all(Radius.circular(20)),
  );
}

/// A five-step [BorderRadius] scale for a single shape family.
///
/// Mirrors the `M3EShapeSet` from the `m3e_design` package.
@immutable
class M3EShapeSet {
  const M3EShapeSet({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  final BorderRadius xs;
  final BorderRadius sm;
  final BorderRadius md;
  final BorderRadius lg;
  final BorderRadius xl;
}
