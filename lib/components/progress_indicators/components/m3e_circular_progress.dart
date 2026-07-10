import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'm3e_circular_progress_painter.dart';

/// A Material 3 Expressive circular progress indicator.
///
/// Pass a [value] in 0..1 for a determinate arc, or leave it null for the
/// spinning indeterminate indicator.
class M3ECircularProgress extends StatefulWidget {
  const M3ECircularProgress({
    this.value,
    this.size,
    this.strokeWidth,
    super.key,
  });

  final double? value;
  final double? size;
  final double? strokeWidth;

  @override
  State<M3ECircularProgress> createState() => _M3ECircularProgressState();
}

class _M3ECircularProgressState extends State<M3ECircularProgress>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: M3EMotion.extraLong2,
    );
    if (widget.value == null) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(M3ECircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null && !_controller.isAnimating) {
      _controller.repeat();
    } else if (widget.value != null && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final circularTheme = theme.progressIndicatorTheme.circular;
    final double resolvedSize = widget.size ?? circularTheme.defaultSize;
    final double resolvedStrokeWidth =
        widget.strokeWidth ?? circularTheme.defaultStrokeWidth;
    return M3EComponentTheme(builder: (context) => SizedBox(
        width: resolvedSize,
        height: resolvedSize,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            final _Arc arc = _resolveArc();
            return CustomPaint(
              painter: M3ECircularProgressPainter(
                trackColor: circularTheme.trackColor(scheme),
                activeColor: circularTheme.activeColor(scheme),
                strokeWidth: resolvedStrokeWidth,
                startAngle: arc.start,
                sweepAngle: arc.sweep,
              ),
            );
          },
        ),
      ),
    );
  }

  _Arc _resolveArc() {
    const double tau = 2 * math.pi;
    final double? value = widget.value;
    if (value != null) {
      return _Arc(-math.pi / 2, value.clamp(0, 1).toDouble() * tau);
    }
    final double t = _controller.value;
    final double rotation = t * tau * 2;
    final double sweep = (math.sin(t * math.pi) * 0.75 + 0.15) * tau;
    return _Arc(rotation, sweep);
  }
}

@immutable
class _Arc {
  const _Arc(this.start, this.sweep);

  final double start;
  final double sweep;
}
