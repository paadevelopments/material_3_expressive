// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/foundation.dart';
import 'package:motor/motor.dart';

/// Spring animation configuration for Material 3 Expressive buttons.
///
/// Use with [M3EButtonDecoration.motion] or [M3EToggleButtonDecoration.motion]
/// to customize the spring physics for button animations.
///
/// ## Motion Presets
///
/// The class provides two families of presets:
/// - **Spatial** motions: animate the button's shape (border radius) during press
/// - **Effects** motions: animate opacity/scale effects during press
///
/// Each family has three speed variants:
/// - **Fast**: Snappy, responsive animations
/// - **Default**: Balanced feel
/// - **Slow**: More relaxed, dramatic animations
///
/// ## Custom Motion
///
/// Use [M3EButtonMotion.custom] to create a custom spring with specific physics:
/// ```dart
/// M3EButtonDecoration(
///   motion: M3EButtonMotion.custom(stiffness: 1600, damping: 0.85),
/// )
/// ```
///
/// See also:
/// - [M3EButtonDecoration.motion] for button styling
/// - [M3EToggleButtonDecoration.motion] for toggle button styling
@immutable
class M3EButtonMotion {
  const M3EButtonMotion._({
    required this.stiffness,
    required this.damping,
    this.snapToEnd = false,
  });

  /// Fast spatial motion (stiffness: 1400, damping: 0.9).
  ///
  /// Snappy spring for responsive feel.
  static const M3EButtonMotion standardSpatialFast = M3EButtonMotion._(
    stiffness: 1400,
    damping: 0.9,
    snapToEnd: false,
  );

  /// Default spatial motion (stiffness: 700, damping: 0.9).
  ///
  /// Balanced spring for general use.
  static const M3EButtonMotion standardSpatialDefault = M3EButtonMotion._(
    stiffness: 700,
    damping: 0.9,
  );

  /// Slow spatial motion (stiffness: 300, damping: 0.9).
  ///
  /// Relaxed spring for dramatic feel.
  static const M3EButtonMotion standardSpatialSlow = M3EButtonMotion._(
    stiffness: 300,
    damping: 0.9,
  );

  /// Fast expressive spatial motion (stiffness: 800, damping: 0.6).
  ///
  /// Bouncier spring for expressive feel.
  static const M3EButtonMotion expressiveSpatialFast = M3EButtonMotion._(
    stiffness: 800,
    damping: 0.6,
  );

  /// Default expressive spatial motion (stiffness: 380, damping: 0.8).
  ///
  /// Bouncy, balanced spring for expressive feel.
  static const M3EButtonMotion expressiveSpatialDefault = M3EButtonMotion._(
    stiffness: 380,
    damping: 0.8,
  );

  /// Slow expressive spatial motion (stiffness: 200, damping: 0.8).
  ///
  /// Very bouncy spring for dramatic expressive feel.
  static const M3EButtonMotion expressiveSpatialSlow = M3EButtonMotion._(
    stiffness: 200,
    damping: 0.8,
  );

  /// Fast effects motion (stiffness: 3800, damping: 1).
  ///
  /// Snappy effect animation.
  static const M3EButtonMotion standardEffectsFast = M3EButtonMotion._(
    stiffness: 3800,
    damping: 1,
  );

  /// Default effects motion (stiffness: 1600, damping: 1).
  ///
  /// Balanced effect animation.
  static const M3EButtonMotion standardEffectsDefault = M3EButtonMotion._(
    stiffness: 1600,
    damping: 1,
  );

  /// Slow effects motion (stiffness: 800, damping: 1).
  ///
  /// Relaxed effect animation.
  static const M3EButtonMotion standardEffectsSlow = M3EButtonMotion._(
    stiffness: 800,
    damping: 1,
  );

  /// Fast expressive effects motion (stiffness: 3800, damping: 1).
  ///
  /// Snappy expressive effect animation.
  static const M3EButtonMotion expressiveEffectsFast = M3EButtonMotion._(
    stiffness: 3800,
    damping: 1,
  );

  /// Default expressive effects motion (stiffness: 1600, damping: 1).
  ///
  /// Balanced expressive effect animation.
  static const M3EButtonMotion expressiveEffectsDefault = M3EButtonMotion._(
    stiffness: 1600,
    damping: 1,
  );

  /// Slow expressive effects motion (stiffness: 800, damping: 1).
  ///
  /// Relaxed expressive effect animation.
  static const M3EButtonMotion expressiveEffectsSlow = M3EButtonMotion._(
    stiffness: 800,
    damping: 1,
  );

  /// Standard overflow animation (stiffness: 1600, damping: 0.85).
  ///
  /// Spring animation for overflow menus and popups.
  static const M3EButtonMotion standardOverflow = M3EButtonMotion._(
    stiffness: 1600,
    damping: 0.85,
  );

  /// Standard popup animation (stiffness: 1000, damping: 0.6).
  ///
  /// Bouncy spring for popup menus.
  static const M3EButtonMotion standardPopup = M3EButtonMotion._(
    stiffness: 1000,
    damping: 0.6,
  );

  /// Creates a custom spring motion with the specified physics.
  ///
  /// [stiffness] controls how fast the spring bounces (higher = faster).
  /// [damping] controls how quickly oscillations settle (0.7-1.0 recommended).
  factory M3EButtonMotion.custom(double stiffness, double damping) {
    return M3EButtonMotion._(stiffness: stiffness, damping: damping);
  }

  /// Spring stiffness. Higher values make the spring snappier.
  final double stiffness;

  /// Spring damping. Values closer to 1 make the spring less bouncy.
  final double damping;

  /// Whether the spring should snap to the end position.
  final bool snapToEnd;

  /// Converts this [M3EButtonMotion] to a [SpringMotion] for animation use.
  SpringMotion toMotion() => MaterialSpringMotion.expressiveEffectsFast()
      .copyWith(stiffness: stiffness, damping: damping, snapToEnd: snapToEnd);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EButtonMotion &&
          stiffness == other.stiffness &&
          damping == other.damping &&
          snapToEnd == other.snapToEnd;

  @override
  int get hashCode => Object.hash(stiffness, damping, snapToEnd);
}
