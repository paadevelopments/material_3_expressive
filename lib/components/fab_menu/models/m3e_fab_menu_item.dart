import 'package:flutter/widgets.dart';

/// A single action shown when an `M3EFabMenu` is open.
@immutable
class M3EFabMenuItem {
  /// Creates a FAB menu item.
  const M3EFabMenuItem({
    required this.icon,
    required this.label,
    this.onPressed,
    this.openBuilder,
    this.openColor,
    this.transformScrimColor,
  });

  /// Leading icon (decorative for semantics).
  final Widget icon;

  /// Visible label; also used as the button semantic label.
  final String label;

  /// Tap callback. When [openBuilder] is null, the menu closes after it runs
  /// unless `M3EFabMenu.closeOnItemTap` is false.
  final VoidCallback? onPressed;

  /// When set, tap opens a container transform to this destination.
  ///
  /// The menu stays open while the destination is shown and after it closes,
  /// so the transform returns to this item.
  final WidgetBuilder? openBuilder;

  /// Destination fill color for the container transform.
  final Color? openColor;

  /// Scrim color behind the open container transform.
  final Color? transformScrimColor;
}
