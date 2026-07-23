// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// Slider.kt drawTrack / drawTrackPath / drawStopIndicator

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../enums/m3e_slider_enums.dart';
import '../styles/m3e_slider_theme.dart';
import '../utils/m3e_slider_math.dart';

/// How the track interprets active fill extents.
enum M3ESliderPaintMode {
  /// Single thumb; active from start → thumb (or centered).
  single,

  /// Dual thumbs; active between start and end.
  range,
}

/// Paints expressive track segments, stop indicators, and discrete ticks.
///
/// The thumb is painted separately by [M3ESliderThumb] so it can animate.
class M3ESliderTrackPainter extends CustomPainter {
  const M3ESliderTrackPainter({
    required this.mode,
    required this.trackKind,
    required this.activeStartFraction,
    required this.activeEndFraction,
    required this.tickFractions,
    required this.colors,
    required this.trackHeight,
    required this.handleGap,
    required this.handleThickness,
    required this.insideCornerSize,
    required this.stopIndicatorSize,
    required this.tickSize,
    required this.axis,
    required this.textDirection,
    this.drawStops = true,
  });

  final M3ESliderPaintMode mode;
  final M3ESliderTrackKind trackKind;
  final double activeStartFraction;
  final double activeEndFraction;
  final List<double> tickFractions;
  final M3ESliderColors colors;
  final double trackHeight;
  final double handleGap;
  final double handleThickness;
  final double insideCornerSize;
  final double stopIndicatorSize;
  final double tickSize;
  final Axis axis;
  final TextDirection textDirection;
  final bool drawStops;

  bool get _vertical => axis == Axis.vertical;
  bool get _rtl => !_vertical && textDirection == TextDirection.rtl;
  bool get _centered =>
      mode == M3ESliderPaintMode.single &&
      trackKind == M3ESliderTrackKind.centered;
  bool get _range => mode == M3ESliderPaintMode.range;

  @override
  void paint(Canvas canvas, Size size) {
    final double trackCross = trackHeight;
    final Rect trackBounds = _trackBounds(size, trackCross);
    final double sliderStart = _primaryMin(trackBounds);
    final double sliderEnd = _primaryMax(trackBounds);
    final double span = sliderEnd - sliderStart;
    if (span <= 0) {
      return;
    }

    final double corner = trackCross / 2;
    final double startGap =
        (_centered || _range) ? handleThickness / 2 + handleGap : 0;
    final double endGap = handleThickness / 2 + handleGap;

    final double valueStart =
        sliderStart + span * activeStartFraction.clamp(0.0, 1.0);
    final double valueEnd =
        sliderStart + span * activeEndFraction.clamp(0.0, 1.0);
    final double centerAxis = (sliderStart + sliderEnd) / 2;

    // Leading inactive (centered / range).
    final double adjustedValueEnd =
        _centered ? math.min(valueEnd, centerAxis) : valueStart;
    if ((_centered || _range) &&
        adjustedValueEnd > sliderStart + startGap + corner) {
      final double start = sliderStart;
      final double end = adjustedValueEnd - startGap;
      if (end > start) {
        _drawSegment(
          canvas,
          trackBounds,
          start,
          end,
          colors.inactiveTrack,
          startCorner: _rtl ? insideCornerSize : corner,
          endCorner: _rtl ? corner : insideCornerSize,
        );
        if (drawStops) {
          _drawStop(
            canvas,
            trackBounds,
            start + corner,
            colors.stopIndicator,
          );
        }
      }
    }

    // Trailing inactive.
    final double adjustedValueStart =
        _centered ? math.max(valueEnd, centerAxis) : valueEnd;
    if (adjustedValueStart < sliderEnd - endGap - corner) {
      final double start = adjustedValueStart + endGap;
      final double end = sliderEnd;
      if (end > start) {
        _drawSegment(
          canvas,
          trackBounds,
          start,
          end,
          colors.inactiveTrack,
          startCorner: _rtl ? corner : insideCornerSize,
          endCorner: _rtl ? insideCornerSize : corner,
        );
        if (drawStops) {
          _drawStop(
            canvas,
            trackBounds,
            end - corner,
            colors.stopIndicator,
          );
        }
      }
    }

    // Active track.
    final double activeStart = _centered
        ? adjustedValueEnd + (adjustedValueEnd < centerAxis ? startGap : 0)
        : _range
            ? valueStart + startGap
            : sliderStart;
    final double activeEnd = _centered
        ? adjustedValueStart - (adjustedValueStart > centerAxis ? endGap : 0)
        : valueEnd - endGap;

    final double startCorner =
        (_rtl || _centered || _range) ? insideCornerSize : corner;
    final double endCorner =
        (_rtl && !_centered && !_range) ? corner : insideCornerSize;
    final double activeWidth = activeEnd - activeStart;
    if (activeWidth > startCorner) {
      _drawSegment(
        canvas,
        trackBounds,
        activeStart,
        activeEnd,
        colors.activeTrack,
        startCorner: startCorner,
        endCorner: endCorner,
      );
    }

    // Discrete ticks (skip stops and handle gaps).
    if (tickFractions.isEmpty) {
      return;
    }
    final double tickStart = sliderStart + corner;
    final double tickEnd = sliderEnd - corner;
    final double tickCenterGapStart = _centered ? centerAxis - endGap : 0;
    final double tickCenterGapEnd = _centered ? centerAxis + endGap : 0;
    final double tickStartGapLo = valueStart - startGap;
    final double tickStartGapHi = valueStart + startGap;
    final double tickEndGapLo = valueEnd - endGap;
    final double tickEndGapHi = valueEnd + endGap;

    for (int i = 0; i < tickFractions.length; i++) {
      if (drawStops) {
        final bool stopAtStart = (_centered || _range) && i == 0;
        if (stopAtStart || i == tickFractions.length - 1) {
          continue;
        }
      }
      final double centerTick =
          M3ESliderMath.lerp(tickStart, tickEnd, tickFractions[i]);
      if (_centered &&
          centerTick >= tickCenterGapStart &&
          centerTick <= tickCenterGapEnd) {
        continue;
      }
      if (_range &&
          centerTick >= tickStartGapLo &&
          centerTick <= tickStartGapHi) {
        continue;
      }
      if (centerTick >= tickEndGapLo && centerTick <= tickEndGapHi) {
        continue;
      }
      final bool inActive =
          centerTick >= activeStart && centerTick <= activeEnd;
      _drawStop(
        canvas,
        trackBounds,
        centerTick,
        inActive ? colors.activeTick : colors.inactiveTick,
        size: tickSize,
      );
    }
  }

  Rect _trackBounds(Size size, double trackCross) {
    if (_vertical) {
      final double left = (size.width - trackCross) / 2;
      return Rect.fromLTWH(left, 0, trackCross, size.height);
    }
    final double top = (size.height - trackCross) / 2;
    return Rect.fromLTWH(0, top, size.width, trackCross);
  }

  double _primaryMin(Rect bounds) => _vertical ? bounds.top : bounds.left;
  double _primaryMax(Rect bounds) => _vertical ? bounds.bottom : bounds.right;

  void _drawSegment(
    Canvas canvas,
    Rect trackBounds,
    double start,
    double end,
    Color color, {
    required double startCorner,
    required double endCorner,
  }) {
    if (end <= start) {
      return;
    }
    final RRect rrect;
    if (_vertical) {
      rrect = RRect.fromRectAndCorners(
        Rect.fromLTRB(trackBounds.left, start, trackBounds.right, end),
        topLeft: Radius.circular(startCorner),
        topRight: Radius.circular(startCorner),
        bottomLeft: Radius.circular(endCorner),
        bottomRight: Radius.circular(endCorner),
      );
    } else if (_rtl) {
      // Mirror primary axis: paint from size-relative coordinates already
      // computed in LTR space by callers using physical offsets.
      rrect = RRect.fromRectAndCorners(
        Rect.fromLTRB(start, trackBounds.top, end, trackBounds.bottom),
        topLeft: Radius.circular(startCorner),
        bottomLeft: Radius.circular(startCorner),
        topRight: Radius.circular(endCorner),
        bottomRight: Radius.circular(endCorner),
      );
    } else {
      rrect = RRect.fromRectAndCorners(
        Rect.fromLTRB(start, trackBounds.top, end, trackBounds.bottom),
        topLeft: Radius.circular(startCorner),
        bottomLeft: Radius.circular(startCorner),
        topRight: Radius.circular(endCorner),
        bottomRight: Radius.circular(endCorner),
      );
    }
    canvas.drawRRect(rrect, Paint()..color = color);
  }

  void _drawStop(
    Canvas canvas,
    Rect trackBounds,
    double primary,
    Color color, {
    double? size,
  }) {
    final double diameter = size ?? stopIndicatorSize;
    final Offset center = _vertical
        ? Offset(trackBounds.center.dx, primary)
        : Offset(primary, trackBounds.center.dy);
    canvas.drawCircle(center, diameter / 2, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant M3ESliderTrackPainter oldDelegate) {
    return oldDelegate.mode != mode ||
        oldDelegate.trackKind != trackKind ||
        oldDelegate.activeStartFraction != activeStartFraction ||
        oldDelegate.activeEndFraction != activeEndFraction ||
        oldDelegate.tickFractions != tickFractions ||
        oldDelegate.colors != colors ||
        oldDelegate.trackHeight != trackHeight ||
        oldDelegate.handleGap != handleGap ||
        oldDelegate.handleThickness != handleThickness ||
        oldDelegate.insideCornerSize != insideCornerSize ||
        oldDelegate.stopIndicatorSize != stopIndicatorSize ||
        oldDelegate.tickSize != tickSize ||
        oldDelegate.axis != axis ||
        oldDelegate.textDirection != textDirection ||
        oldDelegate.drawStops != drawStops;
  }
}
