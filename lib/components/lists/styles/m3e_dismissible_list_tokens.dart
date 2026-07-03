import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3EDismissibleList`.
class M3EDismissibleListTokens {
  const M3EDismissibleListTokens._();

  static const double outerRadius = 18.0;
  static const double innerRadius = 4.0;
  static const double gap = 3.0;
  static const double dismissThreshold = 0.2;
  static const double neighbourPull = 8.0;
  static const int neighbourReach = 3;
  static const double backgroundBorderRadius = 100.0;
  static const double collapseSpeed = 50.0;

  static Color backgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

  static const EdgeInsetsGeometry itemPadding = EdgeInsets.all(16);
}
