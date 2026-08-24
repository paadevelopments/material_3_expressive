import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_expressive_loading_indicator.dart';
import 'enums/m3e_loading_indicator_variant.dart';

export 'components/m3e_expressive_loading_indicator.dart';
export 'enums/m3e_loading_indicator_variant.dart';
export 'styles/m3e_loading_indicator_theme.dart';

/// Material 3 Expressive loading indicator.
///
/// Port of the reference `LoadingIndicatorM3E`:
///  * [M3ELoadingIndicatorVariant.defaultStyle] draws a floating morphing shape
///    on the surface.
///  * [M3ELoadingIndicatorVariant.contained] draws the shape inside a filled
///    container, using the on-container color for the shape.
///
/// Colors:
///  * [color] — morphing shape (inner) color for both variants.
///  * [containerColor] — filled shell behind a contained indicator.
///
/// Elevation:
///  * Contained — rounded container casts [M3EElevation] shadows.
///  * Default — shadow follows the morphing polygon path (rotate/scale/morph).
class M3ELoadingIndicator extends StatelessWidget {
  /// M3ELoadingIndicator.
  const M3ELoadingIndicator({
    super.key,
    this.variant = M3ELoadingIndicatorVariant.defaultStyle,
    this.color,
    this.containerColor,
    this.elevation,
    this.polygons,
    this.constraints,
    this.padding,
    this.globalRotationDuration,
    this.morphInterval,
    this.morphRotationDegrees,
    this.morphSpring,
    this.morphSpringVelocity,
    this.pulseStartScale,
    this.pulseSpring,
    this.pulseSpringVelocity,
    this.rotationTurns,
    this.semanticLabel,
    this.semanticValue,
  }) : assert(elevation == null || elevation >= 0.0, 'assertion failed');

  /// variant.
  final M3ELoadingIndicatorVariant variant;

  /// Morphing shape (inner) color.
  final Color? color;

  /// Contained shell color behind the shape. Ignored for the default variant
  /// when left null (transparent).
  final Color? containerColor;

  /// Surface elevation. Defaults to theme (`0`).
  ///
  /// Contained uses container shadows; default follows the polygon path.
  final double? elevation;

  /// polygons.
  final List<RoundedPolygon>? polygons;

  /// constraints.
  final BoxConstraints? constraints;

  /// padding.
  final EdgeInsetsGeometry? padding;

  /// Full 360° continuous spin period.
  final Duration? globalRotationDuration;

  /// Delay between polygon morph cycles.
  final Duration? morphInterval;

  /// Extra rotation (degrees) across each morph transition.
  final double? morphRotationDegrees;

  /// Spring for morph progress.
  final M3ESpring? morphSpring;

  /// Initial morph spring velocity.
  final double? morphSpringVelocity;

  /// Scale at the start of each morph-in pulse (default expands above 1, then settles).
  final double? pulseStartScale;

  /// Spring for the morph-in scale pulse settle.
  final M3ESpring? pulseSpring;

  /// Initial pulse spring velocity.
  final double? pulseSpringVelocity;

  /// When non-null, disables auto spin and pulse; rotation is driven by this
  /// value in turns (`1.0` = 360°).
  final double? rotationTurns;

  /// semanticLabel.
  final String? semanticLabel;

  /// semanticValue.
  final String? semanticValue;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final loadingTheme = theme.loadingIndicatorTheme;
    final size = Size(
      loadingTheme.containerWidth,
      loadingTheme.containerHeight,
    );

    final cons = constraints ?? BoxConstraints.tight(size);

    final activeColor =
        color ?? loadingTheme.resolveActiveColor(scheme, variant);

    final containerBg =
        containerColor ?? loadingTheme.resolveContainerColor(scheme, variant);

    final resolvedElevation = elevation ?? loadingTheme.elevation;
    final contained = variant == M3ELoadingIndicatorVariant.contained;

    final indicator = M3EExpressiveLoadingIndicator(
      color: activeColor,
      polygons: polygons,
      semanticsLabel: semanticLabel,
      semanticsValue: semanticValue,
      constraints: cons,
      globalRotationDuration: globalRotationDuration,
      morphInterval: morphInterval,
      morphRotationDegrees: morphRotationDegrees,
      morphSpring: morphSpring,
      morphSpringVelocity: morphSpringVelocity,
      pulseStartScale: pulseStartScale,
      pulseSpring: pulseSpring,
      pulseSpringVelocity: pulseSpringVelocity,
      rotationTurns: rotationTurns,
      // Uncontained: shadow is painted on the morphing path.
      elevation: contained ? 0 : resolvedElevation,
      shadowColor: scheme.shadow,
    );

    return M3EComponentTheme(
      builder: (context) => DecoratedBox(
        decoration: BoxDecoration(
          color: containerBg,
          borderRadius: loadingTheme.containerRadius,
          // Contained: elevation on the rounded shell only.
          boxShadow: contained
              ? M3EElevation.shadows(
                  resolvedElevation,
                  shadowColor: scheme.shadow,
                )
              : const <BoxShadow>[],
        ),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: indicator),
      ),
    );
  }
}
