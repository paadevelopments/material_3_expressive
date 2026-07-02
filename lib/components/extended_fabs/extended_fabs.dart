import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../floating_action_buttons/enums/m3e_fab.dart';
import '../floating_action_buttons/models/m3e_fab_spec.dart';
import 'styles/m3e_extended_fab_tokens.dart';

export 'styles/m3e_extended_fab_tokens.dart';

/// A Material 3 Expressive extended floating action button.
///
/// A pill shaped FAB pairing an icon with a label. Setting [extended] to false
/// animates the label away, collapsing it toward an icon only FAB.
class M3EExtendedFab extends StatelessWidget {
  const M3EExtendedFab({
    required this.label,
    required this.icon,
    this.onPressed,
    this.color = M3EFabColor.primary,
    this.extended = true,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final M3EFabColor color;

  /// Whether the label is shown. When false the button collapses to the icon.
  final bool extended;

  final FocusNode? focusNode;
  final bool autofocus;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final spec = M3EFabSpec.resolve(
      size: M3EFabSize.medium,
      color: color,
      scheme: theme.colorScheme,
    );
    final borderRadius =
        M3EShapes.resolve(M3EExtendedFabTokens.cornerRadius);
    final border = RoundedRectangleBorder(borderRadius: borderRadius);

    return M3ETappable(
      onTap: onPressed,
      enabled: _enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: label,
      pressedScale: M3EExtendedFabTokens.pressedScale,
      builder: (BuildContext context, M3EInteractionState state) {
        final double elevation = M3EExtendedFabTokens.elevation(
          hovered: state.hovered,
        );
        return AnimatedContainer(
          duration: M3EMotion.medium2,
          curve: M3EMotion.emphasized,
          height: M3EExtendedFabTokens.height,
          padding: EdgeInsets.symmetric(
            horizontal: extended
                ? M3EExtendedFabTokens.extendedHorizontalPadding
                : M3EExtendedFabTokens.collapsedHorizontalPadding,
          ),
          decoration: BoxDecoration(
            color: spec.background,
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
                color: spec.foreground,
                shape: border,
              ),
              _buildContent(theme, spec),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(M3EThemeData theme, M3EFabSpec spec) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconTheme.merge(
          data: IconThemeData(
            color: spec.foreground,
            size: M3EExtendedFabTokens.iconSize,
          ),
          child: icon,
        ),
        AnimatedSize(
          duration: M3EMotion.medium2,
          curve: M3EMotion.emphasized,
          child: extended
              ? Padding(
                  padding: const EdgeInsets.only(
                    left: M3EExtendedFabTokens.iconLabelGap,
                  ),
                  child: Text(
                    label,
                    style: M3EExtendedFabTokens.labelStyle(
                      theme.typeScale,
                      spec.foreground,
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
