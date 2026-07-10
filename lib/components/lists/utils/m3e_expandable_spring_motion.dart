import 'package:motor/motor.dart';

import '../../../foundations/m3e_motion.dart';

/// Converts [M3ESpring] to a motor [SpringMotion] for expandable animations.
extension M3EExpandableSpringMotion on M3ESpring {
  SpringMotion toMotion({bool snapToEnd = false}) =>
      const MaterialSpringMotion.expressiveEffectsFast()
          .copyWith(
            stiffness: stiffness,
            damping: damping,
            snapToEnd: snapToEnd,
          );
}
