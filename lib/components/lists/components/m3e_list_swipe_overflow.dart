import 'package:flutter/widgets.dart';

/// Asks a dismissible row to reveal its swipe actions without a drag.
class M3EListSwipeOverflow extends InheritedWidget {
  /// Creates a swipe-overflow scope.
  const M3EListSwipeOverflow({
    required this.onReveal,
    required super.child,
    super.key,
  });

  /// Opens the action preview.
  final VoidCallback onReveal;

  /// Nearest scope, or null when the row has no swipe actions.
  static M3EListSwipeOverflow? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<M3EListSwipeOverflow>();
  }

  @override
  bool updateShouldNotify(M3EListSwipeOverflow oldWidget) {
    return onReveal != oldWidget.onReveal;
  }
}
