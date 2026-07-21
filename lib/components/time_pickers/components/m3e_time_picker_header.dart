import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';

/// Header for time picker dialogs.
class M3ETimePickerHeader extends StatelessWidget {
  const M3ETimePickerHeader({
    required this.helpText,
    required this.titleText,
    required this.showTitle,
    required this.orientation,
    this.titleSemanticsLabel,
    this.isShort = false,
    this.entryModeButton,
    super.key,
  });

  final String helpText;
  final String titleText;
  final bool showTitle;
  final String? titleSemanticsLabel;
  final Orientation orientation;
  final bool isShort;
  final Widget? entryModeButton;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final timeTheme = theme.timePickerTheme;
    final dialogTheme = theme.dialogTheme;
    final scheme = theme.colorScheme;
    final TextStyle helpStyle =
        timeTheme.headerHelpStyle(theme.typeScale, scheme);
    final TextStyle titleStyle = (isShort
            ? timeTheme.headerHeadlineShortStyle
            : timeTheme.headerHeadlineStyle)(
          theme.typeScale,
          scheme,
        );

    final Widget title = Semantics(
      label: titleSemanticsLabel ?? titleText,
      child: Text(titleText, style: titleStyle),
    );

    final Widget help = Text(helpText, style: helpStyle);

    if (orientation == Orientation.landscape) {
      return SizedBox(
        width: timeTheme.headerLandscapeWidth,
        child: ColoredBox(
          color: timeTheme.headerBackgroundColor(scheme),
          child: Padding(
            padding: dialogTheme.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                help,
                if (entryModeButton != null)
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: entryModeButton,
                  ),
                Visibility(visible: showTitle, child: title),
              ],
            ),
          ),
        ),
      );
    }

    return ColoredBox(
      color: timeTheme.headerBackgroundColor(scheme),
      child: Padding(
        padding: dialogTheme.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: help),
                ?entryModeButton,
              ],
            ),
            Visibility(visible: showTitle, child: title),
          ],
        ),
      ),
    );
  }
}

/// Icon button that switches time picker entry mode.
class M3ETimePickerEntryModeButton extends StatelessWidget {
  const M3ETimePickerEntryModeButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;
    return M3EIconButton(
      icon: Icon(icon, color: scheme.onSurfaceVariant),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
