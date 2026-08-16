import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show TextTheme;

/// The Material 3 type scale.
///
/// Each role stores the font size, line height and tracking (letter spacing)
/// published in the M3 type system. Weights follow the regular/medium split
/// used across the baseline scale.
@immutable
class M3ETypeScale {
  /// Creates a complete Material 3 type scale.
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

  /// Largest display role.
  final TextStyle displayLarge;

  /// Medium display role.
  final TextStyle displayMedium;

  /// Smallest display role.
  final TextStyle displaySmall;

  /// Largest headline role.
  final TextStyle headlineLarge;

  /// Medium headline role.
  final TextStyle headlineMedium;

  /// Smallest headline role.
  final TextStyle headlineSmall;

  /// Largest title role.
  final TextStyle titleLarge;

  /// Medium title role.
  final TextStyle titleMedium;

  /// Smallest title role.
  final TextStyle titleSmall;

  /// Largest body role.
  final TextStyle bodyLarge;

  /// Medium body role.
  final TextStyle bodyMedium;

  /// Smallest body role.
  final TextStyle bodySmall;

  /// Largest label role.
  final TextStyle labelLarge;

  /// Medium label role.
  final TextStyle labelMedium;

  /// Smallest label role.
  final TextStyle labelSmall;

  /// Adapts a framework [TextTheme] into an [M3ETypeScale].
  ///
  /// Each role is taken from [textTheme] when present, falling back to the
  /// [M3ETypeScale.baseline] value otherwise. Lets the expressive foundation
  /// inherit the typography of an ambient Material `ThemeData`.
  factory M3ETypeScale.fromTextTheme(TextTheme textTheme) {
    final base = M3ETypeScale.baseline();
    return M3ETypeScale(
      displayLarge: textTheme.displayLarge ?? base.displayLarge,
      displayMedium: textTheme.displayMedium ?? base.displayMedium,
      displaySmall: textTheme.displaySmall ?? base.displaySmall,
      headlineLarge: textTheme.headlineLarge ?? base.headlineLarge,
      headlineMedium: textTheme.headlineMedium ?? base.headlineMedium,
      headlineSmall: textTheme.headlineSmall ?? base.headlineSmall,
      titleLarge: textTheme.titleLarge ?? base.titleLarge,
      titleMedium: textTheme.titleMedium ?? base.titleMedium,
      titleSmall: textTheme.titleSmall ?? base.titleSmall,
      bodyLarge: textTheme.bodyLarge ?? base.bodyLarge,
      bodyMedium: textTheme.bodyMedium ?? base.bodyMedium,
      bodySmall: textTheme.bodySmall ?? base.bodySmall,
      labelLarge: textTheme.labelLarge ?? base.labelLarge,
      labelMedium: textTheme.labelMedium ?? base.labelMedium,
      labelSmall: textTheme.labelSmall ?? base.labelSmall,
    );
  }

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
  M3ETypeScale withColor(Color color) => apply(color: color);

  /// Applies shared typography attributes to every role.
  ///
  /// Mirrors [TextTheme.apply] for family, fallback, package, size, color, and
  /// decoration. [fontVariations] is the one-knob for M3 Expressive axes
  /// (width, grade, weight, roundness). Per-role size, weight, and tracking
  /// stay unless size factor/delta change the size.
  M3ETypeScale apply({
    String? fontFamily,
    List<String>? fontFamilyFallback,
    String? package,
    double fontSizeFactor = 1.0,
    double fontSizeDelta = 0.0,
    Color? color,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    List<FontVariation>? fontVariations,
  }) {
    TextStyle map(TextStyle style) {
      return style.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        package: package,
        fontSize: style.fontSize == null
            ? null
            : style.fontSize! * fontSizeFactor + fontSizeDelta,
        color: color,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        fontVariations: fontVariations,
      );
    }

    return M3ETypeScale(
      displayLarge: map(displayLarge),
      displayMedium: map(displayMedium),
      displaySmall: map(displaySmall),
      headlineLarge: map(headlineLarge),
      headlineMedium: map(headlineMedium),
      headlineSmall: map(headlineSmall),
      titleLarge: map(titleLarge),
      titleMedium: map(titleMedium),
      titleSmall: map(titleSmall),
      bodyLarge: map(bodyLarge),
      bodyMedium: map(bodyMedium),
      bodySmall: map(bodySmall),
      labelLarge: map(labelLarge),
      labelMedium: map(labelMedium),
      labelSmall: map(labelSmall),
    );
  }
}

/// Named Roboto Flex axis presets for Material 3 Expressive type.
///
/// Static and mono fonts ignore axes they do not define.
enum M3ETypeVariations {
  /// No extra axes; the baseline scale weights stand.
  regular,

  /// Slight weight and grade bump for emphasized type.
  emphasized,

  /// Condensed width (`wdth` 75).
  condensed,

  /// Extra-condensed width (`wdth` 50).
  extraCondensed,

  /// Wide width (`wdth` 125).
  wide,

  /// Extra-wide width (`wdth` 151).
  extraWide,

  /// Roundness on (`ROND` 100).
  round;

  /// Variable-font axes for this preset.
  List<FontVariation> get variations {
    switch (this) {
      case M3ETypeVariations.regular:
        return const <FontVariation>[];
      case M3ETypeVariations.emphasized:
        return const <FontVariation>[
          FontVariation('wght', 600),
          FontVariation('GRAD', 50),
        ];
      case M3ETypeVariations.condensed:
        return const <FontVariation>[FontVariation('wdth', 75)];
      case M3ETypeVariations.extraCondensed:
        return const <FontVariation>[FontVariation('wdth', 50)];
      case M3ETypeVariations.wide:
        return const <FontVariation>[FontVariation('wdth', 125)];
      case M3ETypeVariations.extraWide:
        return const <FontVariation>[FontVariation('wdth', 151)];
      case M3ETypeVariations.round:
        return const <FontVariation>[FontVariation('ROND', 100)];
    }
  }
}

/// Per-size label font sizes for expressive buttons.
///
/// Mirrors the `ButtonFontSize` token from the `m3e_design` package.
@immutable
class M3EButtonFontSize {
  /// Creates button label sizes for each expressive size step.
  const M3EButtonFontSize({
    this.xs = 14,
    this.sm = 14,
    this.md = 16,
    this.lg = 20,
    this.xl = 24,
  });

  /// Extra-small button label size.
  final double xs;

  /// Small button label size.
  final double sm;

  /// Medium button label size.
  final double md;

  /// Large button label size.
  final double lg;

  /// Extra-large button label size.
  final double xl;
}

/// Memoises [M3ETypeScale.toTextTheme] results per instance.
final Expando<TextTheme> _textThemeCache = Expando<TextTheme>();
