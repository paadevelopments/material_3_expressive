import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../../buttons/m3e_buttons.dart';
import '../res/m3e_date_picker_constants.dart';

/// Cancel and confirm actions for date picker dialogs.
class M3EDatePickerActions extends StatelessWidget {
  const M3EDatePickerActions({
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
    final theme = M3ETheme.of(context);
    final dateTheme = theme.datePickerTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: M3EDatePickerConstants.actionsMinHeight,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dateTheme.actionHorizontalPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            M3EButton.text(
              onPressed: onCancel,
              child: Text(cancelText),
            ),
            SizedBox(width: dateTheme.actionSpacing),
            M3EButton.text(
              onPressed: onConfirm,
              child: Text(confirmText),
            ),
          ],
        ),
      ),
    );
  }
}
