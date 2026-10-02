import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3ENavigationRail].
class NavigationRailPlayground extends PlaygroundWidget {
  /// Creates the navigation rail playground.
  const NavigationRailPlayground({super.key});

  @override
  PlaygroundState<NavigationRailPlayground> createState() =>
      _NavigationRailPlaygroundState();
}

class _NavigationRailPlaygroundState
    extends PlaygroundState<NavigationRailPlayground> {
  M3ENavigationRailType _type = M3ENavigationRailType.collapsed;
  M3ENavigationRailModality _modality = M3ENavigationRailModality.standard;
  M3ENavigationRailAlignment _alignment = M3ENavigationRailAlignment.top;
  M3ENavigationRailLabelBehavior _labelBehavior =
      M3ENavigationRailLabelBehavior.alwaysShow;
  bool _showFab = true;
  bool _showDivider = false;
  bool _hideWhenCollapsed = false;
  bool _sectionHeaders = false;
  bool _shortItems = false;
  bool _badges = true;
  bool _customWidth = false;
  double _expandedWidth = 256;
  int _index = 0;

  M3ENavigationRailController _controller = M3ENavigationRailController(
    expanded: false,
  );

  static const List<(IconData, String, String)> _main =
      <(IconData, String, String)>[
        (M3EIcons.home, 'home', 'Home'),
        (M3EIcons.search, 'search', 'Search'),
        (M3EIcons.calendar_today, 'calendar_today', 'Agenda'),
      ];

  static const List<(IconData, String, String)> _more =
      <(IconData, String, String)>[
        (M3EIcons.edit, 'edit', 'Drafts'),
        (M3EIcons.archive, 'archive', 'Archive'),
      ];

  bool get _modal => _modality == M3ENavigationRailModality.modal;

  /// The rail can show its collapsed form.
  bool get _canCollapse => _type != M3ENavigationRailType.alwaysExpand;

  /// The rail can show its expanded form.
  bool get _canExpand => _type != M3ENavigationRailType.alwaysCollapse;

  bool get _startsExpanded =>
      _type == M3ENavigationRailType.expanded ||
      _type == M3ENavigationRailType.alwaysExpand;

  void _resetController() {
    final M3ENavigationRailController old = _controller;
    _controller = M3ENavigationRailController(expanded: _startsExpanded);
    WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<M3ENavigationRailSection> get _sections {
    M3ENavigationRailDestination destination(
      (IconData, String, String) entry, {
      int? badge,
    }) {
      return M3ENavigationRailDestination(
        icon: Icon(entry.$1),
        label: entry.$3,
        badgeCount: _badges ? badge : null,
        short: _shortItems,
      );
    }

    return <M3ENavigationRailSection>[
      M3ENavigationRailSection(
        header: _sectionHeaders ? const Text('Mail') : null,
        destinations: <M3ENavigationRailDestination>[
          destination(_main[0]),
          destination(_main[1]),
          destination(_main[2], badge: 3),
        ],
      ),
      M3ENavigationRailSection(
        header: _sectionHeaders ? const Text('Labels') : null,
        destinations: <M3ENavigationRailDestination>[
          for (final (IconData, String, String) entry in _more)
            destination(entry),
        ],
      ),
    ];
  }

  String get _title =>
      <(IconData, String, String)>[..._main, ..._more][_index].$3;

  @override
  Widget buildPreview(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final (IconData icon, String _, String _) = <(IconData, String, String)>[
      ..._main,
      ..._more,
    ][_index];
    return Icon(icon, size: 48, color: theme.colorScheme.primary);
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    return PlaygroundSlots(
      appBar: M3EAppBar.top(
        titleText: _title,
        leading: chrome.leading,
        actions: <Widget>[
          if (_modal)
            M3EIconButton(
              variant: M3EIconButtonVariant.standard,
              icon: const Icon(M3EIcons.menu),
              tooltip: 'Open navigation',
              onPressed: _controller.expand,
            ),
          ...chrome.trailingActions,
        ],
      ),
      startPane: M3ENavigationRail(
        // Type and modality only apply when the rail is created.
        key: ValueKey<String>('$_type-$_modality'),
        sections: _sections,
        selectedIndex: _index,
        onDestinationSelected: (int i) => setState(() => _index = i),
        type: _type,
        modality: _modality,
        alignment: _alignment,
        labelBehavior: _labelBehavior,
        showDivider: _showDivider,
        hideWhenCollapsed: _canCollapse && _hideWhenCollapsed,
        expandedWidth: _canExpand && _customWidth ? _expandedWidth : null,
        controller: _controller,
        fab: _showFab
            ? M3ENavigationRailFabSlot(
                icon: const Icon(M3EIcons.add),
                label: 'Compose',
                onPressed: () {},
              )
            : null,
      ),
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer()
      ..writeln('  type: M3ENavigationRailType.${_type.name},')
      ..writeln('  modality: M3ENavigationRailModality.${_modality.name},')
      ..writeln('  alignment: M3ENavigationRailAlignment.${_alignment.name},');
    if (_canCollapse) {
      args
        ..writeln(
          '  labelBehavior: '
          'M3ENavigationRailLabelBehavior.${_labelBehavior.name},',
        )
        ..writeln('  hideWhenCollapsed: $_hideWhenCollapsed,');
    }
    if (_canExpand && _customWidth) {
      args.writeln('  expandedWidth: ${_expandedWidth.round()},');
    }
    args.writeln('  showDivider: $_showDivider,');
    if (_modal) {
      args.writeln('  controller: controller, // controller.expand() opens it');
    }
    if (_showFab) {
      args.writeln(
        '  fab: M3ENavigationRailFabSlot(\n'
        '    icon: const Icon(M3EIcons.add),\n'
        "    label: 'Compose',\n"
        '    onPressed: () {},\n'
        '  ),',
      );
    }
    final String header = _sectionHeaders
        ? "\n      header: Text('Mail'),"
        : '';
    final String badge = _badges ? ', badgeCount: 3' : '';
    final String short = _shortItems ? ', short: true' : '';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Navigation rail',
        code:
            '''
$kPlaySnippetImport

Row(
  children: <Widget>[
    M3ENavigationRail(
  sections: const <M3ENavigationRailSection>[
    M3ENavigationRailSection($header
      destinations: <M3ENavigationRailDestination>[
        M3ENavigationRailDestination(icon: Icon(M3EIcons.home), label: 'Home'$short),
        M3ENavigationRailDestination(icon: Icon(M3EIcons.calendar_today), label: 'Agenda'$badge$short),
      ],
    ),
  ],
  selectedIndex: $_index,
  onDestinationSelected: (int index) {},
$args    ),
    Expanded(child: content),
  ],
);''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<M3ENavigationRailType>(
            label: 'Type',
            value: _type,
            values: M3ENavigationRailType.values,
            labelOf: (M3ENavigationRailType v) => v.name,
            onChanged: (M3ENavigationRailType v) {
              setState(() {
                _type = v;
                _resetController();
              });
            },
          ),
          PlayEnumChoice<M3ENavigationRailModality>(
            label: 'Modality',
            value: _modality,
            values: M3ENavigationRailModality.values,
            labelOf: (M3ENavigationRailModality v) => v.name,
            onChanged: (M3ENavigationRailModality v) {
              setState(() {
                _modality = v;
                _resetController();
              });
            },
          ),
          PlayEnumChoice<M3ENavigationRailAlignment>(
            label: 'Destination alignment',
            value: _alignment,
            values: M3ENavigationRailAlignment.values,
            labelOf: (M3ENavigationRailAlignment v) => v.name,
            onChanged: (M3ENavigationRailAlignment v) {
              setState(() => _alignment = v);
            },
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Collapsed and expanded',
        children: <Widget>[
          if (_canCollapse) ...<Widget>[
            PlayEnumChoice<M3ENavigationRailLabelBehavior>(
              label: 'Collapsed labels',
              value: _labelBehavior,
              values: M3ENavigationRailLabelBehavior.values,
              labelOf: (M3ENavigationRailLabelBehavior v) => v.name,
              onChanged: (M3ENavigationRailLabelBehavior v) {
                setState(() => _labelBehavior = v);
              },
            ),
            PlaySwitchItem(
              label: 'Hide when collapsed',
              value: _hideWhenCollapsed,
              onChanged: (bool v) => setState(() => _hideWhenCollapsed = v),
            ),
          ],
          if (_canExpand) ...<Widget>[
            PlaySwitchItem(
              label: 'Custom expanded width',
              value: _customWidth,
              onChanged: (bool v) => setState(() => _customWidth = v),
            ),
            if (_customWidth)
              PlaySlider(
                label: 'Expanded width',
                value: _expandedWidth,
                min: 220,
                max: 360,
                divisions: 14,
                onChanged: (double v) => setState(() => _expandedWidth = v),
              ),
          ],
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlaySwitchItem(
            label: 'FAB',
            value: _showFab,
            onChanged: (bool v) => setState(() => _showFab = v),
          ),
          PlaySwitchItem(
            label: 'Section headers',
            value: _sectionHeaders,
            onChanged: (bool v) => setState(() => _sectionHeaders = v),
          ),
          PlaySwitchItem(
            label: 'Badges',
            description: 'A count on Agenda',
            value: _badges,
            onChanged: (bool v) => setState(() => _badges = v),
          ),
          PlaySwitchItem(
            label: 'Short items',
            description: '56dp destinations instead of 64dp',
            value: _shortItems,
            onChanged: (bool v) => setState(() => _shortItems = v),
          ),
          PlaySwitchItem(
            label: 'Divider',
            description: 'Line on the content edge',
            value: _showDivider,
            onChanged: (bool v) => setState(() => _showDivider = v),
          ),
        ],
      ),
    ];
  }
}
