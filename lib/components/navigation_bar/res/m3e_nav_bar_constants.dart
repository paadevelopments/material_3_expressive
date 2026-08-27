/// Layout constants for the M3E navigation bar.
abstract final class M3ENavBarConstants {
  const M3ENavBarConstants._();

  /// Default fixed width of each destination chip in wide layout.
  static const double wideDestinationWidth = 128;

  /// Gap between wide destination chips.
  static const double wideDestinationGap = 8;

  /// Horizontal inset of the wide destination group from the bar edges.
  static const double wideBarHorizontalPadding = 16;

  /// Typical Material max destination count used for the documented default
  /// [wideBreakpoint].
  static const int wideBreakpointDestinationCount = 5;

  /// Default autoLayout threshold sized for
  /// [wideBreakpointDestinationCount] chips at [wideDestinationWidth].
  /// Prefer [minWideBarWidth] or a custom `wideBreakpoint` on the bar when
  /// the destination count differs.
  static const double wideBreakpoint =
      wideBreakpointDestinationCount * wideDestinationWidth +
      (wideBreakpointDestinationCount - 1) * wideDestinationGap +
      2 * wideBarHorizontalPadding;

  /// Minimum bar width needed to fit [destinationCount] fixed-width wide chips.
  static double minWideBarWidth(
    int destinationCount, {
    double itemWidth = wideDestinationWidth,
  }) {
    assert(destinationCount > 0, 'destinationCount must be > 0');
    return destinationCount * itemWidth +
        (destinationCount - 1) * wideDestinationGap +
        2 * wideBarHorizontalPadding;
  }

  /// Compact resting pill width (icon chip).
  static const double compactIndicatorWidth = 64;

  /// Compact resting / fluid pill height.
  static const double indicatorHeight = 32;

  /// Subtracted from the bar content height (excludes system nav inset) for
  /// the wide active pill height.
  static const double wideIndicatorHeightReduction = 32;

  /// Gap between icon and label inside a wide destination chip.
  static const double wideIconLabelGap = 8;

  /// Horizontal padding inside a wide destination pill around its content.
  /// Effective pad is at least stadium radius ([indicatorHeight]/2) plus
  /// [widePillCapClearance] so icons clear the curved ends.
  static const double widePillHorizontalPadding = 16;

  /// Extra inset past the stadium radius inside a wide pill.
  static const double widePillCapClearance = 4;

  /// Remeasure window after geometry-affecting layoutToken changes (behaviors,
  /// alignment, compact↔wide) so the fluid pill tracks settling chip sizes.
  static const Duration layoutSettleDuration = Duration(milliseconds: 160);
}
