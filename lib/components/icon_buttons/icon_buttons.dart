import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_icon_button_variant.dart';
import 'models/m3e_icon_button_size_spec.dart';
import 'models/m3e_icon_button_style.dart';

export 'enums/m3e_icon_button_variant.dart';

/// A Material 3 Expressive icon button.
///
/// Works as a plain action button or as a toggle when [selected] is provided.
/// Supports the four color variants, five sizes, the round/square shape morph
/// on press and state layers for hover, focus and press.
class M3EIconButton extends StatelessWidget {
  const M3EIconButton({
    required this.icon,
    this.onPressed,
    this.selected,
    this.selectedIcon,
    this.variant = M3EIconButtonVariant.standard,
    this.size = M3EIconButtonSize.small,
    this.shape = M3EIconButtonShape.round,
    this.tooltip,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  final Widget icon;
  final VoidCallback? onPressed;

  /// When non-null the button behaves as a toggle showing this selection state.
  final bool? selected;

  /// Optional icon shown while [selected] is true.
  final Widget? selectedIcon;

  final M3EIconButtonVariant variant;
  final M3EIconButtonSize size;
  final M3EIconButtonShape shape;
  final String? tooltip;
  final FocusNode? focusNode;
  final bool autofocus;

  bool get _enabled => onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final spec = M3EIconButtonSizeSpec.of(size);
    final style = M3EIconButtonStyle.resolve(
      variant: variant,
      scheme: theme.colorScheme,
      enabled: _enabled,
      selected: selected,
    );
    final bool showSelected = (selected ?? false) && selectedIcon != null;

    return M3ETappable(
      onTap: onPressed,
      enabled: _enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: tooltip,
      builder: (BuildContext context, M3EInteractionState state) {
        return _build(theme, spec, style, state, showSelected);
      },
    );
  }

  Widget _build(
    M3EThemeData theme,
    M3EIconButtonSizeSpec spec,
    M3EIconButtonStyle style,
    M3EInteractionState state,
    bool showSelected,
  ) {
    final double radius = state.pressed
        ? spec.pressedRadius(shape)
        : spec.resolveRadius(shape);
    final borderRadius = M3EShapes.resolve(radius);
    final border = RoundedRectangleBorder(borderRadius: borderRadius);

    return AnimatedContainer(
      duration: M3EMotion.medium1,
      curve: M3EMotion.emphasized,
      width: spec.container,
      height: spec.container,
      decoration: BoxDecoration(
        color: style.container,
        borderRadius: borderRadius,
        border: style.outline == null
            ? null
            : Border.all(color: style.outline!, width: spec.outlineWidth),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          M3EStateLayerOverlay(
            state: state,
            color: style.stateLayer,
            shape: border,
          ),
          IconTheme.merge(
            data: IconThemeData(color: style.icon, size: spec.iconSize),
            child: showSelected ? selectedIcon! : icon,
          ),
        ],
      ),
    );
  }
}
