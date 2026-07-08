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
class M3ELoadingIndicator extends StatelessWidget {
  const M3ELoadingIndicator({
    super.key,
    this.variant = M3ELoadingIndicatorVariant.defaultStyle,
    this.color,
    this.containerColor,
    this.polygons,
    this.constraints,
    this.padding,
    this.semanticLabel,
    this.semanticValue,
  });

  final M3ELoadingIndicatorVariant variant;
  final Color? color;
  final Color? containerColor;
  final List<RoundedPolygon>? polygons;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;
  final String? semanticValue;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final loadingTheme = theme.loadingIndicatorTheme;
    final size = Size(loadingTheme.containerWidth, loadingTheme.containerHeight);

    final cons = constraints ?? BoxConstraints.tight(size);

    final activeColor = color ??
        loadingTheme.resolveActiveColor(scheme, variant);

    final containerBg = containerColor ??
        loadingTheme.resolveContainerColor(scheme, variant);

    final indicator = M3EExpressiveLoadingIndicator(
      color: activeColor,
      polygons: polygons,
      semanticsLabel: semanticLabel,
      semanticsValue: semanticValue,
      constraints: cons,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: containerBg,
        borderRadius: loadingTheme.containerRadius,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: indicator,
      ),
    );
  }
}
