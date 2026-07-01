import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'models/m3e_button_group_item.dart';

export 'models/m3e_button_group_item.dart';

/// A Material 3 Expressive button group.
///
/// Lays out related buttons in a connected row. The signature expressive
/// interaction plays here: pressing a button grows it while its neighbours
/// gently compress, using a spring driven width animation.
class M3EButtonGroup extends StatefulWidget {
  const M3EButtonGroup({
    required this.items,
    this.height = 48,
    this.spacing = 4,
    super.key,
  }) : assert(items.length >= 2, 'A button group needs 2+ items.');

  final List<M3EButtonGroupItem> items;
  final double height;
  final double spacing;

  @override
  State<M3EButtonGroup> createState() => _M3EButtonGroupState();
}

class _M3EButtonGroupState extends State<M3EButtonGroup> {
  int? _pressedIndex;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _buildChildren(theme),
    );
  }

  List<Widget> _buildChildren(M3EThemeData theme) {
    final children = <Widget>[];
    for (var i = 0; i < widget.items.length; i++) {
      if (i > 0) {
        children.add(SizedBox(width: widget.spacing));
      }
      children.add(_buildItem(theme, i));
    }
    return children;
  }

  Widget _buildItem(M3EThemeData theme, int index) {
    final M3EButtonGroupItem item = widget.items[index];
    final scheme = theme.colorScheme;
    final pressed = _pressedIndex == index;
    final Color background =
        item.selected ? scheme.secondaryContainer : scheme.surfaceContainerHigh;
    final Color foreground =
        item.selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;
    final double radius = pressed || item.selected
        ? widget.height / 2
        : M3EShapes.medium;
    final borderRadius = M3EShapes.resolve(radius);

    return M3ETappable(
      onTap: item.onPressed,
      enabled: item.onPressed != null,
      semanticLabel: item.label,
      onStateChanged: (M3EInteractionState state) =>
          _handleState(index, state),
      builder: (BuildContext context, M3EInteractionState state) {
        return AnimatedContainer(
          duration: M3EMotion.medium2,
          curve: M3EMotion.emphasized,
          height: widget.height,
          padding: EdgeInsets.symmetric(horizontal: pressed ? 24 : 16),
          decoration: BoxDecoration(
            color: background,
            borderRadius: borderRadius,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              M3EStateLayerOverlay(
                state: state,
                color: foreground,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
              ),
              _buildContent(theme, item, foreground),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(
    M3EThemeData theme,
    M3EButtonGroupItem item,
    Color foreground,
  ) {
    final Widget iconWidget = IconTheme.merge(
      data: IconThemeData(color: foreground, size: 24),
      child: item.icon,
    );
    if (item.label == null) {
      return iconWidget;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        iconWidget,
        const SizedBox(width: 8),
        Text(
          item.label!,
          style: theme.typeScale.labelLarge.copyWith(color: foreground),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _handleState(int index, M3EInteractionState state) {
    final int? next = state.pressed ? index : null;
    if (next == _pressedIndex) {
      return;
    }
    if (!state.pressed && _pressedIndex != index) {
      return;
    }
    setState(() => _pressedIndex = next);
  }
}
