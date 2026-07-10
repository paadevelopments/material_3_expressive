import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../enums/m3e_toolbar_enums.dart';

/// Resolved height, padding, and elevation metrics for a toolbar.
@immutable
class M3EToolbarMetrics {
  const M3EToolbarMetrics({
    required this.heightSmall,
    required this.heightMedium,
    required this.heightLarge,
    required this.horizontalPadding,
    required this.gap,
    required this.iconSize,
    required this.elevationSurface,
    required this.elevationProminent,
  });

  final double heightSmall;
  final double heightMedium;
  final double heightLarge;
  final EdgeInsetsGeometry horizontalPadding;
  final double gap;
  final double iconSize;
  final double elevationSurface;
  final double elevationProminent;
}

/// Theme values for `M3EToolbar`.
@immutable
class M3EToolbarTheme extends M3EThemeExtension<M3EToolbarTheme> {
  const M3EToolbarTheme({
    this.heightSmall = 40,
    this.heightMedium = 48,
    this.heightLarge = 56,
    this.iconSize = 24,
    this.compactHeightReduction = 4,
    this.elevationSurface = 0,
    this.elevationProminent = 2,
  });

  static const M3EToolbarTheme defaults = M3EToolbarTheme();

  final double heightSmall;
  final double heightMedium;
  final double heightLarge;
  final double iconSize;
  final double compactHeightReduction;
  final double elevationSurface;
  final double elevationProminent;

  M3EToolbarMetrics metrics(
    M3EToolbarDensity density,
    M3ESpacing spacing,
  ) {
    var small = heightSmall;
    var medium = heightMedium;
    var large = heightLarge;

    if (density == M3EToolbarDensity.compact) {
      small -= compactHeightReduction;
      medium -= compactHeightReduction;
      large -= compactHeightReduction;
    }

    return M3EToolbarMetrics(
      heightSmall: small,
      heightMedium: medium,
      heightLarge: large,
      horizontalPadding: EdgeInsets.symmetric(horizontal: spacing.md),
      gap: spacing.sm,
      iconSize: iconSize,
      elevationSurface: elevationSurface,
      elevationProminent: elevationProminent,
    );
  }

  Color containerColor(M3EColorScheme scheme, M3EToolbarVariant variant) {
    switch (variant) {
      case M3EToolbarVariant.surface:
        return scheme.surfaceContainerHigh;
      case M3EToolbarVariant.tonal:
        return scheme.secondaryContainer;
      case M3EToolbarVariant.primary:
        return scheme.primaryContainer;
    }
  }

  Color foregroundColor(M3EColorScheme scheme, M3EToolbarVariant variant) {
    switch (variant) {
      case M3EToolbarVariant.surface:
        return scheme.onSurface;
      case M3EToolbarVariant.tonal:
        return scheme.onSecondaryContainer;
      case M3EToolbarVariant.primary:
        return scheme.onPrimaryContainer;
    }
  }

  ShapeBorder shape(M3EToolbarShapeFamily family) {
    final BorderRadius radius = family == M3EToolbarShapeFamily.round
        ? M3EShapes.roundSet.md
        : M3EShapes.squareSet.md;
    return RoundedRectangleBorder(borderRadius: radius);
  }

  TextStyle titleStyle(M3ETypeScale typeScale) => typeScale.titleSmall;

  TextStyle subtitleStyle(M3ETypeScale typeScale) => typeScale.bodySmall;

  /// Scopes [base] so toolbar content uses [foreground] for on-surface roles.
  M3EThemeData scopedTheme(M3EThemeData base, Color foreground) {
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        onSurface: foreground,
        onSurfaceVariant: foreground,
      ),
    );
  }

  M3EIconButtonSize iconButtonSize(M3EToolbarSize size) {
    switch (size) {
      case M3EToolbarSize.small:
        return M3EIconButtonSize.xs;
      case M3EToolbarSize.medium:
      case M3EToolbarSize.large:
        return M3EIconButtonSize.sm;
    }
  }

  @override
  M3EToolbarTheme copyWith({
    double? heightSmall,
    double? heightMedium,
    double? heightLarge,
    double? iconSize,
    double? compactHeightReduction,
    double? elevationSurface,
    double? elevationProminent,
  }) {
    return M3EToolbarTheme(
      heightSmall: heightSmall ?? this.heightSmall,
      heightMedium: heightMedium ?? this.heightMedium,
      heightLarge: heightLarge ?? this.heightLarge,
      iconSize: iconSize ?? this.iconSize,
      compactHeightReduction:
          compactHeightReduction ?? this.compactHeightReduction,
      elevationSurface: elevationSurface ?? this.elevationSurface,
      elevationProminent: elevationProminent ?? this.elevationProminent,
    );
  }

  @override
  M3EToolbarTheme lerp(M3EToolbarTheme? other, double t) {
    if (other is! M3EToolbarTheme) {
      return this;
    }
    return M3EToolbarTheme(
      heightSmall: _lerpDouble(heightSmall, other.heightSmall, t)!,
      heightMedium: _lerpDouble(heightMedium, other.heightMedium, t)!,
      heightLarge: _lerpDouble(heightLarge, other.heightLarge, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      compactHeightReduction:
          _lerpDouble(compactHeightReduction, other.compactHeightReduction, t)!,
      elevationSurface:
          _lerpDouble(elevationSurface, other.elevationSurface, t)!,
      elevationProminent:
          _lerpDouble(elevationProminent, other.elevationProminent, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
