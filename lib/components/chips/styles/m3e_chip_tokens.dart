import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_chip_type.dart';

/// Design tokens for Material 3 Expressive Chips.
abstract class M3EChipTokens {
  /// The default height of a chip.
  static const double height = 32.0;

  /// The default icon size for leading and trailing icons in a chip.
  static const double iconSize = 18.0;

  /// Resolves the container color for a chip based on its state.
  static Color containerColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool selected,
    required bool elevated,
    required M3EChipType type,
  }) {
    if (!enabled) {
      return selected
          ? M3EColorUtils.withOpacity(scheme.onSurface, 0.12)
          : const Color(0x00000000);
    }
    if (selected) {
      return scheme.secondaryContainer;
    }
    if (elevated) {
      return scheme.surfaceContainerLow;
    }
    return const Color(0x00000000);
  }

  /// Resolves the foreground (text and icon) color for a chip based on its state.
  static Color foregroundColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool selected,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;
  }

  /// The shape of the chip.
  static ShapeBorder shape(BuildContext context) {
    return RoundedRectangleBorder(borderRadius: M3EShapes.radiusSmall);
  }
}
