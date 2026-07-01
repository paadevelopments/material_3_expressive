import 'package:flutter/widgets.dart';

import 'm3e_color_scheme.dart';
import 'm3e_spacing.dart';
import 'm3e_typography.dart';

/// Immutable bundle of the design tokens shared by every expressive component.
@immutable
class M3EThemeData {
  M3EThemeData({
    M3EColorScheme? colorScheme,
    M3ETypeScale? typeScale,
    this.spacing = const M3ESpacing.regular(),
    this.visualDensity = 0,
  })  : colorScheme = colorScheme ?? M3EColorScheme.light(),
        typeScale = typeScale ?? M3ETypeScale.baseline();

  /// Builds a light theme, optionally seeded from [seedColor].
  factory M3EThemeData.light({Color? seedColor}) {
    return M3EThemeData(
      colorScheme: seedColor == null
          ? M3EColorScheme.light()
          : M3EColorScheme.fromSeed(seedColor),
    );
  }

  /// Builds a dark theme, optionally seeded from [seedColor].
  factory M3EThemeData.dark({Color? seedColor}) {
    return M3EThemeData(
      colorScheme: seedColor == null
          ? M3EColorScheme.dark()
          : M3EColorScheme.fromSeed(seedColor, brightness: Brightness.dark),
    );
  }

  final M3EColorScheme colorScheme;
  final M3ETypeScale typeScale;

  /// The spacing scale used for gaps and padding.
  final M3ESpacing spacing;

  /// Additional density applied to touch targets, in logical pixels per axis.
  final double visualDensity;

  M3EThemeData copyWith({
    M3EColorScheme? colorScheme,
    M3ETypeScale? typeScale,
    M3ESpacing? spacing,
    double? visualDensity,
  }) {
    return M3EThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      typeScale: typeScale ?? this.typeScale,
      spacing: spacing ?? this.spacing,
      visualDensity: visualDensity ?? this.visualDensity,
    );
  }
}

/// Provides an [M3EThemeData] to the widget subtree.
class M3ETheme extends InheritedWidget {
  const M3ETheme({required this.data, required super.child, super.key});

  final M3EThemeData data;

  /// Returns the nearest theme, falling back to a default light theme.
  static M3EThemeData of(BuildContext context) {
    final M3ETheme? theme =
        context.dependOnInheritedWidgetOfExactType<M3ETheme>();
    return theme?.data ?? _fallback;
  }

  static final M3EThemeData _fallback = M3EThemeData();

  @override
  bool updateShouldNotify(M3ETheme oldWidget) => data != oldWidget.data;
}
