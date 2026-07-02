// Vendored from the `navigation_rail_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_rail_m3e/lib).
// The logic is kept identical to the reference `NavigationRailTokensAdapter`;
// theme tokens are read from this package's own `M3ETheme` (with safe fallbacks
// to the ambient Material theme) instead of the external `m3e_design` package.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';

/// Provides colors & shapes from the expressive `M3ETheme` with safe fallbacks
/// to `Theme.of(context)`.
class M3ENavigationRailTokensAdapter {
  /// Creates a [M3ENavigationRailTokensAdapter].
  const M3ENavigationRailTokensAdapter(this.context);

  /// Source context for resolving Theme and m3e tokens.
  final BuildContext context;

  ColorScheme get _cs => Theme.of(context).colorScheme;

  M3EColorScheme get _m3e => M3ETheme.of(context).colorScheme;

  // Colors per spec
  /// Background color of the rail container.
  Color get containerColor {
    // Use surface container token if present, else fallback.
    return _maybe(() => _m3e.surface) ?? _cs.surface;
  }

  /// Background color of the active item indicator.
  Color get activeIndicatorColor {
    return _maybe(() => _m3e.secondaryContainer) ?? _cs.secondaryContainer;
  }

  /// Color for the icon and label when the item is active.
  Color get activeIconAndLabel {
    return _maybe(() => _m3e.secondary) ?? _cs.secondary;
  }

  /// Color for the icon and label when the item is inactive.
  Color get inactiveIconAndLabel {
    return _maybe(() => _m3e.onSurfaceVariant) ?? _cs.onSurfaceVariant;
  }

  /// Foreground color used for the menu (top) slot.
  Color get menuColor {
    return _maybe(() => _m3e.onSecondaryContainer) ?? _cs.onSecondaryContainer;
  }

  Color get badgeBackground => _maybe(() => _m3e.primary) ?? _cs.primary;
  Color get badgeLargeLabel => _maybe(() => _m3e.onPrimary) ?? _cs.onPrimary;

  ShapeBorder get indicatorShapeFull {
    // Full corner per M3E: use the most rounded token, fallback to StadiumBorder.
    final br = _maybe(() => M3EShapes.roundSet.xs);
    if (br != null) return RoundedRectangleBorder(borderRadius: br);
    return const StadiumBorder();
  }

  T? _maybe<T>(T Function() pick) {
    try {
      return pick();
    } catch (_) {
      return null;
    }
  }
}
