import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_fab.dart';

/// Resolved size and color metrics for a floating action button.
@immutable
class M3EFabTokens {
  const M3EFabTokens({
    required this.container,
    required this.iconSize,
    required this.radius,
    required this.background,
    required this.foreground,
  });

  /// Resolves metrics for [size] and [color] against [scheme].
  factory M3EFabTokens.resolve({
    required M3EFabSize size,
    required M3EFabColor color,
    required M3EColorScheme scheme,
  }) {
    final _Dimensions dims = _dimensions(size);
    final _Palette palette = _palette(color, scheme);
    return M3EFabTokens(
      container: dims.container,
      iconSize: dims.iconSize,
      radius: dims.radius,
      background: palette.background,
      foreground: palette.foreground,
    );
  }

  final double container;
  final double iconSize;
  final double radius;
  final Color background;
  final Color foreground;

  static _Dimensions _dimensions(M3EFabSize size) {
    switch (size) {
      case M3EFabSize.small:
        return const _Dimensions(container: 40, iconSize: 24, radius: 12);
      case M3EFabSize.medium:
        return const _Dimensions(container: 56, iconSize: 24, radius: 16);
      case M3EFabSize.large:
        return const _Dimensions(container: 96, iconSize: 36, radius: 28);
    }
  }

  static _Palette _palette(M3EFabColor color, M3EColorScheme scheme) {
    switch (color) {
      case M3EFabColor.primary:
        return _Palette(scheme.primaryContainer, scheme.onPrimaryContainer);
      case M3EFabColor.secondary:
        return _Palette(
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
        );
      case M3EFabColor.tertiary:
        return _Palette(scheme.tertiaryContainer, scheme.onTertiaryContainer);
      case M3EFabColor.surface:
        return _Palette(scheme.surfaceContainerHigh, scheme.primary);
    }
  }
}

@immutable
class _Dimensions {
  const _Dimensions({
    required this.container,
    required this.iconSize,
    required this.radius,
  });

  final double container;
  final double iconSize;
  final double radius;
}

@immutable
class _Palette {
  const _Palette(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
