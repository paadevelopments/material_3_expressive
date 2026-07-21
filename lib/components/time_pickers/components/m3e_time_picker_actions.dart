import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../buttons/enums/m3e_button_enums.dart';
import '../../buttons/m3e_buttons.dart';

/// Cancel and confirm actions for time picker dialogs.
class M3ETimePickerActions extends StatelessWidget {
  const M3ETimePickerActions({
    required this.onCancel,
    required this.onConfirm,
    required this.cancelText,
    required this.confirmText,
    super.key,
  });

  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final String cancelText;
  final String confirmText;

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
            M3EButton(
              onPressed: onConfirm,
              child: Text(confirmText),
            ),
          ],
        ),
      ),
    );
  }
}
