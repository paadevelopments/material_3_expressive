import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../styles/m3e_time_picker_theme.dart';

/// Paints the clock dial: hour or minute labels, the selection hand and knob.
class M3ETimeDialPainter extends CustomPainter {
  const M3ETimeDialPainter({
    required this.labels,
    required this.selectedIndex,
    required this.dialColor,
    required this.accentColor,
    required this.onAccentColor,
    required this.labelColor,
    required this.labelStyle,
    required this.textDirection,
    required this.timeTheme,
  });

  /// The labels drawn evenly around the ring, starting at the 12 o'clock slot.
  final List<String> labels;

  /// Index into [labels] of the currently selected slot.
  final int selectedIndex;

  final Color dialColor;
  final Color accentColor;
  final Color onAccentColor;
  final Color labelColor;
  final TextStyle labelStyle;
  final TextDirection textDirection;
  final M3ETimePickerTheme timeTheme;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.shortestSide / 2;
    final double knobRadius = timeTheme.dialKnobRadius;
    final double ringRadius = radius - knobRadius - timeTheme.dialRingInset;

    canvas.drawCircle(center, radius, Paint()..color = dialColor);

    final angle = _angleFor(selectedIndex);
    final Offset knob = center + Offset.fromDirection(angle, ringRadius);
    final accent = Paint()..color = accentColor;
    canvas
      ..drawLine(
        center,
        knob,
        Paint()
          ..color = accentColor
          ..strokeWidth = timeTheme.dialHandWidth,
      )
      ..drawCircle(center, timeTheme.dialCenterRadius, accent)
      ..drawCircle(knob, knobRadius, accent);

    for (var i = 0; i < labels.length; i++) {
      _paintLabel(canvas, center, ringRadius, i);
    }
  }

  void _paintLabel(
    Canvas canvas,
    Offset center,
    double ringRadius,
    int i,
  ) {
    final angle = _angleFor(i);
    final Offset position = center + Offset.fromDirection(angle, ringRadius);
    final selected = i == selectedIndex;
    final painter = TextPainter(
      text: TextSpan(
        text: labels[i],
        style: labelStyle.copyWith(
          color: selected ? onAccentColor : labelColor,
          fontSize: timeTheme.dialLabelFontSize,
        ),
      ),
      textDirection: textDirection,
    )..layout();
    painter.paint(
      canvas,
      position - Offset(painter.width / 2, painter.height / 2),
    );
  }

  double _angleFor(int index) {
    final double step = 2 * math.pi / labels.length;
    return -math.pi / 2 + index * step;
  }

  @override
  bool shouldRepaint(M3ETimeDialPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.labels != labels ||
        oldDelegate.accentColor != accentColor ||
        oldDelegate.labelStyle != labelStyle ||
        oldDelegate.timeTheme != timeTheme;
  }
}
