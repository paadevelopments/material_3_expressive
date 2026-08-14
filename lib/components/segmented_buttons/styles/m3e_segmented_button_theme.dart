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
    this.outlineColor,
    this.outlineGradient,
    this.dividerColor,
    this.dividerGradient,
    this.selectedBackgroundGradient,
    this.unselectedBackgroundGradient,
    this.selectedForegroundColor,
    this.unselectedForegroundColor,
    this.selectedForegroundGradient,
    this.unselectedForegroundGradient,
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

  /// Group outline color. Defaults to the color scheme outline.
  final Color? outlineColor;

  /// Optional gradient for the group outline ring.
  final Gradient? outlineGradient;

  /// Divider color between segments. Defaults to the group outline color.
  final Color? dividerColor;

  /// Optional gradient for the dividers, sampled across the whole group.
  final Gradient? dividerGradient;

  /// Optional gradient for selected segments.
  final Gradient? selectedBackgroundGradient;

  /// Optional gradient for unselected segments.
  final Gradient? unselectedBackgroundGradient;

  /// Optional solid color for selected labels and icons.
  final Color? selectedForegroundColor;

  /// Optional solid color for unselected labels and icons.
  final Color? unselectedForegroundColor;

  /// Optional gradient for selected labels and icons.
  final Gradient? selectedForegroundGradient;

  /// Optional gradient for unselected labels and icons.
  final Gradient? unselectedForegroundGradient;

  /// The borderRadius.

  BorderRadius get borderRadius => M3EShapes.resolve(height / 2);

  /// Solid outline color for the group ring.
  Color outline(M3EColorScheme scheme) => outlineColor ?? scheme.outline;

  /// Solid divider color between segments.
  Color divider(M3EColorScheme scheme) => dividerColor ?? outline(scheme);

  /// foregroundColor.

  Color foregroundColor(M3EColorScheme scheme, {required bool selected}) {
    if (selected) {
      return selectedForegroundColor ?? scheme.onSecondaryContainer;
    }
    return unselectedForegroundColor ?? scheme.onSurface;
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
    Color? outlineColor,
    Gradient? outlineGradient,
    Color? dividerColor,
    Gradient? dividerGradient,
    Gradient? selectedBackgroundGradient,
    Gradient? unselectedBackgroundGradient,
    Color? selectedForegroundColor,
    Color? unselectedForegroundColor,
    Gradient? selectedForegroundGradient,
    Gradient? unselectedForegroundGradient,
  }) {
    return M3ESegmentedButtonTheme(
      height: height ?? this.height,
      iconSize: iconSize ?? this.iconSize,
      segmentHorizontalPadding:
          segmentHorizontalPadding ?? this.segmentHorizontalPadding,
      iconLabelGap: iconLabelGap ?? this.iconLabelGap,
      borderWidth: borderWidth ?? this.borderWidth,
      outlineColor: outlineColor ?? this.outlineColor,
      outlineGradient: outlineGradient ?? this.outlineGradient,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerGradient: dividerGradient ?? this.dividerGradient,
      selectedBackgroundGradient:
          selectedBackgroundGradient ?? this.selectedBackgroundGradient,
      unselectedBackgroundGradient:
          unselectedBackgroundGradient ?? this.unselectedBackgroundGradient,
      selectedForegroundColor:
          selectedForegroundColor ?? this.selectedForegroundColor,
      unselectedForegroundColor:
          unselectedForegroundColor ?? this.unselectedForegroundColor,
      selectedForegroundGradient:
          selectedForegroundGradient ?? this.selectedForegroundGradient,
      unselectedForegroundGradient:
          unselectedForegroundGradient ?? this.unselectedForegroundGradient,
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
      outlineColor: Color.lerp(outlineColor, other.outlineColor, t),
      outlineGradient: t < 0.5 ? outlineGradient : other.outlineGradient,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      dividerGradient: t < 0.5 ? dividerGradient : other.dividerGradient,
      selectedBackgroundGradient: t < 0.5
          ? selectedBackgroundGradient
          : other.selectedBackgroundGradient,
      unselectedBackgroundGradient: t < 0.5
          ? unselectedBackgroundGradient
          : other.unselectedBackgroundGradient,
      selectedForegroundColor: Color.lerp(
        selectedForegroundColor,
        other.selectedForegroundColor,
        t,
      ),
      unselectedForegroundColor: Color.lerp(
        unselectedForegroundColor,
        other.unselectedForegroundColor,
        t,
      ),
      selectedForegroundGradient: t < 0.5
          ? selectedForegroundGradient
          : other.selectedForegroundGradient,
      unselectedForegroundGradient: t < 0.5
          ? unselectedForegroundGradient
          : other.unselectedForegroundGradient,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
