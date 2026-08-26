import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

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
  int _index = 0;
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
  selectedIndex: $_index,
  onDestinationSelected: (int i) {},
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
          label: 'Navigation rail',
          child: SizedBox(
            height: 320,
            child: _framed(
              theme,
              M3ENavigationRail(
                sections: _sections,
                selectedIndex: _index,
                onDestinationSelected: (int i) => setState(() => _index = i),
                type: _type,
                modality: _modality,
                labelBehavior: _labelBehavior,
                fab: _showFab
                    ? M3ENavigationRailFabSlot(
                        icon: const Icon(M3EIcons.add),
                        label: 'Compose',
                        onPressed: () {},
                      )
                    : null,
              ),
            ),
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
