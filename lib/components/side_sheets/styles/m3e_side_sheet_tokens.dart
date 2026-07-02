import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3ESideSheet`, following the Material 3 side sheet specs.
///
/// See https://m3.material.io/components/side-sheets/specs.
class M3ESideSheetTokens {
  const M3ESideSheetTokens._();

  /// Width of the side sheet panel.
  static const double width = 320;

  /// Leading corner radius of the sheet (top-left and bottom-left).
  static const double cornerRadius = 28;

  /// Scrim opacity behind a modal side sheet.
  static const double scrimOpacity = 0.32;

  /// Header padding and close-button tap target padding.
  static const EdgeInsets headerPadding = EdgeInsets.fromLTRB(24, 16, 8, 16);
  static const EdgeInsets closeButtonPadding = EdgeInsets.all(12);

  /// Close icon size.
  static const double iconSize = 24;

  /// Padding around the action row.
  static const EdgeInsets actionsPadding = EdgeInsets.all(16);

  /// Container color of the sheet.
  static Color containerColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerLow;

  /// Scrim color behind a modal side sheet.
  static Color scrimColor(M3EColorScheme scheme) =>
      scheme.scrim.withValues(alpha: scrimOpacity);

  /// Title text style.
  static TextStyle titleStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.titleLarge.copyWith(color: scheme.onSurface);

  /// Divider color separating actions from the body.
  static Color dividerColor(M3EColorScheme scheme) => scheme.outlineVariant;
}
