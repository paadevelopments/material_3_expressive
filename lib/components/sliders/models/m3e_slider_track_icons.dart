// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// Optional track inset icons (SliderWithTrackIconsSample pattern)

import 'package:flutter/widgets.dart';

/// Optional icons inset into the active / inactive track segments.
@immutable
class M3ESliderTrackIcons {
  const M3ESliderTrackIcons({
    this.activeStart,
    this.activeEnd,
    this.inactiveStart,
    this.inactiveEnd,
    this.size = 16,
  });

  final Widget? activeStart;
  final Widget? activeEnd;
  final Widget? inactiveStart;
  final Widget? inactiveEnd;
  final double size;

  bool get hasAny =>
      activeStart != null ||
      activeEnd != null ||
      inactiveStart != null ||
      inactiveEnd != null;
}
