import 'package:flutter/widgets.dart';

import '../styles/m3e_slider_tokens.dart';

/// Paints the expressive slider's thick active and inactive track segments
/// plus the vertical handle, leaving a gap around the handle.
class M3ESliderTrackPainter extends CustomPainter {
  const M3ESliderTrackPainter({
    required this.fraction,
    required this.activeColor,
    required this.inactiveColor,
    required this.handleColor,
  });

  static const double _trackHeight = M3ESliderTokens.trackHeight;
  static const double _handleWidth = M3ESliderTokens.handleWidth;
  static const double _handleHeight = M3ESliderTokens.handleHeight;
  static const double _gap = M3ESliderTokens.handleGap;

  final double fraction;
  final Color activeColor;
  final Color inactiveColor;
  final Color handleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double centerY = size.height / 2;
    final double handleX = fraction.clamp(0, 1) * size.width;
    const radius = Radius.circular(_trackHeight / 2);

    final double activeRight = (handleX - _gap).clamp(0, size.width);
    if (activeRight > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            0,
            centerY - _trackHeight / 2,
            activeRight,
            _trackHeight,
          ),
          radius,
        ),
        Paint()..color = activeColor,
      );
    }

    final double inactiveLeft = (handleX + _gap).clamp(0, size.width);
    if (inactiveLeft < size.width) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            inactiveLeft,
            centerY - _trackHeight / 2,
            size.width - inactiveLeft,
            _trackHeight,
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
          width: _handleWidth,
          height: _handleHeight,
        ),
        const Radius.circular(_handleWidth / 2),
      ),
      Paint()..color = handleColor,
    );
  }

  @override
  bool shouldRepaint(M3ESliderTrackPainter oldDelegate) {
    return oldDelegate.fraction != fraction ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.handleColor != handleColor;
  }
}
