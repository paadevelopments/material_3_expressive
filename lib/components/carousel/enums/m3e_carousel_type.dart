/// Defines the visual presentation and layout style of an `M3ECarousel`.
enum M3ECarouselType {
  /// A large, prominent carousel that spotlights one big item with small
  /// peeking neighbours. Shows 2 - 3 visible items depending on
  /// [M3ECarouselHeroAlignment].
  hero,

  /// A standard carousel where items stay visually contained within the
  /// content area. Shows 3 - 4 visible items depending on whether the layout
  /// is extended.
  contained,

  /// A carousel whose items scroll to the edge of the container, all sharing a
  /// uniform extent.
  uncontained,
}

/// The horizontal alignment of the focal item in a [M3ECarouselType.hero]
/// carousel.
enum M3ECarouselHeroAlignment {
  /// The focal item is aligned to the leading edge, with one small peek after.
  left,

  /// The focal item is centered, with a small peek on either side.
  center,

  /// The focal item is aligned to the trailing edge, with one small peek
  /// before.
  right,
}
