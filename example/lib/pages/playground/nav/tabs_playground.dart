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
  bool _showIcons = false;

  List<PlaySnippet> get _snippets {
    final String tabs = _showIcons
        ? '''
  tabs: const <M3ETab>[
    M3ETab(label: 'Overview', icon: Icon(M3EIcons.home)),
    M3ETab(label: 'Specs', icon: Icon(M3EIcons.tune)),
    M3ETab(label: 'Reviews', icon: Icon(M3EIcons.star_outline)),
  ],'''
        : '''
  tabs: const <M3ETab>[
    M3ETab(label: 'Overview'),
    M3ETab(label: 'Specs'),
    M3ETab(label: 'Reviews'),
  ],''';
    final String sample =
        '''
M3ETabs(
  variant: M3ETabsVariant.${_variant.name},
  selectedIndex: 0,
  onTabSelected: (int i) {},
$tabs
);''';
    return <PlaySnippet>[
      PlaySnippet(label: 'Tabs', code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  void _openDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _TabsDemoHost(variant: _variant, showIcons: _showIcons);
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
                'Opens a page with the tab bar under the app bar and a view '
                'for each tab.',
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
            PlaySwitch(
              label: 'Show icons',
              value: _showIcons,
              onChanged: (bool v) => setState(() => _showIcons = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _TabsDemoHost extends StatefulWidget {
  const _TabsDemoHost({required this.variant, required this.showIcons});

  final M3ETabsVariant variant;
  final bool showIcons;

  @override
  State<_TabsDemoHost> createState() => _TabsDemoHostState();
}

class _TabsDemoHostState extends State<_TabsDemoHost> {
  int _selected = 0;

  static const List<({String label, IconData icon})> _pages =
      <({String label, IconData icon})>[
        (label: 'Overview', icon: M3EIcons.home),
        (label: 'Specs', icon: M3EIcons.tune),
        (label: 'Reviews', icon: M3EIcons.star_outline),
      ];

  List<M3ETab> get _tabs {
    return <M3ETab>[
      for (final ({String label, IconData icon}) page in _pages)
        M3ETab(
          label: page.label,
          icon: widget.showIcons ? Icon(page.icon) : null,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          M3ETabs(
            variant: widget.variant,
            selectedIndex: _selected,
            onTabSelected: (int i) => setState(() => _selected = i),
            tabs: _tabs,
          ),
          Expanded(
            child: Center(
              child: Icon(
                page.icon,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
