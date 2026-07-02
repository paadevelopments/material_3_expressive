// Vendored from the `navigation_rail_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_rail_m3e/lib).
// The logic is kept identical to the reference `NavigationRailM3EFabSlot`; the
// external `fab_m3e` configuration types are mapped onto this package's own
// `M3EFab`/`M3EExtendedFab` API ([M3EFabColor], [M3EFabSize]).

import 'package:flutter/material.dart';

import '../../floating_action_buttons/enums/m3e_fab.dart';

/// Configuration for the rail's built-in FAB.
///
/// The rail renders:
/// - a `M3EFab` when collapsed
/// - an `M3EExtendedFab` when expanded
///
/// Consumers provide values (icon, label, onPressed, etc.) instead of a widget.
@immutable
class M3ENavigationRailFabSlot {
  /// Creates a [M3ENavigationRailFabSlot].
  const M3ENavigationRailFabSlot({
    required this.icon,
    required this.label,
    this.onPressed,
    this.tooltip,
    this.color = M3EFabColor.primary,
    this.size = M3EFabSize.medium,
    this.semanticLabel,
  });

  /// Icon widget shown inside the FAB (collapsed) and leading icon (expanded).
  final Widget icon;

  /// Text label for the extended FAB (expanded rail variant).
  final String label;

  /// Tap callback for the FAB.
  final VoidCallback? onPressed;

  /// Tooltip text for hover/long-press.
  final String? tooltip;

  /// Visual color role (primary, secondary, tertiary, surface).
  final M3EFabColor color;

  /// Size of the FAB button.
  final M3EFabSize size;

  /// Optional semantic label for accessibility.
  final String? semanticLabel;
}
