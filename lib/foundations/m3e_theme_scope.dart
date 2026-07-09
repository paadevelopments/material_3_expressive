import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart' show Brightness, ColorScheme;
import 'package:flutter/widgets.dart';

import 'm3e_color_scheme.dart';
import 'm3e_resolved_theme.dart';
import 'm3e_theme_controller.dart';
import 'm3e_theme_data.dart';

/// Hosts adaptive theme listeners and resolves [M3EThemeData] for components.
class M3EThemeScope extends StatefulWidget {
  const M3EThemeScope({
    required this.baseData,
    required this.controller,
    required this.child,
    this.initialTheme,
    this.autoTheming,
    this.dynamicColoring,
    super.key,
  });

  final M3EThemeData baseData;
  final M3EThemeController controller;
  final Widget child;
  final Brightness? initialTheme;
  final bool? autoTheming;
  final bool? dynamicColoring;

  /// Returns the nearest scope, if any.
  static M3EThemeScopeState? maybeOf(BuildContext context) {
    final _InheritedM3EThemeScope? inherited = context
        .getInheritedWidgetOfExactType<_InheritedM3EThemeScope>();
    return inherited?.scopeState;
  }

  /// Resolves theme from the nearest scope, or null when none is present.
  static M3EThemeData? resolveOf(BuildContext context) {
    return maybeOf(context)?.resolve(context);
  }

  /// Resolves theme for a component, registering an inherited dependency.
  static M3EThemeData? resolveForComponent(BuildContext context) {
    final _InheritedM3EThemeScope? inherited = context
        .dependOnInheritedWidgetOfExactType<_InheritedM3EThemeScope>();
    return inherited?.resolve(context);
  }

  @override
  State<M3EThemeScope> createState() => M3EThemeScopeState();
}

class M3EThemeScopeState extends State<M3EThemeScope> {
  M3EThemeData get baseData => widget.baseData;
  M3EThemeController get controller => widget.controller;
  Brightness? get initialTheme => widget.initialTheme;
  bool get autoTheming => widget.autoTheming == true;
  bool get dynamicColoring => widget.dynamicColoring == true;

  M3EThemeData get lightTemplate => widget.baseData;
  M3EThemeData get darkTemplate => M3EThemeData.dark(
        seedColor: widget.baseData.colorScheme.primary,
      ).copyWith(
        typeScale: widget.baseData.typeScale,
        spacing: widget.baseData.spacing,
        visualDensity: widget.baseData.visualDensity,
        platform: widget.baseData.platform,
        useMaterial3: widget.baseData.useMaterial3,
        splashColor: widget.baseData.splashColor,
        highlightColor: widget.baseData.highlightColor,
        appBarTheme: widget.baseData.appBarTheme,
        badgeTheme: widget.baseData.badgeTheme,
        bottomSheetTheme: widget.baseData.bottomSheetTheme,
        buttonTheme: widget.baseData.buttonTheme,
        cardTheme: widget.baseData.cardTheme,
        carouselTheme: widget.baseData.carouselTheme,
        checkboxTheme: widget.baseData.checkboxTheme,
        chipTheme: widget.baseData.chipTheme,
        datePickerTheme: widget.baseData.datePickerTheme,
        dialogTheme: widget.baseData.dialogTheme,
        dividerTheme: widget.baseData.dividerTheme,
        fabTheme: widget.baseData.fabTheme,
        fabMenuTheme: widget.baseData.fabMenuTheme,
        iconButtonTheme: widget.baseData.iconButtonTheme,
        listTheme: widget.baseData.listTheme,
        loadingIndicatorTheme: widget.baseData.loadingIndicatorTheme,
        menuTheme: widget.baseData.menuTheme,
        navigationBarTheme: widget.baseData.navigationBarTheme,
        navigationDrawerTheme: widget.baseData.navigationDrawerTheme,
        navigationRailTheme: widget.baseData.navigationRailTheme,
        progressIndicatorTheme: widget.baseData.progressIndicatorTheme,
        radioTheme: widget.baseData.radioTheme,
        refreshIndicatorTheme: widget.baseData.refreshIndicatorTheme,
        searchBarTheme: widget.baseData.searchBarTheme,
        segmentedButtonTheme: widget.baseData.segmentedButtonTheme,
        sideSheetTheme: widget.baseData.sideSheetTheme,
        sliderTheme: widget.baseData.sliderTheme,
        snackBarTheme: widget.baseData.snackBarTheme,
        splitButtonTheme: widget.baseData.splitButtonTheme,
        switchTheme: widget.baseData.switchTheme,
        tabTheme: widget.baseData.tabTheme,
        textFieldTheme: widget.baseData.textFieldTheme,
        timePickerTheme: widget.baseData.timePickerTheme,
        toggleButtonTheme: widget.baseData.toggleButtonTheme,
        toggleButtonGroupTheme: widget.baseData.toggleButtonGroupTheme,
        toolbarTheme: widget.baseData.toolbarTheme,
        tooltipTheme: widget.baseData.tooltipTheme,
      );

  Brightness resolveBrightness(BuildContext context) {
    final Brightness? manual = widget.controller.brightnessOverride;
    if (manual != null) {
      return manual;
    }
    if (autoTheming) {
      return MediaQuery.platformBrightnessOf(context);
    }
    return initialTheme ?? Brightness.light;
  }

  M3EThemeData resolve(
    BuildContext context, {
    ColorScheme? lightDynamic,
    ColorScheme? darkDynamic,
  }) {
    final Brightness brightness = resolveBrightness(context);
    final M3EThemeData template =
        brightness == Brightness.dark ? darkTemplate : lightTemplate;

    if (!dynamicColoring) {
      return template;
    }

    final ColorScheme? dynamicScheme =
        brightness == Brightness.dark ? darkDynamic : lightDynamic;
    if (dynamicScheme == null) {
      return template;
    }

    final ColorScheme harmonizedDynamic = dynamicScheme.harmonized();
    final M3EColorScheme m3eScheme =
        M3EColorScheme.fromColorScheme(harmonizedDynamic).harmonized();

    return template.withColorScheme(m3eScheme);
  }

  Widget _buildInheritedScope(
    BuildContext context, {
    ColorScheme? lightDynamic,
    ColorScheme? darkDynamic,
  }) {
    final Brightness? manualBrightness = widget.controller.brightnessOverride;
    final Brightness? platformBrightness =
        autoTheming ? MediaQuery.platformBrightnessOf(context) : null;
    final M3EThemeData resolved = resolve(
      context,
      lightDynamic: lightDynamic,
      darkDynamic: darkDynamic,
    );

    return _InheritedM3EThemeScope(
      scopeState: this,
      manualBrightness: manualBrightness,
      platformBrightness: platformBrightness,
      lightDynamic: lightDynamic,
      darkDynamic: darkDynamic,
      child: M3EResolvedTheme(
        data: resolved,
        child: widget.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (dynamicColoring) {
      return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return ListenableBuilder(
            listenable: widget.controller,
            builder: (BuildContext context, Widget? _) {
              return _buildInheritedScope(
                context,
                lightDynamic: lightDynamic,
                darkDynamic: darkDynamic,
              );
            },
          );
        },
      );
    }

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (BuildContext context, Widget? _) {
        return _buildInheritedScope(context);
      },
    );
  }
}

class _InheritedM3EThemeScope extends InheritedWidget {
  const _InheritedM3EThemeScope({
    required this.scopeState,
    required this.manualBrightness,
    required this.platformBrightness,
    required this.lightDynamic,
    required this.darkDynamic,
    required super.child,
  });

  final M3EThemeScopeState scopeState;
  final Brightness? manualBrightness;
  final Brightness? platformBrightness;
  final ColorScheme? lightDynamic;
  final ColorScheme? darkDynamic;

  M3EThemeData resolve(BuildContext context) {
    return scopeState.resolve(
      context,
      lightDynamic: lightDynamic,
      darkDynamic: darkDynamic,
    );
  }

  @override
  bool updateShouldNotify(_InheritedM3EThemeScope oldWidget) {
    return scopeState != oldWidget.scopeState ||
        manualBrightness != oldWidget.manualBrightness ||
        platformBrightness != oldWidget.platformBrightness ||
        lightDynamic != oldWidget.lightDynamic ||
        darkDynamic != oldWidget.darkDynamic;
  }
}
