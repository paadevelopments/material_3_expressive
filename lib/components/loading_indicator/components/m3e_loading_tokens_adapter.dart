import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Resolves the Material 3 loading-indicator design tokens from the ambient
/// [M3ETheme].
///
/// Port of the reference `LoadingTokensAdapter`, adapted to read colors from
/// this package's own [M3EColorScheme] instead of an external design system.
@immutable
class M3ELoadingTokensAdapter {
  const M3ELoadingTokensAdapter(this.context);

  final BuildContext context;

  M3EColorScheme get _colors => M3ETheme.of(context).colorScheme;

  /// Active indicator color for the default variant.
  Color activeColor() => _colors.primary;

  /// Container color for the default variant (a transparent background).
  Color containerColorDefault() => const Color(0x00000000);

  /// Container color for the contained variant.
  Color containedContainerColor() => _colors.primaryContainer;

  /// Active indicator color for the contained variant.
  Color containedActiveColor() => _colors.onPrimaryContainer;

  /// The container width, from the spec.
  double containerWidth() => 48;

  /// The container height, from the spec.
  double containerHeight() => 48;

  /// The size of the active morphing indicator, from the spec.
  double activeIndicatorSize() => 38;

  /// The full-corner container radius.
  BorderRadius containerRadius() => BorderRadius.circular(999);
}
