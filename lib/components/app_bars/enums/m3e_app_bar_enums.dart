/// The top app bar layouts. Mirrors `AppBarM3EVariant`.
///
/// The variant only influences the scrolling `M3ESliverAppBar`; the fixed
/// `M3ETopAppBar` always renders the collapsed, single-line layout.
enum M3EAppBarVariant {
  /// A single-line bar with no expanded title.
  small,

  /// A two-line bar whose title expands beneath the action row.
  medium,

  /// A taller two-line bar with a larger expanded title.
  large,
}

/// The corner shape family for an app bar container. Mirrors
/// `AppBarM3EShapeFamily`.
enum M3EAppBarShapeFamily {
  /// Rounded container corners.
  round,

  /// Squared container corners.
  square,
}

/// The vertical density of an app bar. Mirrors `AppBarM3EDensity`.
enum M3EAppBarDensity {
  /// Standard M3 heights.
  regular,

  /// Heights reduced by 8dp.
  compact,
}
