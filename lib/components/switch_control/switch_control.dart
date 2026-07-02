import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_switch_tokens.dart';

export 'styles/m3e_switch_tokens.dart';

/// A Material 3 Expressive switch.
///
/// Toggles a single setting on or off. The 52x32 track and thumb recolor on
/// change while the thumb springs across and grows from 16dp to 24dp (28dp
/// while pressed). Optional [selectedIcon]/[unselectedIcon] ride the thumb.
class M3ESwitch extends StatelessWidget {
  const M3ESwitch({
    required this.value,
    required this.onChanged,
    this.selectedIcon,
    this.unselectedIcon,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? selectedIcon;
  final Widget? unselectedIcon;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  bool get _enabled => onChanged != null;

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;

    return M3ETappable(
      onTap: _enabled ? () => onChanged!(!value) : null,
      enabled: _enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      builder: (BuildContext context, M3EInteractionState state) {
        return AnimatedContainer(
          duration: M3EMotion.short4,
          curve: M3EMotion.emphasized,
          width: M3ESwitchTokens.trackWidth,
          height: M3ESwitchTokens.trackHeight,
          padding: const EdgeInsets.all(M3ESwitchTokens.trackPadding),
          decoration: BoxDecoration(
            color: M3ESwitchTokens.trackColor(
              scheme,
              enabled: _enabled,
              value: value,
            ),
            borderRadius: M3EShapes.resolve(M3ESwitchTokens.trackHeight / 2),
            border: value
                ? null
                : Border.all(
                    color: M3ESwitchTokens.outlineColor(
                      scheme,
                      enabled: _enabled,
                    ),
                    width: M3ESwitchTokens.borderWidth,
                  ),
          ),
          child: _buildThumb(scheme, state),
        );
      },
    );
  }

  Widget _buildThumb(M3EColorScheme scheme, M3EInteractionState state) {
    final double size = M3ESwitchTokens.thumbSize(
      pressed: state.pressed,
      grown: value || selectedIcon != null || unselectedIcon != null,
    );
    return AnimatedAlign(
      duration: M3EMotion.short4,
      curve: M3EMotion.emphasized,
      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
      child: AnimatedContainer(
        duration: M3EMotion.short3,
        curve: M3EMotion.emphasized,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: M3ESwitchTokens.thumbColor(
            scheme,
            enabled: _enabled,
            value: value,
          ),
        ),
        child: _buildThumbIcon(scheme),
      ),
    );
  }

  Widget _buildThumbIcon(M3EColorScheme scheme) {
    final Widget? icon = value ? selectedIcon : unselectedIcon;
    if (icon == null) {
      return const SizedBox.shrink();
    }
    return Center(
      child: IconTheme.merge(
        data: IconThemeData(
          color: M3ESwitchTokens.iconColor(scheme, value: value),
          size: M3ESwitchTokens.iconSize,
        ),
        child: icon,
      ),
    );
  }
}
