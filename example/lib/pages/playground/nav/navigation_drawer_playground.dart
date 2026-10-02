import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3ENavigationDrawer].
class NavigationDrawerPlayground extends PlaygroundWidget {
  /// Creates the navigation drawer playground.
  const NavigationDrawerPlayground({super.key});

  @override
  PlaygroundState<NavigationDrawerPlayground> createState() =>
      _NavigationDrawerPlaygroundState();
}

class _NavigationDrawerPlaygroundState
    extends PlaygroundState<NavigationDrawerPlayground> {
  M3ENavigationDrawerType _type = M3ENavigationDrawerType.modal;
  String _headline = 'Mail';
  bool _showHeadline = true;
  bool _icons = true;
  bool _badges = true;
  bool _sections = true;
  bool _dismissible = false;
  int _index = 0;

  M3ENavigationDrawerController _controller = M3ENavigationDrawerController(
    isOpen: false,
  );

  bool get _modal => _type == M3ENavigationDrawerType.modal;

  /// A menu button opens and closes the drawer.
  bool get _hasMenu => _modal || _dismissible;

  void _resetController() {
    final M3ENavigationDrawerController old = _controller;
    _controller = M3ENavigationDrawerController(isOpen: !_hasMenu);
    WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static const List<(IconData, String, String)> _primary =
      <(IconData, String, String)>[
        (M3EIcons.home, 'home', 'Home'),
        (M3EIcons.search, 'search', 'Search'),
        (M3EIcons.calendar_today, 'calendar_today', 'Agenda'),
        (M3EIcons.edit, 'edit', 'Drafts'),
      ];

  static const List<(IconData, String, String)> _labels =
      <(IconData, String, String)>[
        (M3EIcons.folder, 'folder', 'Personal'),
        (M3EIcons.work, 'work', 'Work'),
        (M3EIcons.flight, 'flight', 'Travel'),
      ];

  List<M3ENavigationDestination> get _destinations {
    return <M3ENavigationDestination>[
      for (int i = 0; i < _primary.length; i++)
        M3ENavigationDestination(
          icon: _icons ? Icon(_primary[i].$1) : null,
          label: _primary[i].$3,
          showBadge: _badges && i == 1,
          badgeLabel: _badges && i == 2 ? '3' : null,
        ),
    ];
  }

  List<M3ENavigationDrawerSection> get _sectionList {
    if (!_sections) {
      return const <M3ENavigationDrawerSection>[];
    }
    return <M3ENavigationDrawerSection>[
      M3ENavigationDrawerSection(
        header: 'Labels',
        destinations: <M3ENavigationDestination>[
          for (final (IconData icon, String _, String label) in _labels)
            M3ENavigationDestination(
              icon: _icons ? Icon(icon) : null,
              label: label,
            ),
        ],
      ),
    ];
  }

  (IconData, String, String) get _current {
    final List<(IconData, String, String)> all = <(IconData, String, String)>[
      ..._primary,
      if (_sections) ..._labels,
    ];
    return all[_index.clamp(0, all.length - 1)];
  }

  M3ENavigationDrawer get _drawer => M3ENavigationDrawer(
    // Type and dismissible only apply when the drawer is created.
    key: ValueKey<String>('$_type-$_dismissible'),
    headline: _showHeadline ? _headline : null,
    destinations: _destinations,
    sections: _sectionList,
    type: _type,
    dismissible: !_modal && _dismissible,
    controller: _controller,
    selectedIndex: _index,
    onDestinationSelected: (int i) => setState(() => _index = i),
  );

  @override
  Widget buildPreview(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return Icon(_current.$1, size: 48, color: theme.colorScheme.primary);
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    return PlaygroundSlots(
      appBar: M3EAppBar.top(
        titleText: _current.$3,
        leading: chrome.leading,
        actions: <Widget>[
          if (_hasMenu)
            M3EIconButton(
              variant: M3EIconButtonVariant.standard,
              icon: const Icon(M3EIcons.menu),
              tooltip: 'Open navigation',
              onPressed: _controller.toggle,
            ),
          ...chrome.trailingActions,
        ],
      ),
      startPane: _modal ? null : _drawer,
      overlay: _modal ? _drawer : null,
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer destinations = StringBuffer();
    for (int i = 0; i < _primary.length; i++) {
      final String icon = _icons
          ? 'icon: Icon(M3EIcons.${_primary[i].$2}), '
          : '';
      final String badge = !_badges
          ? ''
          : i == 1
          ? ', showBadge: true'
          : i == 2
          ? ", badgeLabel: '3'"
          : '';
      destinations.writeln(
        "    M3ENavigationDestination(${icon}label: '${_primary[i].$3}'$badge),",
      );
    }
    final String headline = _showHeadline
        ? '  headline: ${playDartString(_headline)},\n'
        : '';
    final String sections = _sections
        ? '''
  sections: const <M3ENavigationDrawerSection>[
    M3ENavigationDrawerSection(
      header: 'Labels',
      destinations: <M3ENavigationDestination>[
        M3ENavigationDestination(label: 'Personal'),
      ],
    ),
  ],
'''
        : '';
    final String dismissible = !_modal && _dismissible
        ? '  dismissible: true,\n'
        : '';
    final String controller = _hasMenu
        ? '  controller: controller, // controller.toggle() opens it\n'
        : '';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Navigation drawer',
        code:
            '''
$kPlaySnippetImport

M3ENavigationDrawer(
  type: M3ENavigationDrawerType.${_type.name},
$dismissible$controller$headline  destinations: const <M3ENavigationDestination>[
$destinations  ],
$sections  selectedIndex: $_index,
  onDestinationSelected: (int index) {},
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
          PlayEnumChoice<M3ENavigationDrawerType>(
            label: 'Type',
            value: _type,
            values: M3ENavigationDrawerType.values,
            labelOf: (M3ENavigationDrawerType v) => v.name,
            onChanged: (M3ENavigationDrawerType v) {
              setState(() {
                _type = v;
                _resetController();
              });
            },
          ),
          if (!_modal)
            PlaySwitchItem(
              label: 'Dismissible',
              description: 'A menu button hides and shows the drawer',
              value: _dismissible,
              onChanged: (bool v) {
                setState(() {
                  _dismissible = v;
                  _resetController();
                });
              },
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Headline',
            value: _showHeadline,
            onChanged: (bool v) => setState(() => _showHeadline = v),
          ),
          if (_showHeadline)
            PlayTextField(
              label: 'Headline text',
              value: _headline,
              onChanged: (String v) => setState(() => _headline = v),
            ),
          PlaySwitchItem(
            label: 'Icons',
            value: _icons,
            onChanged: (bool v) => setState(() => _icons = v),
          ),
          PlaySwitchItem(
            label: 'Badges',
            description: 'A dot on Search and a label on Agenda',
            value: _badges,
            onChanged: (bool v) => setState(() => _badges = v),
          ),
          PlaySwitchItem(
            label: 'Labels section',
            description: 'A second group with a header',
            value: _sections,
            onChanged: (bool v) => setState(() => _sections = v),
          ),
        ],
      ),
    ];
  }
}
