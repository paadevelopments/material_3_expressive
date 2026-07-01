import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

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

  static const double _trackWidth = 52;
  static const double _trackHeight = 32;

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
          width: _trackWidth,
          height: _trackHeight,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _trackColor(scheme),
            borderRadius: M3EShapes.resolve(_trackHeight / 2),
            border: value
                ? null
                : Border.all(color: _outlineColor(scheme), width: 2),
          ),
          child: _buildThumb(scheme, state),
        );
      },
    );
  }

  Widget _buildThumb(M3EColorScheme scheme, M3EInteractionState state) {
    final double size = _thumbSize(state);
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
          color: _thumbColor(scheme),
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
    final Color color =
        value ? scheme.onPrimaryContainer : scheme.surfaceContainerHighest;
    return Center(
      child: IconTheme.merge(
        data: IconThemeData(color: color, size: 16),
        child: icon,
      ),
    );
  }

  double _thumbSize(M3EInteractionState state) {
    if (state.pressed) {
      return 28;
    }
    if (value || selectedIcon != null || unselectedIcon != null) {
      return 24;
    }
    return 16;
  }

  Color _trackColor(M3EColorScheme scheme) {
    if (!_enabled) {
      return M3EColorUtils.withOpacity(
        value ? scheme.onSurface : scheme.surfaceContainerHighest,
        0.12,
      );
    }
    return value ? scheme.primary : scheme.surfaceContainerHighest;
  }

  Color _thumbColor(M3EColorScheme scheme) {
    if (!_enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return value ? scheme.onPrimary : scheme.outline;
  }

  Color _outlineColor(M3EColorScheme scheme) {
    if (!_enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.12);
    }
    return scheme.outline;
  }
}
