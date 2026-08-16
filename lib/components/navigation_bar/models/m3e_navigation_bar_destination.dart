// Vendored from the `navigation_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e/lib).
// The logic is kept identical to the reference `NavigationDestinationM3E`; only
// the public class name carries the `M3E` prefix.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
import 'package:material_ui/material_ui.dart';

import '../components/m3e_nav_badge_view.dart';

/// M3ENavigationBarDestination.

class M3ENavigationBarDestination {
  /// M3ENavigationBarDestination.
  const M3ENavigationBarDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.badgeCount,
    this.badgeDot = false,
    this.semanticLabel,
  });

  /// icon.

  final Widget icon;

  /// selectedIcon.
  final Widget? selectedIcon;

  /// label.
  final String label;

  /// Optional badgeValue counter
  final int? badgeCount;

  /// If true, show a small dot instead of a counter.
  final bool badgeDot;

  /// semanticLabel.

  final String? semanticLabel;

  /// buildIcon.

  Widget buildIcon({bool selected = false}) {
    final base = selected && selectedIcon != null ? selectedIcon! : icon;
    if (badgeCount != null || badgeDot) {
      return M3ENavBadge(
        count: badgeCount,
        showDot: badgeDot,
        semanticLabel: semanticLabel,
        child: base,
      );
    }
    return base;
  }
}
