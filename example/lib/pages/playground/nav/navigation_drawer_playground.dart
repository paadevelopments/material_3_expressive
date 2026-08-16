import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

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
  int _index = 0;
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
  selectedIndex: $_index,
  onDestinationSelected: (int i) {},
);''';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Navigation drawer',
        code: '$kPlaySnippetImport\n$sample',
      ),
    ];
  }

  Widget _framed(M3EThemeData theme, Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: M3EShapes.radiusLarge,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ClipRRect(borderRadius: M3EShapes.radiusLarge, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Navigation drawer',
          child: SizedBox(
            height: 328,
            child: _framed(
              theme,
              M3ENavigationDrawer(
                headline: _headline.isEmpty ? null : _headline,
                destinations: _destinations,
                selectedIndex: _index,
                onDestinationSelected: (int i) => setState(() => _index = i),
              ),
            ),
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
