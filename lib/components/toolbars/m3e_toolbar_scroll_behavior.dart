import 'package:flutter/widgets.dart';

import 'controllers/m3e_toolbar_visibility_controller.dart';
import 'enums/m3e_toolbar_enums.dart';

/// Integrates scroll notifications with a [M3EToolbarVisibilityController].
class M3EToolbarScrollBehavior {
  /// M3EToolbarScrollBehavior.
  const M3EToolbarScrollBehavior({
    required this.exitDirection,
    required this.controller,
  });

  /// Creates a behavior that exits while scrolling (opt-in).
  factory M3EToolbarScrollBehavior.exitAlways({
    M3EToolbarExitDirection exitDirection = M3EToolbarExitDirection.bottom,
    M3EToolbarVisibilityController? controller,
  }) {
    return M3EToolbarScrollBehavior(
      exitDirection: exitDirection,
      controller: controller ?? M3EToolbarVisibilityController(),
    );
  }

  /// Direction the toolbar slides when hiding.
  final M3EToolbarExitDirection exitDirection;

  /// Shared visibility state (manual
  /// [M3EToolbarVisibilityController.show] /
  /// [M3EToolbarVisibilityController.hide] or scroll-driven).
  final M3EToolbarVisibilityController controller;
}

/// Listens to [ScrollNotification]s on [child] and updates [behavior].
///
/// Place this around the scrollable content, not around the toolbar itself.
/// The toolbar reads the same [M3EToolbarScrollBehavior.controller].
class M3EToolbarScrollWrapper extends StatefulWidget {
  /// M3EToolbarScrollWrapper.
  const M3EToolbarScrollWrapper({
    required this.behavior,
    required this.child,
    super.key,
  });

  /// behavior.
  final M3EToolbarScrollBehavior behavior;

  /// child.
  final Widget child;

  @override
  State<M3EToolbarScrollWrapper> createState() =>
      _M3EToolbarScrollWrapperState();
}

class _M3EToolbarScrollWrapperState extends State<M3EToolbarScrollWrapper> {
  void _updateOffset(double delta) {
    widget.behavior.controller
      ..contentOffset += delta
      ..offset -= delta;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      widget.behavior.controller.cancelAnimation();
    } else if (notification is ScrollUpdateNotification) {
      _handleScrollUpdate(notification);
    } else if (notification is ScrollEndNotification) {
      // Non-drag scroll input (mouse wheel, discrete trackpad ticks) fires its
      // own start/update/end per tick with no drag details. Settling on those
      // snaps the bar back before the next tick continues it, reading as a
      // reversal while scrolling slowly. Only settle on a real drag release.
      final DragEndDetails? drag = notification.dragDetails;
      if (drag != null) {
        widget.behavior.controller.settle(velocity: drag.primaryVelocity ?? 0);
      }
    }
    return false;
  }

  void _handleScrollUpdate(ScrollUpdateNotification notification) {
    if (widget.behavior.controller.isAnimating) {
      return;
    }
    final double delta = notification.scrollDelta ?? 0;
    if (delta != 0) {
      _updateOffset(delta);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: widget.child,
    );
  }
}
