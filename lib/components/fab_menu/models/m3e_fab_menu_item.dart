import 'package:flutter/widgets.dart';

/// A single action shown when an `M3EFabMenu` is open.
@immutable
class M3EFabMenuItem {
  const M3EFabMenuItem({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onPressed;
}
