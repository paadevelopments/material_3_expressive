// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// Slider.kt track variants (Track / CenteredTrack)

import 'package:material_3_expressive/components/sliders/m3e_sliders.dart'
    show M3ESlider;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3ESlider;

/// Which track geometry an [M3ESlider] paints.
enum M3ESliderTrackKind {
  /// Active track from the start edge to the thumb.
  standard,

  /// Active track grows from the midpoint toward the thumb.
  centered,
}

/// How the track interprets active fill extents.
enum M3ESliderPaintMode {
  /// Single thumb; active from start → thumb (or centered).
  single,

  /// Dual thumbs; active between start and end.
  range,
}
