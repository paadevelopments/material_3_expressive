import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ENavigationDrawer`.
@immutable
class M3ENavigationDrawerTheme
    extends M3EThemeExtension<M3ENavigationDrawerTheme> {
  /// M3ENavigationDrawerTheme.
  const M3ENavigationDrawerTheme({
    this.width = 360,
    this.destinationHeight = 56,
    this.headlineHorizontalPadding = 28,
    this.headlineVerticalPadding = 16,
    this.iconSize = 24,
    this.destinationHorizontalPadding = 12,
    this.destinationVerticalPadding = 2,
    this.destinationInnerHorizontalPadding = 16,
    this.iconLabelGap = 12,
  });

  /// defaults.

  static const M3ENavigationDrawerTheme defaults = M3ENavigationDrawerTheme();

  /// width.

  final double width;

  /// destinationHeight.
  final double destinationHeight;

  /// headlineHorizontalPadding.
  final double headlineHorizontalPadding;

  /// headlineVerticalPadding.
  final double headlineVerticalPadding;

  /// iconSize.
  final double iconSize;

  /// destinationHorizontalPadding.
  final double destinationHorizontalPadding;

  /// destinationVerticalPadding.
  final double destinationVerticalPadding;

  /// destinationInnerHorizontalPadding.
  final double destinationInnerHorizontalPadding;

  /// iconLabelGap.
  final double iconLabelGap;

  /// containerColor.

  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainerLow;

  /// destinationForegroundColor.

  Color destinationForegroundColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) => selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;

  /// destinationBackgroundColor.

  Color destinationBackgroundColor(
    M3EColorScheme scheme, {
    required bool selected,
  }) => selected ? scheme.secondaryContainer : const Color(0x00000000);

  /// destinationShape.

  ShapeBorder destinationShape() {
    return RoundedRectangleBorder(borderRadius: M3EShapes.resolve(28));
  }

  @override
  M3ENavigationDrawerTheme copyWith({
    double? width,
    double? destinationHeight,
    double? headlineHorizontalPadding,
    double? headlineVerticalPadding,
    double? iconSize,
    double? destinationHorizontalPadding,
    double? destinationVerticalPadding,
    double? destinationInnerHorizontalPadding,
    double? iconLabelGap,
  }) {
    return M3ENavigationDrawerTheme(
      width: width ?? this.width,
      destinationHeight: destinationHeight ?? this.destinationHeight,
      headlineHorizontalPadding:
          headlineHorizontalPadding ?? this.headlineHorizontalPadding,
      headlineVerticalPadding:
          headlineVerticalPadding ?? this.headlineVerticalPadding,
      iconSize: iconSize ?? this.iconSize,
      destinationHorizontalPadding:
          destinationHorizontalPadding ?? this.destinationHorizontalPadding,
      destinationVerticalPadding:
          destinationVerticalPadding ?? this.destinationVerticalPadding,
      destinationInnerHorizontalPadding:
          destinationInnerHorizontalPadding ??
          this.destinationInnerHorizontalPadding,
      iconLabelGap: iconLabelGap ?? this.iconLabelGap,
    );
  }

  @override
  M3ENavigationDrawerTheme lerp(M3ENavigationDrawerTheme? other, double t) {
    if (other is! M3ENavigationDrawerTheme) {
      return this;
    }
    return M3ENavigationDrawerTheme(
      width: _lerpDouble(width, other.width, t)!,
      destinationHeight: _lerpDouble(
        destinationHeight,
        other.destinationHeight,
        t,
      )!,
      headlineHorizontalPadding: _lerpDouble(
        headlineHorizontalPadding,
        other.headlineHorizontalPadding,
        t,
      )!,
      headlineVerticalPadding: _lerpDouble(
        headlineVerticalPadding,
        other.headlineVerticalPadding,
        t,
      )!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      destinationHorizontalPadding: _lerpDouble(
        destinationHorizontalPadding,
        other.destinationHorizontalPadding,
        t,
      )!,
      destinationVerticalPadding: _lerpDouble(
        destinationVerticalPadding,
        other.destinationVerticalPadding,
        t,
      )!,
      destinationInnerHorizontalPadding: _lerpDouble(
        destinationInnerHorizontalPadding,
        other.destinationInnerHorizontalPadding,
        t,
      )!,
      iconLabelGap: _lerpDouble(iconLabelGap, other.iconLabelGap, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
