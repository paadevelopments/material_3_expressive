import 'package:flutter/widgets.dart';

import '../enums/m3e_slider_enums.dart';
import '../models/m3e_slider_dot_builder.dart';
import '../styles/m3e_slider_theme.dart';
import '../utils/m3e_slider_dot_layout.dart';

/// Positions custom stop/tick widgets from [dotBuilder].
class M3ESliderDotOverlay extends StatelessWidget {
  const M3ESliderDotOverlay({
    required this.builder,
    required this.mode,
    required this.trackKind,
    required this.activeStartFraction,
    required this.activeEndFraction,
    required this.tickFractions,
    required this.colors,
    required this.trackHeight,
    required this.handleGap,
    required this.handleThickness,
    required this.stopIndicatorSize,
    required this.tickSize,
    required this.axis,
    required this.textDirection,
    this.edgeInset,
    super.key,
  });

  final M3ESliderDotBuilder builder;
  final M3ESliderPaintMode mode;
  final M3ESliderTrackKind trackKind;
  final double activeStartFraction;
  final double activeEndFraction;
  final List<double> tickFractions;
  final M3ESliderColors colors;
  final double trackHeight;
  final double handleGap;
  final double handleThickness;
  final double stopIndicatorSize;
  final double tickSize;
  final Axis axis;
  final TextDirection textDirection;
  final double? edgeInset;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = constraints.biggest;
        final List<M3ESliderDotPlacement> dots = M3ESliderDotLayout.resolve(
          size: size,
          mode: mode,
          trackKind: trackKind,
          activeStartFraction: activeStartFraction,
          activeEndFraction: activeEndFraction,
          tickFractions: tickFractions,
          colors: colors,
          trackHeight: trackHeight,
          handleGap: handleGap,
          handleThickness: handleThickness,
          stopIndicatorSize: stopIndicatorSize,
          tickSize: tickSize,
          edgeInset: edgeInset ?? trackHeight / 2,
          axis: axis,
          textDirection: textDirection,
        );
        final bool vertical = axis == Axis.vertical;
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            for (final M3ESliderDotPlacement dot in dots)
              Positioned(
                left: vertical ? (size.width - dot.size) / 2 : dot.primary - dot.size / 2,
                top: vertical
                    ? dot.primary - dot.size / 2
                    : (size.height - dot.size) / 2,
                width: dot.size,
                height: dot.size,
                child: builder(
                  context: context,
                  color: dot.color,
                  size: dot.size,
                  active: dot.active,
                ),
              ),
          ],
        );
      },
    );
  }
}
