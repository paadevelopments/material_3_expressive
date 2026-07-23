import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../models/m3e_menu_node.dart';
import '../styles/m3e_menu_theme.dart';
import 'm3e_menu_divider.dart';
import 'm3e_menu_item.dart';

/// Callback when a menu node produces a selection result.
typedef M3EMenuSelectCallback = void Function(Object? value);

/// Callback to open a cascading submenu from an item rect.
typedef M3EMenuOpenSubmenuCallback = void Function(
  Rect anchorRect,
  List<M3EMenuNode> children,
);

/// Renders a tree of [M3EMenuNode]s inside a menu surface.
class M3EMenuContent extends StatelessWidget {
  const M3EMenuContent({
    required this.nodes,
    required this.onSelect,
    required this.closeOnSelect,
    this.onOpenSubmenu,
    this.selectedValue,
    this.applyGroupShapes = true,
    this.autofocusFirst = true,
    super.key,
  });

  final List<M3EMenuNode> nodes;
  final M3EMenuSelectCallback onSelect;
  final bool closeOnSelect;
  final M3EMenuOpenSubmenuCallback? onOpenSubmenu;
  final Object? selectedValue;
  final bool applyGroupShapes;
  final bool autofocusFirst;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final menuTheme = theme.menuTheme;
    final children = <Widget>[];
    var focused = false;

    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];
      if (i > 0 && node is M3EMenuGroup) {
        children.add(SizedBox(height: menuTheme.groupSpacing));
      }
      children.addAll(
        _buildNode(
          context,
          node,
          menuTheme,
          requestFocus: autofocusFirst && !focused,
          onFocused: () => focused = true,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  List<Widget> _buildNode(
    BuildContext context,
    M3EMenuNode node,
    M3EMenuTheme menuTheme, {
    required bool requestFocus,
    required VoidCallback onFocused,
  }) {
    switch (node) {
      case M3EMenuDivider():
        return const <Widget>[M3EMenuDividerWidget()];
      case M3EMenuGroup(:final label, :final children):
        return _buildGroup(
          context,
          label,
          children,
          menuTheme,
          requestFocus: requestFocus,
          onFocused: onFocused,
        );
      case M3EMenuEntry entry:
        final autofocus = requestFocus && entry.enabled;
        if (autofocus) {
          onFocused();
        }
        return <Widget>[
          M3EMenuItem(
            label: entry.label,
            leading: entry.leading,
            trailing: entry.trailing,
            supportingText: entry.supportingText,
            enabled: entry.enabled,
            isDestructive: entry.isDestructive,
            shape: entry.shape,
            autofocus: autofocus,
            onTap: entry.enabled
                ? () {
                    entry.onPressed?.call();
                    if (closeOnSelect) {
                      onSelect(entry.value);
                    }
                  }
                : null,
          ),
        ];
      case M3EMenuSelectable item:
        final selected = item.selected ||
            (selectedValue != null && selectedValue == item.value);
        final autofocus = requestFocus && item.enabled;
        if (autofocus) {
          onFocused();
        }
        return <Widget>[
          M3EMenuItem(
            label: item.label,
            leading: item.leading,
            trailing: item.trailing ??
                (selected
                    ? Icon(
                        M3EIcons.check_rounded,
                        size: menuTheme.iconSize * 0.9,
                      )
                    : null),
            supportingText: item.supportingText,
            enabled: item.enabled,
            selected: selected,
            shape: item.shape,
            autofocus: autofocus,
            onTap: item.enabled
                ? () {
                    item.onPressed?.call();
                    onSelect(item.value);
                  }
                : null,
          ),
        ];
      case M3EMenuToggleable item:
        final autofocus = requestFocus && item.enabled;
        if (autofocus) {
          onFocused();
        }
        return <Widget>[
          M3EMenuItem(
            label: item.label,
            leading: item.leading ??
                Icon(
                  item.checked
                      ? M3EIcons.check_box_rounded
                      : M3EIcons.check_box_outline_blank_rounded,
                  size: menuTheme.iconSize,
                ),
            trailing: item.trailing,
            supportingText: item.supportingText,
            enabled: item.enabled,
            selected: item.checked,
            shape: item.shape,
            autofocus: autofocus,
            onTap: item.enabled
                ? () {
                    final next = !item.checked;
                    item.onChanged?.call(next);
                    if (closeOnSelect) {
                      onSelect(next);
                    }
                  }
                : null,
          ),
        ];
      case M3EMenuSubmenu item:
        final autofocus = requestFocus && item.enabled;
        if (autofocus) {
          onFocused();
        }
        return <Widget>[
          Builder(
            builder: (BuildContext itemContext) {
              return M3EMenuItem(
                label: item.label,
                leading: item.leading,
                trailing: Icon(
                  M3EIcons.arrow_right_rounded,
                  size: menuTheme.iconSize,
                ),
                enabled: item.enabled,
                shape: item.shape,
                autofocus: autofocus,
                onTap: item.enabled && onOpenSubmenu != null
                    ? () {
                        final box =
                            itemContext.findRenderObject() as RenderBox?;
                        if (box == null) {
                          return;
                        }
                        final rect = box.localToGlobal(Offset.zero) & box.size;
                        onOpenSubmenu!(rect, item.children);
                      }
                    : null,
              );
            },
          ),
        ];
      case M3EMenuWidget item:
        final autofocus = requestFocus && item.enabled;
        if (autofocus) {
          onFocused();
        }
        final scheme = M3ETheme.of(context).colorScheme;
        final radius = menuTheme.itemShape(item.shape);
        final background = item.selected
            ? menuTheme.selectedContainerColor(scheme)
            : const Color(0x00000000);
        return <Widget>[
          M3ETappable(
            enabled: item.enabled,
            autofocus: autofocus,
            semanticLabel: item.semanticLabel,
            onTap: item.enabled
                ? () {
                    item.onPressed?.call();
                    if (closeOnSelect || item.value != null) {
                      onSelect(item.value);
                    }
                  }
                : null,
            builder: (BuildContext context, M3EInteractionState state) {
              return Container(
                constraints: BoxConstraints(minHeight: menuTheme.entryHeight),
                padding: EdgeInsets.symmetric(
                  horizontal: menuTheme.entryHorizontalPadding,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Color.alphaBlend(
                    scheme.onSurface.withValues(alpha: state.opacity),
                    background,
                  ),
                  borderRadius: radius,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(child: item.child),
                    if (item.selected)
                      Padding(
                        padding: EdgeInsets.only(left: menuTheme.iconGap),
                        child: Icon(
                          M3EIcons.check_rounded,
                          size: menuTheme.iconSize * 0.9,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ];
    }
  }

  List<Widget> _buildGroup(
    BuildContext context,
    String? label,
    List<M3EMenuNode> children,
    M3EMenuTheme menuTheme, {
    required bool requestFocus,
    required VoidCallback onFocused,
  }) {
    final theme = M3ETheme.of(context);
    final out = <Widget>[];
    if (label != null) {
      out.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: menuTheme.groupLabelHorizontalPadding,
            vertical: menuTheme.groupLabelVerticalPadding,
          ),
          child: Text(
            label,
            style: menuTheme.groupLabelStyle(theme.typeScale, theme.colorScheme),
          ),
        ),
      );
    }

    final shaped = <M3EMenuNode>[];
    for (var i = 0; i < children.length; i++) {
      final child = children[i];
      if (!applyGroupShapes) {
        shaped.add(child);
        continue;
      }
      final shape = menuTheme.shapeForIndex(i, children.length);
      shaped.add(_withShape(child, shape));
    }

    var focus = requestFocus;
    for (final child in shaped) {
      final widgets = _buildNode(
        context,
        child,
        menuTheme,
        requestFocus: focus,
        onFocused: () {
          focus = false;
          onFocused();
        },
      );
      out.addAll(widgets);
    }
    return out;
  }

  M3EMenuNode _withShape(M3EMenuNode node, M3EMenuItemShape shape) {
    return switch (node) {
      M3EMenuEntry e => M3EMenuEntry(
          label: e.label,
          leading: e.leading,
          trailing: e.trailing,
          supportingText: e.supportingText,
          onPressed: e.onPressed,
          enabled: e.enabled,
          isDestructive: e.isDestructive,
          value: e.value,
          shape: shape,
        ),
      M3EMenuSelectable e => M3EMenuSelectable(
          label: e.label,
          value: e.value,
          leading: e.leading,
          trailing: e.trailing,
          supportingText: e.supportingText,
          selected: e.selected,
          onPressed: e.onPressed,
          enabled: e.enabled,
          shape: shape,
        ),
      M3EMenuToggleable e => M3EMenuToggleable(
          label: e.label,
          checked: e.checked,
          leading: e.leading,
          trailing: e.trailing,
          supportingText: e.supportingText,
          onChanged: e.onChanged,
          enabled: e.enabled,
          shape: shape,
        ),
      M3EMenuSubmenu e => M3EMenuSubmenu(
          label: e.label,
          children: e.children,
          leading: e.leading,
          enabled: e.enabled,
          shape: shape,
        ),
      M3EMenuWidget e => M3EMenuWidget(
          child: e.child,
          value: e.value,
          onPressed: e.onPressed,
          enabled: e.enabled,
          selected: e.selected,
          semanticLabel: e.semanticLabel,
          shape: shape,
        ),
      _ => node,
    };
  }
}
