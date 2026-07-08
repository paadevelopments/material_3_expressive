import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';

/// Theme values for [M3EFabMenu].
@immutable
class M3EFabMenuTheme extends M3EThemeExtension<M3EFabMenuTheme> {
  const M3EFabMenuTheme({
    this.menuOffset = 16,
    this.scrimOpacity = 0.32,
    this.itemGap = 12,
    this.itemHeight = 56,
    this.itemHorizontalPadding = 20,
    this.iconSize = 24,
    this.iconLabelGap = 12,
    this.itemElevation = M3EElevation.level3,
  });

  static const M3EFabMenuTheme defaults = M3EFabMenuTheme();

  final double menuOffset;
  final double scrimOpacity;
  final double itemGap;
  final double itemHeight;
  final double itemHorizontalPadding;
  final double iconSize;
  final double iconLabelGap;
  final double itemElevation;

  Color scrimColor(M3EColorScheme scheme) =>
      scheme.scrim.withValues(alpha: scrimOpacity);

  Color itemContainerColor(M3EColorScheme scheme) => scheme.primaryContainer;

  Color itemForegroundColor(M3EColorScheme scheme) => scheme.onPrimaryContainer;

  TextStyle itemLabelStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.titleMedium.copyWith(color: itemForegroundColor(scheme));

  @override
  M3EFabMenuTheme copyWith({
    double? menuOffset,
    double? scrimOpacity,
    double? itemGap,
    double? itemHeight,
    double? itemHorizontalPadding,
    double? iconSize,
    double? iconLabelGap,
    double? itemElevation,
  }) {
    return M3EFabMenuTheme(
      menuOffset: menuOffset ?? this.menuOffset,
      scrimOpacity: scrimOpacity ?? this.scrimOpacity,
      itemGap: itemGap ?? this.itemGap,
      itemHeight: itemHeight ?? this.itemHeight,
      itemHorizontalPadding:
          itemHorizontalPadding ?? this.itemHorizontalPadding,
      iconSize: iconSize ?? this.iconSize,
      iconLabelGap: iconLabelGap ?? this.iconLabelGap,
      itemElevation: itemElevation ?? this.itemElevation,
    );
  }

  @override
  M3EFabMenuTheme lerp(M3EFabMenuTheme? other, double t) {
    if (other is! M3EFabMenuTheme) {
      return this;
    }
    return M3EFabMenuTheme(
      menuOffset: _lerpDouble(menuOffset, other.menuOffset, t)!,
      scrimOpacity: _lerpDouble(scrimOpacity, other.scrimOpacity, t)!,
      itemGap: _lerpDouble(itemGap, other.itemGap, t)!,
      itemHeight: _lerpDouble(itemHeight, other.itemHeight, t)!,
      itemHorizontalPadding:
          _lerpDouble(itemHorizontalPadding, other.itemHorizontalPadding, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      iconLabelGap: _lerpDouble(iconLabelGap, other.iconLabelGap, t)!,
      itemElevation: _lerpDouble(itemElevation, other.itemElevation, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
