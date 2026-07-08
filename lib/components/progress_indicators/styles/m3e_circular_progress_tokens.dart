import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for Material 3 Expressive Circular Progress Indicators.
abstract class M3ECircularProgressTokens {
  /// The default size of a circular progress indicator.
  static const double defaultSize = 40.0;

  /// The default stroke width.
  static const double defaultStrokeWidth = 4.0;

  /// Resolves the track color.
  static Color trackColor(M3EColorScheme scheme) {
    return scheme.secondaryContainer;
  }

  /// Resolves the active color.
  static Color activeColor(M3EColorScheme scheme) {
    return scheme.primary;
  }
}
