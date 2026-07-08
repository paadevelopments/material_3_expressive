import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';

/// Theme values for [M3EBottomSheet].
@immutable
class M3EBottomSheetTheme extends M3EThemeExtension<M3EBottomSheetTheme> {
  const M3EBottomSheetTheme({
    this.maxWidth = 640,
    this.topCornerRadius = 28,
    this.handleWidth = 32,
    this.handleHeight = 4,
    this.handleCornerRadius = 2,
    this.handleVerticalPadding = 16,
    this.handleOpacity = 0.4,
    this.scrimOpacity = 0.32,
    this.dismissVelocity = 200,
  });

  static const M3EBottomSheetTheme defaults = M3EBottomSheetTheme();

  final double maxWidth;
  final double topCornerRadius;
  final double handleWidth;
  final double handleHeight;
  final double handleCornerRadius;
  final double handleVerticalPadding;
  final double handleOpacity;
  final double scrimOpacity;
  final double dismissVelocity;

  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainerLow;

  Color handleColor(M3EColorScheme scheme) =>
      M3EColorUtils.withOpacity(scheme.onSurfaceVariant, handleOpacity);

  Color scrimColor(M3EColorScheme scheme) =>
      scheme.scrim.withValues(alpha: scrimOpacity);

  @override
  M3EBottomSheetTheme copyWith({
    double? maxWidth,
    double? topCornerRadius,
    double? handleWidth,
    double? handleHeight,
    double? handleCornerRadius,
    double? handleVerticalPadding,
    double? handleOpacity,
    double? scrimOpacity,
    double? dismissVelocity,
  }) {
    return M3EBottomSheetTheme(
      maxWidth: maxWidth ?? this.maxWidth,
      topCornerRadius: topCornerRadius ?? this.topCornerRadius,
      handleWidth: handleWidth ?? this.handleWidth,
      handleHeight: handleHeight ?? this.handleHeight,
      handleCornerRadius: handleCornerRadius ?? this.handleCornerRadius,
      handleVerticalPadding:
          handleVerticalPadding ?? this.handleVerticalPadding,
      handleOpacity: handleOpacity ?? this.handleOpacity,
      scrimOpacity: scrimOpacity ?? this.scrimOpacity,
      dismissVelocity: dismissVelocity ?? this.dismissVelocity,
    );
  }

  @override
  M3EBottomSheetTheme lerp(M3EBottomSheetTheme? other, double t) {
    if (other is! M3EBottomSheetTheme) {
      return this;
    }
    return M3EBottomSheetTheme(
      maxWidth: _lerpDouble(maxWidth, other.maxWidth, t)!,
      topCornerRadius: _lerpDouble(topCornerRadius, other.topCornerRadius, t)!,
      handleWidth: _lerpDouble(handleWidth, other.handleWidth, t)!,
      handleHeight: _lerpDouble(handleHeight, other.handleHeight, t)!,
      handleCornerRadius:
          _lerpDouble(handleCornerRadius, other.handleCornerRadius, t)!,
      handleVerticalPadding:
          _lerpDouble(handleVerticalPadding, other.handleVerticalPadding, t)!,
      handleOpacity: _lerpDouble(handleOpacity, other.handleOpacity, t)!,
      scrimOpacity: _lerpDouble(scrimOpacity, other.scrimOpacity, t)!,
      dismissVelocity: _lerpDouble(dismissVelocity, other.dismissVelocity, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
