import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ENavigationRail].
class NavigationRailPlayground extends StatefulWidget {
  /// Creates the navigation rail playground.
  const NavigationRailPlayground({super.key});

  @override
  State<NavigationRailPlayground> createState() =>
      _NavigationRailPlaygroundState();
}

class _NavigationRailPlaygroundState extends State<NavigationRailPlayground> {
  M3ENavigationRailType _type = M3ENavigationRailType.expanded;
  final M3ENavigationRailModality _modality =
      M3ENavigationRailModality.standard;
  M3ENavigationRailLabelBehavior _labelBehavior =
      M3ENavigationRailLabelBehavior.alwaysShow;
  bool _showFab = true;

  static const List<M3ENavigationRailSection> _sections =
      <M3ENavigationRailSection>[
        M3ENavigationRailSection(
          destinations: <M3ENavigationRailDestination>[
            M3ENavigationRailDestination(
              icon: Icon(M3EIcons.home),
              label: 'Home',
            ),
            M3ENavigationRailDestination(
              icon: Icon(M3EIcons.search),
              label: 'Search',
            ),
            M3ENavigationRailDestination(
              icon: Icon(M3EIcons.calendar_today),
              label: 'Agenda',
              badgeCount: 3,
            ),
            M3ENavigationRailDestination(
              icon: Icon(M3EIcons.edit),
              label: 'Drafts',
            ),
          ],
        ),
      ];

  List<PlaySnippet> get _snippets {
    final String fab = _showFab
        ? '''
  fab: M3ENavigationRailFabSlot(
    icon: const Icon(M3EIcons.add),
    label: 'Compose',
    onPressed: () {},
  ),'''
        : '';
    final String sample =
        '''
M3ENavigationRail(
  sections: const <M3ENavigationRailSection>[
    M3ENavigationRailSection(
      destinations: <M3ENavigationRailDestination>[
        M3ENavigationRailDestination(
          icon: Icon(M3EIcons.home),
          label: 'Home',
        ),
        M3ENavigationRailDestination(
          icon: Icon(M3EIcons.search),
          label: 'Search',
        ),
      ],
    ),
  ],
  selectedIndex: 0,
  onDestinationSelected: (int i) {},
  expandTooltip: 'Expand',
  collapseTooltip: 'Collapse',
  type: M3ENavigationRailType.${_type.name},
  modality: M3ENavigationRailModality.${_modality.name},
  labelBehavior: M3ENavigationRailLabelBehavior.${_labelBehavior.name},$fab
);''';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Navigation rail',
        code: '$kPlaySnippetImport\n$sample',
      ),
    ];
  }

  void _openDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _NavigationRailDemoHost(
            sections: _sections,
            type: _type,
            modality: _modality,
            labelBehavior: _labelBehavior,
            showFab: _showFab,
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
          label: 'Navigation rail demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a full screen with the rail beside the page, the way '
                'an app uses it. Expand it and switch destinations to review '
                'the indicator.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open navigation rail demo'),
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
            PlayEnumMenu<M3ENavigationRailType>(
              label: 'Type',
              value: _type,
              values: M3ENavigationRailType.values,
              labelOf: (M3ENavigationRailType v) => v.name,
              onChanged: (M3ENavigationRailType v) {
                setState(() => _type = v);
              },
            ),
            PlayEnumMenu<M3ENavigationRailLabelBehavior>(
              label: 'Labels',
              value: _labelBehavior,
              values: M3ENavigationRailLabelBehavior.values,
              labelOf: (M3ENavigationRailLabelBehavior v) => v.name,
              onChanged: (M3ENavigationRailLabelBehavior v) {
                setState(() => _labelBehavior = v);
              },
            ),
            PlaySwitch(
              label: 'Show FAB',
              value: _showFab,
              onChanged: (bool v) => setState(() => _showFab = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavigationRailDemoHost extends StatefulWidget {
  const _NavigationRailDemoHost({
    required this.sections,
    required this.type,
    required this.modality,
    required this.labelBehavior,
    required this.showFab,
  });

  final List<M3ENavigationRailSection> sections;
  final M3ENavigationRailType type;
  final M3ENavigationRailModality modality;
  final M3ENavigationRailLabelBehavior labelBehavior;
  final bool showFab;

  @override
  State<_NavigationRailDemoHost> createState() =>
      _NavigationRailDemoHostState();
}

class _NavigationRailDemoHostState extends State<_NavigationRailDemoHost> {
  int _index = 0;

  M3ENavigationRailDestination get _destination {
    return widget.sections
        .expand((M3ENavigationRailSection section) => section.destinations)
        .elementAt(_index);
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ENavigationRailDestination destination = _destination;
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          M3ENavigationRail(
            sections: widget.sections,
            selectedIndex: _index,
            onDestinationSelected: (int i) => setState(() => _index = i),
            type: widget.type,
            modality: widget.modality,
            labelBehavior: widget.labelBehavior,
            fab: widget.showFab
                ? M3ENavigationRailFabSlot(
                    icon: const Icon(M3EIcons.add),
                    label: 'Compose',
                    onPressed: () {},
                  )
                : null,
          ),
          Expanded(
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
    );
  }
}
