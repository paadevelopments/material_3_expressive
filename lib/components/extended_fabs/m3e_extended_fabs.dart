import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../buttons/utils/m3e_button_gradient_layer.dart';
import '../floating_action_buttons/enums/m3e_fab.dart';
import '../floating_action_buttons/styles/m3e_fab_decoration.dart';
import '../floating_action_buttons/styles/m3e_fab_theme.dart';

/// A Material 3 Expressive extended floating action button.
///
/// A pill shaped FAB pairing an icon with a label. Setting [extended] to false
/// animates the label away, collapsing it toward an icon only FAB. Press uses
/// spatial spring scale only (380 / 0.55).
class M3EExtendedFab extends StatelessWidget {
  /// M3EExtendedFab.
  const M3EExtendedFab({
    required this.label,
    required this.icon,
    this.onPressed,
    this.color = M3EFabColor.primary,
    this.extended = true,
    this.decoration,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  /// label.

  final String label;

  /// icon.
  final Widget icon;

  /// onPressed.
  final VoidCallback? onPressed;

  /// color.
  final M3EFabColor color;

  /// Whether the label is shown. When false the button collapses to the icon.
  final bool extended;

  /// Optional decoration for solid and gradient surfaces.
  final M3EFabDecoration? decoration;

  /// focusNode.

  final FocusNode? focusNode;

  /// autofocus.
  final bool autofocus;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final fabTheme = theme.fabTheme;
    final extendedTheme = fabTheme.extended;
    final metrics = fabTheme.resolve(
      size: M3EFabSize.medium,
      color: color,
      scheme: theme.colorScheme,
    );
    final borderRadius = M3EShapes.resolve(extendedTheme.cornerRadius);
    final border = RoundedRectangleBorder(borderRadius: borderRadius);

    return M3EComponentTheme(
      builder: (context) => M3ETappable(
        onTap: onPressed,
        enabled: _enabled,
        focusNode: focusNode,
        autofocus: autofocus,
        semanticLabel: label,
        pressedScale: extendedTheme.pressedScale,
        materialInk: !m3eUsesGradientOverlay(decoration?.overlayGradient),
        builder: (context, state) => _buildSurface(
          theme: theme,
          fabTheme: fabTheme,
          extendedTheme: extendedTheme,
          metrics: metrics,
          borderRadius: borderRadius,
          border: border,
          state: state,
        ),
      ),
    );
  }

  Widget _buildSurface({
    required M3EThemeData theme,
    required M3EFabTheme fabTheme,
    required M3EExtendedFabTheme extendedTheme,
    required M3EFabMetrics metrics,
    required BorderRadius borderRadius,
    required ShapeBorder border,
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
    final elevation = extendedTheme.elevation(hovered: state.hovered);

    Widget content = _decorateContent(
      state: state,
      states: states,
      fg: fg,
      borderRadius: borderRadius,
      border: border,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: extended
              ? extendedTheme.extendedHorizontalPadding
              : extendedTheme.collapsedHorizontalPadding,
        ),
        child: _buildContent(theme, metrics, extendedTheme, fg),
      ),
    );

    Widget surface = AnimatedContainer(
      duration: M3EMotion.medium2,
      curve: M3EMotion.emphasized,
      height: extendedTheme.height,
      decoration: BoxDecoration(
        color: fill == null ? solidBg : null,
        gradient: fill,
        borderRadius: borderRadius,
        border: side == null ? null : Border.fromBorderSide(side),
        boxShadow: M3EElevation.shadows(
          elevation,
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

  Widget _buildContent(
    M3EThemeData theme,
    M3EFabMetrics metrics,
    M3EExtendedFabTheme extendedTheme,
    Color foreground,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconTheme.merge(
          data: IconThemeData(color: foreground, size: extendedTheme.iconSize),
          child: icon,
        ),
        AnimatedSize(
          duration: M3EMotion.medium2,
          curve: M3EMotion.emphasized,
          child: extended
              ? Padding(
                  padding: EdgeInsets.only(left: extendedTheme.iconLabelGap),
                  child: Text(
                    label,
                    style: extendedTheme.labelStyle(
                      theme.typeScale,
                      foreground,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
