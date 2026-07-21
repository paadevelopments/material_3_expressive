import 'package:flutter/widgets.dart';

/// Layout constants for M3E time picker dialogs and dials.
abstract final class M3ETimePickerConstants {
  const M3ETimePickerConstants._();

  static const Size dialPortraitDialogSize = Size(328, 520);
  static const Size dialLandscapeDialogSize = Size(496, 346);
  static const Size inputPortraitDialogSize = Size(328, 270);
  static const Size inputLandscapeDialogSize = Size(496, 160);

  static const Duration dialogSizeAnimationDuration =
      Duration(milliseconds: 200);

  static const double maxTextScaleFactor = 3;
  static const double fontSizeToScale = 14;

  static const double dialDialogBodyHeight = 360;
  static const double inputFormPortraitHeight = 120;

  static const EdgeInsets defaultInsetPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 24);
}
