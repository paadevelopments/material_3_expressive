// Vendored from the `navigation_rail_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_rail_m3e/lib).
// The logic is kept identical to the reference `NavigationRailM3ESection`; only
// the public class name carries the `M3E` prefix.

import 'package:flutter/material.dart';

import 'm3e_navigation_rail_destination.dart';

/// Section groups a header and a list of destinations. One class per file.
class M3ENavigationRailSection {
  /// Creates a [M3ENavigationRailSection].
  const M3ENavigationRailSection({
    required this.destinations,
    this.header,
  });

  /// Destinations shown in this section.
  final List<M3ENavigationRailDestination> destinations;

  /// Optional header widget displayed above the destinations.
  final Widget? header;
}
