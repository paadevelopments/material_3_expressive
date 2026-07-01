import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_button_variant.dart';

/// The resolved paint values for a button in a specific variant and state.
@immutable
class M3EButtonStyle {
  const M3EButtonStyle({
    required this.container,
    required this.content,
    required this.stateLayer,
    required this.outline,
    required this.elevation,
  });

  /// Resolves colors for [variant] against [scheme], honouring [enabled].
  factory M3EButtonStyle.resolve({
    required M3EButtonVariant variant,
    required M3EColorScheme scheme,
    required bool enabled,
  }) {
    if (!enabled) {
      return _disabled(variant, scheme);
    }
    switch (variant) {
      case M3EButtonVariant.elevated:
        return M3EButtonStyle(
          container: scheme.surfaceContainerLow,
          content: scheme.primary,
          stateLayer: scheme.primary,
          outline: null,
          elevation: M3EElevation.level1,
        );
      case M3EButtonVariant.filled:
        return M3EButtonStyle(
          container: scheme.primary,
          content: scheme.onPrimary,
          stateLayer: scheme.onPrimary,
          outline: null,
          elevation: M3EElevation.level0,
        );
      case M3EButtonVariant.filledTonal:
        return M3EButtonStyle(
          container: scheme.secondaryContainer,
          content: scheme.onSecondaryContainer,
          stateLayer: scheme.onSecondaryContainer,
          outline: null,
          elevation: M3EElevation.level0,
        );
      case M3EButtonVariant.outlined:
        return M3EButtonStyle(
          container: const Color(0x00000000),
          content: scheme.primary,
          stateLayer: scheme.primary,
          outline: scheme.outlineVariant,
          elevation: M3EElevation.level0,
        );
      case M3EButtonVariant.text:
        return M3EButtonStyle(
          container: const Color(0x00000000),
          content: scheme.primary,
          stateLayer: scheme.primary,
          outline: null,
          elevation: M3EElevation.level0,
        );
    }
  }

  static M3EButtonStyle _disabled(
    M3EButtonVariant variant,
    M3EColorScheme scheme,
  ) {
    final Color disabledContent = M3EColorUtils.withOpacity(
      scheme.onSurface,
      M3EStateOpacity.disabledContent,
    );
    final bool hasContainer = variant == M3EButtonVariant.elevated ||
        variant == M3EButtonVariant.filled ||
        variant == M3EButtonVariant.filledTonal;
    return M3EButtonStyle(
      container: hasContainer
          ? M3EColorUtils.withOpacity(
              scheme.onSurface,
              M3EStateOpacity.disabledContainer,
            )
          : const Color(0x00000000),
      content: disabledContent,
      stateLayer: scheme.onSurface,
      outline: variant == M3EButtonVariant.outlined
          ? M3EColorUtils.withOpacity(scheme.onSurface, 0.12)
          : null,
      elevation: M3EElevation.level0,
    );
  }

  final Color container;
  final Color content;
  final Color stateLayer;
  final Color? outline;
  final double elevation;
}
