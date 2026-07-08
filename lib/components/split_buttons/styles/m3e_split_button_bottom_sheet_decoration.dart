// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';

import '../../buttons/styles/m3e_button_motion.dart';
import '../enums/m3e_split_button_selection_mode.dart';
import 'm3e_split_button_checkbox_style.dart';

/// Styling options for split-button bottom-sheet menus.
@immutable
class M3ESplitButtonBottomSheetDecoration {
  const M3ESplitButtonBottomSheetDecoration({
    this.title,
    this.titlePadding,
    this.showDragHandle = true,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.motion = M3EButtonMotion.expressiveSpatialDefault,
    this.selectionMode = M3ESplitButtonSelectionMode.single,
    this.checkboxStyle,
  });

  final Widget? title;
  final EdgeInsetsGeometry? titlePadding;
  final bool showDragHandle;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final M3EButtonMotion motion;
  final M3ESplitButtonSelectionMode selectionMode;
  final M3ESplitButtonCheckboxStyle? checkboxStyle;

  M3ESplitButtonBottomSheetDecoration copyWith({
    Widget? title,
    EdgeInsetsGeometry? titlePadding,
    bool? showDragHandle,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    M3EButtonMotion? motion,
    M3ESplitButtonSelectionMode? selectionMode,
    M3ESplitButtonCheckboxStyle? checkboxStyle,
  }) {
    return M3ESplitButtonBottomSheetDecoration(
      title: title ?? this.title,
      titlePadding: titlePadding ?? this.titlePadding,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      shape: shape ?? this.shape,
      motion: motion ?? this.motion,
      selectionMode: selectionMode ?? this.selectionMode,
      checkboxStyle: checkboxStyle ?? this.checkboxStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3ESplitButtonBottomSheetDecoration &&
          title == other.title &&
          titlePadding == other.titlePadding &&
          showDragHandle == other.showDragHandle &&
          backgroundColor == other.backgroundColor &&
          elevation == other.elevation &&
          shape == other.shape &&
          motion == other.motion &&
          selectionMode == other.selectionMode &&
          checkboxStyle == other.checkboxStyle;

  @override
  int get hashCode => Object.hash(
    title,
    titlePadding,
    showDragHandle,
    backgroundColor,
    elevation,
    shape,
    motion,
    selectionMode,
    checkboxStyle,
  );
}
