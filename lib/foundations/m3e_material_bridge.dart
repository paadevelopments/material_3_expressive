import 'package:flutter/material.dart' show ColorScheme, TextTheme;
import 'package:flutter/widgets.dart';

import 'm3e_theme.dart';

/// A minimal Material theme view — a [ColorScheme] plus a [TextTheme] — derived
/// from the nearest [M3EThemeData].
///
/// Some vendored components are written against Flutter's `ThemeData`
/// (`theme.colorScheme` / `theme.textTheme`). This bridge lets them keep that
/// shape while sourcing every value from [M3ETheme] instead of the ambient
/// Material theme.
@immutable
class M3EMaterialTheme {
  const M3EMaterialTheme({required this.colorScheme, required this.textTheme});

  /// The Material color scheme mirrored from [M3EThemeData.colorScheme].
  final ColorScheme colorScheme;

  /// The Material text theme mirrored from [M3EThemeData.typeScale].
  final TextTheme textTheme;
}

/// Resolves the nearest [M3EThemeData] as a Material [ColorScheme]/[TextTheme]
/// pair. Use in place of `Theme.of(context)` inside expressive components.
M3EMaterialTheme m3eMaterialTheme(BuildContext context) {
  final M3EThemeData data = M3ETheme.of(context);
  return M3EMaterialTheme(
    colorScheme: data.colorScheme.toColorScheme(),
    textTheme: data.typeScale.toTextTheme(),
  );
}

/// Convenience accessors for the expressive theme from a [BuildContext].
extension M3EThemeContext on BuildContext {
  /// The nearest [M3EThemeData].
  M3EThemeData get m3eTheme => M3ETheme.of(this);

  /// The nearest expressive palette as a Material [ColorScheme].
  ColorScheme get m3eColorScheme => M3ETheme.of(this).colorScheme.toColorScheme();

  /// The nearest expressive type scale as a Material [TextTheme].
  TextTheme get m3eTextTheme => M3ETheme.of(this).typeScale.toTextTheme();
}
