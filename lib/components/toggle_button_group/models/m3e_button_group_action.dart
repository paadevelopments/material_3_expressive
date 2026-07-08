// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';

import '../../buttons/styles/m3e_button_decoration.dart';

/// Declarative description of a single toggle button inside [M3EButtonGroup].
class M3EButtonGroupAction {
  const M3EButtonGroupAction({
    this.icon,
    this.checkedIcon,
    this.label,
    this.checkedLabel,
    this.checked,
    this.enabled = true,
    this.decoration,
    this.width,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.tooltip,
    this.enableFeedback,
  }) : assert(
  icon != null || label != null,
  'M3EButtonGroupAction must have either an icon or a label.',
  );

  final Widget? icon;
  final Widget? checkedIcon;
  final Widget? label;
  final Widget? checkedLabel;
  final bool? checked;
  final bool enabled;
  final M3EToggleButtonDecoration? decoration;
  final double? width;
  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChange;
  final String? semanticLabel;
  final String? tooltip;
  final bool? enableFeedback;
}
