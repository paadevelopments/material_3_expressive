// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// RangeSlider Track

import 'package:flutter/widgets.dart';

import '../enums/m3e_slider_enums.dart';
import '../styles/m3e_slider_theme.dart';
import 'm3e_slider_track_painter.dart';

/// Default expressive track for [M3ERangeSlider].
class M3ERangeSliderTrack extends StatelessWidget {
  const M3ERangeSliderTrack({
    required this.startFraction,
    required this.endFraction,
    required this.tickFractions,
    required this.colors,
    required this.theme,
    required this.axis,
    required this.textDirection,
    required this.handleThickness,
    this.trackHeight,
    this.drawDots = true,
    this.isWavy = false,
    this.waveAmplitude = 0,
    this.wavelength = 40,
    this.phase = 0,
    this.amplitudeFactor = 1,
    super.key,
  });

  final double startFraction;
  final double endFraction;
  final List<double> tickFractions;
  final M3ESliderColors colors;
  final M3ESliderTheme theme;
  final Axis axis;
  final TextDirection textDirection;
  final double handleThickness;
  final double? trackHeight;
  final bool drawDots;
  final bool isWavy;
  final double waveAmplitude;
  final double wavelength;
  final double phase;
  final double amplitudeFactor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: M3ESliderTrackPainter(
        mode: M3ESliderPaintMode.range,
        trackKind: M3ESliderTrackKind.standard,
        activeStartFraction: startFraction,
        activeEndFraction: endFraction,
        tickFractions: tickFractions,
        colors: colors,
        trackHeight: trackHeight ?? theme.trackHeight,
        handleGap: theme.handleGap,
        handleThickness: handleThickness,
        insideCornerSize: theme.trackInsideCornerSize,
        stopIndicatorSize: theme.stopIndicatorSize,
        tickSize: theme.tickSize,
        axis: axis,
        textDirection: textDirection,
        drawDots: drawDots,
        isWavy: isWavy,
        waveAmplitude: waveAmplitude,
        wavelength: wavelength,
        phase: phase,
        amplitudeFactor: amplitudeFactor,
      ),
      child: const SizedBox.expand(),
    );
  }
}
