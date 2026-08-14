// Vendored from the `navigation_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e/lib).
// Delegates to [M3EBadge] for the shared badge implementation.

import 'package:flutter/widgets.dart';

import 'package:material_3_expressive/components/badges/m3e_badges.dart';

/// M3ENavBadge.

class M3ENavBadge extends StatelessWidget {
  /// M3ENavBadge.
  const M3ENavBadge({
    super.key,
    required this.child,
    this.count,
    this.showDot = false,
    this.maxCount = 99,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticLabel,
    this.offset = Offset.zero,
  }) : assert(
         count == null || count >= 0,
         'count must be null or non-negative',
       );

  /// child.

  final Widget child;

  /// count.
  final int? count;

  /// showDot.
  final bool showDot;

  /// maxCount.
  final int maxCount;

  /// backgroundColor.
  final Color? backgroundColor;

  /// foregroundColor.
  final Color? foregroundColor;

  /// semanticLabel.
  final String? semanticLabel;

  /// Nudge away from the icon's top-right corner.
  ///
  /// Defaults to none so a badge never shifts the icon inside its indicator.
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return M3EBadge(
      count: count,
      showDot: showDot,
      maxCount: maxCount,
      offset: offset,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      semanticLabel: semanticLabel,
      child: child,
    );
  }
}
