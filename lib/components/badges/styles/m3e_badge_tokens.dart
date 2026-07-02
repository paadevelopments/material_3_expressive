import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3EBadge`, following the Material 3 badge specs.
///
/// See https://m3.material.io/components/badges/specs.
class M3EBadgeTokens {
  const M3EBadgeTokens._();

  /// Diameter of the small (dot) badge.
  static const double dotSize = 6;

  /// Height and minimum width of the large (numbered) badge.
  static const double largeSize = 16;

  /// Horizontal padding around the large badge label.
  static const double largeHorizontalPadding = 4;

  /// Corner radius of the large badge (fully rounded at this size).
  static const double largeCornerRadius = 8;

  /// Default anchor of the badge within the badged content.
  static const Alignment defaultAlignment = Alignment(0.75, -0.75);

  /// Container color for both badge sizes.
  static Color containerColor(M3EColorScheme scheme) => scheme.error;

  /// Label text style for the large badge.
  static TextStyle labelStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.labelSmall.copyWith(color: scheme.onError);
}
