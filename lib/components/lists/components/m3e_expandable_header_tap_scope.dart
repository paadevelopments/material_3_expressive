import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Provides an optional expandable header content tap.
///
/// Prefer card / header-level expand press when possible. This scope remains
/// for custom headers that wrap only title/subtitle in
/// [M3EExpandableHeaderTapTarget].
class M3EExpandableHeaderTapScope extends InheritedWidget {
  /// Creates a header tap scope.
  const M3EExpandableHeaderTapScope({
    required this.onTap,
    required super.child,
    super.key,
  });

  /// Tap handler for header text content (not leading / trailing chrome).
  final VoidCallback? onTap;

  /// Nearest scope, if any.
  static M3EExpandableHeaderTapScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<M3EExpandableHeaderTapScope>();
  }

  @override
  bool updateShouldNotify(M3EExpandableHeaderTapScope oldWidget) =>
      onTap != oldWidget.onTap;
}

/// Wraps header text so it receives [M3EExpandableHeaderTapScope.onTap].
class M3EExpandableHeaderTapTarget extends StatelessWidget {
  /// Creates a header content tap target.
  const M3EExpandableHeaderTapTarget({required this.child, super.key});

  /// Title / subtitle (or custom) content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? onTap = M3EExpandableHeaderTapScope.maybeOf(context)
        ?.onTap;
    if (onTap == null) {
      return child;
    }
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          M3EFocusInteraction.instance.notePointerInteraction();
          onTap();
        },
        child: child,
      ),
    );
  }
}
