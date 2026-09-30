import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ENavigationDrawer].
class NavigationDrawerPlayground extends StatefulWidget {
  /// Creates the navigation drawer playground.
  const NavigationDrawerPlayground({super.key});

  @override
  State<NavigationDrawerPlayground> createState() =>
      _NavigationDrawerPlaygroundState();
}

class _NavigationDrawerPlaygroundState
    extends State<NavigationDrawerPlayground> {
  String _headline = 'Mail';
  bool _badges = true;
  bool _sections = true;
  bool _dismissible = false;
  M3ENavigationDrawerType _type = M3ENavigationDrawerType.standard;

  List<M3ENavigationDestination> get _destinations {
    return <M3ENavigationDestination>[
      const M3ENavigationDestination(icon: Icon(M3EIcons.home), label: 'Home'),
      M3ENavigationDestination(
        icon: const Icon(M3EIcons.search),
        label: 'Search',
        showBadge: _badges,
      ),
      M3ENavigationDestination(
        icon: const Icon(M3EIcons.calendar_today),
        label: 'Agenda',
        badgeLabel: _badges ? '3' : null,
      ),
      const M3ENavigationDestination(
        icon: Icon(M3EIcons.edit),
        label: 'Drafts',
      ),
    ];
  }

  List<M3ENavigationDrawerSection> get _sectionList {
    if (!_sections) {
      return const <M3ENavigationDrawerSection>[];
    }
    return const <M3ENavigationDrawerSection>[
      M3ENavigationDrawerSection(
        header: 'Labels',
        destinations: <M3ENavigationDestination>[
          M3ENavigationDestination(
            icon: Icon(M3EIcons.folder),
            label: 'Personal',
          ),
          M3ENavigationDestination(icon: Icon(M3EIcons.work), label: 'Work'),
          M3ENavigationDestination(
            icon: Icon(M3EIcons.flight),
            label: 'Travel',
          ),
        ],
      ),
    ];
  }

  List<PlaySnippet> get _snippets {
    final headline = _headline.isEmpty
        ? ''
        : '  headline: ${playDartString(_headline)},\n';
    final badges = _badges
        ? '''
    M3ENavigationDestination(
      icon: Icon(M3EIcons.search),
      label: 'Search',
      showBadge: true,
    ),
    M3ENavigationDestination(
      icon: Icon(M3EIcons.calendar_today),
      label: 'Agenda',
      badgeLabel: '3',
    ),'''
        : '''
    M3ENavigationDestination(icon: Icon(M3EIcons.search), label: 'Search'),
    M3ENavigationDestination(
      icon: Icon(M3EIcons.calendar_today),
      label: 'Agenda',
    ),''';
    final sections = _sections
        ? '''
  sections: const <M3ENavigationDrawerSection>[
    M3ENavigationDrawerSection(
      header: 'Labels',
      destinations: <M3ENavigationDestination>[
        M3ENavigationDestination(
          icon: Icon(M3EIcons.folder),
          label: 'Personal',
        ),
        M3ENavigationDestination(icon: Icon(M3EIcons.work), label: 'Work'),
        M3ENavigationDestination(
          icon: Icon(M3EIcons.flight),
          label: 'Travel',
        ),
      ],
    ),
  ],
'''
        : '';
    final modal = _type == M3ENavigationDrawerType.modal;
    final controlled = modal || _dismissible;
    final opener = controlled
        ? '''
final M3ENavigationDrawerController controller =
    M3ENavigationDrawerController(${modal ? '' : 'isOpen: true'});

M3EButton(
  onPressed: controller.${modal ? 'open' : 'toggle'},
  child: const Text('Open navigation'),
);

'''
        : '';
    final controllerArg = controlled ? '  controller: controller,\n' : '';
    final dismissibleArg = _dismissible && !modal
        ? '  dismissible: true,\n'
        : '';
    final typeArg = modal ? '  type: M3ENavigationDrawerType.modal,\n' : '';
    final sample =
        '''
${opener}M3ENavigationDrawer(
$headline  destinations: const <M3ENavigationDestination>[
    M3ENavigationDestination(icon: Icon(M3EIcons.home), label: 'Home'),
$badges
    M3ENavigationDestination(icon: Icon(M3EIcons.edit), label: 'Drafts'),
  ],
$sections$typeArg$dismissibleArg$controllerArg  selectedIndex: 0,
  onDestinationSelected: (int i) {},
);''';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Navigation drawer',
        code: '$kPlaySnippetImport\n$sample',
      ),
    ];
  }

  void _openDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _NavigationDrawerDemoHost(
            headline: _headline.isEmpty ? null : _headline,
            destinations: _destinations,
            sections: _sectionList,
            type: _type,
            dismissible: _dismissible,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Navigation drawer demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a full screen with the drawer beside the page. A modal '
                'drawer opens from the menu and covers the page.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open navigation drawer demo'),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Content',
          children: <Widget>[
            PlayTextField(
              label: 'Headline',
              value: _headline,
              onChanged: (String v) => setState(() => _headline = v),
            ),
            PlaySwitch(
              label: 'Badges',
              value: _badges,
              onChanged: (bool v) => setState(() => _badges = v),
            ),
            PlaySwitch(
              label: 'Section',
              value: _sections,
              onChanged: (bool v) => setState(() => _sections = v),
            ),
            PlayEnumMenu<M3ENavigationDrawerType>(
              label: 'Type',
              value: _type,
              values: M3ENavigationDrawerType.values,
              labelOf: (M3ENavigationDrawerType value) => value.name,
              onChanged: (M3ENavigationDrawerType value) {
                setState(() => _type = value);
              },
            ),
            PlaySwitch(
              label: 'Dismissible',
              value: _dismissible,
              onChanged: (bool v) => setState(() => _dismissible = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavigationDrawerDemoHost extends StatefulWidget {
  const _NavigationDrawerDemoHost({
    required this.headline,
    required this.destinations,
    required this.sections,
    required this.type,
    required this.dismissible,
  });

  final String? headline;
  final List<M3ENavigationDestination> destinations;
  final List<M3ENavigationDrawerSection> sections;
  final M3ENavigationDrawerType type;
  final bool dismissible;

  @override
  State<_NavigationDrawerDemoHost> createState() =>
      _NavigationDrawerDemoHostState();
}

class _NavigationDrawerDemoHostState extends State<_NavigationDrawerDemoHost> {
  late final M3ENavigationDrawerController _controller;
  int _index = 0;

  bool get _menu =>
      widget.type == M3ENavigationDrawerType.modal || widget.dismissible;

  List<M3ENavigationDestination> get _all {
    return <M3ENavigationDestination>[
      ...widget.destinations,
      for (final section in widget.sections) ...section.destinations,
    ];
  }

  @override
  void initState() {
    super.initState();
    final startsOpen =
        widget.type == M3ENavigationDrawerType.standard && !widget.dismissible;
    _controller = M3ENavigationDrawerController(isOpen: startsOpen);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final destination = _all[_index.clamp(0, _all.length - 1)];
    final drawer = M3ENavigationDrawer(
      headline: widget.headline,
      destinations: widget.destinations,
      sections: widget.sections,
      type: widget.type,
      dismissible: widget.dismissible,
      controller: _controller,
      selectedIndex: _index,
      onDestinationSelected: (int i) => setState(() => _index = i),
    );
    final page = _page(theme, destination);
    final modal = widget.type == M3ENavigationDrawerType.modal;
    return Material(
      color: theme.colorScheme.surface,
      child: modal
          ? Stack(
              children: <Widget>[
                Positioned.fill(child: page),
                drawer,
              ],
            )
          : LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                const minContentWidth = 200;
                final drawerWidth = theme.navigationDrawerTheme.width;
                final width =
                    constraints.maxWidth >= drawerWidth + minContentWidth
                    ? constraints.maxWidth
                    : drawerWidth + minContentWidth;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: width,
                    height: constraints.maxHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        drawer,
                        Expanded(child: page),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _page(M3EThemeData theme, M3ENavigationDestination destination) {
    return Column(
      children: <Widget>[
        M3EAppBar.top(
          titleText: destination.label,
          leading: M3EIconButton(
            variant: M3EIconButtonVariant.standard,
            icon: Icon(_menu ? M3EIcons.menu : M3EIcons.arrow_back),
            tooltip: _menu ? 'Open navigation' : 'Back',
            onPressed: () {
              if (_menu) {
                _controller.toggle();
                return;
              }
              Navigator.of(context).maybePop();
            },
          ),
          actions: <Widget>[
            if (_menu)
              M3EIconButton(
                variant: M3EIconButtonVariant.standard,
                icon: const Icon(M3EIcons.arrow_back),
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
          ],
        ),
        Expanded(
          child: Center(
            child: IconTheme(
              data: IconThemeData(size: 48, color: theme.colorScheme.primary),
              child: destination.icon ?? const Icon(M3EIcons.folder),
            ),
          ),
        ),
      ],
    );
  }
}
