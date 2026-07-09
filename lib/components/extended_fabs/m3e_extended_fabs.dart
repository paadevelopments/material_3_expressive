import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../floating_action_buttons/enums/m3e_fab.dart';
import '../floating_action_buttons/styles/m3e_fab_theme.dart';

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
    final fabTheme = theme.fabTheme;
    final extendedTheme = fabTheme.extended;
    final metrics = fabTheme.resolve(
      size: M3EFabSize.medium,
      color: color,
      scheme: theme.colorScheme,
    );
    final borderRadius = M3EShapes.resolve(extendedTheme.cornerRadius);
    final border = RoundedRectangleBorder(borderRadius: borderRadius);

    return M3ETappable(
      onTap: onPressed,
      enabled: _enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: label,
      pressedScale: extendedTheme.pressedScale,
      builder: (BuildContext context, M3EInteractionState state) {
        final double elevation = extendedTheme.elevation(
          hovered: state.hovered,
        );
        return AnimatedContainer(
          duration: M3EMotion.medium2,
          curve: M3EMotion.emphasized,
          height: extendedTheme.height,
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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: extended
                    ? extendedTheme.extendedHorizontalPadding
                    : extendedTheme.collapsedHorizontalPadding,
              ),
              child: _buildContent(theme, metrics, extendedTheme),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    M3EThemeData theme,
    M3EFabMetrics metrics,
    M3EExtendedFabTheme extendedTheme,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconTheme.merge(
          data: IconThemeData(
            color: metrics.foreground,
            size: extendedTheme.iconSize,
          ),
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
                      metrics.foreground,
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
