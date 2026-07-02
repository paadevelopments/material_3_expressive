// Vendored from the `navigation_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e/lib).
// The logic is kept identical to the reference implementation; only the public
// identifiers carry the `M3E` prefix to match this package's conventions.

/// Controls when destination labels are shown in the navigation bar.
enum M3ENavBarLabelBehavior { alwaysShow, onlySelected, alwaysHide }

/// The overall height variant of the navigation bar.
enum M3ENavBarSize { small, medium }

/// The container shape family of the navigation bar.
enum M3ENavBarShapeFamily { round, square }

/// Density adjustment for the navigation bar metrics.
enum M3ENavBarDensity { regular, compact }

/// The visual style of the selection indicator.
enum M3ENavBarIndicatorStyle { pill, underline, none }
