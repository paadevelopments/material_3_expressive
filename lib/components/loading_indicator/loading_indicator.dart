import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_loading_painter.dart';

/// A Material 3 Expressive loading indicator.
///
/// A compact, continuously rotating shape that morphs between lobe counts to
/// signal a short, indeterminate wait. Provide [color] to override the default
/// primary color role.
class M3ELoadingIndicator extends StatefulWidget {
  const M3ELoadingIndicator({
    this.size = 48,
    this.color,
    this.contained = false,
    super.key,
  });

  final double size;
  final Color? color;

  /// When true the shape sits on a filled surface container.
  final bool contained;

  @override
  State<M3ELoadingIndicator> createState() => _M3ELoadingIndicatorState();
}

class _M3ELoadingIndicatorState extends State<M3ELoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: M3EMotion.extraLong4,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;
    final Color shapeColor = widget.color ?? scheme.primary;

    Widget indicator = AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double t = _controller.value;
        return CustomPaint(
          size: Size.square(widget.size * 0.7),
          painter: M3ELoadingPainter(
            color: shapeColor,
            rotation: t * 2 * 3.1415926535 * 2,
            lobes: 4 + (t * 3).roundToDouble(),
            amplitude: 0.25,
          ),
        );
      },
    );

    if (widget.contained) {
      indicator = Container(
        width: widget.size,
        height: widget.size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.secondaryContainer,
          shape: BoxShape.circle,
        ),
        child: indicator,
      );
    }
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Center(child: indicator),
    );
  }
}
