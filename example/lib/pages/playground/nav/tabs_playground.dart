import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Where the tab bar lives.
enum _Placement { fixed, sliver }

/// Scrollable override; auto scrolls only when labels do not fit.
enum _Scrolling { auto, always, never }

/// Badge on the first tab.
enum _Badge { none, dot, count }

/// Live playground for [M3ETabs].
class TabsPlayground extends PlaygroundWidget {
  /// Creates the tabs playground.
  const TabsPlayground({super.key});

  @override
  PlaygroundState<TabsPlayground> createState() => _TabsPlaygroundState();
}

class _TabsPlaygroundState extends PlaygroundState<TabsPlayground> {
  final M3ETabsController _controller = M3ETabsController();

  _Placement _placement = _Placement.fixed;
  M3ETabsVariant _variant = M3ETabsVariant.primary;
  M3ETabsAlignment _alignment = M3ETabsAlignment.fill;
  _Scrolling _scrolling = _Scrolling.auto;
  double _count = 3;
  bool _showIcons = false;
  _Badge _badge = _Badge.none;
  bool _badgeInline = false;
  bool _floating = true;
  int _selected = 0;

  static const List<(String, IconData, String)> _pages =
      <(String, IconData, String)>[
        ('Overview', M3EIcons.home, 'home'),
        ('Specs', M3EIcons.tune, 'tune'),
        ('Reviews', M3EIcons.star_outline, 'star_outline'),
        ('Pricing', M3EIcons.sell, 'sell'),
        ('Support', M3EIcons.help, 'help'),
        ('Related', M3EIcons.link, 'link'),
      ];

  int get _tabCount => _count.round();

  bool? get _scrollable => switch (_scrolling) {
    _Scrolling.auto => null,
    _Scrolling.always => true,
    _Scrolling.never => false,
  };

  /// Alignment shares fixed tab slots; it is ignored while scrolling.
  bool get _hasAlignment => _scrolling != _Scrolling.always;

  /// Inline only matters where a primary tab badge would overlap the icon.
  bool get _hasInline =>
      _badge != _Badge.none && _variant == M3ETabsVariant.primary && _showIcons;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<M3ETab> get _tabs => <M3ETab>[
    for (int i = 0; i < _tabCount; i++)
      M3ETab(
        label: _pages[i].$1,
        icon: _showIcons ? Icon(_pages[i].$2) : null,
        badgeDot: i == 0 && _badge == _Badge.dot,
        badgeCount: i == 0 && _badge == _Badge.count ? 2 : null,
        badgeInline: _hasInline && _badgeInline,
      ),
  ];

  int get _index => _selected.clamp(0, _tabCount - 1);

  void _select(int index) => setState(() => _selected = index);

  M3ETabs _bar() => M3ETabs(
    variant: _variant,
    alignment: _alignment,
    scrollable: _scrollable,
    selectedIndex: _index,
    onTabSelected: _select,
    controller: _controller,
    tabs: _tabs,
  );

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    final M3EThemeData theme = M3ETheme.of(context);
    if (_placement == _Placement.fixed) {
      return Padding(
        padding: EdgeInsets.only(top: padding.top - 16),
        child: M3ETabsView(
          selectedIndex: _index,
          onTabSelected: _select,
          children: <Widget>[
            for (int i = 0; i < _tabCount; i++)
              Center(
                child: Icon(
                  _pages[i].$2,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
          ],
        ),
      );
    }
    final (String label, IconData icon, String _) = _pages[_index];
    // The sliver tab bar pins or floats at the top of the scroll view, so the
    // view starts below the controls banner.
    return Padding(
      padding: EdgeInsets.only(top: padding.top - 16),
      child: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          M3ETabs.sliver(
            variant: _variant,
            alignment: _alignment,
            scrollable: _scrollable,
            floating: _floating,
            selectedIndex: _index,
            onTabSelected: _select,
            controller: _controller,
            tabs: _tabs,
          ),
          SliverPadding(
            padding: padding.copyWith(top: 16),
            sliver: SliverToBoxAdapter(
              child: M3EList(
                color: theme.colorScheme.surfaceContainerHighest,
                itemCount: 24,
                itemBuilder: (BuildContext context, int index) {
                  return M3EListItem(
                    headline: 'Item ${index + 1}',
                    supportingText: label,
                    leading: Icon(icon),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    final M3EAppBar appBar = M3EAppBar.top(
      titleText: _pages[_index].$1,
      leading: chrome.leading,
      actions: <Widget>[
        M3EIconButton(
          variant: M3EIconButtonVariant.standard,
          icon: const Icon(M3EIcons.arrow_forward),
          tooltip: 'Next tab',
          onPressed: () => _controller.select((_index + 1) % _tabCount),
        ),
        ...chrome.trailingActions,
      ],
    );
    if (_placement == _Placement.sliver) {
      return PlaygroundSlots(appBar: appBar);
    }
    return PlaygroundSlots(
      header: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[appBar, _bar()],
      ),
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer tabs = StringBuffer();
    for (int i = 0; i < _tabCount; i++) {
      final String icon = _showIcons
          ? ', icon: Icon(M3EIcons.${_pages[i].$3})'
          : '';
      final String badge = i != 0
          ? ''
          : switch (_badge) {
              _Badge.none => '',
              _Badge.dot => ', badgeDot: true',
              _Badge.count => ', badgeCount: 2',
            };
      final String inline = i == 0 && _hasInline && _badgeInline
          ? ', badgeInline: true'
          : '';
      tabs.writeln("    M3ETab(label: '${_pages[i].$1}'$icon$badge$inline),");
    }
    final bool sliver = _placement == _Placement.sliver;
    final StringBuffer args = StringBuffer()
      ..writeln('  variant: M3ETabsVariant.${_variant.name},');
    if (_hasAlignment) {
      args.writeln('  alignment: M3ETabsAlignment.${_alignment.name},');
    }
    if (_scrollable != null) {
      args.writeln('  scrollable: $_scrollable,');
    }
    if (sliver) {
      args.writeln('  floating: $_floating,');
    }
    final String call = sliver ? 'M3ETabs.sliver' : 'M3ETabs';
    final String view = sliver
        ? '\n// Place it first in a CustomScrollView.'
        : '''


M3ETabsView(
  selectedIndex: selected,
  onTabSelected: (int i) {},
  children: pages,
);''';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Tabs',
        code:
            '''
$kPlaySnippetImport

$call(
$args  selectedIndex: $_index,
  onTabSelected: (int i) {},
  tabs: const <M3ETab>[
$tabs  ],
);$view''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_Placement>(
            label: 'Placement',
            value: _placement,
            values: _Placement.values,
            labelOf: (_Placement v) => switch (v) {
              _Placement.fixed => 'under app bar',
              _Placement.sliver => 'sliver in scroll view',
            },
            onChanged: (_Placement v) => setState(() => _placement = v),
          ),
          if (_placement == _Placement.sliver)
            PlaySwitchItem(
              label: 'Floating',
              description: 'Scrolls away and returns on scroll up',
              value: _floating,
              onChanged: (bool v) => setState(() => _floating = v),
            ),
          PlayEnumChoice<M3ETabsVariant>(
            label: 'Style',
            value: _variant,
            values: M3ETabsVariant.values,
            labelOf: (M3ETabsVariant v) => v.name,
            onChanged: (M3ETabsVariant v) => setState(() => _variant = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Layout',
        children: <Widget>[
          PlaySlider(
            label: 'Tabs',
            value: _count,
            min: 2,
            max: _pages.length.toDouble(),
            divisions: _pages.length - 2,
            onChanged: (double v) => setState(() => _count = v),
          ),
          PlayEnumChoice<_Scrolling>(
            label: 'Scrolling',
            value: _scrolling,
            values: _Scrolling.values,
            labelOf: (_Scrolling v) => switch (v) {
              _Scrolling.auto => 'auto (when labels overflow)',
              _Scrolling.always => 'always scrollable',
              _Scrolling.never => 'never (equal slots)',
            },
            onChanged: (_Scrolling v) => setState(() => _scrolling = v),
          ),
          if (_hasAlignment)
            PlayEnumChoice<M3ETabsAlignment>(
              label: 'Alignment',
              value: _alignment,
              values: M3ETabsAlignment.values,
              labelOf: (M3ETabsAlignment v) => v.name,
              onChanged: (M3ETabsAlignment v) => setState(() => _alignment = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Icons',
            value: _showIcons,
            onChanged: (bool v) => setState(() => _showIcons = v),
          ),
          PlayEnumChoice<_Badge>(
            label: 'Badge on first tab',
            value: _badge,
            values: _Badge.values,
            labelOf: (_Badge v) => v.name,
            onChanged: (_Badge v) => setState(() => _badge = v),
          ),
          if (_hasInline)
            PlaySwitchItem(
              label: 'Inline badge',
              description: 'After the label instead of over the icon',
              value: _badgeInline,
              onChanged: (bool v) => setState(() => _badgeInline = v),
            ),
        ],
      ),
    ];
  }
}
