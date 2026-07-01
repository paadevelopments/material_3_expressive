import 'package:flutter/material.dart' show TextTheme;
import 'package:flutter/widgets.dart';

/// The Material 3 type scale.
///
/// Each role stores the font size, line height and tracking (letter spacing)
/// published in the M3 type system. Weights follow the regular/medium split
/// used across the baseline scale.
@immutable
class M3ETypeScale {
  const M3ETypeScale({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  /// The baseline Material 3 type scale using the platform default font.
  factory M3ETypeScale.baseline() {
    TextStyle style(
      double size,
      double height,
      double tracking,
      FontWeight weight,
    ) {
      return TextStyle(
        fontSize: size,
        height: height / size,
        letterSpacing: tracking,
        fontWeight: weight,
        textBaseline: TextBaseline.alphabetic,
        leadingDistribution: TextLeadingDistribution.even,
      );
    }

    const FontWeight regular = FontWeight.w400;
    const FontWeight medium = FontWeight.w500;
    return M3ETypeScale(
      displayLarge: style(57, 64, -0.25, regular),
      displayMedium: style(45, 52, 0, regular),
      displaySmall: style(36, 44, 0, regular),
      headlineLarge: style(32, 40, 0, regular),
      headlineMedium: style(28, 36, 0, regular),
      headlineSmall: style(24, 32, 0, regular),
      titleLarge: style(22, 28, 0, regular),
      titleMedium: style(16, 24, 0.15, medium),
      titleSmall: style(14, 20, 0.1, medium),
      bodyLarge: style(16, 24, 0.5, regular),
      bodyMedium: style(14, 20, 0.25, regular),
      bodySmall: style(12, 16, 0.4, regular),
      labelLarge: style(14, 20, 0.1, medium),
      labelMedium: style(12, 16, 0.5, medium),
      labelSmall: style(11, 16, 0.5, medium),
    );
  }

  final TextStyle displayLarge;
  final TextStyle displayMedium;
  final TextStyle displaySmall;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;

  /// The per-size label font sizes used by expressive buttons.
  M3EButtonFontSize get buttonFontSize => const M3EButtonFontSize();

  /// A framework [TextTheme] mirroring these roles.
  ///
  /// Lets components written against Material's [TextTheme] consume the
  /// expressive type scale carried by `M3EThemeData`. Memoised per instance so
  /// a stable theme yields a stable identity.
  TextTheme toTextTheme() {
    final TextTheme? cached = _textThemeCache[this];
    if (cached != null) {
      return cached;
    }
    final textTheme = TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      headlineLarge: headlineLarge,
      headlineMedium: headlineMedium,
      headlineSmall: headlineSmall,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
    _textThemeCache[this] = textTheme;
    return textTheme;
  }

  /// Returns a copy with [color] applied to every role.
  M3ETypeScale withColor(Color color) {
    TextStyle apply(TextStyle style) => style.copyWith(color: color);
    return M3ETypeScale(
      displayLarge: apply(displayLarge),
      displayMedium: apply(displayMedium),
      displaySmall: apply(displaySmall),
      headlineLarge: apply(headlineLarge),
      headlineMedium: apply(headlineMedium),
      headlineSmall: apply(headlineSmall),
      titleLarge: apply(titleLarge),
      titleMedium: apply(titleMedium),
      titleSmall: apply(titleSmall),
      bodyLarge: apply(bodyLarge),
      bodyMedium: apply(bodyMedium),
      bodySmall: apply(bodySmall),
      labelLarge: apply(labelLarge),
      labelMedium: apply(labelMedium),
      labelSmall: apply(labelSmall),
    );
  }
}

/// Per-size label font sizes for expressive buttons.
///
/// Mirrors the `ButtonFontSize` token from the `m3e_design` package.
@immutable
class M3EButtonFontSize {
  const M3EButtonFontSize({
    this.xs = 14,
    this.sm = 14,
    this.md = 16,
    this.lg = 20,
    this.xl = 24,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
}

/// Memoises [M3ETypeScale.toTextTheme] results per instance.
final Expando<TextTheme> _textThemeCache = Expando<TextTheme>();
