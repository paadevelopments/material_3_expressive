import 'package:flutter/widgets.dart';

/// Scrim drawn over a carousel image and under its text.
class M3ECarouselScrim {
  /// Creates a scrim.
  const M3ECarouselScrim({required this.color, this.opacity = 1});

  /// Scrim color. [opacity] replaces the color's alpha.
  final Color color;

  /// How solid the scrim is, from 0 to 1.
  final double opacity;

  /// Color painted between the image and the text.
  Color get paintColor =>
      color.withValues(alpha: opacity.clamp(0, 1).toDouble());
}
