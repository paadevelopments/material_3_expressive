import 'package:flutter/widgets.dart';

/// Material 3 Expressive motion tokens.
///
/// Expressive motion favours spring based physics for spatial movement while
/// keeping duration/easing pairs for effects such as opacity and color. The
/// values below mirror the published M3 Expressive spring and easing sets.
abstract final class M3EMotion {
  const M3EMotion._();

  // Duration tokens.
  static const Duration short1 = Duration(milliseconds: 50);
  static const Duration short2 = Duration(milliseconds: 100);
  static const Duration short3 = Duration(milliseconds: 150);
  static const Duration short4 = Duration(milliseconds: 200);
  static const Duration medium1 = Duration(milliseconds: 250);
  static const Duration medium2 = Duration(milliseconds: 300);
  static const Duration medium3 = Duration(milliseconds: 350);
  static const Duration medium4 = Duration(milliseconds: 400);
  static const Duration long1 = Duration(milliseconds: 450);
  static const Duration long2 = Duration(milliseconds: 500);
  static const Duration long3 = Duration(milliseconds: 550);
  static const Duration long4 = Duration(milliseconds: 600);
  static const Duration extraLong1 = Duration(milliseconds: 700);
  static const Duration extraLong2 = Duration(milliseconds: 800);
  static const Duration extraLong3 = Duration(milliseconds: 900);
  static const Duration extraLong4 = Duration(milliseconds: 1000);

  // Easing tokens.
  static const Curve standard = Cubic(0.2, 0, 0, 1);
  static const Curve standardAccelerate = Cubic(0.3, 0, 1, 1);
  static const Curve standardDecelerate = Cubic(0, 0, 0, 1);
  static const Curve emphasized = Cubic(0.2, 0, 0, 1);
  static const Curve emphasizedAccelerate = Cubic(0.3, 0, 0.8, 0.15);
  static const Curve emphasizedDecelerate = Cubic(0.05, 0.7, 0.1, 1);
  static const Curve linear = Cubic(0, 0, 1, 1);

  // Spatial springs drive size, position and shape morph transitions.
  static const M3ESpring spatialFast = M3ESpring(stiffness: 1400, damping: 0.9);
  static const M3ESpring spatialDefault =
      M3ESpring(stiffness: 700, damping: 0.9);
  static const M3ESpring spatialSlow = M3ESpring(stiffness: 300, damping: 0.9);

  // Expressive spatial springs add a small overshoot for a lively feel.
  static const M3ESpring expressiveSpatialFast =
      M3ESpring(stiffness: 800, damping: 0.6);
  static const M3ESpring expressiveSpatialDefault =
      M3ESpring(stiffness: 380, damping: 0.8);
  static const M3ESpring expressiveSpatialSlow =
      M3ESpring(stiffness: 200, damping: 0.8);

  // Effect springs drive color and opacity and never overshoot.
  static const M3ESpring effectsFast = M3ESpring(stiffness: 3800, damping: 1);
  static const M3ESpring effectsDefault =
      M3ESpring(stiffness: 1600, damping: 1);
  static const M3ESpring effectsSlow = M3ESpring(stiffness: 800, damping: 1);
}

/// A serialisable description of a Material 3 Expressive spring.
///
/// [damping] is expressed as a damping ratio where `1.0` is critically damped
/// (no overshoot) and values below `1.0` produce an expressive overshoot.
@immutable
class M3ESpring {
  const M3ESpring({required this.stiffness, required this.damping});

  /// Spring stiffness. Higher values settle faster.
  final double stiffness;

  /// Damping ratio. `1.0` is critically damped; lower values overshoot.
  final double damping;

  /// Builds a [SpringDescription] for a unit mass.
  SpringDescription toDescription() {
    return SpringDescription.withDampingRatio(
      mass: 1,
      stiffness: stiffness,
      ratio: damping,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is M3ESpring &&
        other.stiffness == stiffness &&
        other.damping == damping;
  }

  @override
  int get hashCode => Object.hash(stiffness, damping);
}
