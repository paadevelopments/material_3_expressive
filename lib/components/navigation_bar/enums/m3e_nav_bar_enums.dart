// Vendored from the `navigation_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e/lib).
// The logic is kept identical to the reference implementation; only the public
// identifiers carry the `M3E` prefix to match this package's conventions.

/// Controls when destination labels are shown in the navigation bar.
enum M3ENavBarLabelBehavior {
  /// Always show destination labels.
  alwaysShow,

  /// Show the label only on the selected destination.
  onlySelected,

  /// Never show destination labels.
  alwaysHide,
}

/// The overall height variant of the navigation bar.
enum M3ENavBarSize {
  /// Compact navigation bar height.
  small,

  /// Standard navigation bar height.
  medium,
}

/// The container shape family of the navigation bar.
enum M3ENavBarShapeFamily {
  /// Rounded container corners.
  round,

  /// Square container corners.
  square,
}

/// Density adjustment for the navigation bar metrics.
enum M3ENavBarDensity {
  /// Default spacing and sizing.
  regular,

  /// Tighter spacing and sizing.
  compact,
}

/// The visual style of the selection indicator.
enum M3ENavBarIndicatorStyle {
  /// Pill-shaped selection indicator.
  pill,

  /// Underline selection indicator.
  underline,

  /// No selection indicator.
  none,
}
