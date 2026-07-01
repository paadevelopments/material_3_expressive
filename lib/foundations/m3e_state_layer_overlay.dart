import 'package:flutter/widgets.dart';

import 'm3e_motion.dart';
import 'm3e_state_layer.dart';

/// Paints an animated Material state layer clipped to [shape].
///
/// Place this in a [Stack] above the container background and below the
/// content so hover/focus/press overlays read correctly.
class M3EStateLayerOverlay extends StatelessWidget {
  const M3EStateLayerOverlay({
    required this.state,
    required this.color,
    required this.shape,
    super.key,
  });

  /// The active interaction state driving the overlay opacity.
  final M3EInteractionState state;

  /// The role color painted as the overlay.
  final Color color;

  /// The border used to clip the overlay to the component shape.
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: M3EMotion.short3,
          curve: M3EMotion.standard,
          decoration: ShapeDecoration(
            shape: shape,
            color: color.withValues(alpha: state.opacity),
          ),
        ),
      ),
    );
  }
}
