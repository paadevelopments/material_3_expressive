import 'package:flutter/material.dart' show InheritedTheme, Theme;
import 'package:flutter/widgets.dart';

import 'm3e_theme_controller.dart';
import 'm3e_theme_data.dart';
import 'm3e_theme_scope.dart';

export 'components/m3e_component_theme.dart';
export 'm3e_theme_controller.dart';
export 'm3e_theme_data.dart';
export 'm3e_theme_scope.dart';

/// Provides an [M3EThemeData] to the widget subtree.
///
/// At the app entry point, pass [initialTheme], [autoTheming], [dynamicColoring],
/// and an optional [controller] to enable adaptive theming. Nested instances
/// that only pass [data] continue to provide a static local override.
class M3ETheme extends StatefulWidget {
  const M3ETheme({
    required this.data,
    required this.child,
    this.initialTheme,
    this.autoTheming,
    this.dynamicColoring,
    this.controller,
    super.key,
  });

  final M3EThemeData data;
  final Widget child;
  final Brightness? initialTheme;
  final bool? autoTheming;
  final bool? dynamicColoring;
  final M3EThemeController? controller;

  bool get usesAdaptiveScope =>
      initialTheme != null ||
      autoTheming == true ||
      dynamicColoring == true ||
      controller != null;

  /// Returns the nearest expressive theme, or derives one from Material.
  static M3EThemeData of(BuildContext context) {
    final _M3EInheritedTheme? inherited =
        context.dependOnInheritedWidgetOfExactType<_M3EInheritedTheme>();
    if (inherited != null) {
      return inherited.data;
    }
    final M3EThemeData? scoped = M3EThemeScope.resolveForComponent(context);
    if (scoped != null) {
      return scoped;
    }
    return M3EThemeData.fromMaterial(Theme.of(context));
  }

  /// Returns the nearest expressive theme, or null if none is found.
  static M3EThemeData? maybeOf(BuildContext context) {
    final _M3EInheritedTheme? inherited =
        context.getInheritedWidgetOfExactType<_M3EInheritedTheme>();
    if (inherited != null) {
      return inherited.data;
    }
    return M3EThemeScope.resolveOf(context);
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
  State<M3ETheme> createState() => _M3EThemeState();
}

class _M3EThemeState extends State<M3ETheme> {
  M3EThemeController? _internalController;

  M3EThemeController get _effectiveController =>
      widget.controller ?? (_internalController ??= M3EThemeController());

  @override
  Widget build(BuildContext context) {
    if (widget.usesAdaptiveScope) {
      return M3EThemeScope(
        baseData: widget.data,
        initialTheme: widget.initialTheme,
        autoTheming: widget.autoTheming,
        dynamicColoring: widget.dynamicColoring,
        controller: _effectiveController,
        child: widget.child,
      );
    }

    return _M3EThemeProvider(data: widget.data, child: widget.child);
  }
}

/// Applies a resolved [M3EThemeData] to a subtree.
class _M3EThemeProvider extends StatelessWidget {
  const _M3EThemeProvider({required this.data, required this.child});

  final M3EThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = data.typeScale.bodyMedium.copyWith(
      color: data.colorScheme.onSurface,
      decoration: TextDecoration.none,
    );
    Widget themedChild = _M3EInheritedTheme(
      data: data,
      child: IconTheme(
        data: IconThemeData(color: data.colorScheme.onSurface, size: 24),
        child: DefaultTextStyle(
          style: baseStyle,
          child: child,
        ),
      ),
    );
    if (data.splashColor != null || data.highlightColor != null) {
      themedChild = Theme(
        data: Theme.of(context).copyWith(
          splashColor: data.splashColor,
          highlightColor: data.highlightColor,
        ),
        child: themedChild,
      );
    }
    return themedChild;
  }
}

class _M3EInheritedTheme extends InheritedTheme {
  const _M3EInheritedTheme({required this.data, required super.child});

  final M3EThemeData data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return _M3EThemeProvider(data: data, child: child);
  }

  @override
  bool updateShouldNotify(_M3EInheritedTheme oldWidget) =>
      data != oldWidget.data;
}
