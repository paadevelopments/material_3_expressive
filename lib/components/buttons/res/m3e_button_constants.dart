import 'package:flutter/services.dart';

import '../enums/m3e_button_enums.dart';

/// Shared numeric constants used throughout the button package.
abstract final class M3EButtonConstants {
  /// Minimum distance between any popup / dropdown and the screen edge (dp).
  static const double kScreenEdgePadding = 12.0;

  /// Spring progress threshold at which a pending press-release is committed.
  static const double kPressReleaseThreshold = 0.75;

  /// How long to wait for a press-release threshold before forcing a reset.
  static const Duration kReleaseTimeout = Duration(seconds: 1);

  /// Default natural-width fallback for icon-only buttons.
  static const double kIconOnlyNaturalSizeFallback = 40.0;

  /// Sentinel `index` for the overflow trigger button.
  static const int kOverflowTriggerScopeIndex = 999;

  /// Gap between the component edge and the focus ring outline (dp).
  static const double kFocusRingGap = 2.0;

  /// Stroke width of the focus ring outline (dp).
  static const double kFocusRingWidth = 2.0;

  /// Alpha value for disabled foreground color (text/icons).
  static const double kDisabledForegroundAlpha = 0.38;

  /// Alpha value for disabled background color.
  static const double kDisabledBackgroundAlpha = 0.12;

  /// Alpha value for disabled outline/border color.
  static const double kDisabledOutlineAlpha = 0.12;

  /// Ratio used to calculate pressed corner radius from square radius.
  static const double kPressedRadiusRatio = 0.6;

  /// Minimum pressed corner radius in dp.
  static const double kMinPressedRadius = 6.0;

  /// Maximum pressed corner radius in dp.
  static const double kMaxPressedRadius = 18.0;

  /// Minimum delta threshold for triggering animation progress update.
  static const double kAnimationDeltaThreshold = 0.5;

  /// Triggers haptic feedback for the selected [M3EHapticFeedback] level.
  static void triggerHapticFeedback(M3EHapticFeedback haptic) {
    switch (haptic) {
      case M3EHapticFeedback.light:
        HapticFeedback.lightImpact();
      case M3EHapticFeedback.medium:
        HapticFeedback.mediumImpact();
      case M3EHapticFeedback.heavy:
        HapticFeedback.heavyImpact();
      case M3EHapticFeedback.none:
        break;
    }
  }
}
