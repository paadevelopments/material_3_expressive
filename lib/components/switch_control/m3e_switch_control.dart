import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_switch_theme.dart';

export 'styles/m3e_switch_theme.dart';

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
    final theme = M3ETheme.of(context);
    final switchTheme = theme.switchTheme;
    final scheme = theme.colorScheme;

    return M3EComponentTheme(builder: (context) => M3ETappable(
        onTap: _enabled ? () => onChanged!(!value) : null,
        enabled: _enabled,
        focusNode: focusNode,
        autofocus: autofocus,
        semanticLabel: semanticLabel,
        builder: (BuildContext context, M3EInteractionState state) {
          return AnimatedContainer(
          duration: M3EMotion.short4,
          curve: M3EMotion.emphasized,
          width: switchTheme.trackWidth,
          height: switchTheme.trackHeight,
          padding: EdgeInsets.all(switchTheme.trackPadding),
          decoration: BoxDecoration(
            color: switchTheme.trackColor(
              scheme,
              enabled: _enabled,
              value: value,
            ),
            borderRadius: M3EShapes.resolve(switchTheme.trackHeight / 2),
            border: value
                ? null
                : Border.all(
                    color: switchTheme.outlineColor(
                      scheme,
                      enabled: _enabled,
                    ),
                    width: switchTheme.borderWidth,
                  ),
          ),
          child: _buildThumb(switchTheme, scheme, state),
        );
        },
      ),
    );
  }

  Widget _buildThumb(
    M3ESwitchTheme switchTheme,
    M3EColorScheme scheme,
    M3EInteractionState state,
  ) {
    final double size = switchTheme.thumbSize(
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
          color: switchTheme.thumbColor(
            scheme,
            enabled: _enabled,
            value: value,
          ),
        ),
        child: _buildThumbIcon(switchTheme, scheme),
      ),
    );
  }

  Widget _buildThumbIcon(M3ESwitchTheme switchTheme, M3EColorScheme scheme) {
    final Widget? icon = value ? selectedIcon : unselectedIcon;
    if (icon == null) {
      return const SizedBox.shrink();
    }
    return Center(
      child: IconTheme.merge(
        data: IconThemeData(
          color: switchTheme.iconColor(scheme, value: value),
          size: switchTheme.iconSize,
        ),
        child: icon,
      ),
    );
  }
}
