import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../buttons/enums/m3e_button_enums.dart';
import '../../buttons/m3e_buttons.dart';

/// Cancel and confirm actions for date picker dialogs.
class M3EDatePickerActions extends StatelessWidget {
  /// M3EDatePickerActions.
  const M3EDatePickerActions({
    required this.onCancel,
    required this.onConfirm,
    required this.cancelText,
    required this.confirmText,
    this.entryModeButton,
    super.key,
  });

  /// onCancel.
  final VoidCallback onCancel;

  /// onConfirm.
  final VoidCallback onConfirm;

  /// cancelText.
  final String cancelText;

  /// confirmText.
  final String confirmText;

  /// Optional dial/input (or calendar/input) toggle at the far start.
  final Widget? entryModeButton;

  @override
  Widget build(BuildContext context) {
    final dialogTheme = M3ETheme.of(context).dialogTheme;
    final EdgeInsets padding = dialogTheme.padding;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        padding.left,
        0,
        padding.right,
        padding.bottom,
      ),
      child: Row(
        children: <Widget>[
          ?entryModeButton,
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  M3EButton(
                    style: M3EButtonStyle.text,
                    onPressed: onCancel,
                    child: Text(cancelText),
                  ),
                  SizedBox(width: dialogTheme.actionGap),
                  M3EButton(onPressed: onConfirm, child: Text(confirmText)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
