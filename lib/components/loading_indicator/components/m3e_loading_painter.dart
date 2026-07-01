import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Paints the morphing, rotating blob of the expressive loading indicator.
///
/// The outline is a polar curve whose lobe count animates between two integers
/// so the shape appears to morph while it rotates.
class M3ELoadingPainter extends CustomPainter {
  const M3ELoadingPainter({
    required this.color,
    required this.rotation,
    required this.lobes,
    required this.amplitude,
  });

  final Color color;

  /// Rotation of the whole shape in radians.
  final double rotation;

  /// The (possibly fractional) number of lobes around the blob.
  final double lobes;

  /// How pronounced the lobes are, in the range 0..1.
  final double amplitude;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final base = size.shortestSide / 2;
    final path = Path();
    const samples = 120;

    for (var i = 0; i <= samples; i++) {
      final double angle = (i / samples) * 2 * math.pi;
      final double radius =
          base * (1 - amplitude + amplitude * _lobe(angle));
      final Offset point = center +
          Offset(
            radius * math.cos(angle + rotation),
            radius * math.sin(angle + rotation),
          );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }

  double _lobe(double angle) {
    return (math.cos(lobes * angle) + 1) / 2;
  }

  @override
  bool shouldRepaint(M3ELoadingPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.lobes != lobes ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.color != color;
  }
}
