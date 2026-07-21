import 'package:flutter/material.dart' show Brightness, Color, ColorScheme;

/// In-memory cache of the last resolved dynamic color schemes.
class M3EDynamicColorCache {
  M3EDynamicColorCache._();

  static ColorScheme? light;
  static ColorScheme? dark;

  static bool get isPopulated => light != null && dark != null;

  static void storeSeed(Color seed) {
    light = ColorScheme.fromSeed(seedColor: seed);
    dark = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );
  }

  static void clear() {
    light = null;
    dark = null;
  }
}
