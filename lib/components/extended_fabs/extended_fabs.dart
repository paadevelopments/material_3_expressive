import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../floating_action_buttons/enums/m3e_fab.dart';
import '../floating_action_buttons/models/m3e_fab_spec.dart';

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

  static const double _height = 56;
  static const double _radius = 16;

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
    final borderRadius = M3EShapes.resolve(_radius);
    final border = RoundedRectangleBorder(borderRadius: borderRadius);

    return M3ETappable(
      onTap: onPressed,
      enabled: _enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: label,
      pressedScale: 0.97,
      builder: (BuildContext context, M3EInteractionState state) {
        final double elevation =
            state.hovered ? M3EElevation.level4 : M3EElevation.level3;
        return AnimatedContainer(
          duration: M3EMotion.medium2,
          curve: M3EMotion.emphasized,
          height: _height,
          padding: EdgeInsets.symmetric(horizontal: extended ? 20 : 16),
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
          data: IconThemeData(color: spec.foreground, size: 24),
          child: icon,
        ),
        AnimatedSize(
          duration: M3EMotion.medium2,
          curve: M3EMotion.emphasized,
          child: extended
              ? Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    label,
                    style: theme.typeScale.labelLarge
                        .copyWith(color: spec.foreground),
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
