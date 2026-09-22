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
///  * [indicatorColors] — optional multi-color morph (cannot combine with
///    [color]).
class M3ELoadingIndicator extends StatelessWidget {
  /// M3ELoadingIndicator.
  const M3ELoadingIndicator({
    super.key,
    this.variant = M3ELoadingIndicatorVariant.defaultStyle,
    this.color,
    this.containerColor,
    this.indicatorColors,
    this.indicatorSize,
    this.containerWidth,
    this.containerHeight,
    this.containerShape,
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
  }) : assert(
         color == null || indicatorColors == null,
         'color and indicatorColors cannot both be set',
       ),
       assert(
         indicatorSize == null || indicatorSize > 0,
         'indicatorSize must be greater than zero',
       ),
       assert(
         containerWidth == null || containerWidth > 0,
         'containerWidth must be greater than zero',
       ),
       assert(
         containerHeight == null || containerHeight > 0,
         'containerHeight must be greater than zero',
       ),
       assert(
         constraints == null ||
             (containerWidth == null && containerHeight == null),
         'constraints cannot be combined with containerWidth or containerHeight',
       );

  /// variant.
  final M3ELoadingIndicatorVariant variant;

  /// Morphing shape (inner) color.
  final Color? color;

  /// Contained shell color behind the shape. Ignored for the default variant
  /// when left null (transparent).
  final Color? containerColor;

  /// Indicator colors, cycled and interpolated during morphing.
  ///
  /// Cannot be combined with [color].
  final List<Color>? indicatorColors;

  /// Size of the morphing indicator. Defaults to theme (38).
  final double? indicatorSize;

  /// Width of the container. Defaults to theme (48).
  final double? containerWidth;

  /// Height of the container. Defaults to theme (48).
  final double? containerHeight;

  /// Shape of the container. Defaults to theme.
  final ShapeBorder? containerShape;

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
    assert(() {
      if (indicatorColors != null && indicatorColors!.isEmpty) {
        throw AssertionError('indicatorColors cannot be empty');
      }
      return true;
    }(), 'indicatorColors cannot be empty');
    if (indicatorColors != null && indicatorColors!.isEmpty) {
      throw ArgumentError.value(
        indicatorColors,
        'indicatorColors',
        'must not be empty',
      );
    }
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final loadingTheme = theme.loadingIndicatorTheme;
    final resolvedWidth = containerWidth ?? loadingTheme.containerWidth;
    final resolvedHeight = containerHeight ?? loadingTheme.containerHeight;
    final cons =
        constraints ??
        BoxConstraints.tightFor(width: resolvedWidth, height: resolvedHeight);

    final colors =
        indicatorColors ??
        <Color>[color ?? loadingTheme.resolveActiveColor(scheme, variant)];

    final containerBg =
        containerColor ?? loadingTheme.resolveContainerColor(scheme, variant);

    final indicator = M3EExpressiveLoadingIndicator(
      color: colors.first,
      indicatorColors: colors,
      indicatorSize: indicatorSize ?? loadingTheme.activeIndicatorSize,
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
    );

    return M3EComponentTheme(
      builder: (context) => DecoratedBox(
        decoration: ShapeDecoration(
          color: containerBg,
          shape: containerShape ?? loadingTheme.containerShape,
        ),
        child: Padding(padding: padding ?? EdgeInsets.zero, child: indicator),
      ),
    );
  }
}
