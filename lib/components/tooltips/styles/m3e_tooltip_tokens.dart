import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3ETooltip`, following the Material 3 tooltip specs.
///
/// See https://m3.material.io/components/tooltips/specs.
class M3ETooltipTokens {
  const M3ETooltipTokens._();

  /// Vertical offset between the anchor and the tooltip surface.
  static const double anchorOffset = 4;

  /// Auto-dismiss delay for plain tooltips.
  static Duration get plainDismissDelay => M3EMotion.extraLong4;

  /// Plain tooltip constraints and padding.
  static const double plainMaxWidth = 200;
  static const EdgeInsets plainPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  /// Rich tooltip constraints and padding.
  static const double richMaxWidth = 320;
  static const EdgeInsets richPadding = EdgeInsets.all(16);

  /// Vertical gaps within a rich tooltip.
  static const double richTitleGap = 4;
  static const double richActionsGap = 12;

  /// Elevation of the rich tooltip surface.
  static const double richElevation = M3EElevation.level2;

  /// Plain tooltip corner radius (M3 extra-small shape).
  static BorderRadius get plainBorderRadius => M3EShapes.radiusExtraSmall;

  /// Rich tooltip corner radius (M3 medium shape).
  static BorderRadius get richBorderRadius => M3EShapes.radiusMedium;

  /// Plain tooltip container color.
  static Color plainContainerColor(M3EColorScheme scheme) =>
      scheme.inverseSurface;

  /// Plain tooltip message text style.
  static TextStyle plainMessageStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodySmall.copyWith(color: scheme.onInverseSurface);

  /// Rich tooltip container color.
  static Color richContainerColor(M3EColorScheme scheme) =>
      scheme.surfaceContainer;

  /// Rich tooltip title text style.
  static TextStyle richTitleStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.titleSmall.copyWith(color: scheme.onSurface);

  /// Rich tooltip body text style.
  static TextStyle richBodyStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyMedium.copyWith(color: scheme.onSurfaceVariant);
}
