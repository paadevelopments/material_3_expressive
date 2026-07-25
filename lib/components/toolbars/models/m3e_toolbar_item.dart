import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/toolbars/m3e_toolbars.dart'
    show M3EToolbar;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3EToolbar;

/// A single slot in [M3EToolbar.actions] — icon action or custom widget.
sealed class M3EToolbarItem {
  const M3EToolbarItem();
}

/// An icon action hosted by [M3EToolbar].
class M3EToolbarAction extends M3EToolbarItem {
  /// M3EToolbarAction.
  const M3EToolbarAction({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.semanticLabel,
    this.enabled = true,
    this.label,
    this.isDestructive = false,
    this.isExpandTrigger = false,
  });

  /// icon.

  final IconData icon;

  /// onPressed.
  final VoidCallback onPressed;

  /// tooltip.
  final String? tooltip;

  /// semanticLabel.
  final String? semanticLabel;

  /// enabled.
  final bool enabled;

  /// Label used in the overflow menu when inline slots are exceeded.
  final String? label;

  /// When true, the overflow menu entry uses the error color.
  final bool isDestructive;

  /// Marks this action as the floating-toolbar expand/collapse trigger.
  ///
  /// At most one action may set this. Meaningful only on floating toolbars:
  /// the trigger uses filled icon-button styling and toggles pill expansion
  /// while still calling [onPressed]. Docked toolbars ignore this flag.
  final bool isExpandTrigger;
}

/// Custom content hosted inline in [M3EToolbar.actions].
///
/// Always stays inline (never moves to the overflow menu). Laid out within the
/// bar's available cross-axis extent after content padding.
class M3EToolbarWidget extends M3EToolbarItem {
  /// M3EToolbarWidget.
  const M3EToolbarWidget({required this.child, this.semanticLabel});

  /// child.

  final Widget child;

  /// semanticLabel.
  final String? semanticLabel;
}
