import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../buttons/utils/m3e_button_gradient_layer.dart';
import 'enums/m3e_fab.dart';
import 'styles/m3e_fab_decoration.dart';
import 'styles/m3e_fab_theme.dart';

export 'enums/m3e_fab.dart';
export 'styles/m3e_fab_decoration.dart';
export 'styles/m3e_fab_theme.dart';

/// A Material 3 Expressive floating action button.
///
/// Renders at one of three [M3EFabSize]s with any of the four container
/// [M3EFabColor]s. It sits at elevation level 3 and lifts to level 4 on hover,
/// and plays a spatial spring press scale (380 / 0.55).
class M3EFab extends StatelessWidget {
  /// M3EFab.
  const M3EFab({
    required this.icon,
    this.onPressed,
    this.size = M3EFabSize.medium,
    this.color = M3EFabColor.primary,
    this.cornerRadius,
    this.decoration,
    this.elevation,
    this.hoverElevation,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
    super.key,
  }) : assert(elevation == null || elevation >= 0.0, 'assertion failed'),
       assert(
         hoverElevation == null || hoverElevation >= 0.0,
         'assertion failed',
       );

  /// icon.

  final Widget icon;

  /// onPressed.
  final VoidCallback? onPressed;

  /// size.
  final M3EFabSize size;

  /// color.
  final M3EFabColor color;

  /// When set, overrides the themed corner radius (e.g. for open/close morph).
  final double? cornerRadius;

  /// Optional decoration for solid and gradient surfaces.
  final M3EFabDecoration? decoration;

  /// Resting surface elevation.
  ///
  /// Defaults to [M3EElevation.level3].
  final double? elevation;

  /// Surface elevation while hovered.
  ///
  /// Defaults to [M3EElevation.level4].
  final double? hoverElevation;

  /// tooltip.
  final String? tooltip;

  /// focusNode.
  final FocusNode? focusNode;

  /// autofocus.
  final bool autofocus;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final fabTheme = theme.fabTheme;
    final metrics = fabTheme.resolve(
      size: size,
      color: color,
      scheme: theme.colorScheme,
    );
    final borderRadius = M3EShapes.resolve(cornerRadius ?? metrics.radius);
    final border = RoundedRectangleBorder(borderRadius: borderRadius);
    final radiusDuration = cornerRadius != null
        ? Duration.zero
        : M3EMotion.short4;

    return M3EComponentTheme(
      builder: (context) => M3ETappable(
        onTap: onPressed,
        enabled: _enabled,
        focusNode: focusNode,
        autofocus: autofocus,
        semanticLabel: tooltip,
        pressedScale: fabTheme.pressedScale,
        materialInk: !m3eUsesGradientOverlay(decoration?.overlayGradient),
        builder: (context, state) => _buildSurface(
          theme: theme,
          fabTheme: fabTheme,
          metrics: metrics,
          borderRadius: borderRadius,
          border: border,
          radiusDuration: radiusDuration,
          state: state,
        ),
      ),
    );
  }

  Widget _buildSurface({
    required M3EThemeData theme,
    required M3EFabTheme fabTheme,
    required M3EFabMetrics metrics,
    required BorderRadius borderRadius,
    required ShapeBorder border,
    required Duration radiusDuration,
    required M3EInteractionState state,
  }) {
    final states = m3eStatesForInteraction(state, enabled: _enabled);
    final Gradient? fill =
        decoration?.backgroundGradient?.resolve(states) ?? fabTheme.gradient;
    final Color? solidBg =
        decoration?.backgroundColor?.resolve(states) ??
        (fill == null ? metrics.background : null);
    final Color fg = decoration?.foregroundGradient?.resolve(states) != null
        ? m3eGradientForegroundSourceColor
        : (decoration?.foregroundColor?.resolve(states) ?? metrics.foreground);
    final Gradient? outline = decoration?.outlineGradient?.resolve(states);
    final BorderSide? side = outline != null
        ? null
        : decoration?.side?.resolve(states);
    final resolvedElevation = state.hovered
        ? hoverElevation ?? M3EElevation.level4
        : elevation ?? M3EElevation.level3;

    Widget content = _decorateContent(
      state: state,
      states: states,
      fg: fg,
      borderRadius: borderRadius,
      border: border,
      child: SizedBox(
        width: metrics.container,
        height: metrics.container,
        child: Align(
          child: IconTheme.merge(
            data: IconThemeData(color: fg, size: metrics.iconSize),
            child: icon,
          ),
        ),
      ),
    );

    Widget surface = AnimatedContainer(
      duration: radiusDuration,
      curve: M3EMotion.standard,
      width: metrics.container,
      height: metrics.container,
      decoration: BoxDecoration(
        color: fill == null ? solidBg : null,
        gradient: fill,
        borderRadius: borderRadius,
        border: side == null ? null : Border.fromBorderSide(side),
        boxShadow: M3EElevation.shadows(
          resolvedElevation,
          shadowColor: theme.colorScheme.shadow,
        ),
      ),
      child: content,
    );
    if (outline != null) {
      surface = m3eGradientOutlineLayer(
        clipRadius: borderRadius,
        gradient: outline,
        width: m3eOutlineWidth(decoration?.side?.resolve(states)),
        child: surface,
      );
    }
    return surface;
  }

  Widget _decorateContent({
    required M3EInteractionState state,
    required Set<WidgetState> states,
    required Color fg,
    required BorderRadius borderRadius,
    required ShapeBorder border,
    required Widget child,
  }) {
    var content = child;
    final Gradient? fgGradient = decoration?.foregroundGradient?.resolve(
      states,
    );
    if (fgGradient != null) {
      content = m3eGradientForegroundLayer(
        clipRadius: borderRadius,
        gradient: fgGradient,
        child: content,
      );
    }
    if (m3eUsesGradientOverlay(decoration?.overlayGradient)) {
      return m3eResolveGradientOverlay(
        clipRadius: borderRadius,
        states: states,
        overlayGradient: decoration?.overlayGradient,
        child: content,
      );
    }
    return M3EStateLayerOverlay(
      state: state,
      color: fg,
      shape: border,
      alignment: Alignment.center,
      child: content,
    );
  }
}
