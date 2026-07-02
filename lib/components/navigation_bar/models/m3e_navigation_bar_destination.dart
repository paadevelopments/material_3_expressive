// Vendored from the `navigation_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e/lib).
// The logic is kept identical to the reference `NavigationDestinationM3E`; only
// the public class name carries the `M3E` prefix.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: avoid_positional_boolean_parameters, sort_child_properties_last

import 'package:flutter/material.dart';

import '../components/m3e_nav_badge_view.dart';

class M3ENavigationBarDestination {
  const M3ENavigationBarDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.badgeCount,
    this.badgeDot = false,
    this.semanticLabel,
  });

  final Widget icon;
  final Widget? selectedIcon;
  final String label;

  /// Optional badgeValue counter
  final int? badgeCount;

  /// If true, show a small dot instead of a counter.
  final bool badgeDot;

  final String? semanticLabel;

  Widget buildIcon([bool selected = false]) {
    final base = selected && selectedIcon != null ? selectedIcon! : icon;
    if (badgeCount != null || badgeDot) {
      return M3ENavBadge(
        child: base,
        count: badgeCount,
        showDot: badgeDot,
        semanticLabel: semanticLabel,
      );
    }
    return base;
  }
}
