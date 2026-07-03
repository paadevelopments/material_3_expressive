import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3ECardList`.
class M3ECardListTokens {
  const M3ECardListTokens._();

  /// Default outer radius for the first and last items.
  static const double outerRadius = 24.0;

  /// Default inner radius for adjoining items.
  static const double innerRadius = 4.0;

  /// Default gap between items.
  static const double gap = 4.0;

  /// Default background color for card items.
  static Color backgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

  /// Default internal padding for card items.
  static const EdgeInsetsGeometry itemPadding = EdgeInsets.all(12);
}
