import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3EDivider`, following the Material 3 divider specs.
///
/// See https://m3.material.io/components/divider/specs.
class M3EDividerTokens {
  const M3EDividerTokens._();

  /// Default stroke thickness of the divider.
  static const double thickness = 1;

  /// Default line color.
  static Color color(M3EColorScheme scheme) => scheme.outlineVariant;
}
