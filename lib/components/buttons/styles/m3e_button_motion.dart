// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

/// Spring-based motion configuration for [M3EButton] and [M3EToggleButton].
@immutable
class M3EButtonMotion {
  final double stiffness;
  final double damping;

  const M3EButtonMotion({
    required this.stiffness,
    required this.damping,
  });

  static const M3EButtonMotion standard = M3EButtonMotion(
    stiffness: 1200,
    damping: 0.8,
  );

  static const M3EButtonMotion standardOverflow = M3EButtonMotion(
    stiffness: 1600,
    damping: 0.85,
  );

  static const M3EButtonMotion standardPopup = M3EButtonMotion(
    stiffness: 1600,
    damping: 0.85,
  );

  static const M3EButtonMotion expressiveEffectsFast = M3EButtonMotion(
    stiffness: 1600,
    damping: 0.6,
  );

  static const M3EButtonMotion expressiveSpatialDefault = M3EButtonMotion(
    stiffness: 1200,
    damping: 0.9,
  );

  static const M3EButtonMotion standardSpatialFast = M3EButtonMotion(
    stiffness: 1400,
    damping: 0.8,
  );

  factory M3EButtonMotion.custom(double stiffness, double damping) {
    return M3EButtonMotion(stiffness: stiffness, damping: damping);
  }

  /// Converts this configuration to a [SpringMotion].
  SpringMotion toMotion() => SpringMotion(
        SpringDescription.withDampingRatio(
          mass: 1,
          stiffness: stiffness,
          ratio: damping,
        ),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EButtonMotion &&
          stiffness == other.stiffness &&
          damping == other.damping;

  @override
  int get hashCode => Object.hash(stiffness, damping);
}
