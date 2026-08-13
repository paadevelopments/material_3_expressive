import 'package:flutter/widgets.dart';

/// Paints a gradient stroke around [child] using [clipRadius].
Widget m3eGradientOutlineLayer({
  required BorderRadius clipRadius,
  required Gradient gradient,
  required double width,
  required Widget child,
}) {
  if (width <= 0) {
    return child;
  }
  return CustomPaint(
    foregroundPainter: M3EGradientOutlinePainter(
      gradient: gradient,
      radius: clipRadius,
      width: width,
    ),
    child: child,
  );
}

/// Stroke painter for a rounded-rect gradient outline.
class M3EGradientOutlinePainter extends CustomPainter {
  /// Creates an outline painter.
  const M3EGradientOutlinePainter({
    required this.gradient,
    required this.radius,
    required this.width,
  });

  /// Stroke shader.
  final Gradient gradient;

  /// Corner radii matching the morphing surface.
  final BorderRadius radius;

  /// Stroke width.
  final double width;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = radius.toRRect(rect).deflate(width / 2);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(M3EGradientOutlinePainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
        oldDelegate.radius != radius ||
        oldDelegate.width != width;
  }
}

/// Width from [side], or [fallback] when [side] is null or none.
double m3eOutlineWidth(BorderSide? side, {double fallback = 1}) {
  if (side == null || side.style == BorderStyle.none) {
    return fallback;
  }
  return side.width;
}
