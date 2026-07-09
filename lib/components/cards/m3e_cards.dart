import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../buttons/enums/m3e_button_enums.dart';
import '../buttons/res/m3e_button_constants.dart';
import 'enums/m3e_card_variant.dart';
import 'styles/m3e_card_theme.dart';

export 'enums/m3e_card_variant.dart';
export 'styles/m3e_card_theme.dart';

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
    this.onLongPress,
    this.padding = const EdgeInsets.all(16),
    this.clipBehavior = Clip.antiAlias,
    this.borderRadius,
    this.color,
    this.elevation,
    this.border,
    this.animationDuration,
    this.animationCurve,
    this.width,
    this.surfaceKey,
    this.mouseCursor,
    this.semanticLabel,
    this.haptic = M3EHapticFeedback.none,
    this.onStateChanged,
    super.key,
  });

  final Widget child;
  final M3ECardVariant variant;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;
  final Clip clipBehavior;
  final BorderRadius? borderRadius;
  final Color? color;
  final double? elevation;
  final BorderSide? border;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final double? width;
  final Key? surfaceKey;
  final MouseCursor? mouseCursor;
  final String? semanticLabel;
  final M3EHapticFeedback haptic;
  final ValueChanged<M3EInteractionState>? onStateChanged;

  bool get _isInteractive => onPressed != null || onLongPress != null;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final cardTheme = theme.cardTheme;
    final resolvedBorderRadius = borderRadius ?? cardTheme.borderRadius;
    final shape = RoundedRectangleBorder(borderRadius: resolvedBorderRadius);

    if (!_isInteractive) {
      return _buildSurface(
        theme,
        cardTheme,
        resolvedBorderRadius,
        shape,
        const M3EInteractionState(),
      );
    }

    final VoidCallback? wrappedOnPressed = onPressed == null
        ? null
        : () {
            onPressed!();
            if (haptic != M3EHapticFeedback.none) {
              M3EButtonConstants.triggerHapticFeedback(haptic);
            }
          };

    return M3ETappable(
      onTap: wrappedOnPressed,
      onLongPress: onLongPress,
      mouseCursor: mouseCursor,
      semanticLabel: semanticLabel,
      onStateChanged: onStateChanged,
      builder: (BuildContext context, M3EInteractionState state) {
        return _buildSurface(
          theme,
          cardTheme,
          resolvedBorderRadius,
          shape,
          state,
        );
      },
    );
  }

  Widget _buildSurface(
    M3EThemeData theme,
    M3ECardTheme cardTheme,
    BorderRadius resolvedBorderRadius,
    RoundedRectangleBorder shape,
    M3EInteractionState state,
  ) {
    final scheme = theme.colorScheme;
    final double resolvedElevation = elevation ??
        cardTheme.elevation(variant, hovered: state.hovered);
    final BoxBorder? resolvedBorder = border != null
        ? Border.all(color: border!.color, width: border!.width)
        : (variant == M3ECardVariant.outlined
            ? Border.all(color: cardTheme.outlineColor(scheme))
            : null);

    Widget decoratedChild = Padding(
      padding: padding,
      child: child,
    );

    Widget surface = AnimatedContainer(
      key: surfaceKey,
      width: width,
      duration: animationDuration ?? M3EMotion.short4,
      curve: animationCurve ?? M3EMotion.standard,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: color ?? cardTheme.backgroundColor(scheme, variant),
        borderRadius: resolvedBorderRadius,
        border: resolvedBorder,
        boxShadow: M3EElevation.shadows(
          resolvedElevation,
          shadowColor: scheme.shadow,
        ),
      ),
      child: _isInteractive
          ? M3EStateLayerOverlay(
              state: state,
              color: scheme.onSurface,
              shape: shape,
              child: SizedBox(
                width: width ?? double.infinity,
                child: decoratedChild,
              ),
            )
          : decoratedChild,
    );

    return surface;
  }
}
