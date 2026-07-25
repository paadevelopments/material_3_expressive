import 'package:flutter/widgets.dart';

/// Layout constants for M3E time picker dialogs and dials.
abstract final class M3ETimePickerConstants {
  const M3ETimePickerConstants._();

  /// dialPortraitDialogSize.

  static const Size dialPortraitDialogSize = Size(328, 520);

  /// dialLandscapeDialogSize.
  static const Size dialLandscapeDialogSize = Size(544, 346);

  /// inputPortraitDialogSize.
  static const Size inputPortraitDialogSize = Size(328, 270);

  /// inputLandscapeDialogSize.
  static const Size inputLandscapeDialogSize = Size(544, 248);

  /// dialogSizeAnimationDuration.

  static const Duration dialogSizeAnimationDuration = Duration(
    milliseconds: 200,
  );

  /// maxTextScaleFactor.

  static const double maxTextScaleFactor = 3;

  /// fontSizeToScale.
  static const double fontSizeToScale = 14;

  /// dialDialogBodyHeight.

  static const double dialDialogBodyHeight = 360;

  /// inputFormPortraitHeight.
  static const double inputFormPortraitHeight = 120;

  /// defaultInsetPadding.

  static const EdgeInsets defaultInsetPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 24,
  );
}
