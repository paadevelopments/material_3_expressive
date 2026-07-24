import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'enums/m3e_fab.dart';

/// A Material 3 Expressive floating action button.
///
/// Renders at one of three [M3EFabSize]s with any of the four container
/// [M3EFabColor]s. It sits at elevation level 3 and lifts to level 4 on hover,
/// and plays a spatial spring press scale (380 / 0.55).
class M3EFab extends StatelessWidget {
  const M3EFab({
    required this.icon,
    this.onPressed,
    this.size = M3EFabSize.medium,
    this.color = M3EFabColor.primary,
    this.cornerRadius,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final M3EFabSize size;
  final M3EFabColor color;

  /// When set, overrides the themed corner radius (e.g. for open/close morph).
  final double? cornerRadius;
  final String? tooltip;
  final FocusNode? focusNode;
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
    // External radius is driven frame-by-frame; skip AnimatedContainer lerp.
    final radiusDuration =
        cornerRadius != null ? Duration.zero : M3EMotion.short4;

    return M3EComponentTheme(
      builder: (context) => M3ETappable(
        onTap: onPressed,
        enabled: _enabled,
        focusNode: focusNode,
        autofocus: autofocus,
        semanticLabel: tooltip,
        pressedScale: fabTheme.pressedScale,
        materialInk: true,
        builder: (context, state) {
          final elevation =
              state.hovered ? M3EElevation.level4 : M3EElevation.level3;
          return AnimatedContainer(
            duration: radiusDuration,
            curve: M3EMotion.standard,
            width: metrics.container,
            height: metrics.container,
            decoration: BoxDecoration(
              color: metrics.background,
              borderRadius: borderRadius,
              boxShadow: M3EElevation.shadows(
                elevation,
                shadowColor: theme.colorScheme.shadow,
              ),
            ),
            child: M3EStateLayerOverlay(
              state: state,
              color: metrics.foreground,
              shape: border,
              alignment: Alignment.center,
              child: SizedBox(
                width: metrics.container,
                height: metrics.container,
                child: Align(
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color: metrics.foreground,
                      size: metrics.iconSize,
                    ),
                    child: icon,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
