import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';

/// Theme values for [M3ETooltip].
@immutable
class M3ETooltipTheme extends M3EThemeExtension<M3ETooltipTheme> {
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

  static const M3ETooltipTheme defaults = M3ETooltipTheme();

  final double anchorOffset;
  final double plainMaxWidth;
  final EdgeInsets plainPadding;
  final double richMaxWidth;
  final EdgeInsets richPadding;
  final double richTitleGap;
  final double richActionsGap;
  final double richElevation;

  Duration get plainDismissDelay => M3EMotion.extraLong4;

  BorderRadius get plainBorderRadius => M3EShapes.radiusExtraSmall;

  BorderRadius get richBorderRadius => M3EShapes.radiusMedium;

  Color plainContainerColor(M3EColorScheme scheme) => scheme.inverseSurface;

  TextStyle plainMessageStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodySmall.copyWith(color: scheme.onInverseSurface);

  Color richContainerColor(M3EColorScheme scheme) => scheme.surfaceContainer;

  TextStyle richTitleStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.titleSmall.copyWith(color: scheme.onSurface);

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
