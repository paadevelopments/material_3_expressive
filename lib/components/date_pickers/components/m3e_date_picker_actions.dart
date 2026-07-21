import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../buttons/enums/m3e_button_enums.dart';
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
    final dialogTheme = M3ETheme.of(context).dialogTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dialogTheme.padding.left),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: M3EDatePickerConstants.actionsMinHeight,
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
      ),
    );
  }
}
