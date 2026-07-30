import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

import 'controllers/m3e_toolbar_visibility_controller.dart';
import 'enums/m3e_toolbar_enums.dart';
import 'utils/m3e_toolbar_spring_motion.dart';

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

class _M3EToolbarScrollWrapperState extends State<M3EToolbarScrollWrapper>
    with TickerProviderStateMixin {
  SingleMotionController? _settle;

  @override
  void dispose() {
    _settle?.dispose();
    super.dispose();
  }

  void _updateOffset(double delta) {
    widget.behavior.controller
      ..contentOffset += delta
      ..offset -= delta;
  }

  void _settleTo(double velocity) {
    _settle?.dispose();
    _settle = null;

    final M3EToolbarVisibilityController controller =
        widget.behavior.controller;
    if (controller.offset == 0 || controller.offset == controller.offsetLimit) {
      return;
    }

    final double target;
    if (velocity.abs() > 150) {
      target = velocity > 0 ? controller.offsetLimit : 0;
    } else {
      target = controller.collapsedFraction < 0.5 ? 0 : controller.offsetLimit;
    }

    _settle =
        SingleMotionController(
            motion: controller.motion.toMotion(),
            vsync: this,
            initialValue: controller.offset,
          )
          ..addListener(() {
            if (mounted) {
              controller.offset = _settle!.value;
            }
          })
          ..animateTo(target);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      _settle?.dispose();
      _settle = null;
      widget.behavior.controller.cancelAnimation();
    } else if (notification is ScrollUpdateNotification) {
      _handleScrollUpdate(notification);
    } else if (notification is ScrollEndNotification) {
      final double velocity = notification.dragDetails?.primaryVelocity ?? 0;
      _settleTo(velocity);
    }
    return false;
  }

  void _handleScrollUpdate(ScrollUpdateNotification notification) {
    if (_settle != null) {
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
