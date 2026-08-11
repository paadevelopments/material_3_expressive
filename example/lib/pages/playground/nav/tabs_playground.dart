import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

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
  int _selected = 0;

  List<M3ETab> get _tabs {
    return <M3ETab>[
      M3ETab(
        label: 'Overview',
        icon: _showIcons ? const Icon(M3EIcons.home) : null,
      ),
      M3ETab(
        label: 'Specs',
        icon: _showIcons ? const Icon(M3EIcons.tune) : null,
      ),
      M3ETab(
        label: 'Reviews',
        icon: _showIcons ? const Icon(M3EIcons.star_outline) : null,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Tabs',
          child: M3ETabs(
            variant: _variant,
            selectedIndex: _selected,
            onTabSelected: (int i) => setState(() => _selected = i),
            tabs: _tabs,
          ),
        ),
      ],
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
