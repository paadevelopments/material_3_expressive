import 'package:flutter/material.dart' show Brightness, ChangeNotifier, ThemeMode;

/// Manual brightness control for an adaptive [M3ETheme] root.
///
/// When [brightnessOverride] is set it takes precedence over [autoTheming] and
/// [initialTheme]. Call [followSystem] to clear the override.
class M3EThemeController extends ChangeNotifier {
  Brightness? _brightnessOverride;

  /// Active manual brightness, or null when following system/initial rules.
  Brightness? get brightnessOverride => _brightnessOverride;

  /// Material [ThemeMode] derived from the manual override, if any.
  ThemeMode get materialThemeMode {
    if (_brightnessOverride == null) {
      return ThemeMode.system;
    }
    return _brightnessOverride == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  /// Locks the theme to [brightness] until [followSystem] is called.
  void setBrightness(Brightness brightness) {
    if (_brightnessOverride == brightness) {
      return;
    }
    _brightnessOverride = brightness;
    notifyListeners();
  }

  /// Toggles between light and dark using the current effective brightness.
  void toggleBrightness({Brightness fallback = Brightness.light}) {
    final Brightness effective = _brightnessOverride ?? fallback;
    setBrightness(
      effective == Brightness.light ? Brightness.dark : Brightness.light,
    );
  }

  /// Clears the manual override so [autoTheming] / [initialTheme] apply again.
  void followSystem() {
    if (_brightnessOverride == null) {
      return;
    }
    _brightnessOverride = null;
    notifyListeners();
  }
}
