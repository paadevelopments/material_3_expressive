import 'package:flutter/widgets.dart';

/// Material 3 Expressive shape (corner radius) tokens.
///
/// The expressive shape scale extends the baseline scale with the
/// `largeIncreased`, `extraLargeIncreased` and `extraExtraLarge` steps used by
/// the new large components (FAB menu, toolbars, expressive buttons).
abstract final class M3EShapes {
  const M3EShapes._();

  /// 0dp — sharp corners.
  static const double none = 0;

  /// 4dp corner radius.
  static const double extraSmall = 4;

  /// 8dp corner radius.
  static const double small = 8;

  /// 12dp corner radius.
  static const double medium = 12;

  /// 16dp corner radius.
  static const double large = 16;

  /// 20dp corner radius (expressive large+).
  static const double largeIncreased = 20;

  /// 28dp corner radius.
  static const double extraLarge = 28;

  /// 32dp corner radius (expressive XL+).
  static const double extraLargeIncreased = 32;

  /// 48dp corner radius.
  static const double extraExtraLarge = 48;

  /// Sentinel radius that resolves to a fully rounded (stadium) shape.
  static const double full = 9999;

  /// [BorderRadius] for [none].
  static const BorderRadius radiusNone = BorderRadius.zero;

  /// [BorderRadius] for [extraSmall].
  static const BorderRadius radiusExtraSmall = BorderRadius.all(
    Radius.circular(extraSmall),
  );

  /// [BorderRadius] for [small].
  static const BorderRadius radiusSmall = BorderRadius.all(
    Radius.circular(small),
  );

  /// [BorderRadius] for [medium].
  static const BorderRadius radiusMedium = BorderRadius.all(
    Radius.circular(medium),
  );

  /// [BorderRadius] for [large].
  static const BorderRadius radiusLarge = BorderRadius.all(
    Radius.circular(large),
  );

  /// [BorderRadius] for [largeIncreased].
  static const BorderRadius radiusLargeIncreased = BorderRadius.all(
    Radius.circular(largeIncreased),
  );

  /// [BorderRadius] for [extraLarge].
  static const BorderRadius radiusExtraLarge = BorderRadius.all(
    Radius.circular(extraLarge),
  );

  /// [BorderRadius] for [extraLargeIncreased].
  static const BorderRadius radiusExtraLargeIncreased = BorderRadius.all(
    Radius.circular(extraLargeIncreased),
  );

  /// [BorderRadius] for [extraExtraLarge].
  static const BorderRadius radiusExtraExtraLarge = BorderRadius.all(
    Radius.circular(extraExtraLarge),
  );

  /// Fully rounded stadium shape border.
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
  /// Creates a five-step shape set.
  const M3EShapeSet({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  /// Extra-small corner radius in this family.
  final BorderRadius xs;

  /// Small corner radius in this family.
  final BorderRadius sm;

  /// Medium corner radius in this family.
  final BorderRadius md;

  /// Large corner radius in this family.
  final BorderRadius lg;

  /// Extra-large corner radius in this family.
  final BorderRadius xl;
}
