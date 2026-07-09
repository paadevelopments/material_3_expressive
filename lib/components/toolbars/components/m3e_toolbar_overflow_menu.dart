import 'package:flutter/material.dart';

import '../../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';
import '../models/m3e_toolbar_action.dart';

/// Overflow menu for toolbar actions beyond the inline limit.
class M3EToolbarOverflowMenu extends StatelessWidget {
  const M3EToolbarOverflowMenu({
    required this.actions,
    required this.icon,
    required this.iconButtonSize,
    this.textStyle,
    this.destructiveColor,
    super.key,
  });

  final List<M3EToolbarAction> actions;
  final Widget icon;
  final M3EIconButtonSize iconButtonSize;
  final TextStyle? textStyle;
  final Color? destructiveColor;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'More options',
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<int>>[
          for (var i = 0; i < actions.length; i++)
            PopupMenuItem<int>(
              value: i,
              enabled: actions[i].enabled,
              child: DefaultTextStyle.merge(
                style: actions[i].isDestructive
                    ? (textStyle?.copyWith(color: destructiveColor) ??
                        TextStyle(color: destructiveColor))
                    : textStyle,
                child: Text(
                  actions[i].label ??
                      actions[i].tooltip ??
                      actions[i].semanticLabel ??
                      'Action ${i + 1}',
                ),
              ),
            ),
        ];
      },
      onSelected: (int index) => actions[index].onPressed(),
      child: M3EIconButton(
        icon: icon,
        size: iconButtonSize,
        tooltip: 'More options',
        variant: M3EIconButtonVariant.standard,
      ),
    );
  }
}
