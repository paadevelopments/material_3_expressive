import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/toolbars/m3e_toolbars.dart' show M3EToolbar;
import 'package:material_3_expressive/material_3_expressive.dart' show M3EToolbar;

import '../../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';
import '../models/m3e_toolbar_action.dart';

/// Inline icon action for [M3EToolbar].
class M3EToolbarIconButton extends StatelessWidget {
  const M3EToolbarIconButton({
    required this.action,
    required this.size,
    super.key,
  });

  final M3EToolbarAction action;
  final M3EIconButtonSize size;

  @override
  Widget build(BuildContext context) {
    return M3EIconButton(
      icon: Icon(action.icon),
      onPressed: action.enabled ? action.onPressed : null,
      tooltip: action.tooltip ?? action.label,
      semanticLabel: action.semanticLabel,
      size: size,
    );
  }
}
