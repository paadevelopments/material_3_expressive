// Vendored from the `navigation_rail_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_rail_m3e/lib).
// The logic is kept identical to the reference `NavigationRailM3EMenu`; only the
// public class name carries the `M3E` prefix.

import 'package:flutter/material.dart';

/// Menu slot at the top of the rail (non-selectable). One class per file.
class M3ENavigationRailMenu extends StatelessWidget {
  /// Creates a [M3ENavigationRailMenu].
  const M3ENavigationRailMenu({super.key, required this.child});

  /// Content widget placed in the menu slot.
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
