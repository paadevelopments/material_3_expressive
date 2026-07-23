import 'package:flutter/widgets.dart';

import '../enums/m3e_menu_item_shape.dart';

export '../enums/m3e_menu_item_shape.dart';

/// A node in an [M3EMenu] content tree.
@immutable
sealed class M3EMenuNode {
  const M3EMenuNode();
}

/// Standard action row (Compose `DropdownMenuItem`).
@immutable
class M3EMenuEntry extends M3EMenuNode {
  const M3EMenuEntry({
    required this.label,
    this.leading,
    this.trailing,
    this.supportingText,
    this.onPressed,
    this.enabled = true,
    this.isDestructive = false,
    this.value,
    this.shape = M3EMenuItemShape.standalone,
  });

  final String label;
  final Widget? leading;
  final Widget? trailing;
  final String? supportingText;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool isDestructive;

  /// Optional result returned by [showM3EMenu] when this entry is chosen.
  final Object? value;

  final M3EMenuItemShape shape;
}

/// Single-select row with a trailing check when selected.
@immutable
class M3EMenuSelectable extends M3EMenuNode {
  const M3EMenuSelectable({
    required this.label,
    required this.value,
    this.leading,
    this.trailing,
    this.supportingText,
    this.selected = false,
    this.onPressed,
    this.enabled = true,
    this.shape = M3EMenuItemShape.standalone,
  });

  final String label;
  final Object value;
  final Widget? leading;
  final Widget? trailing;
  final String? supportingText;
  final bool selected;
  final VoidCallback? onPressed;
  final bool enabled;
  final M3EMenuItemShape shape;
}

/// Toggleable row (Compose checked menu item).
@immutable
class M3EMenuToggleable extends M3EMenuNode {
  const M3EMenuToggleable({
    required this.label,
    required this.checked,
    this.leading,
    this.trailing,
    this.supportingText,
    this.onChanged,
    this.enabled = true,
    this.shape = M3EMenuItemShape.standalone,
  });

  final String label;
  final bool checked;
  final Widget? leading;
  final Widget? trailing;
  final String? supportingText;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  final M3EMenuItemShape shape;
}

/// Horizontal rule between menu sections.
@immutable
class M3EMenuDivider extends M3EMenuNode {
  const M3EMenuDivider();
}

/// Group of items with optional label and Compose group spacing/shapes.
@immutable
class M3EMenuGroup extends M3EMenuNode {
  const M3EMenuGroup({
    required this.children,
    this.label,
  });

  final String? label;
  final List<M3EMenuNode> children;
}

/// Cascading submenu opened from a parent row.
@immutable
class M3EMenuSubmenu extends M3EMenuNode {
  const M3EMenuSubmenu({
    required this.label,
    required this.children,
    this.leading,
    this.enabled = true,
    this.shape = M3EMenuItemShape.standalone,
  });

  final String label;
  final Widget? leading;
  final List<M3EMenuNode> children;
  final bool enabled;
  final M3EMenuItemShape shape;
}

/// Row whose body is an arbitrary [child] (host-provided content).
@immutable
class M3EMenuWidget extends M3EMenuNode {
  const M3EMenuWidget({
    required this.child,
    this.value,
    this.onPressed,
    this.enabled = true,
    this.selected = false,
    this.semanticLabel,
    this.shape = M3EMenuItemShape.standalone,
  });

  final Widget child;
  final Object? value;
  final VoidCallback? onPressed;
  final bool enabled;
  final bool selected;
  final String? semanticLabel;
  final M3EMenuItemShape shape;
}
