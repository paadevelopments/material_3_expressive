import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../enums/m3e_slider_enums.dart';
import '../styles/m3e_slider_theme.dart';
import '../utils/m3e_slider_math.dart';

/// One stop/tick marker along the slider track.
@immutable
class M3ESliderDotPlacement {
  const M3ESliderDotPlacement({
    required this.primary,
    required this.color,
    required this.size,
    required this.active,
  });

  /// Position along the primary track axis (x for horizontal, y for vertical).
  final double primary;
  final Color color;
  final double size;
  final bool active;
}

/// Shared stop/tick placement for canvas paint and custom [dotBuilder] overlays.
abstract final class M3ESliderDotLayout {
  const M3ESliderDotLayout._();

  static List<M3ESliderDotPlacement> resolve({
    required Size size,
    required M3ESliderPaintMode mode,
    required M3ESliderTrackKind trackKind,
    required double activeStartFraction,
    required double activeEndFraction,
    required List<double> tickFractions,
    required M3ESliderColors colors,
    required double trackHeight,
    required double handleGap,
    required double handleThickness,
    required double stopIndicatorSize,
    required double tickSize,
    required double edgeInset,
    required Axis axis,
    required TextDirection textDirection,
  }) {
    final bool vertical = axis == Axis.vertical;
    final bool centered = mode == M3ESliderPaintMode.single &&
        trackKind == M3ESliderTrackKind.centered;
    final bool range = mode == M3ESliderPaintMode.range;

    final Rect trackBounds = _trackBounds(size, trackHeight, vertical);
    final double sliderStart = vertical ? trackBounds.top : trackBounds.left;
    final double sliderEnd =
        vertical ? trackBounds.bottom : trackBounds.right;
    final double span = sliderEnd - sliderStart;
    if (span <= 0) {
      return const <M3ESliderDotPlacement>[];
    }

    final double startGap =
        (centered || range) ? handleThickness / 2 + handleGap : 0;
    final double endGap = handleThickness / 2 + handleGap;

    final double valueStart =
        sliderStart + span * activeStartFraction.clamp(0.0, 1.0);
    final double valueEnd =
        sliderStart + span * activeEndFraction.clamp(0.0, 1.0);
    final double centerAxis = (sliderStart + sliderEnd) / 2;

    final double adjustedValueEnd =
        centered ? math.min(valueEnd, centerAxis) : valueStart;
    final double adjustedValueStart =
        centered ? math.max(valueEnd, centerAxis) : valueEnd;

    final double activeStart = centered
        ? adjustedValueEnd + (adjustedValueEnd < centerAxis ? startGap : 0)
        : range
            ? valueStart + startGap
            : sliderStart;
    final double activeEnd = centered
        ? adjustedValueStart - (adjustedValueStart > centerAxis ? endGap : 0)
        : valueEnd - endGap;

    final List<M3ESliderDotPlacement> out = <M3ESliderDotPlacement>[];

    // [edgeInset] is clear space between the track edge and the marker's outer
    // edge; centers are therefore inset by spacing + half the marker size.
    final double stopRadius = stopIndicatorSize / 2;
    final double stopStart = sliderStart + edgeInset + stopRadius;
    final double stopEnd = sliderEnd - edgeInset - stopRadius;
    if (stopEnd > stopStart) {
      if (!_onActiveOrGap(
        stopStart,
        centered: centered,
        range: range,
        activeStart: activeStart,
        activeEnd: activeEnd,
        valueStart: valueStart,
        valueEnd: valueEnd,
        startGap: startGap,
        endGap: endGap,
      )) {
        out.add(
          M3ESliderDotPlacement(
            primary: stopStart,
            color: colors.inactiveTick,
            size: stopIndicatorSize,
            active: false,
          ),
        );
      }
      if (!_onActiveOrGap(
        stopEnd,
        centered: centered,
        range: range,
        activeStart: activeStart,
        activeEnd: activeEnd,
        valueStart: valueStart,
        valueEnd: valueEnd,
        startGap: startGap,
        endGap: endGap,
      )) {
        out.add(
          M3ESliderDotPlacement(
            primary: stopEnd,
            color: colors.inactiveTick,
            size: stopIndicatorSize,
            active: false,
          ),
        );
      }
    }

    if (tickFractions.isEmpty) {
      return out;
    }

    // Discrete ticks share the same padded span as the end stops.
    final double tickStart = stopStart;
    final double tickEnd = stopEnd;
    final double tickCenterGapStart = centered ? centerAxis - endGap : 0;
    final double tickCenterGapEnd = centered ? centerAxis + endGap : 0;
    final double tickStartGapLo = valueStart - startGap;
    final double tickStartGapHi = valueStart + startGap;
    final double tickEndGapLo = valueEnd - endGap;
    final double tickEndGapHi = valueEnd + endGap;

    for (int i = 0; i < tickFractions.length; i++) {
      // Ends are owned by stop indicators.
      if (i == 0 || i == tickFractions.length - 1) {
        continue;
      }
      final double centerTick =
          M3ESliderMath.lerp(tickStart, tickEnd, tickFractions[i]);
      if (centered &&
          centerTick >= tickCenterGapStart &&
          centerTick <= tickCenterGapEnd) {
        continue;
      }
      if (range &&
          centerTick >= tickStartGapLo &&
          centerTick <= tickStartGapHi) {
        continue;
      }
      if (centerTick >= tickEndGapLo && centerTick <= tickEndGapHi) {
        continue;
      }
      final bool inActive =
          centerTick >= activeStart && centerTick <= activeEnd;
      out.add(
        M3ESliderDotPlacement(
          primary: centerTick,
          color: inActive ? colors.activeTick : colors.inactiveTick,
          size: tickSize,
          active: inActive,
        ),
      );
    }

    return out;
  }

  static Rect _trackBounds(Size size, double trackCross, bool vertical) {
    if (vertical) {
      final double left = (size.width - trackCross) / 2;
      return Rect.fromLTWH(left, 0, trackCross, size.height);
    }
    final double top = (size.height - trackCross) / 2;
    return Rect.fromLTWH(0, top, size.width, trackCross);
  }

  static bool _onActiveOrGap(
    double primary, {
    required bool centered,
    required bool range,
    required double activeStart,
    required double activeEnd,
    required double valueStart,
    required double valueEnd,
    required double startGap,
    required double endGap,
  }) {
    if (primary >= activeStart && primary <= activeEnd) {
      return true;
    }
    if (range &&
        primary >= valueStart - startGap &&
        primary <= valueStart + startGap) {
      return true;
    }
    if (primary >= valueEnd - endGap && primary <= valueEnd + endGap) {
      return true;
    }
    if (centered &&
        startGap > 0 &&
        primary >= valueEnd - startGap &&
        primary <= valueEnd + startGap) {
      return true;
    }
    return false;
  }
}
