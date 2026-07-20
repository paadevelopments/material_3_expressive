import 'package:flutter/animation.dart';

/// Shared constants for the M3E search bar and search view.
abstract final class M3ESearchConstants {
  static const int openViewMilliseconds = 600;
  static const Duration openViewDuration =
      Duration(milliseconds: openViewMilliseconds);
  static const Duration anchorFadeDuration = Duration(milliseconds: 150);

  static const Curve viewFadeOnInterval = Interval(0.0, 1 / 2);
  static const Curve viewIconsFadeOnInterval = Interval(1 / 6, 2 / 6);
  static const Curve viewDividerFadeOnInterval = Interval(0.0, 1 / 6);
  static const Curve viewListFadeOnInterval = Interval(
    133 / openViewMilliseconds,
    233 / openViewMilliseconds,
  );

  static const double disabledOpacity = 0.38;
  static const double fullScreenBarHeight = 72.0;

  static const String dismissBarrierLabel = 'Dismiss';
  static const String clearButtonTooltip = 'Clear';
  static const String backButtonTooltip = 'Back';
}
