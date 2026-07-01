import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_button_size.dart';
import 'enums/m3e_button_variant.dart';
import 'models/m3e_button_size_spec.dart';
import 'models/m3e_button_style.dart';

export 'enums/m3e_button_size.dart';
export 'enums/m3e_button_variant.dart';

/// A Material 3 Expressive common button.
///
/// Supports the five color [M3EButtonVariant]s and five [M3EButtonSize]s, an
/// optional leading icon, hover/focus/press state layers, elevated hover lift
/// and the expressive corner shape morph that plays while pressed.
class M3EButton extends StatelessWidget {
  const M3EButton({
    required this.label,
    this.onPressed,
    this.onLongPress,
    this.variant = M3EButtonVariant.filled,
    this.size = M3EButtonSize.small,
    this.shape = M3EButtonShape.round,
    this.icon,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final M3EButtonVariant variant;
  final M3EButtonSize size;
  final M3EButtonShape shape;
  final Widget? icon;
  final FocusNode? focusNode;
  final bool autofocus;

  bool get _enabled => onPressed != null || onLongPress != null;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final spec = M3EButtonSizeSpec.of(size);
    final style = M3EButtonStyle.resolve(
      variant: variant,
      scheme: theme.colorScheme,
      enabled: _enabled,
    );

    return M3ETappable(
      onTap: onPressed,
      onLongPress: onLongPress,
      enabled: _enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: label,
      builder: (BuildContext context, M3EInteractionState state) {
        return _buildButton(theme, spec, style, state);
      },
    );
  }

  Widget _buildButton(
    M3EThemeData theme,
    M3EButtonSizeSpec spec,
    M3EButtonStyle style,
    M3EInteractionState state,
  ) {
    final double radius = state.pressed
        ? spec.pressedRadius(shape)
        : spec.resolveRadius(shape);
    final borderRadius = M3EShapes.resolve(radius);
    final border = RoundedRectangleBorder(borderRadius: borderRadius);
    final double elevation = _resolveElevation(style, state);

    return AnimatedContainer(
      duration: M3EMotion.medium1,
      curve: M3EMotion.emphasized,
      height: spec.height,
      constraints: BoxConstraints(minWidth: spec.height),
      decoration: BoxDecoration(
        color: style.container,
        borderRadius: borderRadius,
        border: style.outline == null
            ? null
            : Border.all(color: style.outline!, width: spec.outlineWidth),
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
            color: style.stateLayer,
            shape: border,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spec.horizontalPadding),
            child: _buildContent(theme, spec, style),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    M3EThemeData theme,
    M3EButtonSizeSpec spec,
    M3EButtonStyle style,
  ) {
    final TextStyle labelStyle =
        spec.labelStyle(theme.typeScale).copyWith(color: style.content);
    final Widget text = Text(
      label,
      style: labelStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    if (icon == null) {
      return Row(mainAxisSize: MainAxisSize.min, children: <Widget>[text]);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconTheme.merge(
          data: IconThemeData(color: style.content, size: spec.iconSize),
          child: icon!,
        ),
        SizedBox(width: spec.gap),
        text,
      ],
    );
  }

  double _resolveElevation(M3EButtonStyle style, M3EInteractionState state) {
    if (style.elevation == M3EElevation.level0) {
      return M3EElevation.level0;
    }
    if (state.hovered) {
      return M3EElevation.level2;
    }
    return style.elevation;
  }
}
