import 'package:flutter/material.dart' show ColorScheme;
import 'package:flutter/widgets.dart';

/// The full set of Material 3 color roles used across expressive components.
///
/// The scheme can be built from a seed color via [M3EColorScheme.fromSeed],
/// which delegates tonal palette generation to the framework, or adapted from
/// an existing [ColorScheme] with [M3EColorScheme.fromColorScheme].
@immutable
class M3EColorScheme {
  const M3EColorScheme({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.surface,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.surfaceTint,
  });

  /// Builds a scheme from a single [seed] color.
  factory M3EColorScheme.fromSeed(
    Color seed, {
    Brightness brightness = Brightness.light,
  }) {
    return M3EColorScheme.fromColorScheme(
      ColorScheme.fromSeed(seedColor: seed, brightness: brightness),
    );
  }

  /// Adapts a framework [ColorScheme] into an [M3EColorScheme].
  factory M3EColorScheme.fromColorScheme(ColorScheme scheme) {
    return M3EColorScheme(
      brightness: scheme.brightness,
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      secondary: scheme.secondary,
      onSecondary: scheme.onSecondary,
      secondaryContainer: scheme.secondaryContainer,
      onSecondaryContainer: scheme.onSecondaryContainer,
      tertiary: scheme.tertiary,
      onTertiary: scheme.onTertiary,
      tertiaryContainer: scheme.tertiaryContainer,
      onTertiaryContainer: scheme.onTertiaryContainer,
      error: scheme.error,
      onError: scheme.onError,
      errorContainer: scheme.errorContainer,
      onErrorContainer: scheme.onErrorContainer,
      surface: scheme.surface,
      onSurface: scheme.onSurface,
      onSurfaceVariant: scheme.onSurfaceVariant,
      surfaceContainerLowest: scheme.surfaceContainerLowest,
      surfaceContainerLow: scheme.surfaceContainerLow,
      surfaceContainer: scheme.surfaceContainer,
      surfaceContainerHigh: scheme.surfaceContainerHigh,
      surfaceContainerHighest: scheme.surfaceContainerHighest,
      surfaceDim: scheme.surfaceDim,
      surfaceBright: scheme.surfaceBright,
      inverseSurface: scheme.inverseSurface,
      onInverseSurface: scheme.onInverseSurface,
      inversePrimary: scheme.inversePrimary,
      outline: scheme.outline,
      outlineVariant: scheme.outlineVariant,
      shadow: scheme.shadow,
      scrim: scheme.scrim,
      surfaceTint: scheme.surfaceTint,
    );
  }

  /// The default light expressive scheme seeded from Material baseline purple.
  factory M3EColorScheme.light() =>
      M3EColorScheme.fromSeed(const Color(0xFF6750A4));

  /// The default dark expressive scheme seeded from Material baseline purple.
  factory M3EColorScheme.dark() => M3EColorScheme.fromSeed(
        const Color(0xFF6750A4),
        brightness: Brightness.dark,
      );

  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color surface;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color inverseSurface;
  final Color onInverseSurface;
  final Color inversePrimary;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color surfaceTint;
}
