import 'package:flutter/material.dart' show Theme, ThemeData, VisualDensity;
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

  /// Derives an [M3EThemeData] from an ambient Material [ThemeData].
  ///
  /// The color scheme and type scale are adapted from [theme] so expressive
  /// components inherit the values of a surrounding `MaterialApp` without any
  /// extra wiring. Results are memoised per [ThemeData] instance so a stable
  /// Material theme yields a stable [M3EThemeData] identity.
  factory M3EThemeData.fromMaterial(ThemeData theme) {
    final M3EThemeData? cached = _materialCache[theme];
    if (cached != null) {
      return cached;
    }
    final data = M3EThemeData(
      colorScheme: M3EColorScheme.fromColorScheme(theme.colorScheme),
      typeScale: M3ETypeScale.fromTextTheme(theme.textTheme),
      visualDensity: theme.visualDensity.vertical,
    );
    _materialCache[theme] = data;
    return data;
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

  /// Projects these expressive tokens onto a Material [ThemeData].
  ///
  /// Use this to drive a `MaterialApp` from the expressive foundation so that
  /// Material widgets and `M3E*` components share a single source of truth:
  ///
  /// ```dart
  /// final tokens = M3EThemeData.light(seedColor: seed);
  /// MaterialApp(
  ///   theme: tokens.toThemeData(),
  ///   home: M3ETheme(data: tokens, child: ...),
  /// );
  /// ```
  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme.toColorScheme(),
      textTheme: typeScale.toTextTheme(),
      visualDensity: VisualDensity(
        horizontal: visualDensity,
        vertical: visualDensity,
      ),
    );
  }
}

/// Memoises [M3EThemeData.fromMaterial] results per [ThemeData] instance.
final Expando<M3EThemeData> _materialCache = Expando<M3EThemeData>();

/// Provides an [M3EThemeData] to the widget subtree.
///
/// Besides exposing the tokens via [M3ETheme.of], this also establishes the
/// ambient [DefaultTextStyle] and [IconTheme] for its subtree so that plain
/// `Text` and `Icon` widgets are styled from the expressive foundation even
/// when there is no surrounding `Material`/`Scaffold` (which would otherwise
/// leave text with the debug "missing default text style" appearance).
class M3ETheme extends StatelessWidget {
  const M3ETheme({required this.data, required this.child, super.key});

  /// The tokens provided to the subtree.
  final M3EThemeData data;

  /// The subtree that reads these tokens.
  final Widget child;

  /// Returns the nearest expressive theme.
  ///
  /// Resolution order:
  /// 1. the nearest [M3ETheme] ancestor, if any;
  /// 2. otherwise a theme derived from the ambient Material [ThemeData] via
  ///    [M3EThemeData.fromMaterial], so components pick up a surrounding
  ///    `MaterialApp` theme automatically.
  ///
  /// When neither is customised the ambient Material theme still supplies a
  /// sensible default, keeping the foundation the single value reference.
  static M3EThemeData of(BuildContext context) {
    final _M3EInheritedTheme? theme =
        context.dependOnInheritedWidgetOfExactType<_M3EInheritedTheme>();
    if (theme != null) {
      return theme.data;
    }
    return M3EThemeData.fromMaterial(Theme.of(context));
  }

  @override
  Widget build(BuildContext context) {
    // A non-merging DefaultTextStyle fully shadows any ancestor fallback style
    // (including the debug yellow double-underline shown when text has no real
    // default), so plain Text is always styled from the expressive tokens.
    final TextStyle baseStyle = data.typeScale.bodyMedium.copyWith(
      color: data.colorScheme.onSurface,
      decoration: TextDecoration.none,
    );
    return _M3EInheritedTheme(
      data: data,
      child: IconTheme.merge(
        data: IconThemeData(color: data.colorScheme.onSurface, size: 24),
        child: DefaultTextStyle(style: baseStyle, child: child),
      ),
    );
  }
}

/// Carries [M3EThemeData] down the tree for [M3ETheme.of].
class _M3EInheritedTheme extends InheritedWidget {
  const _M3EInheritedTheme({required this.data, required super.child});

  final M3EThemeData data;

  @override
  bool updateShouldNotify(_M3EInheritedTheme oldWidget) =>
      data != oldWidget.data;
}
