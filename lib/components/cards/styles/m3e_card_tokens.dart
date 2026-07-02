import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_card_variant.dart';

/// Design tokens for `M3ECard`, following the Material 3 card specs.
///
/// See https://m3.material.io/components/cards/specs.
class M3ECardTokens {
  const M3ECardTokens._();

  /// Container corner radius (M3 medium shape, 12dp).
  static BorderRadius get borderRadius => M3EShapes.radiusMedium;

  /// Default inner padding of the card content.
  static const EdgeInsets contentPadding = EdgeInsets.all(16);

  /// Resolved container color for [variant].
  static Color backgroundColor(M3EColorScheme scheme, M3ECardVariant variant) {
    switch (variant) {
      case M3ECardVariant.elevated:
        return scheme.surfaceContainerLow;
      case M3ECardVariant.filled:
        return scheme.surfaceContainerHighest;
      case M3ECardVariant.outlined:
        return scheme.surface;
    }
  }

  /// Outline color for the outlined variant.
  static Color outlineColor(M3EColorScheme scheme) => scheme.outlineVariant;

  /// Resting/hover elevation for [variant] given a hover [hovered] state.
  static double elevation(M3ECardVariant variant, {required bool hovered}) {
    if (variant != M3ECardVariant.elevated) {
      return M3EElevation.level0;
    }
    return hovered ? M3EElevation.level2 : M3EElevation.level1;
  }
}
