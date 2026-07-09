import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/navigation_bar/models/m3e_navigation_bar_destination.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import 'pages/actions_page.dart';
import 'pages/containment_page.dart';
import 'pages/feedback_page.dart';
import 'pages/navigation_page.dart';
import 'pages/selection_page.dart';

void main() {
  runApp(const ExampleApp());
}

/// A full gallery demonstrating every Material 3 Expressive component,
/// grouped the same way as the official Material 3 documentation.
class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  static const Color _seed = Color(0xFF6750A4);

  final M3EThemeController _themeController = M3EThemeController();
  int _index = 0;

  M3EThemeData get _baseTheme => M3EThemeData.light(seedColor: _seed);

  M3EThemeData get _darkTheme =>
      M3EThemeData.dark(seedColor: _seed).copyWith(
        typeScale: _baseTheme.typeScale,
        spacing: _baseTheme.spacing,
      );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeController,
      builder: (BuildContext context, Widget? _) {
        final ThemeMode themeMode = _themeController.brightnessOverride != null
            ? _themeController.materialThemeMode
            : ThemeMode.system;

        return MaterialApp(
          title: 'Material 3 Expressive',
          debugShowCheckedModeBanner: false,
          theme: _baseTheme.toThemeData(),
          darkTheme: _darkTheme.toThemeData(),
          themeMode: themeMode,
          builder: (BuildContext context, Widget? child) {
            return M3ETheme(
              data: _baseTheme,
              autoTheming: true,
              dynamicColoring: true,
              controller: _themeController,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: _Gallery(
            index: _index,
            themeController: _themeController,
            onIndexChanged: (int value) => setState(() => _index = value),
          ),
        );
      },
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({
    required this.index,
    required this.themeController,
    required this.onIndexChanged,
  });

  final int index;
  final M3EThemeController themeController;
  final ValueChanged<int> onIndexChanged;

  static const List<Widget> _pages = <Widget>[
    ActionsPage(),
    SelectionPage(),
    ContainmentPage(),
    NavigationPage(),
    FeedbackPage(),
  ];

  static const List<M3ENavigationBarDestination> _destinations =
      <M3ENavigationBarDestination>[
    M3ENavigationBarDestination(icon: Icon(M3EIcons.add), label: 'Do'),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.check), label: 'Pick'),
    M3ENavigationBarDestination(
      icon: Icon(M3EIcons.calendar_today),
      label: 'View',
    ),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.menu), label: 'Nav'),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.search), label: 'Find'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Column(
        children: <Widget>[
          M3EAppBar.top(
            titleText: 'Material 3 Expressive',
            actions: <Widget>[
              M3EIconButton(
                icon: Icon(
                  theme.brightness == Brightness.dark
                      ? M3EIcons.light_mode
                      : M3EIcons.dark_mode,
                ),
                tooltip: 'Toggle theme',
                onPressed: () => themeController.toggleBrightness(
                  fallback: theme.brightness,
                ),
              ),
            ],
          ),
          Expanded(child: _pages[index]),
          M3ENavigationBar(
            destinations: _destinations,
            selectedIndex: index,
            onDestinationSelected: onIndexChanged,
          ),
        ],
      ),
    );
  }
}
