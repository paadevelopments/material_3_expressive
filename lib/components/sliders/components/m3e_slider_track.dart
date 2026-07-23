// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// SliderDefaults.Track wrapper

import 'package:flutter/widgets.dart';

import '../enums/m3e_slider_enums.dart';
import '../styles/m3e_slider_theme.dart';
import 'm3e_slider_track_painter.dart';

/// Default expressive track for a single-value [M3ESlider].
class M3ESliderTrack extends StatelessWidget {
  const M3ESliderTrack({
    required this.fraction,
    required this.tickFractions,
    required this.colors,
    required this.theme,
    required this.axis,
    required this.textDirection,
    required this.handleThickness,
    this.trackKind = M3ESliderTrackKind.standard,
    this.drawStops = true,
    super.key,
  });

  final double fraction;
  final List<double> tickFractions;
  final M3ESliderColors colors;
  final M3ESliderTheme theme;
  final Axis axis;
  final TextDirection textDirection;
  final double handleThickness;
  final M3ESliderTrackKind trackKind;
  final bool drawStops;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: M3ESliderTrackPainter(
        mode: M3ESliderPaintMode.single,
        trackKind: trackKind,
        activeStartFraction: 0,
        activeEndFraction: fraction,
        tickFractions: tickFractions,
        colors: colors,
        trackHeight: theme.trackHeight,
        handleGap: theme.handleGap,
        handleThickness: handleThickness,
        insideCornerSize: theme.trackInsideCornerSize,
        stopIndicatorSize: theme.stopIndicatorSize,
        tickSize: theme.tickSize,
        axis: axis,
        textDirection: textDirection,
        drawStops: drawStops,
      ),
      child: const SizedBox.expand(),
    );
  }
}
