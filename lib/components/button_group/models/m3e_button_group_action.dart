import 'package:material_3_expressive/components/button_group/m3e_button_group.dart'
    show M3EButtonGroup;
import 'package:material_ui/material_ui.dart';

import '../../buttons/styles/m3e_button_decoration.dart';

/// Declarative description of a single selectable button in [M3EButtonGroup].
class M3EButtonGroupAction {
  /// M3EButtonGroupAction.
  const M3EButtonGroupAction({
    this.icon,
    this.selectedIcon,
    this.label,
    this.selectedLabel,
    this.isSelected,
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

  /// Icon displayed when selected.
  final Widget? selectedIcon;

  /// label.
  final Widget? label;

  /// Label displayed when selected.
  final Widget? selectedLabel;

  /// Selection state used when the group is not controlled.
  final bool? isSelected;

  /// enabled.
  final bool enabled;

  /// decoration.
  final M3EButtonDecoration? decoration;

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
