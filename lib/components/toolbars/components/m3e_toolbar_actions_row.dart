import 'package:flutter/material.dart';

import '../../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../models/m3e_toolbar_action.dart';
import 'm3e_toolbar_icon_button.dart';
import 'm3e_toolbar_overflow_menu.dart';

/// Inline and overflow actions for [M3EToolbar].
class M3EToolbarActionsRow extends StatelessWidget {
  const M3EToolbarActionsRow({
    required this.actions,
    required this.maxInline,
    required this.overflowIcon,
    required this.iconButtonSize,
    required this.overflowTextStyle,
    required this.destructiveColor,
    super.key,
  });

  final List<M3EToolbarAction> actions;
  final int maxInline;
  final Widget overflowIcon;
  final M3EIconButtonSize iconButtonSize;
  final TextStyle overflowTextStyle;
  final Color destructiveColor;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    final List<M3EToolbarAction> inline =
        actions.take(maxInline).toList(growable: false);
    final List<M3EToolbarAction> overflow = actions.length > maxInline
        ? actions.sublist(maxInline)
        : const <M3EToolbarAction>[];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final M3EToolbarAction action in inline)
          M3EToolbarIconButton(
            action: action,
            size: iconButtonSize,
          ),
        if (overflow.isNotEmpty)
          M3EToolbarOverflowMenu(
            actions: overflow,
            icon: overflowIcon,
            iconButtonSize: iconButtonSize,
            textStyle: overflowTextStyle,
            destructiveColor: destructiveColor,
          ),
      ],
    );
  }
}
