// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';

import 'm3e_button_motion.dart';

/// Styling configuration for the overflow bottom sheet in [M3EButtonGroup].
class M3EOverflowBottomSheetDecoration {
  final Widget? title;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final bool showDragHandle;
  final EdgeInsetsGeometry titlePadding;
  final bool useCardList;
  final double outerRadius;
  final double innerRadius;
  final double? selectedBorderRadius;
  final Color? selectedBackgroundColor;
  final Color? itemBackgroundColor;
  final double itemGap;
  final Widget? trailing;
  final EdgeInsetsGeometry itemPadding;
  final M3EButtonMotion motion;

  const M3EOverflowBottomSheetDecoration({
    this.title,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.showDragHandle = true,
    this.titlePadding = const EdgeInsets.fromLTRB(20, 8, 20, 12),
    this.useCardList = true,
    this.outerRadius = 12.0,
    this.innerRadius = 4.0,
    this.selectedBorderRadius,
    this.selectedBackgroundColor,
    this.itemBackgroundColor,
    this.itemGap = 3.0,
    this.trailing,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.motion = M3EButtonMotion.standardOverflow,
  });
}
