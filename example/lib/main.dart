import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  bool _dark = false;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final theme = _dark
        ? M3EThemeData.dark(seedColor: _seed)
        : M3EThemeData.light(seedColor: _seed);
    return WidgetsApp(
      title: 'Material 3 Expressive',
      color: theme.colorScheme.primary,
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (BuildContext context, _, _) => builder(context),
        );
      },
      home: M3ETheme(
        data: theme,
        child: _Gallery(
          index: _index,
          dark: _dark,
          onIndexChanged: (int value) => setState(() => _index = value),
          onToggleTheme: () => setState(() => _dark = !_dark),
        ),
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({
    required this.index,
    required this.dark,
    required this.onIndexChanged,
    required this.onToggleTheme,
  });

  final int index;
  final bool dark;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback onToggleTheme;

  static const List<Widget> _pages = <Widget>[
    ActionsPage(),
    SelectionPage(),
    ContainmentPage(),
    NavigationPage(),
    FeedbackPage(),
  ];

  static const List<M3ENavigationDestination> _destinations =
      <M3ENavigationDestination>[
    M3ENavigationDestination(icon: Icon(M3EIcons.add), label: 'Actions'),
    M3ENavigationDestination(icon: Icon(M3EIcons.check), label: 'Selection'),
    M3ENavigationDestination(
      icon: Icon(M3EIcons.calendar_today),
      label: 'Containment',
    ),
    M3ENavigationDestination(icon: Icon(M3EIcons.menu), label: 'Navigation'),
    M3ENavigationDestination(icon: Icon(M3EIcons.search), label: 'Feedback'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Column(
        children: <Widget>[
          M3ENavigation.topAppBar(
            title: 'Material 3 Expressive',
            actions: <Widget>[
              M3EActions.iconButton(
                icon: Icon(dark ? M3EIcons.close : M3EIcons.check),
                tooltip: 'Toggle theme',
                onPressed: onToggleTheme,
              ),
            ],
          ),
          Expanded(child: _pages[index]),
          M3ENavigation.bar(
            destinations: _destinations,
            selectedIndex: index,
            onDestinationSelected: onIndexChanged,
          ),
        ],
      ),
    );
  }
}
