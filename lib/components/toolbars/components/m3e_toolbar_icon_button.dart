import 'package:flutter/widgets.dart';

import '../../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';
import '../models/m3e_toolbar_action.dart';

/// Inline icon action for [M3EToolbar] — thin adapter over [M3EIconButton].
class M3EToolbarIconButton extends StatelessWidget {
  const M3EToolbarIconButton({
    required this.action,
    required this.size,
    this.onPressed,
    this.variant,
    super.key,
  });

  final M3EToolbarAction action;
  final M3EIconButtonSize size;

  /// Overrides [M3EToolbarAction.onPressed] when set (e.g. expand trigger).
  final VoidCallback? onPressed;

  /// Defaults to filled when [M3EToolbarAction.isExpandTrigger], else standard.
  final M3EIconButtonVariant? variant;

  @override
  Widget build(BuildContext context) {
    final M3EIconButtonVariant resolvedVariant = variant ??
        (action.isExpandTrigger
            ? M3EIconButtonVariant.filled
            : M3EIconButtonVariant.standard);
    final VoidCallback? resolvedOnPressed =
        action.enabled ? (onPressed ?? action.onPressed) : null;

    return M3EIconButton(
      icon: Icon(action.icon),
      onPressed: resolvedOnPressed,
      tooltip: action.tooltip ?? action.label,
      semanticLabel: action.semanticLabel,
      size: size,
      variant: resolvedVariant,
    );
  }
}
