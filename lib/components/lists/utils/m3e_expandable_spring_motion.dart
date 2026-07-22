import 'package:motor/motor.dart';

import '../../../foundations/m3e_motion.dart';

/// Converts [M3ESpring] to a motor [SpringMotion] for expandable animations.
///
/// Matches [M3EDropdownSpringMotion] so expand/collapse feels the same as the
/// dropdown menu panel.
extension M3EExpandableSpringMotion on M3ESpring {
  SpringMotion toMotion() =>
      const MaterialSpringMotion.expressiveSpatialDefault()
          .copyWith(stiffness: stiffness, damping: damping);
}
