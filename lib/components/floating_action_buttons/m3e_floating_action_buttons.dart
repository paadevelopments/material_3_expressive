import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'enums/m3e_fab.dart';
import 'styles/m3e_fab_tokens.dart';

/// A Material 3 Expressive floating action button.
///
/// Renders at one of three [M3EFabSize]s with any of the four container
/// [M3EFabColor]s. It sits at elevation level 3 and lifts to level 4 on hover,
/// and plays a subtle spring press scale.
class M3EFab extends StatelessWidget {
  const M3EFab({
    required this.icon,
    this.onPressed,
    this.size = M3EFabSize.medium,
    this.color = M3EFabColor.primary,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final M3EFabSize size;
  final M3EFabColor color;
  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final tokens = M3EFabTokens.resolve(
      size: size,
      color: color,
      scheme: theme.colorScheme,
    );
    final borderRadius = M3EShapes.resolve(tokens.radius);
    final border = RoundedRectangleBorder(borderRadius: borderRadius);

    return M3ETappable(
      onTap: onPressed,
      enabled: _enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: tooltip,
      pressedScale: 0.95,
      builder: (BuildContext context, M3EInteractionState state) {
        final double elevation =
        state.hovered ? M3EElevation.level4 : M3EElevation.level3;
        return AnimatedContainer(
          duration: M3EMotion.short4,
          curve: M3EMotion.standard,
          width: tokens.container,
          height: tokens.container,
          decoration: BoxDecoration(
            color: tokens.background,
            borderRadius: borderRadius,
            boxShadow: M3EElevation.shadows(
              elevation,
              shadowColor: theme.colorScheme.shadow,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              M3EStateLayerOverlay(
                state: state,
                color: tokens.foreground,
                shape: border,
              ),
              IconTheme.merge(
                data: IconThemeData(
                  color: tokens.foreground,
                  size: tokens.iconSize,
                ),
                child: icon,
              ),
            ],
          ),
        );
      },
    );
  }
}
