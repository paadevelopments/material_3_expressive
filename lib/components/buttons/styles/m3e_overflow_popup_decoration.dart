// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';

import 'm3e_button_motion.dart';

/// Styling configuration for the overflow popup menu in [M3EButtonGroup].
class M3EOverflowPopupDecoration {
  final Color? backgroundColor;
  final double elevation;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final double minWidth;
  final double maxWidth;
  final double maxHeight;
  final EdgeInsetsGeometry padding;
  final Offset offset;
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

  const M3EOverflowPopupDecoration({
    this.backgroundColor,
    this.elevation = 10.0,
    this.borderRadius,
    this.border,
    this.minWidth = 220.0,
    this.maxWidth = 280.0,
    this.maxHeight = 320.0,
    this.padding = const EdgeInsets.all(8),
    this.offset = const Offset(0, 6.0),
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
