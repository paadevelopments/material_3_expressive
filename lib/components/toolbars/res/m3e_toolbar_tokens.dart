// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// FloatingToolbarTokens.kt / DockedToolbarTokens.kt

/// Numeric constants matching Compose Material 3 toolbar tokens.
abstract final class M3EToolbarTokens {
  const M3EToolbarTokens._();

  /// Cross-axis size for floating and docked expressive toolbars.
  static const double containerSize = 64;

  static const double floatingContentPadding = 8;
  static const double dockedHorizontalPadding = 16;
  static const double containerBetweenSpace = 4;
  static const double toolbarToFabGap = 8;
  static const double screenOffset = 16;

  static const double fabBaseline = 56;
  static const double fabMedium = 80;

  static const double elevationNone = 0;
  static const double elevationWithFabExpanded = 1;
}
