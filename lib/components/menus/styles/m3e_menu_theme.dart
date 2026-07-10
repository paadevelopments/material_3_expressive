import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3EMenu`.
@immutable
class M3EMenuTheme extends M3EThemeExtension<M3EMenuTheme> {
  const M3EMenuTheme({
    this.minWidth = 112,
    this.maxWidth = 280,
    this.verticalPadding = 8,
    this.anchorOffset = 4,
    this.entryHeight = 48,
    this.entryHorizontalPadding = 12,
    this.iconSize = 24,
    this.iconGap = 12,
    this.elevation = M3EElevation.level2,
    this.disabledOpacity = 0.38,
  });

  static const M3EMenuTheme defaults = M3EMenuTheme();

  final double minWidth;
  final double maxWidth;
  final double verticalPadding;
  final double anchorOffset;
  final double entryHeight;
  final double entryHorizontalPadding;
  final double iconSize;
  final double iconGap;
  final double elevation;
  final double disabledOpacity;

  BorderRadius get borderRadius => M3EShapes.radiusExtraSmall;

  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainer;

  Color entryForegroundColor(
    M3EColorScheme scheme, {
    required bool enabled,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledOpacity);
    }
    return scheme.onSurface;
  }

  TextStyle entryLabelStyle(
    M3ETypeScale type,
    M3EColorScheme scheme, {
    required bool enabled,
  }) =>
      type.labelLarge.copyWith(
        color: entryForegroundColor(scheme, enabled: enabled),
      );

  @override
  M3EMenuTheme copyWith({
    double? minWidth,
    double? maxWidth,
    double? verticalPadding,
    double? anchorOffset,
    double? entryHeight,
    double? entryHorizontalPadding,
    double? iconSize,
    double? iconGap,
    double? elevation,
    double? disabledOpacity,
  }) {
    return M3EMenuTheme(
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      anchorOffset: anchorOffset ?? this.anchorOffset,
      entryHeight: entryHeight ?? this.entryHeight,
      entryHorizontalPadding:
          entryHorizontalPadding ?? this.entryHorizontalPadding,
      iconSize: iconSize ?? this.iconSize,
      iconGap: iconGap ?? this.iconGap,
      elevation: elevation ?? this.elevation,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
    );
  }

  @override
  M3EMenuTheme lerp(M3EMenuTheme? other, double t) {
    if (other is! M3EMenuTheme) {
      return this;
    }
    return M3EMenuTheme(
      minWidth: _lerpDouble(minWidth, other.minWidth, t)!,
      maxWidth: _lerpDouble(maxWidth, other.maxWidth, t)!,
      verticalPadding: _lerpDouble(verticalPadding, other.verticalPadding, t)!,
      anchorOffset: _lerpDouble(anchorOffset, other.anchorOffset, t)!,
      entryHeight: _lerpDouble(entryHeight, other.entryHeight, t)!,
      entryHorizontalPadding:
          _lerpDouble(entryHorizontalPadding, other.entryHorizontalPadding, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      iconGap: _lerpDouble(iconGap, other.iconGap, t)!,
      elevation: _lerpDouble(elevation, other.elevation, t)!,
      disabledOpacity: _lerpDouble(disabledOpacity, other.disabledOpacity, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
