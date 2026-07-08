import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_card_variant.dart';
import 'styles/m3e_card_tokens.dart';

export 'enums/m3e_card_variant.dart';
export 'styles/m3e_card_tokens.dart';

/// A Material 3 Expressive card.
///
/// A surface for a single subject's content and actions. When [onPressed] is
/// provided the card becomes interactive with hover/press state layers and, for
/// the elevated variant, a hover elevation lift.
class M3ECard extends StatelessWidget {
  const M3ECard({
    required this.child,
    this.variant = M3ECardVariant.elevated,
    this.onPressed,
    this.padding = M3ECardTokens.contentPadding,
    this.clipBehavior = Clip.antiAlias,
    super.key,
  });

  final Widget child;
  final M3ECardVariant variant;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final borderRadius = M3ECardTokens.borderRadius;
    final border = RoundedRectangleBorder(borderRadius: borderRadius);

    if (onPressed == null) {
      return _buildSurface(
        theme,
        borderRadius,
        border,
        const M3EInteractionState(),
      );
    }
    return M3ETappable(
      onTap: onPressed,
      builder: (BuildContext context, M3EInteractionState state) {
        return _buildSurface(theme, borderRadius, border, state);
      },
    );
  }

  Widget _buildSurface(
    M3EThemeData theme,
    BorderRadius borderRadius,
    RoundedRectangleBorder border,
    M3EInteractionState state,
  ) {
    final scheme = theme.colorScheme;
    final double elevation =
        M3ECardTokens.elevation(variant, hovered: state.hovered);
    return AnimatedContainer(
      duration: M3EMotion.short4,
      curve: M3EMotion.standard,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: M3ECardTokens.backgroundColor(scheme, variant),
        borderRadius: borderRadius,
        border: variant == M3ECardVariant.outlined
            ? Border.all(color: M3ECardTokens.outlineColor(scheme))
            : null,
        boxShadow: M3EElevation.shadows(elevation, shadowColor: scheme.shadow),
      ),
      child: Stack(
        children: <Widget>[
          M3EStateLayerOverlay(
            state: state,
            color: scheme.onSurface,
            shape: border,
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}
