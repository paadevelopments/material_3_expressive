import 'package:flutter/widgets.dart';

/// Supplies ink interaction callbacks from the tappable primitive to overlays.
class M3ETappableInkScope extends InheritedWidget {
  const M3ETappableInkScope({
    required super.child,
    this.onTap,
    this.onLongPress,
    this.mouseCursor,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onHover,
    super.key,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final MouseCursor? mouseCursor;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final VoidCallback? onTapCancel;
  final ValueChanged<bool>? onHover;

  static M3ETappableInkScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<M3ETappableInkScope>();
  }

  bool get isInteractive => onTap != null || onLongPress != null;

  @override
  bool updateShouldNotify(M3ETappableInkScope oldWidget) {
    return onTap != oldWidget.onTap ||
        onLongPress != oldWidget.onLongPress ||
        mouseCursor != oldWidget.mouseCursor ||
        onTapDown != oldWidget.onTapDown ||
        onTapUp != oldWidget.onTapUp ||
        onTapCancel != oldWidget.onTapCancel ||
        onHover != oldWidget.onHover;
  }
}
