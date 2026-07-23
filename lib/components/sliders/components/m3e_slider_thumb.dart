// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// SliderDefaults.Thumb / ThumbContent

import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../res/m3e_slider_tokens.dart';

/// Expressive bar handle for [M3ESlider] / [M3ERangeSlider].
///
/// Shrinks along its thickness axis while [pressed] (Compose press/focus/drag).
class M3ESliderThumb extends StatelessWidget {
  const M3ESliderThumb({
    required this.color,
    required this.pressed,
    this.axis = Axis.horizontal,
    this.width,
    this.height,
    this.pressedThickness,
    super.key,
  });

  final Color color;
  final bool pressed;
  final Axis axis;

  /// Resting thumb width (cross-axis for vertical). Defaults to token sizes.
  final double? width;

  /// Resting thumb height (main-axis for vertical). Defaults to token sizes.
  final double? height;

  /// Pressed thickness along the short axis. Defaults to token pressed width.
  final double? pressedThickness;

  @override
  Widget build(BuildContext context) {
    final bool vertical = axis == Axis.vertical;
    final double restingW = width ??
        (vertical
            ? M3ESliderTokens.verticalHandleWidth
            : M3ESliderTokens.handleWidth);
    final double restingH = height ??
        (vertical
            ? M3ESliderTokens.verticalHandleHeight
            : M3ESliderTokens.handleHeight);
    final double pressedT =
        pressedThickness ?? M3ESliderTokens.pressedHandleWidth;

    final double w = vertical ? restingW : (pressed ? pressedT : restingW);
    final double h = vertical ? (pressed ? pressedT : restingH) : restingH;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(math.max(w, h) / 2),
      ),
    );
  }
}
