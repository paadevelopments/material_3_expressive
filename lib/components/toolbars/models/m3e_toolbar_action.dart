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
}
