import 'package:flutter/widgets.dart';

/// A single action hosted by [M3EToolbar].
class M3EToolbarAction {
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

  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final String? semanticLabel;
  final bool enabled;

  /// Label used in the overflow menu when inline slots are exceeded.
  final String? label;

  /// When true, the overflow menu entry uses the error color.
  final bool isDestructive;

  /// Marks this action as the floating-toolbar expand/collapse trigger.
  ///
  /// At most one action in a toolbar may set this. The trigger uses filled
  /// icon-button styling and toggles expansion while still calling [onPressed].
  final bool isExpandTrigger;
}
