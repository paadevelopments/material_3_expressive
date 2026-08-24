import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/sliders/m3e_sliders.dart'
    show M3ERangeSlider, M3ESlider;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3ERangeSlider, M3ESlider;

import '../res/m3e_slider_tokens.dart';

/// Expressive bar handle for [M3ESlider] / [M3ERangeSlider].
///
/// Shrinks along its thickness axis while [pressed]. When [focused], draws a
/// concentric outline for keyboard / traditional focus highlighting.
class M3ESliderThumb extends StatelessWidget {
  /// M3ESliderThumb.
  const M3ESliderThumb({
    required this.color,
    required this.pressed,
    this.focused = false,
    this.axis = Axis.horizontal,
    this.width,
    this.height,
    this.pressedThickness,
    super.key,
  });

  /// color.

  final Color color;

  /// pressed.
  final bool pressed;

  /// Whether to show the keyboard focus outline.
  final bool focused;

  /// axis.
  final Axis axis;

  /// Resting thumb width (cross-axis for vertical). Defaults to token sizes.
  final double? width;

  /// Resting thumb height (main-axis for vertical). Defaults to token sizes.
  final double? height;

  /// Pressed thickness along the short axis. Defaults to token pressed width.
  final double? pressedThickness;

  static const double _focusStroke = 2;
  static const double _focusInflate = 6;

  @override
  Widget build(BuildContext context) {
    final vertical = axis == Axis.vertical;
    final double restingW =
        width ??
        (vertical
            ? M3ESliderTokens.verticalHandleWidth
            : M3ESliderTokens.handleWidth);
    final double restingH =
        height ??
        (vertical
            ? M3ESliderTokens.verticalHandleHeight
            : M3ESliderTokens.handleHeight);
    final double pressedT =
        pressedThickness ?? M3ESliderTokens.pressedHandleWidth;

    final w = vertical ? restingW : (pressed ? pressedT : restingW);
    final h = vertical ? (pressed ? pressedT : restingH) : restingH;
    final radius = math.max(w, h) / 2;

    Widget thumb = AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );

    if (!focused) {
      return thumb;
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          width: w + _focusInflate,
          height: h + _focusInflate,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              math.max(w + _focusInflate, h + _focusInflate) / 2,
            ),
            border: Border.all(color: color, width: _focusStroke),
          ),
        ),
        thumb,
      ],
    );
  }
}
