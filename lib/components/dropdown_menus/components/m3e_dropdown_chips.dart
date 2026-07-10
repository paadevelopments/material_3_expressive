// Ported from https://github.com/Mudit200408/m3e_dropdown_menu
// Adapted for material_3_expressive: import paths, foundations wiring, M3E naming.

import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../models/m3e_dropdown_item.dart';
import '../styles/m3e_dropdown_chip_style.dart';
import '../utils/m3e_dropdown_spring_motion.dart';

/// Internal widget for a bouncy spring chip.
class M3ESpringChip<T> extends StatefulWidget {
  final M3EDropdownItem<T> item;
  final M3EDropdownChipStyle cd;
  final Color chipColor;
  final TextStyle? labelStyle;
  final M3EColorScheme scheme;
  final bool enabled;
  final VoidCallback onRemove;
  final double
  slideOffset; // how much to slide left when a previous chip is removed

  /// When non-null, replaces the default chip body with this widget.
  final Widget? customChild;

  const M3ESpringChip({
    required super.key,
    required this.item,
    required this.cd,
    required this.chipColor,
    required this.labelStyle,
    required this.scheme,
    required this.enabled,
    required this.onRemove,
    this.slideOffset = 0,
    this.customChild,
  });

  @override
  State<M3ESpringChip<T>> createState() => M3ESpringChipState<T>();
}

class M3ESpringChipState<T> extends State<M3ESpringChip<T>>
    with TickerProviderStateMixin {
  late SingleMotionController _scaleCtrl;
  late SingleMotionController _slideCtrl;
  late SingleMotionController _squishCtrl;
  @override
  void initState() {
    super.initState();
    _squishCtrl = SingleMotionController(
      motion: widget.cd.openMotion.toMotion(), // Bouncy spring
      vsync: this,
    );
    _squishCtrl.value = 1.0;
    _scaleCtrl = SingleMotionController(
      motion: widget.cd.openMotion.toMotion(),
      vsync: this,
    );
    _slideCtrl = SingleMotionController(
      motion: widget.cd.openMotion.toMotion(),
      vsync: this,
    );
    _scaleCtrl.animateTo(1);
  }

  @override
  void didUpdateWidget(covariant M3ESpringChip<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slideOffset != widget.slideOffset) {
      _slideCtrl.animateTo(widget.slideOffset);
    }
  }

  void triggerSquish(double intensity) {
    // We animate from 1.0 -> intensity -> 1.0 (handled by the spring)
    _squishCtrl.animateTo(1, from: intensity);
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _slideCtrl.dispose();
    _squishCtrl.dispose();
    super.dispose();
  }

  void animateOut(VoidCallback onDone) {
    _scaleCtrl.motion = widget.cd.closeMotion.toMotion();
    _scaleCtrl.animateTo(0);
    void listener() {
      if (_scaleCtrl.value <= 0.01) {
        _scaleCtrl.removeListener(listener);
        onDone();
      }
    }

    _scaleCtrl.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleCtrl, _slideCtrl, _squishCtrl]),
      builder: (context, child) {
        final scale = _scaleCtrl.value.clamp(0.0, 1.05);
        final slide = _slideCtrl.value;
        final squish = _squishCtrl.value;

        // combine the entrance/exit 'scale' with the 'squish'
        // result: horizontal = entrance_scale * squish_factor
        //         vertical   = entrance_scale
        final double finalXScale = scale * squish;
        final finalYScale = scale;

        return Transform.translate(
          offset: Offset(slide, 0),
          child: Opacity(
            opacity: scale.clamp(0.0, 1.0),
            child: Transform(
              alignment: Alignment.centerLeft,
              // diagonal3Values is the modern, clean way to set x, y, z scale
              transform: Matrix4.diagonal3Values(finalXScale, finalYScale, 1),
              child: child,
            ),
          ),
        );
      },
      child: widget.customChild ?? _buildChipBody(),
    );
  }

  Widget _buildChipBody() {
    final cd = widget.cd;
    return MouseRegion(
      cursor: cd.mouseCursor ?? SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: cd.borderRadius,
          color: widget.enabled ? widget.chipColor : Colors.grey.withAlpha(30),
          border: cd.border != null ? Border.fromBorderSide(cd.border!) : null,
        ),
        padding: cd.padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.item.label,
              style:
                  widget.labelStyle?.copyWith(
                    color: widget.enabled
                        ? widget.labelStyle?.color
                        : Colors.grey,
                  ) ??
                  TextStyle(color: widget.enabled ? null : Colors.grey),
            ),
            if (widget.enabled) ...[
              const SizedBox(width: 4),
              Semantics(
                label: 'Remove ${widget.item.label}',
                button: true,
                child: Tooltip(
                  message: 'Remove ${widget.item.label}',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onRemove,
                    child:
                        widget.cd.deleteIcon ??
                        Icon(
                          Icons.close,
                          size: 16,
                          color: widget.scheme.onSecondaryContainer,
                        ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Layout delegate for the chips in non-wrap mode.
class M3EChipFlowDelegate extends FlowDelegate {
  final List<Animation<double>> slideAnimations;
  final double spacing;

  M3EChipFlowDelegate({required this.slideAnimations, required this.spacing})
    : super(repaint: Listenable.merge(slideAnimations));

  @override
  void paintChildren(FlowPaintingContext context) {
    double x = 0;
    for (var i = 0; i < context.childCount; i++) {
      final childSize = context.getChildSize(i)!;
      final slideOffset = slideAnimations[i].value;
      context.paintChild(
        i,
        transform: Matrix4.translationValues(x + slideOffset, 0, 0),
      );
      x += childSize.width + spacing;
    }
  }

  @override
  Size getSize(BoxConstraints constraints) =>
      Size(constraints.maxWidth, constraints.maxHeight);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) =>
      constraints.loosen();

  @override
  bool shouldRepaint(M3EChipFlowDelegate old) =>
      spacing != old.spacing || slideAnimations != old.slideAnimations;
}

/// Internal indicator shown when more chips exist than the max display count.
class M3EMoreChipsIndicator extends StatefulWidget {
  final int count;
  final M3EDropdownChipStyle cd;
  final Color chipColor;
  final TextStyle? labelStyle;

  const M3EMoreChipsIndicator({
    super.key,
    required this.count,
    required this.cd,
    required this.chipColor,
    required this.labelStyle,
  });

  @override
  State<M3EMoreChipsIndicator> createState() => M3EMoreChipsIndicatorState();
}

class M3EMoreChipsIndicatorState extends State<M3EMoreChipsIndicator>
    with TickerProviderStateMixin {
  late SingleMotionController _scaleCtrl;
  late SingleMotionController _popCtrl;
  late SingleMotionController _squishCtrl;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = SingleMotionController(
      motion: widget.cd.openMotion.toMotion(),
      vsync: this,
    );
    _scaleCtrl.animateTo(1);

    _popCtrl = SingleMotionController(
      motion: M3EMotion.effectsFast.toMotion(),
      vsync: this,
    )..value = 1.0;

    _squishCtrl = SingleMotionController(
      motion: M3EMotion.effectsDefault.toMotion(),
      vsync: this,
    )..value = 1.0;
  }

  void triggerSquish(double intensity) {
    _squishCtrl.animateTo(1, from: intensity);
  }

  void animateOut(VoidCallback onDone) {
    _scaleCtrl.motion = widget.cd.closeMotion.toMotion();
    _scaleCtrl.animateTo(0);
    void listener() {
      if (_scaleCtrl.value <= 0.01) {
        _scaleCtrl.removeListener(listener);
        onDone();
      }
    }

    _scaleCtrl.addListener(listener);
  }

  void animateIn() {
    _scaleCtrl.motion = widget.cd.openMotion.toMotion();
    _scaleCtrl.animateTo(1);
  }

  @override
  void didUpdateWidget(covariant M3EMoreChipsIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count) {
      // Pop effect when the number increments/decrements
      _popCtrl.animateTo(1, from: 1.25);
    }
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _popCtrl.dispose();
    _squishCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleCtrl, _popCtrl, _squishCtrl]),
      builder: (context, child) {
        final scale = _scaleCtrl.value.clamp(0.0, 1.05);
        final pop = _popCtrl.value;
        final squish = _squishCtrl.value;
        return Opacity(
          opacity: scale.clamp(0.0, 1.0),
          child: Transform(
            alignment: Alignment.centerLeft,
            transform: Matrix4.diagonal3Values(
              scale * pop * squish,
              scale * pop,
              1,
            ),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.cd.borderRadius,
          color: widget.chipColor,
          border: widget.cd.border != null
              ? Border.fromBorderSide(widget.cd.border!)
              : null,
        ),
        padding: widget.cd.padding,
        child: Text('+${widget.count}', style: widget.labelStyle),
      ),
    );
  }
}
