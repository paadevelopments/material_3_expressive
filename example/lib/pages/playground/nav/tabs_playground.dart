import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ETabs].
class TabsPlayground extends StatefulWidget {
  /// Creates the tabs playground.
  const TabsPlayground({super.key});

  @override
  State<TabsPlayground> createState() => _TabsPlaygroundState();
}

class _TabsPlaygroundState extends State<TabsPlayground> {
  M3ETabsVariant _variant = M3ETabsVariant.primary;
  M3ETabsAlignment _alignment = M3ETabsAlignment.fill;
  bool _showIcons = false;
  bool _badge = false;
  bool _scrollable = false;
  bool _scrollAway = false;

  List<PlaySnippet> get _snippets {
    final String icon = _showIcons ? ', icon: Icon(M3EIcons.home)' : '';
    final String badge = _badge ? ', badgeCount: 2' : '';
    final String sample =
        '''
M3ETabs(
  variant: M3ETabsVariant.${_variant.name},
  alignment: M3ETabsAlignment.${_alignment.name},
  scrollable: $_scrollable,
  selectedIndex: 0,
  onTabSelected: (int i) {},
  tabs: const <M3ETab>[
    M3ETab(label: 'Overview'$icon$badge),
    M3ETab(label: 'Specs'$icon),
    M3ETab(label: 'Reviews'$icon),
  ],
);''';
    return <PlaySnippet>[
      PlaySnippet(label: 'Tabs', code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  void _openDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _TabsDemoHost(
            variant: _variant,
            alignment: _alignment,
            showIcons: _showIcons,
            badge: _badge,
            scrollable: _scrollable,
            scrollAway: _scrollAway,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Tabs demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a page with the tab bar and a swipeable view for each '
                'tab. Scroll away puts an app bar above the tabs and a list '
                'below, and all three move with the page.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open tabs demo'),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumSegmented<M3ETabsVariant>(
              label: 'Variant',
              value: _variant,
              values: M3ETabsVariant.values,
              labelOf: (M3ETabsVariant v) => v.name,
              onChanged: (M3ETabsVariant v) => setState(() => _variant = v),
            ),
            PlayEnumSegmented<M3ETabsAlignment>(
              label: 'Alignment',
              value: _alignment,
              values: M3ETabsAlignment.values,
              labelOf: (M3ETabsAlignment v) => v.name,
              onChanged: (M3ETabsAlignment v) => setState(() => _alignment = v),
            ),
            PlaySwitch(
              label: 'Show icons',
              value: _showIcons,
              onChanged: (bool v) => setState(() => _showIcons = v),
            ),
            PlaySwitch(
              label: 'Badge',
              value: _badge,
              onChanged: (bool v) => setState(() => _badge = v),
            ),
            PlaySwitch(
              label: 'Scrollable',
              value: _scrollable,
              onChanged: (bool v) => setState(() => _scrollable = v),
            ),
            PlaySwitch(
              label: 'Scroll away',
              value: _scrollAway,
              onChanged: (bool v) => setState(() => _scrollAway = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _TabsDemoHost extends StatefulWidget {
  const _TabsDemoHost({
    required this.variant,
    required this.alignment,
    required this.showIcons,
    required this.badge,
    required this.scrollable,
    required this.scrollAway,
  });

  final M3ETabsVariant variant;
  final M3ETabsAlignment alignment;
  final bool showIcons;
  final bool badge;
  final bool scrollable;
  final bool scrollAway;

  @override
  State<_TabsDemoHost> createState() => _TabsDemoHostState();
}

class _TabsDemoHostState extends State<_TabsDemoHost> {
  final M3ETabsController _controller = M3ETabsController();
  int _selected = 0;

  static const List<({String label, IconData icon})> _pages =
      <({String label, IconData icon})>[
        (label: 'Overview', icon: M3EIcons.home),
        (label: 'Specs', icon: M3EIcons.tune),
        (label: 'Reviews', icon: M3EIcons.star_outline),
      ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<M3ETab> get _tabs {
    return <M3ETab>[
      for (var i = 0; i < _pages.length; i++)
        M3ETab(
          label: _pages[i].label,
          icon: widget.showIcons ? Icon(_pages[i].icon) : null,
          badgeCount: widget.badge && i == 0 ? 2 : null,
        ),
    ];
  }

  void _select(int index) {
    setState(() => _selected = index);
  }

  Widget _tabsBar() {
    return M3ETabs(
      variant: widget.variant,
      alignment: widget.alignment,
      scrollable: widget.scrollable,
      selectedIndex: _selected,
      onTabSelected: _select,
      controller: _controller,
      tabs: _tabs,
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    if (widget.scrollAway) {
      final ({String label, IconData icon}) page = _pages[_selected];
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: CustomScrollView(
          slivers: <Widget>[
            M3EAppBar.sliver(
              variant: M3EAppBarVariant.small,
              pinned: false,
              titleText: page.label,
              leading: M3EIconButton(
                variant: M3EIconButtonVariant.standard,
                icon: const Icon(M3EIcons.arrow_back),
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              actions: <Widget>[
                M3EIconButton(
                  variant: M3EIconButtonVariant.standard,
                  icon: const Icon(M3EIcons.arrow_forward),
                  tooltip: 'Next tab',
                  onPressed: () =>
                      _controller.select((_selected + 1) % _pages.length),
                ),
              ],
            ),
            SliverToBoxAdapter(child: _tabsBar()),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              sliver: SliverToBoxAdapter(
                child: M3EList(
                  color: theme.colorScheme.surfaceContainerHighest,
                  itemCount: 24,
                  itemBuilder: (BuildContext context, int index) {
                    return M3EListItem(
                      headline: 'Item ${index + 1}',
                      supportingText: page.label,
                      leading: Icon(page.icon),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    final ({String label, IconData icon}) page = _pages[_selected];
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: M3EAppBar.top(
        titleText: page.label,
        leading: M3EIconButton(
          variant: M3EIconButtonVariant.standard,
          icon: const Icon(M3EIcons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: <Widget>[
          M3EIconButton(
            variant: M3EIconButtonVariant.standard,
            icon: const Icon(M3EIcons.arrow_forward),
            tooltip: 'Next tab',
            onPressed: () =>
                _controller.select((_selected + 1) % _pages.length),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _tabsBar(),
          Expanded(
            child: M3ETabsView(
              selectedIndex: _selected,
              onTabSelected: _select,
              children: <Widget>[
                for (final ({String label, IconData icon}) item in _pages)
                  Center(
                    child: Icon(
                      item.icon,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
