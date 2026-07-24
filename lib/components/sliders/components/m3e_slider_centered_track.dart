// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// SliderDefaults.CenteredTrack

import 'package:flutter/widgets.dart';

import '../enums/m3e_slider_enums.dart';
import '../styles/m3e_slider_theme.dart';
import 'm3e_slider_track.dart';

/// Centered active-track variant — active fill grows from the midpoint.
class M3ESliderCenteredTrack extends StatelessWidget {
  const M3ESliderCenteredTrack({
    required this.fraction,
    required this.tickFractions,
    required this.colors,
    required this.theme,
    required this.axis,
    required this.textDirection,
    required this.handleThickness,
    this.drawStops = true,
    this.isWavy = false,
    this.waveAmplitude = 0,
    this.wavelength = 40,
    this.phase = 0,
    this.amplitudeFactor = 1,
    super.key,
  });

  final double fraction;
  final List<double> tickFractions;
  final M3ESliderColors colors;
  final M3ESliderTheme theme;
  final Axis axis;
  final TextDirection textDirection;
  final double handleThickness;
  final bool drawStops;
  final bool isWavy;
  final double waveAmplitude;
  final double wavelength;
  final double phase;
  final double amplitudeFactor;

  @override
  Widget build(BuildContext context) {
    return M3ESliderTrack(
      fraction: fraction,
      tickFractions: tickFractions,
      colors: colors,
      theme: theme,
      axis: axis,
      textDirection: textDirection,
      handleThickness: handleThickness,
      trackKind: M3ESliderTrackKind.centered,
      drawStops: drawStops,
      isWavy: isWavy,
      waveAmplitude: waveAmplitude,
      wavelength: wavelength,
      phase: phase,
      amplitudeFactor: amplitudeFactor,
    );
  }
}
