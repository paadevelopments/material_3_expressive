// Vendored from the `navigation_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e/lib).
// Delegates to [M3EBadge] for the shared badge implementation.
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';

import 'package:material_3_expressive/components/badges/m3e_badges.dart';

class M3ENavBadge extends StatelessWidget {
  const M3ENavBadge({
    super.key,
    required this.child,
    this.count,
    this.showDot = false,
    this.maxCount = 99,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticLabel,
    this.offset = const Offset(8, -6),
  }) : assert(count == null || count >= 0);

  final Widget child;
  final int? count;
  final bool showDot;
  final int maxCount;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? semanticLabel;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return M3EBadge(
      child: child,
      count: count,
      showDot: showDot,
      maxCount: maxCount,
      offset: offset,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      semanticLabel: semanticLabel,
    );
  }
}
