// Vendored from the `navigation_rail_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_rail_m3e/lib).
// The logic is kept identical to the reference `RailItem`; only the public
// identifiers carry the `M3E` prefix.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';

import '../enums/m3e_navigation_rail_enums.dart';
import '../models/m3e_navigation_rail_destination.dart';
import '../styles/m3e_nav_rail_theme.dart';
import 'm3e_rail_item_button.dart';

/// Single rail item (private to package). One class per file.
class M3ERailItem extends StatelessWidget {
  /// Creates a single navigation rail item.
  const M3ERailItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.onTap,
    required this.expanded,
    required this.labelBehavior,
    this.suppressInk = false,
  });

  /// Destination data driving this item.
  final M3ENavigationRailDestination destination;

  /// Whether this item is currently selected.
  final bool selected;

  /// Called when the item is tapped.
  final VoidCallback onTap;

  /// Whether the rail is expanded (shows label and badges inline).
  final bool expanded;

  /// Whether this item's label should be visible.
  final M3ENavigationRailLabelBehavior labelBehavior;

  /// When true, disables splash/hover/highlight effects to prevent flicker during transitions.
  final bool suppressInk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<M3ENavigationRailTheme>() ??
        const M3ENavigationRailTheme();
    final height =
        expanded ? theme.itemExpandedHeight : theme.itemCollapsedHeight;

    final Widget button = M3ERailItemButton(
      icon: destination.icon,
      selectedIcon: destination.selectedIcon,
      isSelected: selected,
      onPressed: onTap,
      expanded: expanded,
      labelBehavior: labelBehavior,
      label: destination.label,
      semanticLabel: destination.semanticLabel,
      suppressInk: suppressInk,
      badgeCount: destination.badgeCount,
    );

    Widget core;
    if (!expanded) {
      // Collapsed: left-aligned icon-only button with 48x48 tap target.
      core = SizedBox(
        height: height,
        child: Align(alignment: Alignment.centerLeft, child: button),
      );
    } else {
      core = ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Row(
          children: [
            Expanded(child: button),
          ],
        ),
      );
    }

    return Semantics(
      selected: selected,
      button: true,
      child: core,
    );
  }
}
