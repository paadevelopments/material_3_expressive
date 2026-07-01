import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_button_size.dart';

/// Resolved layout metrics for a given [M3EButtonSize].
///
/// Values follow the Material 3 Expressive button size specification: the
/// container height, horizontal padding, icon size, icon/label gap and the
/// rounded vs. squared corner radii that the shape morph animates between.
@immutable
class M3EButtonSizeSpec {
  const M3EButtonSizeSpec({
    required this.height,
    required this.horizontalPadding,
    required this.iconSize,
    required this.gap,
    required this.roundRadius,
    required this.squareRadius,
    required this.outlineWidth,
  });

  /// Builds the spec for the given [size].
  factory M3EButtonSizeSpec.of(M3EButtonSize size) {
    switch (size) {
      case M3EButtonSize.extraSmall:
        return const M3EButtonSizeSpec(
          height: 32,
          horizontalPadding: 12,
          iconSize: 20,
          gap: 8,
          roundRadius: M3EShapes.full,
          squareRadius: M3EShapes.medium,
          outlineWidth: 1,
        );
      case M3EButtonSize.small:
        return const M3EButtonSizeSpec(
          height: 40,
          horizontalPadding: 16,
          iconSize: 20,
          gap: 8,
          roundRadius: M3EShapes.full,
          squareRadius: M3EShapes.medium,
          outlineWidth: 1,
        );
      case M3EButtonSize.medium:
        return const M3EButtonSizeSpec(
          height: 56,
          horizontalPadding: 24,
          iconSize: 24,
          gap: 8,
          roundRadius: M3EShapes.full,
          squareRadius: M3EShapes.large,
          outlineWidth: 1,
        );
      case M3EButtonSize.large:
        return const M3EButtonSizeSpec(
          height: 96,
          horizontalPadding: 48,
          iconSize: 32,
          gap: 12,
          roundRadius: M3EShapes.full,
          squareRadius: M3EShapes.extraLarge,
          outlineWidth: 2,
        );
      case M3EButtonSize.extraLarge:
        return const M3EButtonSizeSpec(
          height: 136,
          horizontalPadding: 64,
          iconSize: 40,
          gap: 16,
          roundRadius: M3EShapes.full,
          squareRadius: M3EShapes.extraLargeIncreased,
          outlineWidth: 3,
        );
    }
  }

  final double height;
  final double horizontalPadding;
  final double iconSize;
  final double gap;
  final double roundRadius;
  final double squareRadius;
  final double outlineWidth;

  /// The label text style for this size, taken from [typeScale].
  TextStyle labelStyle(M3ETypeScale typeScale) {
    switch (height) {
      case 32:
      case 40:
        return typeScale.labelLarge;
      case 56:
        return typeScale.titleMedium;
      case 96:
        return typeScale.headlineSmall;
      default:
        return typeScale.headlineLarge;
    }
  }

  /// Resolves the base corner radius for [shape].
  double resolveRadius(M3EButtonShape shape) {
    final double rounded = roundRadius == M3EShapes.full ? height / 2 : roundRadius;
    return shape == M3EButtonShape.round ? rounded : squareRadius;
  }

  /// Resolves the pressed corner radius, morphing toward the alternate shape.
  double pressedRadius(M3EButtonShape shape) {
    return shape == M3EButtonShape.round ? squareRadius : height / 2;
  }
}
