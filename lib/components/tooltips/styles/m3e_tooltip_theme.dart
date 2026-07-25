import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ETooltip`.
@immutable
class M3ETooltipTheme extends M3EThemeExtension<M3ETooltipTheme> {
  /// M3ETooltipTheme.
  const M3ETooltipTheme({
    this.anchorOffset = 4,
    this.plainMaxWidth = 200,
    this.plainPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.richMaxWidth = 320,
    this.richPadding = const EdgeInsets.all(16),
    this.richTitleGap = 4,
    this.richActionsGap = 12,
    this.richElevation = M3EElevation.level2,
  });

  /// defaults.

  static const M3ETooltipTheme defaults = M3ETooltipTheme();

  /// anchorOffset.

  final double anchorOffset;

  /// plainMaxWidth.
  final double plainMaxWidth;

  /// plainPadding.
  final EdgeInsets plainPadding;

  /// richMaxWidth.
  final double richMaxWidth;

  /// richPadding.
  final EdgeInsets richPadding;

  /// richTitleGap.
  final double richTitleGap;

  /// richActionsGap.
  final double richActionsGap;

  /// richElevation.
  final double richElevation;

  /// The plainDismissDelay.

  Duration get plainDismissDelay => M3EMotion.extraLong4;

  /// The plainBorderRadius.

  BorderRadius get plainBorderRadius => M3EShapes.radiusExtraSmall;

  /// The richBorderRadius.

  BorderRadius get richBorderRadius => M3EShapes.radiusMedium;

  /// plainContainerColor.

  Color plainContainerColor(M3EColorScheme scheme) => scheme.inverseSurface;

  /// plainMessageStyle.

  TextStyle plainMessageStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodySmall.copyWith(color: scheme.onInverseSurface);

  /// richContainerColor.

  Color richContainerColor(M3EColorScheme scheme) => scheme.surfaceContainer;

  /// richTitleStyle.

  TextStyle richTitleStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.titleSmall.copyWith(color: scheme.onSurface);

  /// richBodyStyle.

  TextStyle richBodyStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyMedium.copyWith(color: scheme.onSurfaceVariant);

  @override
  M3ETooltipTheme copyWith({
    double? anchorOffset,
    double? plainMaxWidth,
    EdgeInsets? plainPadding,
    double? richMaxWidth,
    EdgeInsets? richPadding,
    double? richTitleGap,
    double? richActionsGap,
    double? richElevation,
  }) {
    return M3ETooltipTheme(
      anchorOffset: anchorOffset ?? this.anchorOffset,
      plainMaxWidth: plainMaxWidth ?? this.plainMaxWidth,
      plainPadding: plainPadding ?? this.plainPadding,
      richMaxWidth: richMaxWidth ?? this.richMaxWidth,
      richPadding: richPadding ?? this.richPadding,
      richTitleGap: richTitleGap ?? this.richTitleGap,
      richActionsGap: richActionsGap ?? this.richActionsGap,
      richElevation: richElevation ?? this.richElevation,
    );
  }

  @override
  M3ETooltipTheme lerp(M3ETooltipTheme? other, double t) {
    if (other is! M3ETooltipTheme) {
      return this;
    }
    return M3ETooltipTheme(
      anchorOffset: _lerpDouble(anchorOffset, other.anchorOffset, t)!,
      plainMaxWidth: _lerpDouble(plainMaxWidth, other.plainMaxWidth, t)!,
      plainPadding: EdgeInsets.lerp(plainPadding, other.plainPadding, t)!,
      richMaxWidth: _lerpDouble(richMaxWidth, other.richMaxWidth, t)!,
      richPadding: EdgeInsets.lerp(richPadding, other.richPadding, t)!,
      richTitleGap: _lerpDouble(richTitleGap, other.richTitleGap, t)!,
      richActionsGap: _lerpDouble(richActionsGap, other.richActionsGap, t)!,
      richElevation: _lerpDouble(richElevation, other.richElevation, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
