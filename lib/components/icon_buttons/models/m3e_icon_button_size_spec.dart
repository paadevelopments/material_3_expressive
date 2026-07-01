import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_icon_button_variant.dart';

/// Resolved layout metrics for an icon button [M3EIconButtonSize].
@immutable
class M3EIconButtonSizeSpec {
  const M3EIconButtonSizeSpec({
    required this.container,
    required this.iconSize,
    required this.squareRadius,
    required this.outlineWidth,
  });

  /// Builds the spec for [size].
  factory M3EIconButtonSizeSpec.of(M3EIconButtonSize size) {
    switch (size) {
      case M3EIconButtonSize.extraSmall:
        return const M3EIconButtonSizeSpec(
          container: 32,
          iconSize: 20,
          squareRadius: M3EShapes.medium,
          outlineWidth: 1,
        );
      case M3EIconButtonSize.small:
        return const M3EIconButtonSizeSpec(
          container: 40,
          iconSize: 24,
          squareRadius: M3EShapes.medium,
          outlineWidth: 1,
        );
      case M3EIconButtonSize.medium:
        return const M3EIconButtonSizeSpec(
          container: 56,
          iconSize: 24,
          squareRadius: M3EShapes.large,
          outlineWidth: 1,
        );
      case M3EIconButtonSize.large:
        return const M3EIconButtonSizeSpec(
          container: 96,
          iconSize: 32,
          squareRadius: M3EShapes.extraLarge,
          outlineWidth: 2,
        );
      case M3EIconButtonSize.extraLarge:
        return const M3EIconButtonSizeSpec(
          container: 136,
          iconSize: 40,
          squareRadius: M3EShapes.extraLargeIncreased,
          outlineWidth: 3,
        );
    }
  }

  final double container;
  final double iconSize;
  final double squareRadius;
  final double outlineWidth;

  /// Base corner radius for [shape].
  double resolveRadius(M3EIconButtonShape shape) {
    return shape == M3EIconButtonShape.round ? container / 2 : squareRadius;
  }

  /// Pressed corner radius, morphing toward the alternate shape.
  double pressedRadius(M3EIconButtonShape shape) {
    return shape == M3EIconButtonShape.round ? squareRadius : container / 2;
  }
}
