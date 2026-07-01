import 'package:flutter/widgets.dart';

/// Paints the track and active indicator of a linear progress bar.
class M3ELinearProgressPainter extends CustomPainter {
  const M3ELinearProgressPainter({
    required this.trackColor,
    required this.activeColor,
    required this.fractionStart,
    required this.fractionEnd,
  });

  final Color trackColor;
  final Color activeColor;

  /// Normalised start of the active segment, in the range 0..1.
  final double fractionStart;

  /// Normalised end of the active segment, in the range 0..1.
  final double fractionEnd;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.height / 2;
    final corner = Radius.circular(radius);
    final track = Paint()..color = trackColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, corner),
      track,
    );

    final double left = fractionStart.clamp(0, 1) * size.width;
    final double right = fractionEnd.clamp(0, 1) * size.width;
    if (right <= left) {
      return;
    }
    final active = Paint()..color = activeColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, 0, right, size.height),
        corner,
      ),
      active,
    );
  }

  @override
  bool shouldRepaint(M3ELinearProgressPainter oldDelegate) {
    return oldDelegate.fractionStart != fractionStart ||
        oldDelegate.fractionEnd != fractionEnd ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.trackColor != trackColor;
  }
}
