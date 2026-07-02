import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3EBottomSheet`, following the Material 3 specs.
///
/// See https://m3.material.io/components/bottom-sheets/specs.
class M3EBottomSheetTokens {
  const M3EBottomSheetTokens._();

  /// Maximum width of the sheet on large screens.
  static const double maxWidth = 640;

  /// Top corner radius of the sheet container.
  static const double topCornerRadius = 28;

  /// Drag handle dimensions.
  static const double handleWidth = 32;
  static const double handleHeight = 4;
  static const double handleCornerRadius = 2;
  static const double handleVerticalPadding = 16;

  /// Opacity applied to [M3EColorScheme.onSurfaceVariant] for the drag handle.
  static const double handleOpacity = 0.4;

  /// Scrim opacity behind a modal sheet.
  static const double scrimOpacity = 0.32;

  /// Minimum downward fling velocity that dismisses the sheet.
  static const double dismissVelocity = 200;

  /// Container color of the sheet.
  static Color containerColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerLow;

  /// Drag handle color.
  static Color handleColor(M3EColorScheme scheme) =>
      M3EColorUtils.withOpacity(scheme.onSurfaceVariant, handleOpacity);

  /// Scrim color behind a modal sheet.
  static Color scrimColor(M3EColorScheme scheme) =>
      scheme.scrim.withValues(alpha: scrimOpacity);
}
