import 'package:flutter/widgets.dart';

import 'm3e_motion.dart';
import 'm3e_state_layer.dart';

/// Paints an animated Material state layer clipped to [shape] behind [child].
///
/// Owns the internal [Stack] and sizing rules so callers do not need an outer
/// stack. When [state.opacity] is zero, [child] is returned directly.
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

    // return LayoutBuilder(
    //   builder: (BuildContext context, BoxConstraints constraints) {
    //     final laidOutChild = _layoutChild(constraints);
    //     return Stack(
    //       alignment: alignment,
    //       children: <Widget>[
    //         Positioned.fill(
    //           child: ,
    //         ),
    //         laidOutChild,
    //       ],
    //     );
    //   },
    // );
  }

  Widget _layoutChild(BoxConstraints constraints) {
    final bool tight =
        constraints.hasBoundedWidth && constraints.hasBoundedHeight;
    final bool wide =
        constraints.hasBoundedWidth && !constraints.hasBoundedHeight;

    if (tight) {
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Align(alignment: alignment, child: child),
      );
    }
    if (wide) {
      return SizedBox(width: constraints.maxWidth, child: child);
    }
    return child;
  }
}
