// Vendored from the `icon_button_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/icon_button_m3e/lib).
// The logic is kept identical to the reference implementation; only the public
// identifiers carry the `M3E` prefix to match this package's conventions.
// ignore_for_file: type=lint

import 'package:flutter/material.dart';

import '../enums/m3e_icon_button_enums.dart';
import 'm3e_icon_button_tokens.dart';

/// Shape resolution helpers: resting/pressed radii and toggle behavior.
class M3EIconButtonShapes {
  const M3EIconButtonShapes._();

  static M3EIconButtonShapeVariant restVariant({
    required bool isToggle,
    required bool isSelected,
    required M3EIconButtonShapeVariant baseVariant,
  }) {
    if (isToggle && isSelected) {
      return baseVariant == M3EIconButtonShapeVariant.round
          ? M3EIconButtonShapeVariant.square
          : M3EIconButtonShapeVariant.round;
    }
    return baseVariant;
  }

  static double restingRadius({
    required M3EIconButtonSize size,
    required M3EIconButtonShapeVariant variant,
  }) {
    return switch (variant) {
      M3EIconButtonShapeVariant.round =>
        M3EIconButtonTokens.radiusRestRound[size]!,
      M3EIconButtonShapeVariant.square =>
        M3EIconButtonTokens.radiusRestSquare[size]!,
    };
  }

  /// Effective corner radius for the given material states.
  /// Hover does not change the radius; Pressed uses the shared pressed radius.
  static double effectiveRadius({
    required M3EIconButtonSize size,
    required M3EIconButtonShapeVariant baseVariant,
    required bool isToggle,
    required bool isSelected,
    required Set<WidgetState> states,
  }) {
    final variant = restVariant(
      isToggle: isToggle,
      isSelected: isSelected,
      baseVariant: baseVariant,
    );

    if (states.contains(WidgetState.pressed)) {
      return M3EIconButtonTokens.radiusPressed[size]!;
    }
    return restingRadius(size: size, variant: variant);
  }
}
