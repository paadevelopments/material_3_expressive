import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

/// Subtle scale pop on the newly selected icon (≈1.0 → 1.08 → 1.0).
class M3ENavIconScale extends StatefulWidget {
  const M3ENavIconScale({
    required this.selected,
    required this.child,
    super.key,
  });

  final bool selected;
  final Widget child;

  @override
  State<M3ENavIconScale> createState() => _M3ENavIconScaleState();
}

class _M3ENavIconScaleState extends State<M3ENavIconScale>
    with SingleTickerProviderStateMixin {
  late SingleMotionController _scale;

  SpringMotion get _motion =>
      const MaterialSpringMotion.expressiveSpatialDefault()
          .copyWith(damping: 0.5);

  @override
  void initState() {
    super.initState();
    _scale = SingleMotionController(
      motion: _motion,
      vsync: this,
      initialValue: 1,
    );
  }

  @override
  void didUpdateWidget(covariant M3ENavIconScale oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.selected && widget.selected) {
      // Overshoot spring from slightly under 1 — no shrink-first dip.
      _scale
        ..motion = _motion
        ..value = 0.98
        ..animateTo(1);
    }
  }

  @override
  void dispose() {
    _scale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: _scale.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
