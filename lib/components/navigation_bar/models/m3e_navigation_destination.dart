import 'package:flutter/widgets.dart';

/// A destination shown in a navigation bar, rail or drawer.
@immutable
class M3ENavigationDestination {
  const M3ENavigationDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
    this.badgeLabel,
    this.showBadge = false,
  });

  /// Icon shown when the destination is not selected.
  final Widget icon;

  /// Optional icon shown when the destination is selected.
  final Widget? selectedIcon;

  final String label;

  /// Optional text for a numeric badge on the icon.
  final String? badgeLabel;

  /// Whether to show a small dot badge on the icon.
  final bool showBadge;
}
