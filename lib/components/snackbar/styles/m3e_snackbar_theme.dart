import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ESnackbar`.
@immutable
class M3ESnackbarTheme extends M3EThemeExtension<M3ESnackbarTheme> {
  const M3ESnackbarTheme({
    this.minHeight = 48,
    this.maxWidth = 600,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.elevation = M3EElevation.level3,
    this.defaultDuration = const Duration(seconds: 4),
    this.overlayHorizontalInset = 16,
    this.overlayBottomInset = 16,
    this.actionPadding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.actionGap = 8,
  });

  static const M3ESnackbarTheme defaults = M3ESnackbarTheme();

  final double minHeight;
  final double maxWidth;
  final EdgeInsets contentPadding;
  final double elevation;
  final Duration defaultDuration;
  final double overlayHorizontalInset;
  final double overlayBottomInset;
  final EdgeInsets actionPadding;
  final double actionGap;

  BorderRadius get borderRadius => M3EShapes.radiusExtraSmall;

  Color containerColor(M3EColorScheme scheme) => scheme.inverseSurface;

  TextStyle messageStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyMedium.copyWith(color: scheme.onInverseSurface);

  TextStyle actionStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.labelLarge.copyWith(color: scheme.inversePrimary);

  @override
  M3ESnackbarTheme copyWith({
    double? minHeight,
    double? maxWidth,
    EdgeInsets? contentPadding,
    double? elevation,
    Duration? defaultDuration,
    double? overlayHorizontalInset,
    double? overlayBottomInset,
    EdgeInsets? actionPadding,
    double? actionGap,
  }) {
    return M3ESnackbarTheme(
      minHeight: minHeight ?? this.minHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      contentPadding: contentPadding ?? this.contentPadding,
      elevation: elevation ?? this.elevation,
      defaultDuration: defaultDuration ?? this.defaultDuration,
      overlayHorizontalInset:
          overlayHorizontalInset ?? this.overlayHorizontalInset,
      overlayBottomInset: overlayBottomInset ?? this.overlayBottomInset,
      actionPadding: actionPadding ?? this.actionPadding,
      actionGap: actionGap ?? this.actionGap,
    );
  }

  @override
  M3ESnackbarTheme lerp(M3ESnackbarTheme? other, double t) {
    if (other is! M3ESnackbarTheme) {
      return this;
    }
    return M3ESnackbarTheme(
      minHeight: _lerpDouble(minHeight, other.minHeight, t)!,
      maxWidth: _lerpDouble(maxWidth, other.maxWidth, t)!,
      contentPadding: EdgeInsets.lerp(contentPadding, other.contentPadding, t)!,
      elevation: _lerpDouble(elevation, other.elevation, t)!,
      defaultDuration: t < 0.5 ? defaultDuration : other.defaultDuration,
      overlayHorizontalInset: _lerpDouble(
        overlayHorizontalInset,
        other.overlayHorizontalInset,
        t,
      )!,
      overlayBottomInset:
          _lerpDouble(overlayBottomInset, other.overlayBottomInset, t)!,
      actionPadding: EdgeInsets.lerp(actionPadding, other.actionPadding, t)!,
      actionGap: _lerpDouble(actionGap, other.actionGap, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
