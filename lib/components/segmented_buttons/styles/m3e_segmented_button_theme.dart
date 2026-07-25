import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ESegmentedButton`.
@immutable
class M3ESegmentedButtonTheme
    extends M3EThemeExtension<M3ESegmentedButtonTheme> {
  /// M3ESegmentedButtonTheme.
  const M3ESegmentedButtonTheme({
    this.height = 40,
    this.iconSize = 18,
    this.segmentHorizontalPadding = 12,
    this.iconLabelGap = 8,
    this.borderWidth = 1,
  });

  /// defaults.

  static const M3ESegmentedButtonTheme defaults = M3ESegmentedButtonTheme();

  /// height.

  final double height;

  /// iconSize.
  final double iconSize;

  /// segmentHorizontalPadding.
  final double segmentHorizontalPadding;

  /// iconLabelGap.
  final double iconLabelGap;

  /// borderWidth.
  final double borderWidth;

  /// The borderRadius.

  BorderRadius get borderRadius => M3EShapes.resolve(height / 2);

  /// foregroundColor.

  Color foregroundColor(M3EColorScheme scheme, {required bool selected}) {
    return selected ? scheme.onSecondaryContainer : scheme.onSurface;
  }

  /// backgroundColor.

  Color? backgroundColor(M3EColorScheme scheme, {required bool selected}) {
    return selected ? scheme.secondaryContainer : null;
  }

  @override
  M3ESegmentedButtonTheme copyWith({
    double? height,
    double? iconSize,
    double? segmentHorizontalPadding,
    double? iconLabelGap,
    double? borderWidth,
  }) {
    return M3ESegmentedButtonTheme(
      height: height ?? this.height,
      iconSize: iconSize ?? this.iconSize,
      segmentHorizontalPadding:
          segmentHorizontalPadding ?? this.segmentHorizontalPadding,
      iconLabelGap: iconLabelGap ?? this.iconLabelGap,
      borderWidth: borderWidth ?? this.borderWidth,
    );
  }

  @override
  M3ESegmentedButtonTheme lerp(M3ESegmentedButtonTheme? other, double t) {
    if (other is! M3ESegmentedButtonTheme) {
      return this;
    }
    return M3ESegmentedButtonTheme(
      height: _lerpDouble(height, other.height, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      segmentHorizontalPadding: _lerpDouble(
        segmentHorizontalPadding,
        other.segmentHorizontalPadding,
        t,
      )!,
      iconLabelGap: _lerpDouble(iconLabelGap, other.iconLabelGap, t)!,
      borderWidth: _lerpDouble(borderWidth, other.borderWidth, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
