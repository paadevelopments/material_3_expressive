import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';
import '../res/m3e_date_picker_constants.dart';

/// Header for single- and range-date picker dialogs.
class M3EDatePickerHeader extends StatelessWidget {
  const M3EDatePickerHeader({
    required this.helpText,
    required this.titleText,
    required this.orientation,
    this.titleSemanticsLabel,
    this.isShort = false,
    this.entryModeButton,
    super.key,
  });

  final String helpText;
  final String titleText;
  final String? titleSemanticsLabel;
  final Orientation orientation;
  final bool isShort;
  final Widget? entryModeButton;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final dateTheme = theme.datePickerTheme;
    final scheme = theme.colorScheme;
    final TextStyle helpStyle =
        dateTheme.headerHelpStyle(theme.typeScale, scheme);
    final TextStyle titleStyle = (isShort
            ? dateTheme.headerHeadlineShortStyle
            : dateTheme.headerHeadlineStyle)(
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
        width: dateTheme.headerLandscapeWidth,
        child: ColoredBox(
          color: dateTheme.headerBackgroundColor(scheme),
          child: Padding(
            padding: const EdgeInsets.all(
              M3EDatePickerConstants.headerPaddingLandscape,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                help,
                if (entryModeButton != null)
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: entryModeButton,
                  ),
                title,
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(minHeight: dateTheme.headerPortraitHeight),
      color: dateTheme.headerBackgroundColor(scheme),
      padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 12, 12),
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
          const SizedBox(height: 12),
          title,
        ],
      ),
    );
  }
}

/// Icon button that switches date picker entry mode.
class M3EDatePickerEntryModeButton extends StatelessWidget {
  const M3EDatePickerEntryModeButton({
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
