import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3EDialog`, following the Material 3 dialog specs.
///
/// See https://m3.material.io/components/dialogs/specs.
class M3EDialogTokens {
  const M3EDialogTokens._();

  /// Width constraints of a basic dialog.
  static const double minWidth = 280;
  static const double maxWidth = 560;

  /// Padding around the dialog content.
  static const EdgeInsets padding = EdgeInsets.all(24);

  /// Container corner radius (M3 extra-large shape).
  static BorderRadius get borderRadius => M3EShapes.radiusExtraLarge;

  /// Icon glyph size in the header.
  static const double iconSize = 24;

  /// Vertical gaps within the dialog body.
  static const double gapAfterIcon = 16;
  static const double gapAfterTitle = 16;
  static const double gapBeforeActions = 24;
  static const double actionGap = 8;

  /// Height of the full-screen dialog header.
  static const double fullScreenHeaderHeight = 64;

  /// Scrim opacity behind a modal dialog.
  static const double scrimOpacity = 0.32;

  /// Basic dialog container color.
  static Color containerColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHigh;

  /// Full-screen dialog background color.
  static Color fullScreenBackground(M3EColorScheme scheme) => scheme.surface;

  /// Scrim color behind a modal dialog.
  static Color scrimColor(M3EColorScheme scheme) =>
      scheme.scrim.withValues(alpha: scrimOpacity);
}
