// Ported from https://github.com/Mudit200408/m3e_dropdown_menu
// Adapted for material_3_expressive: import paths, foundations wiring, M3E naming.

import 'package:motor/motor.dart';

import '../../../foundations/m3e_motion.dart';

/// Converts [M3ESpring] to a motor [SpringMotion] for dropdown animations.
extension M3EDropdownSpringMotion on M3ESpring {
  SpringMotion toMotion() => const MaterialSpringMotion.expressiveSpatialDefault()
      .copyWith(stiffness: stiffness, damping: damping);
}
