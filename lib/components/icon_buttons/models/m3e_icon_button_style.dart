import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_icon_button_variant.dart';

/// Resolved paint values for an icon button in a given variant and state.
@immutable
class M3EIconButtonStyle {
  const M3EIconButtonStyle({
    required this.container,
    required this.icon,
    required this.stateLayer,
    required this.outline,
  });

  /// Resolves colors for [variant] and toggle [selected] state.
  ///
  /// A null [selected] denotes a non-toggle button, drawn in its "on" style.
  factory M3EIconButtonStyle.resolve({
    required M3EIconButtonVariant variant,
    required M3EColorScheme scheme,
    required bool enabled,
    required bool? selected,
  }) {
    if (!enabled) {
      return _disabled(variant, scheme);
    }
    final bool on = selected ?? true;
    switch (variant) {
      case M3EIconButtonVariant.standard:
        return M3EIconButtonStyle(
          container: const Color(0x00000000),
          icon: on ? scheme.primary : scheme.onSurfaceVariant,
          stateLayer: on ? scheme.primary : scheme.onSurfaceVariant,
          outline: null,
        );
      case M3EIconButtonVariant.filled:
        return _filled(scheme, on, selected != null);
      case M3EIconButtonVariant.tonal:
        return _tonal(scheme, on, selected != null);
      case M3EIconButtonVariant.outlined:
        return _outlined(scheme, on, selected != null);
    }
  }

  static M3EIconButtonStyle _filled(
    M3EColorScheme scheme,
    bool on,
    bool toggle,
  ) {
    if (toggle && !on) {
      return M3EIconButtonStyle(
        container: scheme.surfaceContainerHighest,
        icon: scheme.primary,
        stateLayer: scheme.primary,
        outline: null,
      );
    }
    return M3EIconButtonStyle(
      container: scheme.primary,
      icon: scheme.onPrimary,
      stateLayer: scheme.onPrimary,
      outline: null,
    );
  }

  static M3EIconButtonStyle _tonal(
    M3EColorScheme scheme,
    bool on,
    bool toggle,
  ) {
    if (toggle && !on) {
      return M3EIconButtonStyle(
        container: scheme.surfaceContainerHighest,
        icon: scheme.onSurfaceVariant,
        stateLayer: scheme.onSurfaceVariant,
        outline: null,
      );
    }
    return M3EIconButtonStyle(
      container: scheme.secondaryContainer,
      icon: scheme.onSecondaryContainer,
      stateLayer: scheme.onSecondaryContainer,
      outline: null,
    );
  }

  static M3EIconButtonStyle _outlined(
    M3EColorScheme scheme,
    bool on,
    bool toggle,
  ) {
    if (toggle && on) {
      return M3EIconButtonStyle(
        container: scheme.inverseSurface,
        icon: scheme.onInverseSurface,
        stateLayer: scheme.onInverseSurface,
        outline: null,
      );
    }
    return M3EIconButtonStyle(
      container: const Color(0x00000000),
      icon: scheme.onSurfaceVariant,
      stateLayer: scheme.onSurfaceVariant,
      outline: scheme.outlineVariant,
    );
  }

  static M3EIconButtonStyle _disabled(
    M3EIconButtonVariant variant,
    M3EColorScheme scheme,
  ) {
    final bool hasContainer = variant == M3EIconButtonVariant.filled ||
        variant == M3EIconButtonVariant.tonal;
    return M3EIconButtonStyle(
      container: hasContainer
          ? M3EColorUtils.withOpacity(
              scheme.onSurface,
              M3EStateOpacity.disabledContainer,
            )
          : const Color(0x00000000),
      icon: M3EColorUtils.withOpacity(
        scheme.onSurface,
        M3EStateOpacity.disabledContent,
      ),
      stateLayer: scheme.onSurface,
      outline: variant == M3EIconButtonVariant.outlined
          ? M3EColorUtils.withOpacity(scheme.onSurface, 0.12)
          : null,
    );
  }

  final Color container;
  final Color icon;
  final Color stateLayer;
  final Color? outline;
}
