import 'package:flutter/widgets.dart';

/// A single action within an `M3EButtonGroup`.
@immutable
class M3EButtonGroupItem {
  const M3EButtonGroupItem({
    required this.icon,
    this.label,
    this.onPressed,
    this.selected = false,
  });

  final Widget icon;
  final String? label;
  final VoidCallback? onPressed;

  /// Whether this item is currently selected (for connected toggle groups).
  final bool selected;
}
