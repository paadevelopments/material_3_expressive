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
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      _handleScrollUpdate(notification);
    }
    return false;
  }

  /// Springs fully open/closed the instant a scroll delta changes direction,
  /// at any scroll position and at any drag speed.
  /// [M3EToolbarVisibilityController.show] / [M3EToolbarVisibilityController.hide]
  /// are no-ops when already at or heading to that target, so repeated deltas
  /// in the same direction don't restart the spring.
  void _handleScrollUpdate(ScrollUpdateNotification notification) {
    final double? delta = notification.scrollDelta;
    if (delta == null || delta == 0) {
      return;
    }
    if (delta > 0) {
      widget.behavior.controller.hide();
    } else {
      widget.behavior.controller.show();
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
