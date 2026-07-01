/// The five expressive button sizes.
///
/// Sizes scale the container height, padding, icon size and label type from a
/// compact 32dp control up to a 136dp hero button.
enum M3EButtonSize {
  extraSmall,
  small,
  medium,
  large,
  extraLarge,
}

/// The two selectable button shapes.
///
/// Expressive buttons morph between these on press to give tactile feedback.
enum M3EButtonShape {
  /// Fully rounded (stadium) corners.
  round,

  /// Squared corners using the size specific radius.
  square,
}
