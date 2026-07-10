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
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return M3EMaterialApp(
      title: 'Material 3 Expressive',
      debugShowCheckedModeBanner: false,
      data: M3EThemeData.light(seedColor: _seed),
      autoTheming: true,
      dynamicColoring: true,
      home: _Gallery(
        index: _index,
        onIndexChanged: (int value) => setState(() => _index = value),
      ),
    );
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({
    required this.index,
    required this.onIndexChanged,
  });

  final int index;
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
    return Scaffold(
      body: ColoredBox(
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
                  onPressed: () => M3ETheme.controllerOf(context)?.toggleBrightness(
                    fallback: theme.brightness,
                    autoTheming: true,
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
      ),
    );
  }
}
