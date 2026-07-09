import 'package:flutter/widgets.dart';

import 'm3e_motion.dart';
import 'm3e_state_layer.dart';

/// Paints an animated Material state layer clipped to [shape] behind [child].
///
/// Owns the internal stack layout and sizing rules so callers do not need an
/// outer stack. When opacity is zero, [child] is returned directly.
///
/// Size [child] to the desired overlay bounds at the call site — the stack
/// sizes to its non-positioned child and the fill overlay paints within that.
class M3EStateLayerOverlay extends StatelessWidget {
  const M3EStateLayerOverlay({
    required this.state,
    required this.color,
    required this.shape,
    required this.child,
    this.alignment = AlignmentDirectional.topStart,
    super.key,
  });

  /// The active interaction state driving the overlay opacity.
  final M3EInteractionState state;

  /// The role color painted as the overlay.
  final Color color;

  /// The border used to clip the overlay to the component shape.
  final ShapeBorder shape;

  /// Content rendered above the state layer.
  final Widget child;

  /// Positions [child] when the parent supplies tight width and height bounds.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    if (state.opacity == 0) {
      return child;
    }

    return IgnorePointer(
      child: AnimatedContainer(
        duration: M3EMotion.short3,
        curve: M3EMotion.standard,
        decoration: ShapeDecoration(
          shape: shape,
          color: color.withValues(alpha: state.opacity),
        ),
        child: child,
      ),
    );
  }
}
