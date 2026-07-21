import 'package:flutter/widgets.dart';

/// Layout constants for M3E date picker dialogs and calendars.
abstract final class M3EDatePickerConstants {
  const M3EDatePickerConstants._();

  static const Size calendarPortraitDialogSize = Size(360, 568);
  static const Size calendarLandscapeDialogSize = Size(496, 346);
  static const Size inputPortraitDialogSize = Size(328, 270);
  static const Size inputLandscapeDialogSize = Size(496, 160);
  static const Size inputRangeLandscapeDialogSize = Size(496, 164);

  static const Duration dialogSizeAnimationDuration = Duration(milliseconds: 200);
  static const Duration monthScrollDuration = Duration(milliseconds: 200);

  static const double inputFormPortraitHeight = 98;
  static const double inputFormLandscapeHeight = 108;

  static const double maxTextScaleFactor = 3;
  static const double maxRangeTextScaleFactor = 1.3;
  static const double maxHeaderTextScaleFactor = 1.6;
  static const double maxHeaderWithEntryTextScaleFactor = 1.4;
  static const double maxHelpPortraitTextScaleFactor = 1.6;
  static const double maxHelpLandscapeTextScaleFactor = 1.4;
  static const double fontSizeToScale = 14;

  static const double dayPickerRowHeight = 48;
  static const int maxDayPickerRowCount = 6;
  static const double maxDayPickerHeight =
      dayPickerRowHeight * (maxDayPickerRowCount + 1);

  static const double monthPickerHorizontalPaddingPortrait = 12;
  static const double monthPickerHorizontalPaddingOther = 8;
  static const double monthNavButtonsWidth = 108;

  static const int yearPickerColumnCount = 3;
  static const double yearPickerPadding = 16;
  static const double yearPickerRowHeight = 52;
  static const double yearPickerRowSpacing = 8;

  static const double subHeaderHeight = 52;
  static const double headerPortraitHeight = 120;
  static const double headerLandscapeWidth = 152;
  static const double headerPaddingLandscape = 16;
  static const double actionsMinHeight = 52;

  /// Calendar body height inside portrait dialogs at minimum header height.
  static const double dialogPickerBodyHeight = 395;

  static const EdgeInsets defaultInsetPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 24);

  static const double modeToggleButtonMaxScaleFactor = 2;
  static const double dayPickerGridPortraitMaxScaleFactor = 2;
  static const double dayPickerGridLandscapeMaxScaleFactor = 1.5;
}
