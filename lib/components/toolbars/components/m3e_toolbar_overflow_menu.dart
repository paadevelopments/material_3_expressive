import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';
import '../../menus/m3e_menus.dart';
import '../models/m3e_toolbar_item.dart';

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
    final theme = M3ETheme.of(context);
    final errorColor = destructiveColor ?? theme.colorScheme.error;

    Widget menu = M3EMenu(
      position: M3EMenuAnchorPosition.bottomEnd,
      children: <M3EMenuNode>[
        for (var i = 0; i < actions.length; i++)
          M3EMenuEntry(
            label: actions[i].label ??
                actions[i].tooltip ??
                actions[i].semanticLabel ??
                'Action ${i + 1}',
            enabled: actions[i].enabled,
            isDestructive: actions[i].isDestructive,
            onPressed: actions[i].onPressed,
          ),
      ],
      anchorBuilder: (BuildContext context, VoidCallback open) {
        return M3EIconButton(
          icon: icon,
          size: iconButtonSize,
          tooltip: 'More options',
          onPressed: open,
        );
      },
    );

    if (textStyle != null) {
      menu = DefaultTextStyle.merge(style: textStyle!, child: menu);
    }

    // Tint destructive labels when a custom error color is supplied.
    if (destructiveColor != null) {
      menu = IconTheme.merge(
        data: IconThemeData(color: errorColor),
        child: menu,
      );
    }

    return menu;
  }
}
