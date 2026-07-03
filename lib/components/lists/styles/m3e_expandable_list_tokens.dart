import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import '../../../foundations/foundations.dart';

/// Design tokens for `M3EExpandableList`.
class M3EExpandableListTokens {
  const M3EExpandableListTokens._();

  /// Default outer radius for the first and last items.
  static const double outerRadius = 24.0;

  /// Default inner radius for adjoining items.
  static const double innerRadius = 6.0;

  /// Default inner radius applied when the card is hovered.
  static const double hoverRadius = 10.0;

  /// Default inner radius applied when the card is pressed.
  static const double pressedRadius = 4.0;

  /// Default gap between items.
  static const double gap = 3.0;

  /// Default gap between simple-mode title and subtitle/body text.
  static const double titleSubtitleGap = 4.0;

  /// Default background color for card items.
  static Color backgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

  /// Default internal padding for header.
  static const EdgeInsetsGeometry headerPadding = EdgeInsets.fromLTRB(16, 14, 16, 2);

  /// Default internal padding for body.
  static const EdgeInsetsGeometry bodyPadding = EdgeInsets.fromLTRB(16, 0, 16, 20);

  /// Default icon padding.
  static const EdgeInsetsGeometry iconPadding = EdgeInsets.all(8.0);

  /// Default icon rotation angle.
  static const double iconRotationAngle = math.pi;

  /// Default tooltips.
  static const String expandTooltip = 'Expand';
  static const String collapseTooltip = 'Collapse';
}
