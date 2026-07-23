// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// Slider.kt track variants (Track / CenteredTrack)

/// Which track geometry an [M3ESlider] paints.
enum M3ESliderTrackKind {
  /// Active track from the start edge to the thumb.
  standard,

  /// Active track grows from the midpoint toward the thumb.
  centered,
}
