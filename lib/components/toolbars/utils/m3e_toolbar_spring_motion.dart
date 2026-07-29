import 'package:motor/motor.dart';

import '../../../foundations/m3e_motion.dart';

/// Converts [M3ESpring] to a motor [SpringMotion] for toolbar animations.
extension M3EToolbarSpringMotion on M3ESpring {
  /// Matches m3e_core floating toolbar: expressive spatial base + token values.
  SpringMotion toMotion() => const MaterialSpringMotion.expressiveSpatialFast()
      .copyWith(stiffness: stiffness, damping: damping);
}

/// Expand / visibility spring used by floating toolbar morph and scroll exit.
SpringMotion m3eToolbarExpandMotion() =>
    M3EMotion.expressiveSpatialFast.toMotion();
