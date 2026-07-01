import 'package:flutter/widgets.dart';

/// A single selectable row within an `M3EMenu`.
@immutable
class M3EMenuEntry {
  const M3EMenuEntry({
    required this.label,
    this.leading,
    this.trailing,
    this.onPressed,
    this.enabled = true,
  });

  final String label;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final bool enabled;
}
