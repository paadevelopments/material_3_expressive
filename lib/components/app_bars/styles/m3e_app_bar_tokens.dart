import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_app_bar_enums.dart';

/// The resolved height/padding/icon tokens for an app bar.
///
/// Port of the reference `_AppBarMetrics`.
@immutable
class M3EAppBarMetrics {
  const M3EAppBarMetrics({
    required this.smallHeight,
    required this.collapsedHeight,
    required this.mediumExpanded,
    required this.largeExpanded,
    required this.horizontalPadding,
    required this.iconSize,
    required this.elevation,
  });

  final double smallHeight;
  final double collapsedHeight;
  final double mediumExpanded;
  final double largeExpanded;
  final EdgeInsetsGeometry horizontalPadding;
  final double iconSize;
  final double elevation;
}

/// Resolves the [M3EAppBarMetrics] for the given [density].
///
/// Port of the reference `metricsFor`.
M3EAppBarMetrics appBarMetricsFor(
  BuildContext context,
  M3EAppBarDensity density,
) {
  // Heights (approx per M3 specs).
  var small = 64.0;
  var collapsed = 64.0;
  var medium = 112.0;
  var large = 152.0;

  // Density tweaks.
  if (density == M3EAppBarDensity.compact) {
    small -= 8;
    collapsed -= 8;
    medium -= 8;
    large -= 8;
  }

  return M3EAppBarMetrics(
    smallHeight: small,
    collapsedHeight: collapsed,
    mediumExpanded: medium,
    largeExpanded: large,
    horizontalPadding: const EdgeInsets.symmetric(horizontal: 16),
    iconSize: 24,
    elevation: 0,
  );
}

/// The default app bar background color. Port of the reference `backgroundFor`.
Color appBarBackgroundFor(BuildContext context) {
  // Prefer container surfaces for bars.
  return M3ETheme.of(context).colorScheme.surfaceContainerHigh;
}

/// The title text style for the given collapse state.
///
/// Port of the reference `titleStyleFor`.
TextStyle appBarTitleStyleFor(BuildContext context, {bool collapsed = true}) {
  final type = M3ETheme.of(context).typeScale;
  return collapsed ? type.titleLarge : type.headlineSmall;
}

/// The container shape for the given [family]. Port of the reference `shapeFor`.
ShapeBorder appBarShapeFor(BuildContext context, M3EAppBarShapeFamily family) {
  final radius = family == M3EAppBarShapeFamily.round
      ? M3EShapes.radiusSmall
      : M3EShapes.radiusNone;
  return RoundedRectangleBorder(borderRadius: radius);
}
