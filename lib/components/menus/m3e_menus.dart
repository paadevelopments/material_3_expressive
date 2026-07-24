import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_menu_popup.dart';
import 'enums/m3e_menu_anchor_position.dart';
import 'enums/m3e_menu_color_style.dart';
import 'models/m3e_menu_node.dart';

export 'components/m3e_menu_content.dart';
export 'components/m3e_menu_divider.dart';
export 'components/m3e_menu_item.dart';
export 'components/m3e_menu_popup.dart';
export 'enums/m3e_menu_anchor_position.dart';
export 'enums/m3e_menu_color_style.dart';
export 'enums/m3e_menu_item_shape.dart';
export 'models/m3e_menu_node.dart';
export 'styles/m3e_menu_theme.dart';
export 'utils/m3e_menu_placer.dart';
export 'utils/m3e_menu_spring_motion.dart';

/// Builds the anchor for an [M3EMenu], given a callback to open the menu.
typedef M3EMenuAnchorBuilder = Widget Function(
  BuildContext context,
  VoidCallback open,
);

/// A Material 3 Expressive menu (Compose `DropdownMenu` + `DropdownMenuPopup`).
///
/// Displays a temporary surface of [children] anchored to a widget built by
/// [anchorBuilder]. The menu springs open from the anchor and closes when an
/// entry is chosen or the scrim is tapped.
class M3EMenu extends StatefulWidget {
  const M3EMenu({
    required this.anchorBuilder,
    this.children,
    this.entries,
    this.position = M3EMenuAnchorPosition.bottomStart,
    this.colorStyle = M3EMenuColorStyle.standard,
    this.closeOnSelect = true,
    this.onSelected,
    this.selectedValue,
    super.key,
  }) : assert(
          children != null || entries != null,
          'Provide children or entries.',
        );

  /// Convenience constructor for a flat list of action [M3EMenuEntry]s.
  factory M3EMenu.entries({
    Key? key,
    required M3EMenuAnchorBuilder anchorBuilder,
    required List<M3EMenuEntry> entries,
    M3EMenuAnchorPosition position = M3EMenuAnchorPosition.bottomStart,
    M3EMenuColorStyle colorStyle = M3EMenuColorStyle.standard,
    bool closeOnSelect = true,
    ValueChanged<Object?>? onSelected,
    Object? selectedValue,
  }) {
    return M3EMenu(
      key: key,
      anchorBuilder: anchorBuilder,
      children: entries,
      position: position,
      colorStyle: colorStyle,
      closeOnSelect: closeOnSelect,
      onSelected: onSelected,
      selectedValue: selectedValue,
    );
  }

  final M3EMenuAnchorBuilder anchorBuilder;

  /// Full menu content tree (items, groups, dividers, submenus).
  final List<M3EMenuNode>? children;

  /// Convenience alias for a flat list of [M3EMenuEntry] action rows.
  final List<M3EMenuEntry>? entries;

  final M3EMenuAnchorPosition position;

  /// Standard (surface) vs vibrant (tertiary) color mapping.
  final M3EMenuColorStyle colorStyle;

  final bool closeOnSelect;
  final ValueChanged<Object?>? onSelected;
  final Object? selectedValue;

  List<M3EMenuNode> get _nodes => children ?? entries!;

  @override
  State<M3EMenu> createState() => _M3EMenuState();
}

class _M3EMenuState extends State<M3EMenu> {
  final GlobalKey _anchorKey = GlobalKey();
  bool _open = false;

  Future<void> _openMenu() async {
    if (_open) {
      return;
    }
    final box = _anchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return;
    }
    final anchor = box.localToGlobal(Offset.zero) & box.size;
    setState(() => _open = true);

    final result = await showM3EMenu<Object>(
      context: context,
      anchor: anchor,
      children: widget._nodes,
      position: widget.position,
      colorStyle: widget.colorStyle,
      closeOnSelect: widget.closeOnSelect,
      selectedValue: widget.selectedValue,
    );

    if (mounted) {
      setState(() => _open = false);
    }
    if (result != null) {
      widget.onSelected?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (BuildContext context) {
        return KeyedSubtree(
          key: _anchorKey,
          child: widget.anchorBuilder(context, _openMenu),
        );
      },
    );
  }
}
