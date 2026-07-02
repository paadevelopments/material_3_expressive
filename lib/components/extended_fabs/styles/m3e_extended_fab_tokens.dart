import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3EExtendedFab`, following the Material 3 extended FAB specs.
///
/// See https://m3.material.io/components/extended-fab/specs.
class M3EExtendedFabTokens {
  const M3EExtendedFabTokens._();

  /// Height of the extended FAB.
  static const double height = 56;

  /// Corner radius (M3 large shape).
  static const double cornerRadius = 16;

  /// Horizontal padding when the label is visible / collapsed.
  static const double extendedHorizontalPadding = 20;
  static const double collapsedHorizontalPadding = 16;

  /// Icon glyph size.
  static const double iconSize = 24;

  /// Gap between icon and label.
  static const double iconLabelGap = 12;

  /// Scale applied while pressed.
  static const double pressedScale = 0.97;

  /// Resting and hover elevation.
  static double elevation({required bool hovered}) =>
      hovered ? M3EElevation.level4 : M3EElevation.level3;

  /// Label text style.
  static TextStyle labelStyle(M3ETypeScale type, Color foreground) =>
      type.labelLarge.copyWith(color: foreground);
}
