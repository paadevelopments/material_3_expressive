import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for Material 3 Expressive Text Fields.
abstract class M3ETextFieldTokens {
  /// The minimum height of the text field container.
  static const double minHeight = 56.0;

  /// The horizontal padding for the text field container.
  static const EdgeInsets horizontalPadding =
      EdgeInsets.symmetric(horizontal: 16.0);

  /// The icon size for leading and trailing icons.
  static const double iconSize = 24.0;

  /// The horizontal gap between icons and the field.
  static const double iconGap = 12.0;

  /// The top padding for the label when floating.
  static const double labelFloatingTopPadding = 8.0;

  /// The top padding for the label when not floating.
  static const double labelRestingTopPadding = 16.0;

  /// The gap between the label and the text field.
  static const double labelBottomPadding = 2.0;

  /// The opacity of the text selection highlight.
  static const double selectionOpacity = 0.4;

  /// The padding for supporting text.
  static const EdgeInsets supportingTextPadding =
      EdgeInsets.only(left: 16, top: 4, right: 16);

  /// Resolves the accent color (primary or error).
  static Color accentColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool hasError,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return hasError ? scheme.error : scheme.primary;
  }

  /// Resolves the container decoration.
  static BoxDecoration decoration(
    M3EColorScheme scheme, {
    required Color accent,
    required bool outlined,
    required bool focused,
    required bool hasError,
  }) {
    if (outlined) {
      return BoxDecoration(
        borderRadius: M3EShapes.radiusExtraSmall,
        border: Border.all(
          color: focused || hasError ? accent : scheme.outline,
          width: focused ? 2 : 1,
        ),
      );
    }
    return BoxDecoration(
      color: scheme.surfaceContainerHighest,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      border: Border(
        bottom: BorderSide(
          color: focused || hasError ? accent : scheme.onSurfaceVariant,
          width: focused ? 2 : 1,
        ),
      ),
    );
  }
}
