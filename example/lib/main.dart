import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/navigation_bar/models/m3e_navigation_bar_destination.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import 'pages/actions_page.dart';
import 'pages/containment_page.dart';
import 'pages/feedback_page.dart';
import 'pages/navigation_page.dart';
import 'pages/selection_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await M3EDynamicColorHost.preload();
  runApp(const ExampleApp());
}

/// A full gallery demonstrating every Material 3 Expressive component,
/// grouped the same way as the official Material 3 documentation.
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  static const Color _seed = Color(0xFF6750A4);

  @override
  Widget build(BuildContext context) {
    return M3EMaterialApp(
      title: 'Material 3 Expressive',
      debugShowCheckedModeBanner: false,
      drawUnderSystemBars: true,
      data: M3EThemeData.light(seedColor: _seed),
      autoTheming: true,
      dynamicColoring: true,
      home: const _GalleryShell(),
    );
  }
}

class _GalleryShell extends StatefulWidget {
  const _GalleryShell();

  @override
  State<_GalleryShell> createState() => _GalleryShellState();
}

class _GalleryShellState extends State<_GalleryShell> {
  int _index = 0;

  late final List<GlobalKey> _pageKeys =
      List<GlobalKey>.generate(5, (_) => GlobalKey());

  List<Widget> get _pages => <Widget>[
        ActionsPage(key: _pageKeys[0]),
        SelectionPage(key: _pageKeys[1]),
        ContainmentPage(key: _pageKeys[2]),
        NavigationPage(key: _pageKeys[3]),
        FeedbackPage(key: _pageKeys[4]),
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
            Expanded(
              child: TickerMode(
                enabled: true,
                child: _pages[_index],
              ),
            ),
            M3ENavigationBar(
              destinations: _destinations,
              selectedIndex: _index,
              onDestinationSelected: (int value) =>
                  setState(() => _index = value),
            ),
          ],
        ),
      ),
    );
  }
}
