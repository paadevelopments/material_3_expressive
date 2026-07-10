import 'package:flutter/material.dart';

import 'm3e_theme.dart';
import 'm3e_theme_controller.dart';
import 'm3e_theme_data.dart';

/// A [MaterialApp] wired to adaptive [M3ETheme] with minimal integration code.
///
/// Owns platform-brightness observation, [M3EThemeController] lifecycle, and
/// keeps Material [ThemeMode] aligned with the resolved M3E brightness.
class M3EMaterialApp extends StatefulWidget {
  const M3EMaterialApp({
    required this.data,
    required this.home,
    this.autoTheming,
    this.dynamicColoring,
    this.initialTheme,
    this.controller,
    this.title,
    this.debugShowCheckedModeBanner,
    this.routes,
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.navigatorKey,
    this.theme,
    this.darkTheme,
    super.key,
  });

  final M3EThemeData data;
  final Widget home;
  final bool? autoTheming;
  final bool? dynamicColoring;
  final Brightness? initialTheme;
  final M3EThemeController? controller;
  final String? title;
  final bool? debugShowCheckedModeBanner;
  final Map<String, WidgetBuilder>? routes;
  final RouteFactory? onGenerateRoute;
  final RouteFactory? onUnknownRoute;
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Optional Material light theme override. Defaults to [data.toThemeData].
  final ThemeData? theme;

  /// Optional Material dark theme override. Defaults to
  /// [data.deriveDarkTemplate().toThemeData].
  final ThemeData? darkTheme;

  bool get _usesAdaptiveLifecycle =>
      autoTheming == true ||
      dynamicColoring == true ||
      controller != null;

  @override
  State<M3EMaterialApp> createState() => _M3EMaterialAppState();
}

class _M3EMaterialAppState extends State<M3EMaterialApp>
    with WidgetsBindingObserver {
  M3EThemeController? _internalController;

  M3EThemeController get _effectiveController =>
      widget.controller ?? (_internalController ??= M3EThemeController());

  @override
  void initState() {
    super.initState();
    if (widget._usesAdaptiveLifecycle) {
      WidgetsBinding.instance.addObserver(this);
      _effectiveController.addListener(_onThemeControllerChanged);
    }
  }

  @override
  void didUpdateWidget(covariant M3EMaterialApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      if (oldWidget._usesAdaptiveLifecycle) {
        (oldWidget.controller ?? _internalController)
            ?.removeListener(_onThemeControllerChanged);
      }
      if (widget._usesAdaptiveLifecycle) {
        _effectiveController.addListener(_onThemeControllerChanged);
      }
    }
  }

  @override
  void dispose() {
    if (widget._usesAdaptiveLifecycle) {
      WidgetsBinding.instance.removeObserver(this);
      _effectiveController.removeListener(_onThemeControllerChanged);
    }
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
  }

  void _onThemeControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Brightness platformBrightness =
        MediaQuery.maybePlatformBrightnessOf(context) ??
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final ThemeMode themeMode = _effectiveController.effectiveThemeMode(
      platformBrightness: platformBrightness,
      autoTheming: widget.autoTheming == true,
      initialTheme: widget.initialTheme,
    );

    return MaterialApp(
      title: widget.title ?? '',
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner ?? true,
      theme: widget.theme ?? widget.data.toThemeData(),
      darkTheme: widget.darkTheme ?? widget.data.deriveDarkTemplate().toThemeData(),
      themeMode: themeMode,
      navigatorKey: widget.navigatorKey,
      routes: widget.routes ?? const <String, WidgetBuilder>{},
      onGenerateRoute: widget.onGenerateRoute,
      onUnknownRoute: widget.onUnknownRoute,
      home: widget.home,
      builder: (BuildContext context, Widget? child) {
        return M3ETheme(
          data: widget.data,
          autoTheming: widget.autoTheming,
          dynamicColoring: widget.dynamicColoring,
          initialTheme: widget.initialTheme,
          controller: _effectiveController,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
