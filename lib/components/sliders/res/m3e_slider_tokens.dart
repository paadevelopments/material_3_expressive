// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// SliderTokens.kt (v2_3_5)
// Copyright (c) The Android Open Source Project
// Licensed under the Apache License, Version 2.0

/// Numeric constants matching Compose Material 3 [SliderTokens].
abstract final class M3ESliderTokens {
  const M3ESliderTokens._();

  static const double activeHandleHeight = 44;
  static const double activeHandleWidth = 4;
  static const double handleHeight = 44;
  static const double handleWidth = 4;
  static const double pressedHandleWidth = 2;
  static const double focusHandleWidth = 2;
  static const double hoverHandleWidth = 4;

  static const double activeTrackHeight = 16;
  static const double inactiveTrackHeight = 16;

  /// Gap between the handle edge and the track segments.
  static const double thumbTrackGapSize = 6;

  /// Corner radius on track ends facing the handle gap.
  static const double trackInsideCornerSize = 2;

  static const double stopIndicatorSize = 4;
  static const double tickSize = 4;
  static const double stopIndicatorTrailingSpace = 6;

  static const double valueIndicatorActiveBottomSpace = 12;

  static const double disabledHandleOpacity = 0.38;
  static const double disabledActiveTrackOpacity = 0.38;
  static const double disabledInactiveTrackOpacity = 0.12;

  /// Vertical thumb is the horizontal size swapped (44×4).
  static const double verticalHandleWidth = handleHeight;
  static const double verticalHandleHeight = handleWidth;
  static const double verticalPressedHandleHeight = pressedHandleWidth;
}
