import 'package:flutter/widgets.dart';

/// Runtime theme choices for the gallery, edited from the theme config screen.
///
/// Notifies so the root [M3EMaterialApp] can rebuild with the new values.
class ExampleThemeSettings extends ChangeNotifier {
  /// Seed choices offered when dynamic color is off.
  ///
  /// The first entry is the package default seed.
  static const List<Color> seedOptions = <Color>[
    Color(0xFF6750A4),
    Color(0xFF00658F),
    Color(0xFF006D3D),
    Color(0xFF8F4C00),
    Color(0xFFA1003C),
  ];

  /// Labels shown under each entry in [seedOptions].
  static const List<String> seedLabels = <String>[
    'Default',
    'Ocean',
    'Forest',
    'Amber',
    'Rose',
  ];

  bool _autoTheming = true;
  bool _dynamicColoring = true;
  Color _seedColor = seedOptions.first;

  /// Whether the theme follows the platform brightness.
  bool get autoTheming => _autoTheming;

  set autoTheming(bool value) {
    if (value == _autoTheming) {
      return;
    }
    _autoTheming = value;
    notifyListeners();
  }

  /// Whether device dynamic color overrides the seeded scheme.
  bool get dynamicColoring => _dynamicColoring;

  set dynamicColoring(bool value) {
    if (value == _dynamicColoring) {
      return;
    }
    _dynamicColoring = value;
    notifyListeners();
  }

  /// Seed used to generate the scheme when dynamic color is off.
  Color get seedColor => _seedColor;

  set seedColor(Color value) {
    if (value == _seedColor) {
      return;
    }
    _seedColor = value;
    notifyListeners();
  }
}
