import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ESideSheet`.
@immutable
class M3ESideSheetTheme extends M3EThemeExtension<M3ESideSheetTheme> {
  /// M3ESideSheetTheme.
  const M3ESideSheetTheme({
    this.width = 320,
    this.cornerRadius = 28,
    this.scrimOpacity = 0.32,
    this.headerPadding = const EdgeInsets.fromLTRB(24, 16, 8, 16),
    this.closeButtonPadding = const EdgeInsets.all(12),
    this.iconSize = 24,
    this.actionsPadding = const EdgeInsets.all(16),
  });

  /// defaults.

  static const M3ESideSheetTheme defaults = M3ESideSheetTheme();

  /// width.

  final double width;

  /// cornerRadius.
  final double cornerRadius;

  /// scrimOpacity.
  final double scrimOpacity;

  /// headerPadding.
  final EdgeInsets headerPadding;

  /// closeButtonPadding.
  final EdgeInsets closeButtonPadding;

  /// iconSize.
  final double iconSize;

  /// actionsPadding.
  final EdgeInsets actionsPadding;

  /// containerColor.

  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainerLow;

  /// scrimColor.

  Color scrimColor(M3EColorScheme scheme) =>
      scheme.scrim.withValues(alpha: scrimOpacity);

  /// titleStyle.

  TextStyle titleStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.titleLarge.copyWith(color: scheme.onSurface);

  /// dividerColor.

  Color dividerColor(M3EColorScheme scheme) => scheme.outlineVariant;

  @override
  M3ESideSheetTheme copyWith({
    double? width,
    double? cornerRadius,
    double? scrimOpacity,
    EdgeInsets? headerPadding,
    EdgeInsets? closeButtonPadding,
    double? iconSize,
    EdgeInsets? actionsPadding,
  }) {
    return M3ESideSheetTheme(
      width: width ?? this.width,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      scrimOpacity: scrimOpacity ?? this.scrimOpacity,
      headerPadding: headerPadding ?? this.headerPadding,
      closeButtonPadding: closeButtonPadding ?? this.closeButtonPadding,
      iconSize: iconSize ?? this.iconSize,
      actionsPadding: actionsPadding ?? this.actionsPadding,
    );
  }

  @override
  M3ESideSheetTheme lerp(M3ESideSheetTheme? other, double t) {
    if (other is! M3ESideSheetTheme) {
      return this;
    }
    return M3ESideSheetTheme(
      width: _lerpDouble(width, other.width, t)!,
      cornerRadius: _lerpDouble(cornerRadius, other.cornerRadius, t)!,
      scrimOpacity: _lerpDouble(scrimOpacity, other.scrimOpacity, t)!,
      headerPadding: EdgeInsets.lerp(headerPadding, other.headerPadding, t)!,
      closeButtonPadding: EdgeInsets.lerp(
        closeButtonPadding,
        other.closeButtonPadding,
        t,
      )!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      actionsPadding: EdgeInsets.lerp(actionsPadding, other.actionsPadding, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
