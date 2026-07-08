import 'package:flutter/widgets.dart';

/// Paints the expressive slider's thick active and inactive track segments
/// plus the vertical handle, leaving a gap around the handle.
class M3ESliderTrackPainter extends CustomPainter {
  const M3ESliderTrackPainter({
    required this.fraction,
    required this.activeColor,
    required this.inactiveColor,
    required this.handleColor,
    required this.trackHeight,
    required this.handleWidth,
    required this.handleHeight,
    required this.handleGap,
  });

  final double fraction;
  final Color activeColor;
  final Color inactiveColor;
  final Color handleColor;
  final double trackHeight;
  final double handleWidth;
  final double handleHeight;
  final double handleGap;

  @override
  void paint(Canvas canvas, Size size) {
    final double centerY = size.height / 2;
    final double handleX = fraction.clamp(0, 1) * size.width;
    final radius = Radius.circular(trackHeight / 2);

    final double activeRight = (handleX - handleGap).clamp(0, size.width);
    if (activeRight > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            0,
            centerY - trackHeight / 2,
            activeRight,
            trackHeight,
          ),
          radius,
        ),
        Paint()..color = activeColor,
      );
    }

    final double inactiveLeft = (handleX + handleGap).clamp(0, size.width);
    if (inactiveLeft < size.width) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            inactiveLeft,
            centerY - trackHeight / 2,
            size.width - inactiveLeft,
            trackHeight,
          ),
          radius,
        ),
        Paint()..color = inactiveColor,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(handleX, centerY),
          width: handleWidth,
          height: handleHeight,
        ),
        Radius.circular(handleWidth / 2),
      ),
      Paint()..color = handleColor,
    );
  }

  @override
  bool shouldRepaint(M3ESliderTrackPainter oldDelegate) {
    return oldDelegate.fraction != fraction ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.handleColor != handleColor ||
        oldDelegate.trackHeight != trackHeight ||
        oldDelegate.handleWidth != handleWidth ||
        oldDelegate.handleHeight != handleHeight ||
        oldDelegate.handleGap != handleGap;
  }
}
