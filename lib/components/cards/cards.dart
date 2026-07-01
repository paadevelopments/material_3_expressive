import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

/// The three card variants defined by Material 3.
enum M3ECardVariant {
  elevated,
  filled,
  outlined,
}

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
    this.padding = const EdgeInsets.all(16),
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
    final borderRadius = M3EShapes.radiusMedium;
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
    final double elevation = _resolveElevation(state);
    return AnimatedContainer(
      duration: M3EMotion.short4,
      curve: M3EMotion.standard,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: _background(scheme),
        borderRadius: borderRadius,
        border: variant == M3ECardVariant.outlined
            ? Border.all(color: scheme.outlineVariant)
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

  Color _background(M3EColorScheme scheme) {
    switch (variant) {
      case M3ECardVariant.elevated:
        return scheme.surfaceContainerLow;
      case M3ECardVariant.filled:
        return scheme.surfaceContainerHighest;
      case M3ECardVariant.outlined:
        return scheme.surface;
    }
  }

  double _resolveElevation(M3EInteractionState state) {
    if (variant != M3ECardVariant.elevated) {
      return M3EElevation.level0;
    }
    return state.hovered ? M3EElevation.level2 : M3EElevation.level1;
  }
}
