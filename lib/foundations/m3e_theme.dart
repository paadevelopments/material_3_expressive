import 'package:flutter/material.dart' show InheritedTheme, Theme;
import 'package:flutter/widgets.dart';

import 'm3e_theme_data.dart';

export 'm3e_theme_data.dart';

/// Provides an [M3EThemeData] to the widget subtree.
class M3ETheme extends StatelessWidget {
  const M3ETheme({required this.data, required this.child, super.key});

  final M3EThemeData data;
  final Widget child;

  /// Returns the nearest expressive theme, or derives one from Material.
  static M3EThemeData of(BuildContext context) {
    final _M3EInheritedTheme? inherited =
        context.dependOnInheritedWidgetOfExactType<_M3EInheritedTheme>();
    if (inherited != null) {
      return inherited.data;
    }
    return M3EThemeData.fromMaterial(Theme.of(context));
  }

  /// Returns the nearest expressive theme, or null if none is found.
  static M3EThemeData? maybeOf(BuildContext context) {
    final _M3EInheritedTheme? inherited =
        context.getInheritedWidgetOfExactType<_M3EInheritedTheme>();
    return inherited?.data;
  }

  /// Brightness from the nearest [M3ETheme], else platform brightness.
  static Brightness brightnessOf(BuildContext context) {
    return maybeOf(context)?.brightness ??
        MediaQuery.platformBrightnessOf(context);
  }

  /// Platform from the nearest [M3ETheme], else [Theme] or default.
  static TargetPlatform platformOf(BuildContext context) {
    final M3EThemeData? theme = maybeOf(context);
    if (theme?.platform != null) {
      return theme!.platform!;
    }
    return Theme.of(context).platform;
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = data.typeScale.bodyMedium.copyWith(
      color: data.colorScheme.onSurface,
      decoration: TextDecoration.none,
    );
    return _M3EInheritedTheme(
      data: data,
      child: IconTheme(
        data: IconThemeData(color: data.colorScheme.onSurface, size: 24),
        child: DefaultTextStyle(
          style: baseStyle,
          child: child,
        ),
      ),
    );
  }
}

class _M3EInheritedTheme extends InheritedTheme {
  const _M3EInheritedTheme({required this.data, required super.child});

  final M3EThemeData data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return M3ETheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(_M3EInheritedTheme oldWidget) =>
      data != oldWidget.data;
}
