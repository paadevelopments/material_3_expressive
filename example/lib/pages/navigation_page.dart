import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/components/floating_action_buttons/enums/m3e_fab.dart';
import 'package:material_3_expressive/components/navigation_bar/models/m3e_navigation_bar_destination.dart';
import 'package:material_3_expressive/components/navigation_drawer/models/m3e_navigation_destination.dart';
import 'package:material_3_expressive/components/navigation_rail/models/m3e_navigation_rail_destination.dart';
import 'package:material_3_expressive/components/navigation_rail/models/m3e_navigation_rail_fab_slot.dart';
import 'package:material_3_expressive/components/navigation_rail/models/m3e_navigation_rail_section.dart';
import 'package:material_3_expressive/components/split_buttons/models/m3e_split_button_item.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../widgets/gallery_section.dart';

/// Demonstrates every component in the Material 3 *Navigation* group.
class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _barIndex = 0;
  int _railIndex = 0;
  int _drawerIndex = 0;
  int _primaryTab = 0;
  int _secondaryTab = 0;
  final M3ESearchController _appBarSearchController = M3ESearchController();

  static const List<String> _appBarSearchSuggestions = <String>[
    'Inbox',
    'Starred',
    'Snoozed',
    'Important',
    'Sent',
    'Drafts',
  ];

  @override
  void dispose() {
    _appBarSearchController.dispose();
    super.dispose();
  }

  static const List<M3ENavigationBarDestination> _barDestinations =
      <M3ENavigationBarDestination>[
    M3ENavigationBarDestination(icon: Icon(M3EIcons.menu), label: 'Home'),
    M3ENavigationBarDestination(
      icon: Icon(M3EIcons.search),
      label: 'Search',
      badgeDot: true,
    ),
    M3ENavigationBarDestination(
      icon: Icon(M3EIcons.calendar_today),
      label: 'Agenda',
      badgeCount: 3,
    ),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.edit), label: 'Drafts'),
  ];

  static const List<M3ENavigationRailSection> _railSections =
      <M3ENavigationRailSection>[
    M3ENavigationRailSection(
      destinations: <M3ENavigationRailDestination>[
        M3ENavigationRailDestination(icon: Icon(M3EIcons.menu), label: 'Home'),
        M3ENavigationRailDestination(
          icon: Icon(M3EIcons.search),
          label: 'Search',
        ),
        M3ENavigationRailDestination(
          icon: Icon(M3EIcons.calendar_today),
          label: 'Agenda',
          badgeCount: 3,
        ),
        M3ENavigationRailDestination(icon: Icon(M3EIcons.edit), label: 'Drafts'),
      ],
    ),
  ];

  static const List<M3ENavigationDestination> _drawerDestinations =
      <M3ENavigationDestination>[
    M3ENavigationDestination(icon: Icon(M3EIcons.menu), label: 'Home'),
    M3ENavigationDestination(
      icon: Icon(M3EIcons.search),
      label: 'Search',
      showBadge: true,
    ),
    M3ENavigationDestination(
      icon: Icon(M3EIcons.calendar_today),
      label: 'Agenda',
      badgeLabel: '3',
    ),
    M3ENavigationDestination(icon: Icon(M3EIcons.edit), label: 'Drafts'),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = M3ETheme.of(context);
    return GalleryPageScrollView(
      sections: <Widget>[
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
          M3EAppBar.top(
            titleText: 'Small',
            leading: const Icon(M3EIcons.menu),
            actions: const <Widget>[Icon(M3EIcons.search)],
          ),
        ),
        const SizedBox(height: 12),
        _framed(
          theme,
          M3EAppBar.top(
            titleText: 'Centered • compact',
            centerTitle: true,
            density: M3EAppBarDensity.compact,
            shapeFamily: M3EAppBarShapeFamily.square,
            actions: const <Widget>[Icon(M3EIcons.file_copy)],
          ),
        ),
        const SizedBox(height: 12),
        _framed(
          theme,
          M3EAppBar.search(
            searchController: _appBarSearchController,
            barHintText: 'Search mail',
            leading: const Icon(M3EIcons.menu),
            actions: const <Widget>[
              Icon(M3EIcons.tune),
              Icon(M3EIcons.account_circle),
            ],
            suggestionsBuilder:
                (BuildContext context, M3ESearchController controller) {
              final query = controller.text.trim().toLowerCase();
              final matches = query.isEmpty
                  ? _appBarSearchSuggestions
                  : _appBarSearchSuggestions.where(
                      (String name) => name.toLowerCase().contains(query),
                    );
              return matches.map(
                (String name) => GestureDetector(
                  onTap: () => controller.closeView(name),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(name),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _framed(
          theme,
          RepaintBoundary(
            child: SizedBox(
              height: 180,
              child: CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
                slivers: <Widget>[
                  M3EAppBar.sliver(
                    titleText: 'Sliver • medium',
                    actions: const <Widget>[Icon(M3EIcons.search)],
                  ),
                  SliverList.list(
                    children: <Widget>[
                      for (int i = 0; i < 6; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text('Scrollable item ${i + 1}'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _framed(
          theme,
          M3EAppBar.bottom(
            actions: const <Widget>[
              Icon(M3EIcons.menu),
              Icon(M3EIcons.search),
              Icon(M3EIcons.edit),
            ],
            floatingActionButton: M3EFab(
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
        M3ETabs(
          selectedIndex: _primaryTab,
          onTabSelected: (int i) => setState(() => _primaryTab = i),
          tabs: const <M3ETab>[
            M3ETab(label: 'Overview'),
            M3ETab(label: 'Specs'),
            M3ETab(label: 'Reviews'),
          ],
        ),
        const SizedBox(height: 16),
        M3ETabs(
          variant: M3ETabsVariant.secondary,
          selectedIndex: _secondaryTab,
          onTabSelected: (int i) => setState(() => _secondaryTab = i),
          tabs: const <M3ETab>[
            M3ETab(label: 'Photos', icon: Icon(M3EIcons.calendar_today)),
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
          M3ENavigationBar(
            destinations: _barDestinations,
            selectedIndex: _barIndex,
            safeArea: false,
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
                M3ENavigationRail(
                  sections: _railSections,
                  selectedIndex: _railIndex,
                  onDestinationSelected: (int i) =>
                      setState(() => _railIndex = i),
                  fab: M3ENavigationRailFabSlot(
                    icon: const Icon(M3EIcons.add),
                    label: 'Compose',
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 328,
              child: _framed(
                theme,
                M3ENavigationDrawer(
                  headline: 'Mail',
                  destinations: _drawerDestinations,
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
    final List<M3EToolbarItem> sampleActions = <M3EToolbarItem>[
      M3EToolbarAction(icon: M3EIcons.edit, onPressed: () {}),
      M3EToolbarAction(
        icon: M3EIcons.share,
        onPressed: () {},
        isExpandTrigger: true,
      ),
      M3EToolbarAction(icon: M3EIcons.favorite, onPressed: () {}),
    ];

    Widget insetFrame({
      required EdgeInsets padding,
      required Widget child,
    }) {
      return child;
    }

    return GallerySection(
      title: 'Toolbar & menu',
      children: <Widget>[
        DemoRow(
          label: 'Floating (tap filled trigger to expand / collapse)',
          children: <Widget>[
            M3EToolbar(
              actions: sampleActions,
            ),
            M3EToolbar(
              colorStyle: M3EToolbarColorStyle.vibrant,
              actions: sampleActions,
            ),
          ],
        ),
        DemoRow(
          label: 'Floating + leading (starts collapsed)',
          children: <Widget>[
            M3EToolbar(
              expanded: false,
              leading: M3EIconButton(
                icon: const Icon(M3EIcons.arrow_back),
                onPressed: () {},
                size: M3EIconButtonSize.sm,
              ),
              actions: sampleActions,
            ),
          ],
        ),
        DemoRow(
          label: 'Floating + FAB (pill expands independently; FAB always shown)',
          children: <Widget>[
            M3EToolbar(
              actions: sampleActions,
              fabIcon: const Icon(M3EIcons.add),
              onFabPressed: () {},
              expanded: true,
            ),
            M3EToolbar(
              actions: sampleActions,
              fabIcon: const Icon(M3EIcons.add),
              onFabPressed: () {},
              expanded: false,
            ),
          ],
        ),
        DemoRow(
          label: 'Floating vertical',
          children: <Widget>[
            Row(
              spacing: 16,
              children: [
                M3EToolbar(
                  axis: Axis.vertical,
                  actions: sampleActions,
                ),
                M3EToolbar(
                  axis: Axis.vertical,
                  colorStyle: M3EToolbarColorStyle.vibrant,
                  actions: sampleActions,
                  fabIcon: const Icon(M3EIcons.add),
                  onFabPressed: () {},
                  fabPosition: M3EToolbarFabPosition.bottom,
                )
              ],
            ),
          ],
        ),
        DemoRow(
          label: 'Floating safeArea on / off',
          children: <Widget>[
            insetFrame(
              padding: const EdgeInsets.only(bottom: 0),
              child: M3EToolbar(
                safeArea: true,
                dockEdge: M3EToolbarDockEdge.bottom,
                alignment: Alignment.bottomCenter,
                actions: sampleActions,
              ),
            ),
            M3EToolbar(
              safeArea: false,
              actions: sampleActions,
            ),
          ],
        ),
        DemoRow(
          label: 'Docked bottom icons-only (evenly spaced)',
          children: <Widget>[
            insetFrame(
              padding: const EdgeInsets.only(bottom: 0),
              child: M3EToolbar.docked(
                safeArea: true,
                dockEdge: M3EToolbarDockEdge.bottom,
                actions: sampleActions,
              ),
            ),
            insetFrame(
              padding: const EdgeInsets.only(bottom: 0),
              child: M3EToolbar.docked(
                safeArea: false,
                dockEdge: M3EToolbarDockEdge.bottom,
                actions: sampleActions,
              ),
            ),
          ],
        ),
        DemoRow(
          label: 'Docked top (safeArea on)',
          children: <Widget>[
            insetFrame(
              padding: const EdgeInsets.only(top: 0),
              child: M3EToolbar.docked(
                safeArea: true,
                dockEdge: M3EToolbarDockEdge.top,
                colorStyle: M3EToolbarColorStyle.vibrant,
                titleText: 'Docked top',
                actions: sampleActions,
              ),
            ),
          ],
        ),
        DemoRow(
          label: 'Floating with title + overflow',
          children: <Widget>[
            M3EToolbar(
              titleText: 'Inbox',
              subtitleText: '12 unread',
              maxInlineActions: 3,
              actions: <M3EToolbarItem>[
                M3EToolbarAction(
                  icon: M3EIcons.search,
                  tooltip: 'Search',
                  onPressed: () {},
                ),
                M3EToolbarAction(
                  icon: M3EIcons.filter_list,
                  tooltip: 'Filter',
                  onPressed: () {},
                ),
                M3EToolbarAction(
                  icon: M3EIcons.archive,
                  tooltip: 'Archive',
                  onPressed: () {},
                ),
                M3EToolbarAction(
                  icon: M3EIcons.delete,
                  tooltip: 'Delete',
                  label: 'Delete',
                  isDestructive: true,
                  onPressed: () {},
                ),
                M3EToolbarAction(
                  icon: M3EIcons.settings,
                  tooltip: 'Settings',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        DemoRow(
          label: 'Floating + custom widget items',
          children: <Widget>[
            M3EToolbar(
              actions: <M3EToolbarItem>[
                M3EToolbarAction(icon: M3EIcons.edit, onPressed: () {}),
                M3EToolbarWidget(
                  semanticLabel: 'Sort',
                  child: M3ESplitButton<String>(
                    size: M3EButtonSize.sm,
                    label: 'Sort',
                    items: const <M3ESplitButtonItem<String>>[
                      M3ESplitButtonItem(value: 'name', child: 'Name'),
                      M3ESplitButtonItem(value: 'date', child: 'Date'),
                    ],
                    onSelected: (_) {},
                  ),
                ),
                M3EToolbarAction(
                  icon: M3EIcons.share,
                  onPressed: () {},
                  isExpandTrigger: true,
                ),
                M3EToolbarAction(icon: M3EIcons.favorite, onPressed: () {}),
              ],
            ),
          ],
        ),
        DemoRow(
          label: 'Docked + input widget',
          children: <Widget>[
            insetFrame(
              padding: EdgeInsets.zero,
              child: M3EToolbar.docked(
                safeArea: false,
                dockEdge: M3EToolbarDockEdge.bottom,
                actions: <M3EToolbarItem>[
                  M3EToolbarAction(icon: M3EIcons.menu, onPressed: () {}),
                  M3EToolbarWidget(
                    semanticLabel: 'Search',
                    child: SizedBox(
                      width: 160,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: const Color(0x33000000),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Search…'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  M3EToolbarAction(icon: M3EIcons.mic, onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
        DemoRow(
          label: 'Anchored menu',
          children: <Widget>[
            _SpecMenuDemo(
              label: 'Standard menu',
              colorStyle: M3EMenuColorStyle.standard,
            ),
            _SpecMenuDemo(
              label: 'Vibrant menu',
              colorStyle: M3EMenuColorStyle.vibrant,
            ),
            _ExpressiveMenuDemo(),
          ],
        ),
      ],
    );
  }
}

class _SpecMenuDemo extends StatelessWidget {
  const _SpecMenuDemo({
    required this.label,
    required this.colorStyle,
  });

  final String label;
  final M3EMenuColorStyle colorStyle;

  @override
  Widget build(BuildContext context) {
    return M3EMenu(
      position: M3EMenuAnchorPosition.bottomStart,
      colorStyle: colorStyle,
      selectedValue: 'Item 4',
      anchorBuilder: (BuildContext context, VoidCallback open) {
        return M3EButton.icon(
          style: M3EButtonStyle.outlined,
          icon: const Icon(M3EIcons.arrow_drop_down),
          label: Text(label),
          onPressed: open,
        );
      },
      children: <M3EMenuNode>[
        M3EMenuGroup.entries(
          entries: <M3EMenuNode>[
            M3EMenuEntry(
              label: 'Item 1',
              leading: const Icon(M3EIcons.visibility),
              onPressed: () {},
            ),
            M3EMenuEntry(
              label: 'Item 2',
              leading: const Icon(M3EIcons.star_outline),
              trailingText: '⌘C',
              onPressed: () {},
            ),
            M3EMenuEntry(
              label: 'Item 3',
              leading: const Icon(M3EIcons.edit),
              trailing: const Icon(M3EIcons.chevron_right),
              onPressed: () {},
            ),
            const M3EMenuSelectable(
              label: 'Item 4',
              value: 'Item 4',
              selected: true,
            ),
          ],
        ),
        M3EMenuGroup.entries(
          label: 'Label text',
          entries: <M3EMenuNode>[
            M3EMenuEntry(
              label: 'Item 5',
              supportingText: 'Supporting text',
              trailing: const Icon(M3EIcons.chevron_right),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _ExpressiveMenuDemo extends StatefulWidget {
  @override
  State<_ExpressiveMenuDemo> createState() => _ExpressiveMenuDemoState();
}

class _ExpressiveMenuDemoState extends State<_ExpressiveMenuDemo> {
  String _selected = 'Inbox';
  bool _starred = true;

  @override
  Widget build(BuildContext context) {
    return M3EMenu(
      position: M3EMenuAnchorPosition.bottomEnd,
      selectedValue: _selected,
      onSelected: (Object? value) {
        if (value is String) {
          setState(() => _selected = value);
        }
      },
      anchorBuilder: (BuildContext context, VoidCallback open) {
        return M3EButton.icon(
          style: M3EButtonStyle.tonal,
          icon: const Icon(M3EIcons.more_vert),
          label: Text(_selected),
          onPressed: open,
        );
      },
      children: <M3EMenuNode>[
        M3EMenuGroup(
          label: 'Mailbox',
          children: <M3EMenuNode>[
            M3EMenuSelectable(
              label: 'Inbox',
              value: 'Inbox',
              selected: _selected == 'Inbox',
              leading: const Icon(M3EIcons.inbox),
            ),
            M3EMenuSelectable(
              label: 'Sent',
              value: 'Sent',
              selected: _selected == 'Sent',
              leading: const Icon(M3EIcons.send),
            ),
          ],
        ),
        M3EMenuGroup(
          children: <M3EMenuNode>[
            M3EMenuToggleable(
              label: 'Starred',
              checked: _starred,
              onChanged: (bool value) => setState(() => _starred = value),
            ),
            M3EMenuSubmenu(
              label: 'More actions',
              leading: const Icon(M3EIcons.more_horiz),
              children: <M3EMenuNode>[
                M3EMenuEntry(
                  label: 'Archive',
                  leading: const Icon(M3EIcons.archive),
                  onPressed: () {},
                ),
                M3EMenuEntry(
                  label: 'Report',
                  leading: const Icon(M3EIcons.report),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
