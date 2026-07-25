import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';

/// Header for time picker dialogs.
class M3ETimePickerHeader extends StatelessWidget {
  /// M3ETimePickerHeader.
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

  /// helpText.

  final String helpText;

  /// titleText.
  final String titleText;

  /// showTitle.
  final bool showTitle;

  /// titleSemanticsLabel.
  final String? titleSemanticsLabel;

  /// orientation.
  final Orientation orientation;

  /// isShort.
  final bool isShort;

  /// entryModeButton.
  final Widget? entryModeButton;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final timeTheme = theme.timePickerTheme;
    final dialogTheme = theme.dialogTheme;
    final scheme = theme.colorScheme;
    final TextStyle helpStyle = timeTheme.headerHelpStyle(
      theme.typeScale,
      scheme,
    );
    final TextStyle titleStyle = (isShort
        ? timeTheme.headerHeadlineShortStyle
        : timeTheme.headerHeadlineStyle)(theme.typeScale, scheme);

    final Widget title = Semantics(
      label: titleSemanticsLabel ?? titleText,
      child: Text(titleText, style: titleStyle),
    );

    final Widget help = Text(helpText, style: helpStyle);

    final Widget helpRow = Row(
      children: <Widget>[
        Expanded(child: help),
        ?entryModeButton,
      ],
    );

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
                helpRow,
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
            helpRow,
            Visibility(visible: showTitle, child: title),
          ],
        ),
      ),
    );
  }
}

/// Icon button that switches time picker entry mode.
class M3ETimePickerEntryModeButton extends StatelessWidget {
  /// M3ETimePickerEntryModeButton.
  const M3ETimePickerEntryModeButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  /// icon.

  final IconData icon;

  /// tooltip.
  final String tooltip;

  /// onPressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return M3EIconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
