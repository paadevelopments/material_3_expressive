import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../widgets/gallery_section.dart';

/// Demonstrates every component in the Material 3 *Navigation* group.
class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _barIndex = 0;
  int _railIndex = 0;
  int _drawerIndex = 0;
  int _primaryTab = 0;
  int _secondaryTab = 0;

  static const List<M3ENavigationDestination> _destinations =
      <M3ENavigationDestination>[
    M3ENavigationDestination(icon: Icon(M3EIcons.menu), label: 'Home'),
    M3ENavigationDestination(
      icon: Icon(M3EIcons.search),
      label: 'Search',
      showBadge: true,
    ),
    M3ENavigationDestination(
      icon: Icon(M3EIcons.calendarToday),
      label: 'Agenda',
      badgeLabel: '3',
    ),
    M3ENavigationDestination(icon: Icon(M3EIcons.edit), label: 'Drafts'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        _appBars(theme),
        _tabs(),
        _bar(theme),
        _railAndDrawer(theme),
        _toolbarAndMenu(),
      ],
    );
  }

  Widget _framed(M3EThemeData theme, Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: M3EShapes.radiusLarge,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: M3EShapes.radiusLarge,
        child: child,
      ),
    );
  }

  Widget _appBars(M3EThemeData theme) {
    return GallerySection(
      title: 'App bars',
      children: <Widget>[
        _framed(
          theme,
          M3ENavigation.topAppBar(
            title: 'Small',
            leading: const Icon(M3EIcons.menu),
            actions: const <Widget>[Icon(M3EIcons.search)],
          ),
        ),
        const SizedBox(height: 12),
        _framed(
          theme,
          M3ENavigation.topAppBar(
            title: 'Large title',
            variant: M3ETopAppBarVariant.large,
            actions: const <Widget>[Icon(M3EIcons.moreVert)],
          ),
        ),
        const SizedBox(height: 12),
        _framed(
          theme,
          M3ENavigation.bottomAppBar(
            actions: const <Widget>[
              Icon(M3EIcons.menu),
              Icon(M3EIcons.search),
              Icon(M3EIcons.edit),
            ],
            floatingActionButton: M3EActions.fab(
              icon: const Icon(M3EIcons.add),
              size: M3EFabSize.small,
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabs() {
    return GallerySection(
      title: 'Tabs',
      children: <Widget>[
        M3ENavigation.tabs(
          selectedIndex: _primaryTab,
          onTabSelected: (int i) => setState(() => _primaryTab = i),
          tabs: const <M3ETab>[
            M3ETab(label: 'Overview'),
            M3ETab(label: 'Specs'),
            M3ETab(label: 'Reviews'),
          ],
        ),
        const SizedBox(height: 16),
        M3ENavigation.tabs(
          variant: M3ETabsVariant.secondary,
          selectedIndex: _secondaryTab,
          onTabSelected: (int i) => setState(() => _secondaryTab = i),
          tabs: const <M3ETab>[
            M3ETab(label: 'Photos', icon: Icon(M3EIcons.calendarToday)),
            M3ETab(label: 'Albums', icon: Icon(M3EIcons.menu)),
          ],
        ),
      ],
    );
  }

  Widget _bar(M3EThemeData theme) {
    return GallerySection(
      title: 'Navigation bar',
      children: <Widget>[
        _framed(
          theme,
          M3ENavigation.bar(
            destinations: _destinations,
            selectedIndex: _barIndex,
            onDestinationSelected: (int i) => setState(() => _barIndex = i),
          ),
        ),
      ],
    );
  }

  Widget _railAndDrawer(M3EThemeData theme) {
    return GallerySection(
      title: 'Navigation rail & drawer',
      children: <Widget>[
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: <Widget>[
            SizedBox(
              height: 320,
              child: _framed(
                theme,
                M3ENavigation.rail(
                  destinations: _destinations,
                  selectedIndex: _railIndex,
                  onDestinationSelected: (int i) =>
                      setState(() => _railIndex = i),
                  leading: M3EActions.fab(
                    icon: const Icon(M3EIcons.add),
                    size: M3EFabSize.small,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 320,
              child: _framed(
                theme,
                M3ENavigation.drawer(
                  headline: 'Mail',
                  destinations: _destinations,
                  selectedIndex: _drawerIndex,
                  onDestinationSelected: (int i) =>
                      setState(() => _drawerIndex = i),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _toolbarAndMenu() {
    return GallerySection(
      title: 'Toolbar & menu',
      children: <Widget>[
        DemoRow(
          label: 'Floating toolbars',
          children: <Widget>[
            M3ENavigation.toolbar(
              children: <Widget>[
                M3EActions.iconButton(
                  icon: const Icon(M3EIcons.arrowBack),
                  onPressed: () {},
                ),
                M3EActions.iconButton(
                  icon: const Icon(M3EIcons.edit),
                  onPressed: () {},
                ),
                M3EActions.iconButton(
                  icon: const Icon(M3EIcons.arrowForward),
                  onPressed: () {},
                ),
              ],
            ),
            M3ENavigation.toolbar(
              color: M3EToolbarColor.vibrant,
              children: <Widget>[
                M3EActions.iconButton(
                  icon: const Icon(M3EIcons.remove),
                  onPressed: () {},
                ),
                M3EActions.iconButton(
                  icon: const Icon(M3EIcons.add),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        DemoRow(
          label: 'Anchored menu',
          children: <Widget>[
            M3ENavigation.menu(
              anchorBuilder: (BuildContext context, VoidCallback open) {
                return M3EActions.button(
                  label: 'Open menu',
                  variant: M3EButtonVariant.outlined,
                  icon: const Icon(M3EIcons.arrowDropDown),
                  onPressed: open,
                );
              },
              entries: <M3EMenuEntry>[
                M3EMenuEntry(
                  label: 'Edit',
                  leading: const Icon(M3EIcons.edit),
                  onPressed: () {},
                ),
                M3EMenuEntry(
                  label: 'Schedule',
                  leading: const Icon(M3EIcons.schedule),
                  onPressed: () {},
                ),
                const M3EMenuEntry(label: 'Disabled', enabled: false),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
