import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Flips horizontally between [child] and [selectedChild] when [selected].
class M3ESelectionLeading extends StatelessWidget {
  /// Creates a selection leading flip.
  const M3ESelectionLeading({
    required this.selected,
    required this.child,
    required this.selectedChild,
    this.duration = const Duration(milliseconds: 220),
    this.onTap,
    super.key,
  });

  /// Whether the selected face is shown.
  final bool selected;

  /// Unselected leading widget.
  final Widget child;

  /// Selected leading widget.
  final Widget selectedChild;

  /// Flip duration.
  final Duration duration;

  /// Optional tap handler (always toggles selection when set by the list).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget face = AnimatedSwitcher(
      duration: duration,
      switchInCurve: const Cubic(0.2, 0, 0, 1),
      switchOutCurve: const Cubic(0.4, 0, 1, 1),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final Animation<double> turns = Tween<double>(
          begin: 0.5,
          end: 1,
        ).animate(animation);
        return AnimatedBuilder(
          animation: turns,
          child: child,
          builder: (BuildContext context, Widget? child) {
            final double angle = (1 - turns.value) * math.pi;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: child,
            );
          },
        );
      },
      child: KeyedSubtree(
        key: ValueKey<bool>(selected),
        child: selected ? selectedChild : child,
      ),
    );

    if (onTap == null) {
      return face;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: face,
    );
  }
}
