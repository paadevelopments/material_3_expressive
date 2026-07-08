import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';
import '../enums/m3e_chip_type.dart';

/// Theme values for [M3EChip].
@immutable
class M3EChipTheme extends M3EThemeExtension<M3EChipTheme> {
  const M3EChipTheme({
    this.height = 32,
    this.iconSize = 18,
    this.labelStartPadding = 16,
    this.iconStartPadding = 8,
    this.endPadding = 12,
    this.iconLabelGap = 8,
  });

  static const M3EChipTheme defaults = M3EChipTheme();

  final double height;
  final double iconSize;
  final double labelStartPadding;
  final double iconStartPadding;
  final double endPadding;
  final double iconLabelGap;

  BorderRadius get borderRadius => M3EShapes.radiusSmall;

  ShapeBorder get shape => RoundedRectangleBorder(borderRadius: borderRadius);

  Color containerColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool selected,
    required bool elevated,
    required M3EChipType type,
  }) {
    if (!enabled) {
      return selected
          ? M3EColorUtils.withOpacity(scheme.onSurface, 0.12)
          : const Color(0x00000000);
    }
    if (selected) {
      return scheme.secondaryContainer;
    }
    if (elevated) {
      return scheme.surfaceContainerLow;
    }
    return const Color(0x00000000);
  }

  Color foregroundColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool selected,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;
  }

  @override
  M3EChipTheme copyWith({
    double? height,
    double? iconSize,
    double? labelStartPadding,
    double? iconStartPadding,
    double? endPadding,
    double? iconLabelGap,
  }) {
    return M3EChipTheme(
      height: height ?? this.height,
      iconSize: iconSize ?? this.iconSize,
      labelStartPadding: labelStartPadding ?? this.labelStartPadding,
      iconStartPadding: iconStartPadding ?? this.iconStartPadding,
      endPadding: endPadding ?? this.endPadding,
      iconLabelGap: iconLabelGap ?? this.iconLabelGap,
    );
  }

  @override
  M3EChipTheme lerp(M3EChipTheme? other, double t) {
    if (other is! M3EChipTheme) {
      return this;
    }
    return M3EChipTheme(
      height: _lerpDouble(height, other.height, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      labelStartPadding:
          _lerpDouble(labelStartPadding, other.labelStartPadding, t)!,
      iconStartPadding:
          _lerpDouble(iconStartPadding, other.iconStartPadding, t)!,
      endPadding: _lerpDouble(endPadding, other.endPadding, t)!,
      iconLabelGap: _lerpDouble(iconLabelGap, other.iconLabelGap, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
