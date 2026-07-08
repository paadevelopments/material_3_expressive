// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/foundations.dart';

/// Styling options for the checkbox shown in multi-select bottom sheets.
@immutable
class M3ESplitButtonCheckboxStyle {
  const M3ESplitButtonCheckboxStyle({
    this.activeColor,
    this.iconColor,
    this.nonActiveColor,
    this.borderColor,
    this.activeBorderRadius,
    this.nonActiveBorderRadius,
    this.icon = const Icon(M3EIcons.check_rounded),
  });

  final Color? activeColor;
  final Color? iconColor;
  final Color? nonActiveColor;
  final Color? borderColor;
  final BorderRadius? activeBorderRadius;
  final BorderRadius? nonActiveBorderRadius;
  final Widget? icon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3ESplitButtonCheckboxStyle &&
          activeColor == other.activeColor &&
          iconColor == other.iconColor &&
          nonActiveColor == other.nonActiveColor &&
          borderColor == other.borderColor &&
          activeBorderRadius == other.activeBorderRadius &&
          nonActiveBorderRadius == other.nonActiveBorderRadius &&
          icon == other.icon;

  @override
  int get hashCode => Object.hash(
    activeColor,
    iconColor,
    nonActiveColor,
    borderColor,
    activeBorderRadius,
    nonActiveBorderRadius,
    icon,
  );
}
