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
