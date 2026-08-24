import 'package:material_3_expressive/components/toggle_button_group/m3e_toggle_button_group.dart'
    show M3EButtonGroup;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3EButtonGroup;
import 'package:material_ui/material_ui.dart';

import '../../buttons/styles/m3e_button_decoration.dart';

/// Declarative description of a single toggle button inside [M3EButtonGroup].
class M3EButtonGroupAction {
  /// M3EButtonGroupAction.
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

  /// icon.

  final Widget? icon;

  /// checkedIcon.
  final Widget? checkedIcon;

  /// label.
  final Widget? label;

  /// checkedLabel.
  final Widget? checkedLabel;

  /// checked.
  final bool? checked;

  /// enabled.
  final bool enabled;

  /// decoration.
  final M3EToggleButtonDecoration? decoration;

  /// width.
  final double? width;

  /// focusNode.
  final FocusNode? focusNode;

  /// autofocus.
  final bool autofocus;

  /// onFocusChange.
  final ValueChanged<bool>? onFocusChange;

  /// semanticLabel.
  final String? semanticLabel;

  /// tooltip.
  final String? tooltip;

  /// enableFeedback.
  final bool? enableFeedback;
}
