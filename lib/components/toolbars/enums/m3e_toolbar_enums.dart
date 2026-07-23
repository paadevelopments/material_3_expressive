// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// FloatingToolbar / FlexibleBottomAppBar variants

/// Whether the toolbar floats over content or docks to an edge.
enum M3EToolbarPlacement {
  floating,
  docked,
}

/// Standard vs vibrant container color mapping.
enum M3EToolbarColorStyle {
  /// Surface container + on-surface content.
  standard,

  /// Primary container toolbar (tertiary container FAB when present).
  vibrant,
}

/// Edge used by a docked toolbar for placement and safe-area padding.
enum M3EToolbarDockEdge {
  top,
  bottom,
}

/// Position of an adjacent FAB relative to a floating toolbar.
enum M3EToolbarFabPosition {
  start,
  end,
  top,
  bottom,
}

/// Horizontal alignment of a compact floating toolbar within its parent.
enum M3EToolbarAlignment {
  start,
  center,
  end,
}

/// Legacy size enum — maps to icon-button density, not container height.
enum M3EToolbarSize {
  small,
  medium,
  large,
}

/// Legacy density enum.
enum M3EToolbarDensity {
  regular,
  compact,
}

/// Legacy shape family — floating forces pill; docked forces square.
enum M3EToolbarShapeFamily {
  round,
  square,
}

/// Legacy color emphasis — prefer [M3EToolbarColorStyle].
enum M3EToolbarVariant {
  surface,
  tonal,
  primary,
}
