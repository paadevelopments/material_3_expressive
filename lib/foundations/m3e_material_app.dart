import 'package:flutter/material.dart';

import 'm3e_theme.dart';

/// A [MaterialApp] wired to adaptive [M3ETheme] with minimal integration code.
///
/// Owns platform-brightness observation, [M3EThemeController] lifecycle, and
/// keeps Material [ThemeMode] aligned with the resolved M3E brightness.
///
/// `themeMode` and the core `MaterialApp.builder` are managed internally.
/// Use `appBuilder` to wrap the themed subtree when extra integration layers
/// are needed.
class M3EMaterialApp extends StatefulWidget {
  const M3EMaterialApp({
    required this.data,
    required this.home,
    this.autoTheming,
    this.dynamicColoring,
    this.initialTheme,
    this.controller,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.onNavigationNotification,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.appBuilder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.themeAnimationStyle,
    super.key,
  });

  final M3EThemeData data;
  final Widget home;
  final bool? autoTheming;
  final bool? dynamicColoring;
  final Brightness? initialTheme;
  final M3EThemeController? controller;

  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final Map<String, WidgetBuilder> routes;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;
  final InitialRouteListFactory? onGenerateInitialRoutes;
  final RouteFactory? onUnknownRoute;
  final NotificationListenerCallback<NavigationNotification>?
      onNavigationNotification;
  final List<NavigatorObserver> navigatorObservers;

  /// Optional wrapper applied after `M3ETheme` in the internal `MaterialApp.builder`.
  final TransitionBuilder? appBuilder;

  final String title;
  final GenerateAppTitle? onGenerateTitle;
  final Color? color;

  /// Optional Material light theme override. Defaults to `data.toThemeData`.
  final ThemeData? theme;

  /// Optional Material dark theme override. Defaults to
  /// `data.deriveDarkTemplate().toThemeData`.
  final ThemeData? darkTheme;

  final ThemeData? highContrastTheme;
  final ThemeData? highContrastDarkTheme;
  final Duration themeAnimationDuration;
  final Curve themeAnimationCurve;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final LocaleResolutionCallback? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool debugShowMaterialGrid;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final String? restorationScopeId;
  final ScrollBehavior? scrollBehavior;
  final AnimationStyle? themeAnimationStyle;

  bool get _usesAdaptiveLifecycle =>
      (autoTheming ?? false) ||
      (dynamicColoring ?? false) ||
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
      autoTheming: widget.autoTheming ?? false,
      initialTheme: widget.initialTheme,
    );

    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      scaffoldMessengerKey: widget.scaffoldMessengerKey,
      home: widget.home,
      routes: widget.routes,
      initialRoute: widget.initialRoute,
      onGenerateRoute: widget.onGenerateRoute,
      onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
      onUnknownRoute: widget.onUnknownRoute,
      onNavigationNotification: widget.onNavigationNotification,
      navigatorObservers: widget.navigatorObservers,
      title: widget.title,
      onGenerateTitle: widget.onGenerateTitle,
      color: widget.color,
      theme: widget.theme ?? widget.data.toThemeData(),
      darkTheme:
          widget.darkTheme ?? widget.data.deriveDarkTemplate().toThemeData(),
      highContrastTheme: widget.highContrastTheme,
      highContrastDarkTheme: widget.highContrastDarkTheme,
      themeMode: themeMode,
      themeAnimationDuration: widget.themeAnimationDuration,
      themeAnimationCurve: widget.themeAnimationCurve,
      locale: widget.locale,
      localizationsDelegates: widget.localizationsDelegates,
      localeListResolutionCallback: widget.localeListResolutionCallback,
      localeResolutionCallback: widget.localeResolutionCallback,
      supportedLocales: widget.supportedLocales,
      debugShowMaterialGrid: widget.debugShowMaterialGrid,
      showPerformanceOverlay: widget.showPerformanceOverlay,
      checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
      showSemanticsDebugger: widget.showSemanticsDebugger,
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      shortcuts: widget.shortcuts,
      actions: widget.actions,
      restorationScopeId: widget.restorationScopeId,
      scrollBehavior: widget.scrollBehavior,
      themeAnimationStyle: widget.themeAnimationStyle,
      builder: (BuildContext context, Widget? child) {
        final Widget themed = M3ETheme(
          data: widget.data,
          autoTheming: widget.autoTheming,
          dynamicColoring: widget.dynamicColoring,
          initialTheme: widget.initialTheme,
          controller: _effectiveController,
          child: child ?? const SizedBox.shrink(),
        );
        return widget.appBuilder?.call(context, themed) ?? themed;
      },
    );
  }
}
