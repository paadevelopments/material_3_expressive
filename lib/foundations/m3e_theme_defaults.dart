import 'package:flutter/foundation.dart';

import 'm3e_color_scheme.dart';
import 'm3e_theme_data.dart';
import 'm3e_typography.dart';

/// Assembles a complete [M3EThemeData] from core tokens and component defaults.
M3EThemeData buildM3EThemeDefaults({
  M3EColorScheme? colorScheme,
  M3ETypeScale? typeScale,
  double visualDensity = 0,
  TargetPlatform? platform,
  bool useMaterial3 = true,
}) {
  return M3EThemeData(
    colorScheme: colorScheme,
    typeScale: typeScale,
    visualDensity: visualDensity,
    platform: platform,
    useMaterial3: useMaterial3,
  );
}
