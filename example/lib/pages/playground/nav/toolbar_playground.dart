import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EToolbar].
class ToolbarPlayground extends StatefulWidget {
  /// Creates the toolbar playground.
  const ToolbarPlayground({super.key});

  @override
  State<ToolbarPlayground> createState() => _ToolbarPlaygroundState();
}

class _ToolbarPlaygroundState extends State<ToolbarPlayground> {
  M3EToolbarColorStyle _colorStyle = M3EToolbarColorStyle.standard;
  M3EToolbarPlacement _placement = M3EToolbarPlacement.floating;
  Axis _axis = Axis.horizontal;
  bool _expanded = true;
  bool _showFab = false;
  bool _labeled = false;
  int _activeIndex = 0;

  List<M3EToolbarItem> get _actions {
    if (_labeled) {
      return <M3EToolbarItem>[
        M3EToolbarAction(icon: M3EIcons.home, label: 'Home', onPressed: () {}),
        M3EToolbarAction(
          icon: M3EIcons.search,
          label: 'Search',
          onPressed: () {},
        ),
        M3EToolbarAction(
          icon: M3EIcons.favorite,
          label: 'Favorites',
          onPressed: () {},
        ),
      ];
    }
    return <M3EToolbarItem>[
      M3EToolbarAction(icon: M3EIcons.edit, onPressed: () {}),
      M3EToolbarAction(
        icon: M3EIcons.share,
        onPressed: () {},
        isExpandTrigger: true,
      ),
      M3EToolbarAction(icon: M3EIcons.favorite, onPressed: () {}),
    ];
  }

  Widget _buildToolbar() {
    if (_placement == M3EToolbarPlacement.docked) {
      return M3EToolbar.docked(
        colorStyle: _colorStyle,
        safeArea: false,
        dockEdge: M3EToolbarDockEdge.bottom,
        activeIndex: _labeled ? _activeIndex : null,
        onActiveIndexChanged: _labeled
            ? (int i) => setState(() => _activeIndex = i)
            : null,
        actions: _actions,
      );
    }
    return M3EToolbar(
      colorStyle: _colorStyle,
      axis: _axis,
      expanded: _expanded,
      onExpandedChanged: (bool v) => setState(() => _expanded = v),
      activeIndex: _labeled ? _activeIndex : null,
      onActiveIndexChanged: _labeled
          ? (int i) => setState(() => _activeIndex = i)
          : null,
      fabExpandIcon: _showFab ? const Icon(M3EIcons.add) : null,
      fabCollapseIcon: _showFab ? const Icon(M3EIcons.close) : null,
      actions: _actions,
    );
  }

  List<PlaySnippet> get _snippets {
    final String actions = _labeled
        ? '''
  actions: <M3EToolbarItem>[
    M3EToolbarAction(icon: M3EIcons.home, label: 'Home', onPressed: () {}),
    M3EToolbarAction(icon: M3EIcons.search, label: 'Search', onPressed: () {}),
  ],'''
        : '''
  actions: <M3EToolbarItem>[
    M3EToolbarAction(icon: M3EIcons.edit, onPressed: () {}),
    M3EToolbarAction(
      icon: M3EIcons.share,
      onPressed: () {},
      isExpandTrigger: true,
    ),
    M3EToolbarAction(icon: M3EIcons.favorite, onPressed: () {}),
  ],''';
    final String sample = _placement == M3EToolbarPlacement.docked
        ? '''
M3EToolbar.docked(
  colorStyle: M3EToolbarColorStyle.${_colorStyle.name},
  safeArea: false,
  dockEdge: M3EToolbarDockEdge.bottom,
  activeIndex: ${_labeled ? _activeIndex : 'null'},
$actions
);'''
        : '''
M3EToolbar(
  colorStyle: M3EToolbarColorStyle.${_colorStyle.name},
  axis: Axis.${_axis.name},
  expanded: $_expanded,
  activeIndex: ${_labeled ? _activeIndex : 'null'},
  fabExpandIcon: ${_showFab ? 'const Icon(M3EIcons.add)' : 'null'},
$actions
);''';
    return <PlaySnippet>[
      PlaySnippet(label: 'Toolbar', code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Toolbar',
          child: Center(child: _buildToolbar()),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumSegmented<M3EToolbarPlacement>(
              label: 'Placement',
              value: _placement,
              values: M3EToolbarPlacement.values,
              labelOf: (M3EToolbarPlacement v) => v.name,
              onChanged: (M3EToolbarPlacement v) {
                setState(() => _placement = v);
              },
            ),
            PlayEnumSegmented<M3EToolbarColorStyle>(
              label: 'Color',
              value: _colorStyle,
              values: M3EToolbarColorStyle.values,
              labelOf: (M3EToolbarColorStyle v) => v.name,
              onChanged: (M3EToolbarColorStyle v) {
                setState(() => _colorStyle = v);
              },
            ),
            if (_placement == M3EToolbarPlacement.floating)
              PlayEnumMenu<Axis>(
                label: 'Axis',
                value: _axis,
                values: Axis.values,
                labelOf: (Axis v) => v.name,
                onChanged: (Axis v) => setState(() => _axis = v),
              ),
          ],
        ),
        PlayControlPanel(
          title: 'Behavior',
          children: <Widget>[
            if (_placement == M3EToolbarPlacement.floating)
              PlaySwitch(
                label: 'Expanded',
                value: _expanded,
                onChanged: (bool v) => setState(() => _expanded = v),
              ),
            if (_placement == M3EToolbarPlacement.floating)
              PlaySwitch(
                label: 'Show FAB',
                value: _showFab,
                onChanged: (bool v) => setState(() => _showFab = v),
              ),
            PlaySwitch(
              label: 'Labeled selection',
              value: _labeled,
              onChanged: (bool v) => setState(() => _labeled = v),
            ),
          ],
        ),
      ],
    );
  }
}
