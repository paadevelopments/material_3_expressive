import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for Material 3 Expressive Loading Indicators.
@immutable
class M3ELoadingTokens {
  const M3ELoadingTokens(this.context);

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
  static const double containerWidth = 48.0;

  /// The container height, from the spec.
  static const double containerHeight = 48.0;

  /// The size of the active morphing indicator, from the spec.
  static const double activeIndicatorSize = 38.0;

  /// The full-corner container radius.
  static final BorderRadius containerRadius = BorderRadius.circular(999);
}
