// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// Adjacent FAB slot — size is independent of toolbar expand state.

import 'package:flutter/widgets.dart';

import '../../floating_action_buttons/enums/m3e_fab.dart';
import '../../floating_action_buttons/m3e_floating_action_buttons.dart';

/// Hosts an adjacent [M3EFab]. Unaffected by the toolbar pill's expand state.
class M3EToolbarFabSlot extends StatelessWidget {
  const M3EToolbarFabSlot({
    this.fab,
    this.icon,
    this.onPressed,
    this.color = M3EFabColor.primary,
    super.key,
  });

  /// Custom FAB widget. When null, builds a default [M3EFab] from [icon].
  final Widget? fab;
  final Widget? icon;
  final VoidCallback? onPressed;
  final M3EFabColor color;

  @override
  Widget build(BuildContext context) {
    return fab ??
        M3EFab(
          icon: icon ?? const SizedBox.shrink(),
          onPressed: onPressed,
          size: M3EFabSize.medium,
          color: color,
        );
  }
}
