import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Flips horizontally between [child] and [selectedChild] when [selected].
class M3ESelectionLeading extends StatefulWidget {
  /// Creates a selection leading flip.
  const M3ESelectionLeading({
    required this.selected,
    required this.selectedChild,
    required this.child,
    this.duration = const Duration(milliseconds: 220),
    this.onTap,
    super.key,
  });

  /// Whether the selected face is shown.
  final bool selected;

  /// Unselected leading widget.
  final Widget child;

  /// Selected leading widget.
  final Widget selectedChild;

  /// Flip duration.
  final Duration duration;

  /// Optional tap handler (leading only; does not compete with row body).
  final VoidCallback? onTap;

  @override
  State<M3ESelectionLeading> createState() => _M3ESelectionLeadingState();
}

class _M3ESelectionLeadingState extends State<M3ESelectionLeading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: widget.selected ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(M3ESelectionLeading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
    }
    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Widget face = AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? _) {
        final double angle = _controller.value * math.pi;
        final bool showSelected = angle > math.pi / 2;
        final double displayAngle = showSelected ? math.pi - angle : angle;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(displayAngle),
          child: showSelected ? widget.selectedChild : widget.child,
        );
      },
    );

    final Widget sized = _LeadingSize(
      unselected: widget.child,
      selected: widget.selectedChild,
      child: face,
    );

    if (widget.onTap == null) {
      return sized;
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: sized,
    );
  }
}

/// Reserves the larger of both faces so the flip does not jump layout.
class _LeadingSize extends StatelessWidget {
  const _LeadingSize({
    required this.unselected,
    required this.selected,
    required this.child,
  });

  final Widget unselected;
  final Widget selected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Opacity(opacity: 0, child: unselected),
        Opacity(opacity: 0, child: selected),
        child,
      ],
    );
  }
}
