import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for Material 3 Expressive Refresh Indicators.
abstract class M3ERefreshTokens {
  /// Default displacement from the edge.
  static const double defaultDisplacement = 40.0;

  /// Default edge offset.
  static const double defaultEdgeOffset = 0.0;

  /// Default elevation.
  static const double defaultElevation = 2.0;

  /// Drag container extent percentage from original RefreshIndicator.
  static const double dragContainerExtentPercentage = 0.25;

  /// Drag size factor limit.
  static const double dragSizeFactorLimit = 1.5;

  /// Duration for indicator snap animation.
  static const Duration indicatorSnapDuration = Duration(milliseconds: 150);

  /// Duration for indicator scale animation.
  static const Duration indicatorScaleDuration = Duration(milliseconds: 200);

  /// Resolves the default color.
  static Color color(BuildContext context) {
    return M3ETheme.of(context).colorScheme.primary;
  }

  /// Resolves the default background color for contained variant.
  static Color containedBackgroundColor(BuildContext context) {
    return M3ETheme.of(context).colorScheme.secondaryContainer;
  }
}
