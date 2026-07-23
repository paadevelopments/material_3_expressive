// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// Adjacent FAB slot with size morph (56 ↔ 80)

import 'package:flutter/widgets.dart';

import '../../floating_action_buttons/enums/m3e_fab.dart';
import '../../floating_action_buttons/m3e_floating_action_buttons.dart';
import '../res/m3e_toolbar_tokens.dart';

/// Hosts an adjacent [M3EFab], morphing size with toolbar [expanded] state.
class M3EToolbarFabSlot extends StatelessWidget {
  const M3EToolbarFabSlot({
    required this.expanded,
    this.fab,
    this.icon,
    this.onPressed,
    this.color = M3EFabColor.primary,
    super.key,
  });

  final bool expanded;

  /// Custom FAB widget. When null, builds a default [M3EFab] from [icon].
  final Widget? fab;
  final Widget? icon;
  final VoidCallback? onPressed;
  final M3EFabColor color;

  @override
  Widget build(BuildContext context) {
    final double size = expanded
        ? M3EToolbarTokens.fabBaseline
        : M3EToolbarTokens.fabMedium;

    final Widget child = fab ??
        M3EFab(
          icon: icon ?? const SizedBox.shrink(),
          onPressed: onPressed,
          size: M3EFabSize.medium,
          color: color,
        );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: size,
      height: size,
      child: FittedBox(fit: BoxFit.contain, child: child),
    );
  }
}
