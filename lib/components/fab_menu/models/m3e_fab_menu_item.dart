import 'package:flutter/widgets.dart';

/// A single action shown when an `M3EFabMenu` is open.
@immutable
class M3EFabMenuItem {
  /// M3EFabMenuItem.
  const M3EFabMenuItem({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  /// icon.

  final Widget icon;

  /// label.
  final String label;

  /// onPressed.
  final VoidCallback? onPressed;
}
