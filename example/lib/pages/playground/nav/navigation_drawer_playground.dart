import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
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

  List<PlaySnippet> get _snippets {
    final String headline = _headline.isEmpty
        ? ''
        : '  headline: ${playDartString(_headline)},\n';
    final String destinations = _badges
        ? '''
  destinations: const <M3ENavigationDestination>[
    M3ENavigationDestination(icon: Icon(M3EIcons.home), label: 'Home'),
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
  ],'''
        : '''
  destinations: const <M3ENavigationDestination>[
    M3ENavigationDestination(icon: Icon(M3EIcons.home), label: 'Home'),
    M3ENavigationDestination(icon: Icon(M3EIcons.search), label: 'Search'),
    M3ENavigationDestination(
      icon: Icon(M3EIcons.calendar_today),
      label: 'Agenda',
    ),
    M3ENavigationDestination(icon: Icon(M3EIcons.edit), label: 'Drafts'),
  ],''';
    final String sample =
        '''
M3ENavigationDrawer(
$headline$destinations
  selectedIndex: 0,
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
          label: 'Navigation drawer demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a full screen with the drawer beside the page, the way '
                'an app uses it. Switch destinations to review the indicator.',
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
  });

  final String? headline;
  final List<M3ENavigationDestination> destinations;

  @override
  State<_NavigationDrawerDemoHost> createState() =>
      _NavigationDrawerDemoHostState();
}

class _NavigationDrawerDemoHostState extends State<_NavigationDrawerDemoHost> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ENavigationDestination destination = widget.destinations[_index];
    final double drawerWidth = theme.navigationDrawerTheme.width;
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // The drawer is a fixed-width pane. Keep a readable page beside it,
          // and scroll sideways when the window is narrower than both.
          const double minContentWidth = 200;
          final double width =
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
                  M3ENavigationDrawer(
                    headline: widget.headline,
                    destinations: widget.destinations,
                    selectedIndex: _index,
                    onDestinationSelected: (int i) =>
                        setState(() => _index = i),
                  ),
                  SizedBox(
                    width: width - drawerWidth,
                    child: Column(
                      children: <Widget>[
                        M3EAppBar.top(
                          titleText: destination.label,
                          leading: M3EIconButton(
                            variant: M3EIconButtonVariant.standard,
                            icon: const Icon(M3EIcons.arrow_back),
                            tooltip: 'Back',
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: IconTheme(
                              data: IconThemeData(
                                size: 48,
                                color: theme.colorScheme.primary,
                              ),
                              child: destination.icon,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
