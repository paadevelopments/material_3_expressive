import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_fab.dart';

/// Resolved size and color metrics for a floating action button.
@immutable
class M3EFabMetrics {
  /// M3EFabMetrics.
  const M3EFabMetrics({
    required this.container,
    required this.iconSize,
    required this.radius,
    required this.background,
    required this.foreground,
  });

  /// container.

  final double container;

  /// iconSize.
  final double iconSize;

  /// radius.
  final double radius;

  /// background.
  final Color background;

  /// foreground.
  final Color foreground;
}

/// Theme values for the extended FAB variant.
@immutable
class M3EExtendedFabTheme {
  /// M3EExtendedFabTheme.
  const M3EExtendedFabTheme({
    this.height = 56,
    this.cornerRadius = 16,
    this.extendedHorizontalPadding = 20,
    this.collapsedHorizontalPadding = 16,
    this.iconSize = 24,
    this.iconLabelGap = 12,
    this.pressedScale = 0.97,
  });

  /// height.

  final double height;

  /// cornerRadius.
  final double cornerRadius;

  /// extendedHorizontalPadding.
  final double extendedHorizontalPadding;

  /// collapsedHorizontalPadding.
  final double collapsedHorizontalPadding;

  /// iconSize.
  final double iconSize;

  /// iconLabelGap.
  final double iconLabelGap;

  /// pressedScale.
  final double pressedScale;

  /// elevation.

  double elevation({required bool hovered}) =>
      hovered ? M3EElevation.level4 : M3EElevation.level3;

  /// labelStyle.

  TextStyle labelStyle(M3ETypeScale type, Color foreground) =>
      type.labelLarge.copyWith(color: foreground);
}

/// Theme values for `M3EFab` and `M3EExtendedFab`.
@immutable
class M3EFabTheme extends M3EThemeExtension<M3EFabTheme> {
  /// M3EFabTheme.
  const M3EFabTheme({
    this.pressedScale = 0.95,
    this.smallContainer = 40,
    this.smallIconSize = 24,
    this.smallRadius = 12,
    this.regularContainer = 56,
    this.regularIconSize = 24,
    this.regularRadius = 16,
    this.mediumContainer = 80,
    this.mediumIconSize = 28,
    this.mediumRadius = 20,
    this.largeContainer = 96,
    this.largeIconSize = 36,
    this.largeRadius = 28,
    this.focusRingWidth = 3,
    this.focusRingGap = 2,
    this.focusRingColor,
    this.disabledBackgroundAlpha = 0.1,
    this.disabledForegroundAlpha = 0.38,
    this.appearStartScale = 0.6,
    this.extended = const M3EExtendedFabTheme(),
    this.gradient,
  });

  /// defaults.

  static const M3EFabTheme defaults = M3EFabTheme();

  /// pressedScale.

  final double pressedScale;

  /// smallContainer.
  final double smallContainer;

  /// smallIconSize.
  final double smallIconSize;

  /// smallRadius.
  final double smallRadius;

  /// regularContainer.
  final double regularContainer;

  /// regularIconSize.
  final double regularIconSize;

  /// regularRadius.
  final double regularRadius;

  /// mediumContainer.
  final double mediumContainer;

  /// mediumIconSize.
  final double mediumIconSize;

  /// mediumRadius.
  final double mediumRadius;

  /// largeContainer.
  final double largeContainer;

  /// largeIconSize.
  final double largeIconSize;

  /// largeRadius.
  final double largeRadius;

  /// Focus ring stroke width (dp). Spec: 3.
  final double focusRingWidth;

  /// Gap between FAB edge and focus ring (dp). Spec: 2.
  final double focusRingGap;

  /// Focus ring color; defaults to [M3EColorScheme.secondary].
  final Color? focusRingColor;

  /// Disabled container alpha over on-surface.
  final double disabledBackgroundAlpha;

  /// Disabled icon alpha over on-surface.
  final double disabledForegroundAlpha;

  /// Initial scale for appear morph.
  final double appearStartScale;

  /// extended.
  final M3EExtendedFabTheme extended;

  /// Optional theme-level FAB gradient fill.
  final Gradient? gradient;

  /// resolve.

  M3EFabMetrics resolve({
    required M3EFabSize size,
    required M3EFabColor color,
    required M3EColorScheme scheme,
    bool enabled = true,
  }) {
    final dims = _dimensions(size);
    final palette = _palette(color, scheme, enabled: enabled);
    return M3EFabMetrics(
      container: dims.container,
      iconSize: dims.iconSize,
      radius: dims.radius,
      background: palette.background,
      foreground: palette.foreground,
    );
  }

  /// Resolved focus ring color for [scheme].
  Color resolveFocusRingColor(M3EColorScheme scheme) =>
      focusRingColor ?? scheme.secondary;

  _FabDimensions _dimensions(M3EFabSize size) {
    switch (size) {
      case M3EFabSize.small:
        return _FabDimensions(
          container: smallContainer,
          iconSize: smallIconSize,
          radius: smallRadius,
        );
      case M3EFabSize.regular:
        return _FabDimensions(
          container: regularContainer,
          iconSize: regularIconSize,
          radius: regularRadius,
        );
      case M3EFabSize.medium:
        return _FabDimensions(
          container: mediumContainer,
          iconSize: mediumIconSize,
          radius: mediumRadius,
        );
      case M3EFabSize.large:
        return _FabDimensions(
          container: largeContainer,
          iconSize: largeIconSize,
          radius: largeRadius,
        );
    }
  }

  _FabPalette _palette(
    M3EFabColor color,
    M3EColorScheme scheme, {
    required bool enabled,
  }) {
    if (!enabled) {
      return _FabPalette(
        scheme.onSurface.withValues(alpha: disabledBackgroundAlpha),
        scheme.onSurface.withValues(alpha: disabledForegroundAlpha),
      );
    }
    switch (color) {
      case M3EFabColor.primary:
        return _FabPalette(scheme.primaryContainer, scheme.onPrimaryContainer);
      case M3EFabColor.secondary:
        return _FabPalette(
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
        );
      case M3EFabColor.tertiary:
        return _FabPalette(
          scheme.tertiaryContainer,
          scheme.onTertiaryContainer,
        );
      case M3EFabColor.primaryFilled:
        return _FabPalette(scheme.primary, scheme.onPrimary);
      case M3EFabColor.secondaryFilled:
        return _FabPalette(scheme.secondary, scheme.onSecondary);
      case M3EFabColor.tertiaryFilled:
        return _FabPalette(scheme.tertiary, scheme.onTertiary);
      case M3EFabColor.surface:
        return _FabPalette(scheme.surfaceContainerHigh, scheme.primary);
    }
  }

  @override
  M3EFabTheme copyWith({
    double? pressedScale,
    double? smallContainer,
    double? smallIconSize,
    double? smallRadius,
    double? regularContainer,
    double? regularIconSize,
    double? regularRadius,
    double? mediumContainer,
    double? mediumIconSize,
    double? mediumRadius,
    double? largeContainer,
    double? largeIconSize,
    double? largeRadius,
    double? focusRingWidth,
    double? focusRingGap,
    Color? focusRingColor,
    bool clearFocusRingColor = false,
    double? disabledBackgroundAlpha,
    double? disabledForegroundAlpha,
    double? appearStartScale,
    M3EExtendedFabTheme? extended,
    Gradient? gradient,
  }) {
    return M3EFabTheme(
      pressedScale: pressedScale ?? this.pressedScale,
      smallContainer: smallContainer ?? this.smallContainer,
      smallIconSize: smallIconSize ?? this.smallIconSize,
      smallRadius: smallRadius ?? this.smallRadius,
      regularContainer: regularContainer ?? this.regularContainer,
      regularIconSize: regularIconSize ?? this.regularIconSize,
      regularRadius: regularRadius ?? this.regularRadius,
      mediumContainer: mediumContainer ?? this.mediumContainer,
      mediumIconSize: mediumIconSize ?? this.mediumIconSize,
      mediumRadius: mediumRadius ?? this.mediumRadius,
      largeContainer: largeContainer ?? this.largeContainer,
      largeIconSize: largeIconSize ?? this.largeIconSize,
      largeRadius: largeRadius ?? this.largeRadius,
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      focusRingGap: focusRingGap ?? this.focusRingGap,
      focusRingColor: clearFocusRingColor
          ? null
          : (focusRingColor ?? this.focusRingColor),
      disabledBackgroundAlpha:
          disabledBackgroundAlpha ?? this.disabledBackgroundAlpha,
      disabledForegroundAlpha:
          disabledForegroundAlpha ?? this.disabledForegroundAlpha,
      appearStartScale: appearStartScale ?? this.appearStartScale,
      extended: extended ?? this.extended,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  M3EFabTheme lerp(M3EFabTheme? other, double t) {
    if (other is! M3EFabTheme) {
      return this;
    }
    return M3EFabTheme(
      pressedScale: _lerpDouble(pressedScale, other.pressedScale, t)!,
      smallContainer: _lerpDouble(smallContainer, other.smallContainer, t)!,
      smallIconSize: _lerpDouble(smallIconSize, other.smallIconSize, t)!,
      smallRadius: _lerpDouble(smallRadius, other.smallRadius, t)!,
      regularContainer: _lerpDouble(
        regularContainer,
        other.regularContainer,
        t,
      )!,
      regularIconSize: _lerpDouble(regularIconSize, other.regularIconSize, t)!,
      regularRadius: _lerpDouble(regularRadius, other.regularRadius, t)!,
      mediumContainer: _lerpDouble(mediumContainer, other.mediumContainer, t)!,
      mediumIconSize: _lerpDouble(mediumIconSize, other.mediumIconSize, t)!,
      mediumRadius: _lerpDouble(mediumRadius, other.mediumRadius, t)!,
      largeContainer: _lerpDouble(largeContainer, other.largeContainer, t)!,
      largeIconSize: _lerpDouble(largeIconSize, other.largeIconSize, t)!,
      largeRadius: _lerpDouble(largeRadius, other.largeRadius, t)!,
      focusRingWidth: _lerpDouble(focusRingWidth, other.focusRingWidth, t)!,
      focusRingGap: _lerpDouble(focusRingGap, other.focusRingGap, t)!,
      focusRingColor:
          Color.lerp(focusRingColor, other.focusRingColor, t) ??
          focusRingColor ??
          other.focusRingColor,
      disabledBackgroundAlpha: _lerpDouble(
        disabledBackgroundAlpha,
        other.disabledBackgroundAlpha,
        t,
      )!,
      disabledForegroundAlpha: _lerpDouble(
        disabledForegroundAlpha,
        other.disabledForegroundAlpha,
        t,
      )!,
      appearStartScale: _lerpDouble(
        appearStartScale,
        other.appearStartScale,
        t,
      )!,
      extended: extended,
      gradient: t < 0.5 ? gradient : other.gradient,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

@immutable
class _FabDimensions {
  const _FabDimensions({
    required this.container,
    required this.iconSize,
    required this.radius,
  });

  final double container;
  final double iconSize;
  final double radius;
}

@immutable
class _FabPalette {
  const _FabPalette(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
