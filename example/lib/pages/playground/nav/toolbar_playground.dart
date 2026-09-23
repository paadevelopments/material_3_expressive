import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_slider.dart';
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

enum _ToolbarAlign {
  topStart,
  topCenter,
  topEnd,
  centerStart,
  center,
  centerEnd,
  bottomStart,
  bottomCenter,
  bottomEnd,
}

extension on _ToolbarAlign {
  AlignmentGeometry get value => switch (this) {
    _ToolbarAlign.topStart => AlignmentDirectional.topStart,
    _ToolbarAlign.topCenter => Alignment.topCenter,
    _ToolbarAlign.topEnd => AlignmentDirectional.topEnd,
    _ToolbarAlign.centerStart => AlignmentDirectional.centerStart,
    _ToolbarAlign.center => Alignment.center,
    _ToolbarAlign.centerEnd => AlignmentDirectional.centerEnd,
    _ToolbarAlign.bottomStart => AlignmentDirectional.bottomStart,
    _ToolbarAlign.bottomCenter => Alignment.bottomCenter,
    _ToolbarAlign.bottomEnd => AlignmentDirectional.bottomEnd,
  };

  String get label => switch (this) {
    _ToolbarAlign.topStart => 'Top start',
    _ToolbarAlign.topCenter => 'Top center',
    _ToolbarAlign.topEnd => 'Top end',
    _ToolbarAlign.centerStart => 'Center start',
    _ToolbarAlign.center => 'Center',
    _ToolbarAlign.centerEnd => 'Center end',
    _ToolbarAlign.bottomStart => 'Bottom start',
    _ToolbarAlign.bottomCenter => 'Bottom center',
    _ToolbarAlign.bottomEnd => 'Bottom end',
  };

  String get snippet => switch (this) {
    _ToolbarAlign.topStart => 'AlignmentDirectional.topStart',
    _ToolbarAlign.topCenter => 'Alignment.topCenter',
    _ToolbarAlign.topEnd => 'AlignmentDirectional.topEnd',
    _ToolbarAlign.centerStart => 'AlignmentDirectional.centerStart',
    _ToolbarAlign.center => 'Alignment.center',
    _ToolbarAlign.centerEnd => 'AlignmentDirectional.centerEnd',
    _ToolbarAlign.bottomStart => 'AlignmentDirectional.bottomStart',
    _ToolbarAlign.bottomCenter => 'Alignment.bottomCenter',
    _ToolbarAlign.bottomEnd => 'AlignmentDirectional.bottomEnd',
  };
}

class _ToolbarPlaygroundState extends State<ToolbarPlayground> {
  M3EToolbarColorStyle _colorStyle = M3EToolbarColorStyle.standard;
  M3EToolbarPlacement _placement = M3EToolbarPlacement.floating;
  Axis _axis = Axis.horizontal;
  _ToolbarAlign _align = _ToolbarAlign.bottomCenter;
  double _screenOffset = M3EToolbarTokens.screenOffset;
  bool _expanded = true;
  bool _showFab = false;
  bool _fabExpands = true;
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
      fabExpandsToolbar: _fabExpands,
      onFabPressed: _showFab && !_fabExpands ? () {} : null,
      alignment: _align.value,
      screenOffset: _screenOffset,
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
  alignment: ${_align.snippet},
  screenOffset: $_screenOffset,
  expanded: $_expanded,
  activeIndex: ${_labeled ? _activeIndex : 'null'},
  fabExpandIcon: ${_showFab ? 'const Icon(M3EIcons.add)' : 'null'},${_showFab && !_fabExpands ? '''
  fabExpandsToolbar: false,
  onFabPressed: () {},''' : ''}
$actions
);''';
    return <PlaySnippet>[
      PlaySnippet(label: 'Toolbar', code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  void _openDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _ToolbarDemoHost(
            colorStyle: _colorStyle,
            placement: _placement,
            axis: _axis,
            alignment: _align.value,
            screenOffset: _screenOffset,
            expanded: _expanded,
            showFab: _showFab,
            fabExpands: _fabExpands,
            labeled: _labeled,
            activeIndex: _activeIndex,
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
          label: 'Toolbar',
          child: Center(child: _buildToolbar()),
        ),
        PlayPreviewCard(
          label: 'Toolbar demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a page with the toolbar docked or floating over a '
                'list, using the settings above.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open toolbar demo'),
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
            if (_placement == M3EToolbarPlacement.floating) ...<Widget>[
              PlayEnumMenu<Axis>(
                label: 'Axis',
                value: _axis,
                values: Axis.values,
                labelOf: (Axis v) => v.name,
                onChanged: (Axis v) => setState(() => _axis = v),
              ),
              PlayEnumMenu<_ToolbarAlign>(
                label: 'Alignment',
                value: _align,
                values: _ToolbarAlign.values,
                labelOf: (_ToolbarAlign v) => v.label,
                onChanged: (_ToolbarAlign v) => setState(() => _align = v),
              ),
              PlaySlider(
                label: 'Screen offset',
                value: _screenOffset,
                min: 0,
                max: 48,
                divisions: 48,
                onChanged: (double v) => setState(() => _screenOffset = v),
              ),
            ],
          ],
        ),
        PlayControlPanel(
          title: 'Behavior',
          children: <Widget>[
            if (_placement == M3EToolbarPlacement.floating &&
                !(_showFab && !_fabExpands))
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
            if (_placement == M3EToolbarPlacement.floating && _showFab)
              PlaySwitch(
                label: 'FAB expands',
                value: _fabExpands,
                onChanged: (bool v) => setState(() => _fabExpands = v),
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

class _ToolbarDemoHost extends StatefulWidget {
  const _ToolbarDemoHost({
    required this.colorStyle,
    required this.placement,
    required this.axis,
    required this.alignment,
    required this.screenOffset,
    required this.expanded,
    required this.showFab,
    required this.fabExpands,
    required this.labeled,
    required this.activeIndex,
  });

  final M3EToolbarColorStyle colorStyle;
  final M3EToolbarPlacement placement;
  final Axis axis;
  final AlignmentGeometry alignment;
  final double screenOffset;
  final bool expanded;
  final bool showFab;
  final bool fabExpands;
  final bool labeled;
  final int activeIndex;

  @override
  State<_ToolbarDemoHost> createState() => _ToolbarDemoHostState();
}

class _ToolbarDemoHostState extends State<_ToolbarDemoHost> {
  late bool _expanded = widget.expanded;
  late int _activeIndex = widget.activeIndex;

  List<M3EToolbarItem> get _actions {
    if (widget.labeled) {
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

  Widget _toolbar() {
    if (widget.placement == M3EToolbarPlacement.docked) {
      return M3EToolbar.docked(
        colorStyle: widget.colorStyle,
        dockEdge: M3EToolbarDockEdge.bottom,
        activeIndex: widget.labeled ? _activeIndex : null,
        onActiveIndexChanged: widget.labeled
            ? (int i) => setState(() => _activeIndex = i)
            : null,
        actions: _actions,
      );
    }
    return M3EToolbar(
      colorStyle: widget.colorStyle,
      axis: widget.axis,
      expanded: _expanded,
      onExpandedChanged: (bool v) => setState(() => _expanded = v),
      activeIndex: widget.labeled ? _activeIndex : null,
      onActiveIndexChanged: widget.labeled
          ? (int i) => setState(() => _activeIndex = i)
          : null,
      fabExpandIcon: widget.showFab ? const Icon(M3EIcons.add) : null,
      fabCollapseIcon: widget.showFab ? const Icon(M3EIcons.close) : null,
      fabExpandsToolbar: widget.fabExpands,
      onFabPressed: widget.showFab && !widget.fabExpands ? () {} : null,
      alignment: widget.alignment,
      screenOffset: widget.screenOffset,
      safeArea: true,
      dockEdge: M3EToolbarDockEdge.bottom,
      actions: _actions,
    );
  }

  Widget _page(BuildContext context, {required bool floating}) {
    final double bottom = floating
        ? 16 +
              widget.screenOffset +
              M3EToolbarTokens.containerSize +
              MediaQuery.paddingOf(context).bottom
        : 16;
    return M3ECardList.builder(
      itemCount: 16,
      listPadding: EdgeInsets.fromLTRB(16, 16, 16, bottom),
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Note ${index + 1}',
          supportingText: 'Scroll the page under the toolbar',
          leading: const Icon(M3EIcons.edit),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final PreferredSizeWidget appBar = M3EAppBar.top(
      titleText: 'Toolbar',
      leading: M3EIconButton(
        variant: M3EIconButtonVariant.standard,
        icon: const Icon(M3EIcons.arrow_back),
        tooltip: 'Back',
        onPressed: () => Navigator.of(context).maybePop(),
      ),
    );
    if (widget.placement == M3EToolbarPlacement.docked) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: appBar,
        body: _page(context, floating: false),
        bottomNavigationBar: _toolbar(),
      );
    }
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: appBar,
      body: Stack(
        children: <Widget>[_page(context, floating: true), _toolbar()],
      ),
    );
  }
}
