import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

import '../../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../models/m3e_toolbar_action.dart';
import 'm3e_toolbar_icon_button.dart';
import 'm3e_toolbar_overflow_menu.dart';

/// Floating toolbar actions that expand left/right (or top/bottom) from a
/// filled [M3EToolbarAction.isExpandTrigger] item.
///
/// Container width/height is spring-driven with elastic overshoot. Side icons
/// fade/scale in after ~40% of the width transition (spatial springs spec).
class M3EToolbarExpandingActions extends StatelessWidget {
  const M3EToolbarExpandingActions({
    required this.actions,
    required this.maxInline,
    required this.overflowIcon,
    required this.iconButtonSize,
    required this.overflowTextStyle,
    required this.destructiveColor,
    required this.axis,
    required this.expandProgress,
    required this.onTriggerPressed,
    this.leading,
    this.trailing,
    this.gap = 0,
    super.key,
  });

  final List<M3EToolbarAction> actions;
  final int maxInline;
  final Widget overflowIcon;
  final M3EIconButtonSize iconButtonSize;
  final TextStyle overflowTextStyle;
  final Color destructiveColor;
  final Axis axis;

  /// Spring progress: 0 = collapsed (trigger only), 1 = fully expanded.
  /// May overshoot past 1 for elastic edge give.
  final double expandProgress;

  final VoidCallback onTriggerPressed;
  final Widget? leading;
  final Widget? trailing;
  final double gap;

  static const double _iconRevealStart = 0.4;

  @override
  Widget build(BuildContext context) {
    final int triggerIndex =
        actions.indexWhere((M3EToolbarAction a) => a.isExpandTrigger);

    // No trigger → always show full actions row (no expand morph).
    if (triggerIndex < 0) {
      return _staticRow(actions);
    }

    final List<M3EToolbarAction> inline = _inlineActions(actions, triggerIndex);
    final List<M3EToolbarAction> overflow = actions.length > maxInline
        ? actions
            .where((M3EToolbarAction a) => !a.isExpandTrigger)
            .skip(maxInline - 1)
            .toList(growable: false)
        : const <M3EToolbarAction>[];

    final int inlineTriggerIndex =
        inline.indexWhere((M3EToolbarAction a) => a.isExpandTrigger);
    final List<M3EToolbarAction> before =
        inline.sublist(0, inlineTriggerIndex);
    final M3EToolbarAction trigger = inline[inlineTriggerIndex];
    final List<M3EToolbarAction> after =
        inline.sublist(inlineTriggerIndex + 1);

    final double widthFactor = expandProgress.clamp(0.0, 1.5);
    final double reveal = _iconReveal(expandProgress);

    final Widget triggerButton = M3EToolbarIconButton(
      action: trigger,
      size: iconButtonSize,
      onPressed: onTriggerPressed,
    );

    final Widget? beforeSide = _sideGroup(
      actions: before,
      leading: leading,
      trailing: null,
      overflow: null,
      reveal: reveal,
      widthFactor: widthFactor,
      alignStart: false,
    );
    final Widget? afterSide = _sideGroup(
      actions: after,
      leading: null,
      trailing: trailing,
      overflow: overflow.isEmpty ? null : overflow,
      reveal: reveal,
      widthFactor: widthFactor,
      alignStart: true,
    );

    final List<Widget> children = <Widget>[
      if (beforeSide != null) beforeSide,
      triggerButton,
      if (afterSide != null) afterSide,
    ];

    if (axis == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  List<M3EToolbarAction> _inlineActions(
    List<M3EToolbarAction> all,
    int triggerIndex,
  ) {
    final M3EToolbarAction trigger = all[triggerIndex];
    final List<M3EToolbarAction> others = all
        .where((M3EToolbarAction a) => !a.isExpandTrigger)
        .toList(growable: false);

    // Keep trigger always inline; fill remaining slots around it.
    final int otherSlots = (maxInline - 1).clamp(0, others.length);
    final List<M3EToolbarAction> inlineOthers =
        others.take(otherSlots).toList(growable: false);

    // Preserve relative order: items before trigger, trigger, items after.
    final List<M3EToolbarAction> before = <M3EToolbarAction>[];
    final List<M3EToolbarAction> after = <M3EToolbarAction>[];
    for (final M3EToolbarAction a in inlineOthers) {
      if (all.indexOf(a) < triggerIndex) {
        before.add(a);
      } else {
        after.add(a);
      }
    }
    return <M3EToolbarAction>[...before, trigger, ...after];
  }

  Widget _staticRow(List<M3EToolbarAction> all) {
    final List<M3EToolbarAction> inline =
        all.take(maxInline).toList(growable: false);
    final List<M3EToolbarAction> overflow = all.length > maxInline
        ? all.sublist(maxInline)
        : const <M3EToolbarAction>[];

    final List<Widget> children = <Widget>[
      if (leading != null) ...<Widget>[
        leading!,
        _gapBox(),
      ],
      for (final M3EToolbarAction action in inline)
        M3EToolbarIconButton(action: action, size: iconButtonSize),
      if (overflow.isNotEmpty)
        M3EToolbarOverflowMenu(
          actions: overflow,
          icon: overflowIcon,
          iconButtonSize: iconButtonSize,
          textStyle: overflowTextStyle,
          destructiveColor: destructiveColor,
        ),
      if (trailing != null) ...<Widget>[
        _gapBox(),
        trailing!,
      ],
    ];

    if (axis == Axis.vertical) {
      return Column(mainAxisSize: MainAxisSize.min, children: children);
    }
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }

  /// Side cluster that grows away from the trigger.
  ///
  /// [alignStart] true → anchored at start (grows toward end / right / down).
  Widget? _sideGroup({
    required List<M3EToolbarAction> actions,
    required Widget? leading,
    required Widget? trailing,
    required List<M3EToolbarAction>? overflow,
    required double reveal,
    required double widthFactor,
    required bool alignStart,
  }) {
    final bool hasActions = actions.isNotEmpty ||
        (overflow != null && overflow.isNotEmpty) ||
        leading != null ||
        trailing != null;
    if (!hasActions) {
      return null;
    }

    final List<Widget> children = <Widget>[
      if (leading != null) ...<Widget>[leading, _gapBox()],
      for (final M3EToolbarAction action in actions)
        M3EToolbarIconButton(action: action, size: iconButtonSize),
      if (overflow != null && overflow.isNotEmpty)
        M3EToolbarOverflowMenu(
          actions: overflow,
          icon: overflowIcon,
          iconButtonSize: iconButtonSize,
          textStyle: overflowTextStyle,
          destructiveColor: destructiveColor,
        ),
      if (trailing != null) ...<Widget>[_gapBox(), trailing],
    ];

    final Widget group = axis == Axis.vertical
        ? Column(mainAxisSize: MainAxisSize.min, children: children)
        : Row(mainAxisSize: MainAxisSize.min, children: children);

    final AlignmentGeometry alignment = axis == Axis.horizontal
        ? (alignStart
            ? AlignmentDirectional.centerStart
            : AlignmentDirectional.centerEnd)
        : (alignStart ? Alignment.topCenter : Alignment.bottomCenter);

    return ClipRect(
      child: Align(
        alignment: alignment,
        widthFactor: axis == Axis.horizontal ? widthFactor : null,
        heightFactor: axis == Axis.vertical ? widthFactor : null,
        child: Opacity(
          opacity: reveal,
          child: Transform.scale(
            alignment: alignment,
            scale: 0.85 + (0.15 * reveal),
            child: group,
          ),
        ),
      ),
    );
  }

  Widget _gapBox() => SizedBox(
        width: axis == Axis.horizontal ? gap : 0,
        height: axis == Axis.vertical ? gap : 0,
      );

  /// Icons begin revealing ~40% into the width spring.
  double _iconReveal(double progress) {
    if (progress <= _iconRevealStart) {
      return 0;
    }
    return ((progress - _iconRevealStart) / (1.0 - _iconRevealStart))
        .clamp(0.0, 1.0);
  }
}

/// Spring used for floating toolbar container expand/collapse.
SpringMotion m3eToolbarExpandMotion() =>
    const MaterialSpringMotion.expressiveSpatialDefault()
        .copyWith(damping: 0.55);
