import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Named M3 Expressive type styles for the gallery picker.
enum ExampleTypeStyle {
  /// Baseline scale with no extra axes.
  regular('Regular'),

  /// Weight and grade bump.
  emphasized('Emphasized'),

  /// Condensed width.
  condensed('Condensed'),

  /// Extra-condensed width.
  extraCondensed('Extra condensed'),

  /// Wide width.
  wide('Wide'),

  /// Extra-wide width.
  extraWide('Extra wide'),

  /// Roundness on.
  round('Round');

  const ExampleTypeStyle(this.label);

  /// Short label shown in the theme config picker.
  final String label;

  /// Roboto Flex axes for this style.
  List<FontVariation> get variations {
    switch (this) {
      case ExampleTypeStyle.regular:
        return M3ETypeVariations.regular.variations;
      case ExampleTypeStyle.emphasized:
        return M3ETypeVariations.emphasized.variations;
      case ExampleTypeStyle.condensed:
        return M3ETypeVariations.condensed.variations;
      case ExampleTypeStyle.extraCondensed:
        return M3ETypeVariations.extraCondensed.variations;
      case ExampleTypeStyle.wide:
        return M3ETypeVariations.wide.variations;
      case ExampleTypeStyle.extraWide:
        return M3ETypeVariations.extraWide.variations;
      case ExampleTypeStyle.round:
        return M3ETypeVariations.round.variations;
    }
  }
}

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

  /// Family name registered for Roboto Flex in the example app.
  static const String robotoFlex = 'Roboto Flex';

  /// Family name registered for Roboto Mono in the example app.
  static const String robotoMono = 'Roboto Mono';

  bool _autoTheming = true;
  bool _dynamicColoring = true;
  Color _seedColor = seedOptions.first;
  String? _fontFamily;
  ExampleTypeStyle _typeStyle = ExampleTypeStyle.regular;

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

  /// Font family for the gallery, or null for the platform default.
  String? get fontFamily => _fontFamily;

  set fontFamily(String? value) {
    if (value == _fontFamily) {
      return;
    }
    _fontFamily = value;
    if (value != robotoFlex && _typeStyle != ExampleTypeStyle.regular) {
      _typeStyle = ExampleTypeStyle.regular;
    }
    notifyListeners();
  }

  /// M3 Expressive type style. Applied only when [fontFamily] is Roboto Flex.
  ExampleTypeStyle get typeStyle => _typeStyle;

  set typeStyle(ExampleTypeStyle value) {
    if (value == _typeStyle) {
      return;
    }
    _typeStyle = value;
    notifyListeners();
  }

  /// Variable-font axes for [M3EMaterialApp.fontVariations], or null.
  List<FontVariation>? get fontVariations {
    if (_fontFamily != robotoFlex) {
      return null;
    }
    return _typeStyle.variations;
  }
}
