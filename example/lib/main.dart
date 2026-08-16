import 'package:material_3_expressive/components/navigation_bar/models/m3e_navigation_bar_destination.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'catalog/m3e_demo_section.dart';
import 'pages/section_host_page.dart';
import 'pages/theme_config_page.dart';
import 'theme/example_theme_scope.dart';
import 'theme/example_theme_settings.dart';

void main() {
  runApp(const ExampleApp());
}

/// Material 3 Expressive gallery with catalog-driven playgrounds.
class ExampleApp extends StatefulWidget {
  /// Creates the example app.
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  final ExampleThemeSettings _settings = ExampleThemeSettings();

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Rebuilds the app on every settings change so theming updates instantly.
    return ListenableBuilder(
      listenable: _settings,
      builder: (BuildContext context, Widget? _) {
        return ExampleThemeScope(
          settings: _settings,
          child: M3EMaterialApp(
            title: 'Material 3 Expressive',
            debugShowCheckedModeBanner: false,
            drawUnderSystemBars: true,
            data: M3EThemeData.light(seedColor: _settings.seedColor),
            fontFamily: _settings.fontFamily,
            fontVariations: _settings.fontVariations,
            autoTheming: _settings.autoTheming,
            dynamicColoring: _settings.dynamicColoring,
            home: const _GalleryShell(),
          ),
        );
      },
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

  late final List<GlobalKey> _pageKeys = List<GlobalKey>.generate(
    5,
    (_) => GlobalKey(),
  );

  List<Widget> get _pages => <Widget>[
    SectionHostPage(key: _pageKeys[0], section: M3EDemoSection.doSection),
    SectionHostPage(key: _pageKeys[1], section: M3EDemoSection.pickSection),
    SectionHostPage(key: _pageKeys[2], section: M3EDemoSection.viewSection),
    SectionHostPage(key: _pageKeys[3], section: M3EDemoSection.navSection),
    SectionHostPage(key: _pageKeys[4], section: M3EDemoSection.findSection),
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
    final M3EThemeData theme = M3ETheme.of(context);
    return Scaffold(
      body: ColoredBox(
        color: theme.colorScheme.surface,
        child: Column(
          children: <Widget>[
            M3EAppBar.top(
              titleText: 'Material 3 Expressive',
              actions: <Widget>[
                M3EIconButton(
                  icon: const Icon(M3EIcons.palette),
                  tooltip: 'Theme settings',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const ThemeConfigPage(),
                      ),
                    );
                  },
                ),
                M3EIconButton(
                  icon: Icon(
                    theme.brightness == Brightness.dark
                        ? M3EIcons.light_mode
                        : M3EIcons.dark_mode,
                  ),
                  tooltip: 'Toggle theme',
                  onPressed: () {
                    M3ETheme.controllerOf(context)?.toggleBrightness(
                      fallback: theme.brightness,
                      autoTheming: ExampleThemeScope.of(context).autoTheming,
                    );
                  },
                ),
              ],
            ),
            Expanded(child: TickerMode(enabled: true, child: _pages[_index])),
            M3ENavigationBar(
              destinations: _destinations,
              selectedIndex: _index,
              onDestinationSelected: (int value) {
                setState(() => _index = value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
