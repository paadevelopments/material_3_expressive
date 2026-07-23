// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// FloatingToolbarColors / DockedToolbarTokens

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../enums/m3e_toolbar_enums.dart';
import '../res/m3e_toolbar_tokens.dart';

/// Resolved colors for a toolbar (+ optional FAB).
@immutable
class M3EToolbarColors {
  const M3EToolbarColors({
    required this.container,
    required this.content,
    required this.fabContainer,
    required this.fabContent,
  });

  final Color container;
  final Color content;
  final Color fabContainer;
  final Color fabContent;
}

/// Resolved layout metrics for floating / docked toolbars.
@immutable
class M3EToolbarMetrics {
  const M3EToolbarMetrics({
    required this.crossAxisSize,
    required this.contentPadding,
    required this.gap,
    required this.iconSize,
    required this.elevation,
    required this.elevationWithFab,
  });

  final double crossAxisSize;
  final EdgeInsetsGeometry contentPadding;
  final double gap;
  final double iconSize;
  final double elevation;
  final double elevationWithFab;
}

/// Theme values for [M3EToolbar].
@immutable
class M3EToolbarTheme extends M3EThemeExtension<M3EToolbarTheme> {
  const M3EToolbarTheme({
    this.containerSize = M3EToolbarTokens.containerSize,
    this.floatingPadding = M3EToolbarTokens.floatingContentPadding,
    this.dockedHorizontalPadding = M3EToolbarTokens.dockedHorizontalPadding,
    this.iconSize = 24,
    this.elevation = M3EToolbarTokens.elevationNone,
    this.elevationWithFab = M3EToolbarTokens.elevationWithFabExpanded,
    this.toolbarToFabGap = M3EToolbarTokens.toolbarToFabGap,
    this.screenOffset = M3EToolbarTokens.screenOffset,
    // Legacy fields retained for copyWith / lerp compatibility.
    this.heightSmall = 40,
    this.heightMedium = 48,
    this.heightLarge = 56,
    this.compactHeightReduction = 4,
    this.elevationSurface = 0,
    this.elevationProminent = 2,
  });

  static const M3EToolbarTheme defaults = M3EToolbarTheme();

  final double containerSize;
  final double floatingPadding;
  final double dockedHorizontalPadding;
  final double iconSize;
  final double elevation;
  final double elevationWithFab;
  final double toolbarToFabGap;
  final double screenOffset;

  final double heightSmall;
  final double heightMedium;
  final double heightLarge;
  final double compactHeightReduction;
  final double elevationSurface;
  final double elevationProminent;

  M3EToolbarMetrics metricsFor(M3EToolbarPlacement placement) {
    final EdgeInsetsGeometry padding = placement == M3EToolbarPlacement.floating
        ? EdgeInsets.all(floatingPadding)
        : EdgeInsets.symmetric(horizontal: dockedHorizontalPadding);
    return M3EToolbarMetrics(
      crossAxisSize: containerSize,
      contentPadding: padding,
      gap: M3EToolbarTokens.containerBetweenSpace,
      iconSize: iconSize,
      elevation: elevation,
      elevationWithFab: elevationWithFab,
    );
  }

  /// Legacy metrics API used by older call sites.
  M3EToolbarMetrics metrics(
    M3EToolbarDensity density,
    M3ESpacing spacing,
  ) {
    return metricsFor(M3EToolbarPlacement.floating).copyWithGap(spacing.sm);
  }

  M3EToolbarColors colors(
    M3EColorScheme scheme,
    M3EToolbarColorStyle style,
  ) {
    switch (style) {
      case M3EToolbarColorStyle.standard:
        return M3EToolbarColors(
          container: scheme.surfaceContainer,
          content: scheme.onSurface,
          fabContainer: scheme.primaryContainer,
          fabContent: scheme.onPrimaryContainer,
        );
      case M3EToolbarColorStyle.vibrant:
        return M3EToolbarColors(
          container: scheme.primaryContainer,
          content: scheme.onPrimaryContainer,
          fabContainer: scheme.tertiaryContainer,
          fabContent: scheme.onTertiaryContainer,
        );
    }
  }

  /// Maps legacy [M3EToolbarVariant] onto [M3EToolbarColorStyle].
  M3EToolbarColorStyle colorStyleFromVariant(M3EToolbarVariant variant) {
    return switch (variant) {
      M3EToolbarVariant.primary => M3EToolbarColorStyle.vibrant,
      M3EToolbarVariant.surface ||
      M3EToolbarVariant.tonal =>
        M3EToolbarColorStyle.standard,
    };
  }

  Color containerColor(M3EColorScheme scheme, M3EToolbarVariant variant) {
    return colors(scheme, colorStyleFromVariant(variant)).container;
  }

  Color foregroundColor(M3EColorScheme scheme, M3EToolbarVariant variant) {
    return colors(scheme, colorStyleFromVariant(variant)).content;
  }

  ShapeBorder floatingShape() {
    return const StadiumBorder();
  }

  ShapeBorder dockedShape() {
    return const RoundedRectangleBorder();
  }

  ShapeBorder shape(M3EToolbarShapeFamily family) {
    return family == M3EToolbarShapeFamily.round
        ? floatingShape()
        : dockedShape();
  }

  TextStyle titleStyle(M3ETypeScale typeScale) => typeScale.titleSmall;

  TextStyle subtitleStyle(M3ETypeScale typeScale) => typeScale.bodySmall;

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
    double? containerSize,
    double? floatingPadding,
    double? dockedHorizontalPadding,
    double? iconSize,
    double? elevation,
    double? elevationWithFab,
    double? toolbarToFabGap,
    double? screenOffset,
    double? heightSmall,
    double? heightMedium,
    double? heightLarge,
    double? compactHeightReduction,
    double? elevationSurface,
    double? elevationProminent,
  }) {
    return M3EToolbarTheme(
      containerSize: containerSize ?? this.containerSize,
      floatingPadding: floatingPadding ?? this.floatingPadding,
      dockedHorizontalPadding:
          dockedHorizontalPadding ?? this.dockedHorizontalPadding,
      iconSize: iconSize ?? this.iconSize,
      elevation: elevation ?? this.elevation,
      elevationWithFab: elevationWithFab ?? this.elevationWithFab,
      toolbarToFabGap: toolbarToFabGap ?? this.toolbarToFabGap,
      screenOffset: screenOffset ?? this.screenOffset,
      heightSmall: heightSmall ?? this.heightSmall,
      heightMedium: heightMedium ?? this.heightMedium,
      heightLarge: heightLarge ?? this.heightLarge,
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
      containerSize: _lerp(containerSize, other.containerSize, t),
      floatingPadding: _lerp(floatingPadding, other.floatingPadding, t),
      dockedHorizontalPadding:
          _lerp(dockedHorizontalPadding, other.dockedHorizontalPadding, t),
      iconSize: _lerp(iconSize, other.iconSize, t),
      elevation: _lerp(elevation, other.elevation, t),
      elevationWithFab: _lerp(elevationWithFab, other.elevationWithFab, t),
      toolbarToFabGap: _lerp(toolbarToFabGap, other.toolbarToFabGap, t),
      screenOffset: _lerp(screenOffset, other.screenOffset, t),
      heightSmall: _lerp(heightSmall, other.heightSmall, t),
      heightMedium: _lerp(heightMedium, other.heightMedium, t),
      heightLarge: _lerp(heightLarge, other.heightLarge, t),
      compactHeightReduction:
          _lerp(compactHeightReduction, other.compactHeightReduction, t),
      elevationSurface: _lerp(elevationSurface, other.elevationSurface, t),
      elevationProminent: _lerp(elevationProminent, other.elevationProminent, t),
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}

extension on M3EToolbarMetrics {
  M3EToolbarMetrics copyWithGap(double gap) {
    return M3EToolbarMetrics(
      crossAxisSize: crossAxisSize,
      contentPadding: contentPadding,
      gap: gap,
      iconSize: iconSize,
      elevation: elevation,
      elevationWithFab: elevationWithFab,
    );
  }
}
