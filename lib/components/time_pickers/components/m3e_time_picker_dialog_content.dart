import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Wraps time picker dialog body content with padding in input mode only.
class M3ETimePickerDialogContent extends StatelessWidget {
  const M3ETimePickerDialogContent({
    required this.isInputMode,
    required this.child,
    super.key,
  });

  final bool isInputMode;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!isInputMode) {
      return child;
    }
    return Padding(
      padding: M3ETheme.of(context).dialogTheme.padding,
      child: child,
    );
  }
}
