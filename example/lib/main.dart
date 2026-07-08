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

  bool _dark = false;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final theme = _dark
        ? M3EThemeData.dark(seedColor: _seed)
        : M3EThemeData.light(seedColor: _seed);
    // The expressive foundation is the single source of truth: it both drives
    // the Material theme (so Material widgets, localizations and overlays are
    // consistent) and is provided to the tree for the `M3E*` components.
    return MaterialApp(
      title: 'Material 3 Expressive',
      debugShowCheckedModeBanner: false,
      theme: theme.toThemeData(),
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

  static const List<M3ENavigationBarDestination> _destinations =
      <M3ENavigationBarDestination>[
    M3ENavigationBarDestination(icon: Icon(M3EIcons.add), label: 'Actions'),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.check), label: 'Selection'),
    M3ENavigationBarDestination(
      icon: Icon(M3EIcons.calendar_today),
      label: 'Containment',
    ),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.menu), label: 'Navigation'),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.search), label: 'Feedback'),
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
                icon: Icon(dark ? M3EIcons.close : M3EIcons.check),
                tooltip: 'Toggle theme',
                onPressed: onToggleTheme,
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
