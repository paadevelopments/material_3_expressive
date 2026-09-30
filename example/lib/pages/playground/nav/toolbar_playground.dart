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
  M3EToolbarContentAlignment _contentAlignment =
      M3EToolbarContentAlignment.even;
  Axis _axis = Axis.horizontal;
  _ToolbarAlign _align = _ToolbarAlign.bottomCenter;
  double _screenOffset = M3EToolbarTokens.screenOffset;
  bool _expanded = true;
  bool _showFab = false;
  bool _fabExpands = true;
  bool _labeled = false;
  bool _overflow = false;
  bool _hideOnScroll = false;
  bool _collapseOnScroll = false;
  int _activeIndex = 0;

  /// Whether an adjacent FAB or expand-trigger action exists to collapse to
  /// — [M3EToolbarScrollBehavior.collapseAlways] requires one.
  bool get _hasExpandTarget {
    if (_placement != M3EToolbarPlacement.floating) {
      return false;
    }
    if (_showFab) {
      return _fabExpands;
    }
    return !_labeled;
  }

  /// [_collapseOnScroll], but discarding a stale `true` once its expand
  /// target (FAB / trigger) has disappeared from other control changes.
  bool get _effectiveCollapseOnScroll => _collapseOnScroll && _hasExpandTarget;

  M3EToolbarExitDirection get _exitDirection {
    if (_placement == M3EToolbarPlacement.docked) {
      return M3EToolbarExitDirection.bottom;
    }
    if (_axis == Axis.vertical) {
      return switch (_align) {
        _ToolbarAlign.topStart ||
        _ToolbarAlign.centerStart ||
        _ToolbarAlign.bottomStart => M3EToolbarExitDirection.start,
        _ToolbarAlign.topEnd ||
        _ToolbarAlign.centerEnd ||
        _ToolbarAlign.bottomEnd => M3EToolbarExitDirection.end,
        _ => M3EToolbarExitDirection.bottom,
      };
    }
    return switch (_align) {
      _ToolbarAlign.topStart ||
      _ToolbarAlign.topCenter ||
      _ToolbarAlign.topEnd => M3EToolbarExitDirection.top,
      _ => M3EToolbarExitDirection.bottom,
    };
  }

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
    final List<M3EToolbarItem> actions = <M3EToolbarItem>[
      M3EToolbarAction(icon: M3EIcons.edit, onPressed: () {}),
      M3EToolbarAction(
        icon: M3EIcons.share,
        onPressed: () {},
        isExpandTrigger: true,
      ),
      M3EToolbarAction(icon: M3EIcons.favorite, onPressed: () {}),
    ];
    if (_overflow) {
      actions.addAll(<M3EToolbarItem>[
        M3EToolbarAction(icon: M3EIcons.delete, onPressed: () {}),
        M3EToolbarAction(icon: M3EIcons.settings, onPressed: () {}),
      ]);
    }
    return actions;
  }

  Widget _buildToolbar() {
    if (_placement == M3EToolbarPlacement.docked) {
      return M3EToolbar.docked(
        colorStyle: _colorStyle,
        contentAlignment: _contentAlignment,
        maxInlineActions: _overflow ? 3 : 4,
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
      maxInlineActions: _overflow ? 3 : 4,
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
    final String scrollField = switch ((
      _hideOnScroll,
      _effectiveCollapseOnScroll,
    )) {
      (true, _) =>
        '''
  scrollBehavior: M3EToolbarScrollBehavior.exitAlways(
    exitDirection: M3EToolbarExitDirection.${_exitDirection.name},
  ),''',
      (_, true) =>
        '''
  scrollBehavior: M3EToolbarScrollBehavior.collapseAlways(),''',
      _ => '',
    };
    final String sample = _placement == M3EToolbarPlacement.docked
        ? '''
M3EToolbar.docked(
  colorStyle: M3EToolbarColorStyle.${_colorStyle.name},
  contentAlignment: M3EToolbarContentAlignment.${_contentAlignment.name},
  safeArea: false,
  dockEdge: M3EToolbarDockEdge.bottom,
  activeIndex: ${_labeled ? _activeIndex : 'null'},$scrollField
$actions
);'''
        : '''
M3EToolbar(
  colorStyle: M3EToolbarColorStyle.${_colorStyle.name},
  axis: Axis.${_axis.name},
  alignment: ${_align.snippet},
  screenOffset: $_screenOffset,
  expanded: $_expanded,
  activeIndex: ${_labeled ? _activeIndex : 'null'},$scrollField
  fabExpandIcon: ${_showFab ? 'const Icon(M3EIcons.add)' : 'null'},${_showFab && !_fabExpands ? '''
  fabExpandsToolbar: false,
  onFabPressed: () {},''' : ''}
$actions
);''';
    return <PlaySnippet>[
      PlaySnippet(label: 'Toolbar', code: '$kPlaySnippetImport\n$sample'),
      if (_hideOnScroll || _effectiveCollapseOnScroll)
        PlaySnippet(
          label: 'Scroll',
          code:
              '''
$kPlaySnippetImport

final behavior = ${_hideOnScroll ? '''
M3EToolbarScrollBehavior.exitAlways(
  exitDirection: M3EToolbarExitDirection.${_exitDirection.name},
);''' : '''
M3EToolbarScrollBehavior.collapseAlways();'''}

M3EToolbarScrollWrapper(
  behavior: behavior,
  child: list,
)
''',
        ),
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
            overflow: _overflow,
            hideOnScroll: _hideOnScroll,
            collapseOnScroll: _effectiveCollapseOnScroll,
            exitDirection: _exitDirection,
            contentAlignment: _contentAlignment,
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
                switch ((_hideOnScroll, _effectiveCollapseOnScroll)) {
                  (true, _) =>
                    'Opens a scrolling page. The toolbar slides away and '
                        'returns with the list.',
                  (_, true) =>
                    'Opens a scrolling page. The toolbar collapses to its '
                        'FAB / expand-trigger action and returns with the '
                        'list.',
                  _ =>
                    'Opens a page with the toolbar docked or floating over a '
                        'list, using the settings above.',
                },
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
            if (_placement == M3EToolbarPlacement.docked)
              PlayEnumMenu<M3EToolbarContentAlignment>(
                label: 'Content alignment',
                value: _contentAlignment,
                values: M3EToolbarContentAlignment.values,
                labelOf: (M3EToolbarContentAlignment v) => v.name,
                onChanged: (M3EToolbarContentAlignment v) {
                  setState(() => _contentAlignment = v);
                },
              ),
            if (_placement == M3EToolbarPlacement.floating) ...<Widget>[
              PlayEnumMenu<Axis>(
                label: 'Axis',
                value: _axis,
                values: Axis.values,
                labelOf: (Axis v) => v.name,
                onChanged: (Axis v) {
                  setState(() {
                    _axis = v;
                    _screenOffset = v == Axis.vertical
                        ? M3EToolbarTokens.verticalScreenOffset
                        : M3EToolbarTokens.screenOffset;
                  });
                },
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
            PlaySwitch(
              label: 'Overflow',
              value: _overflow,
              onChanged: (bool v) => setState(() => _overflow = v),
            ),
            PlaySwitch(
              label: 'Hide on scroll',
              value: _hideOnScroll,
              onChanged: (bool v) => setState(() {
                _hideOnScroll = v;
                if (v) {
                  _collapseOnScroll = false;
                }
              }),
            ),
            if (_hasExpandTarget)
              PlaySwitch(
                label: 'Collapse on scroll',
                value: _collapseOnScroll,
                onChanged: (bool v) => setState(() {
                  _collapseOnScroll = v;
                  if (v) {
                    _hideOnScroll = false;
                  }
                }),
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
    required this.overflow,
    required this.hideOnScroll,
    required this.collapseOnScroll,
    required this.exitDirection,
    required this.contentAlignment,
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
  final bool overflow;
  final bool hideOnScroll;
  final bool collapseOnScroll;
  final M3EToolbarExitDirection exitDirection;
  final M3EToolbarContentAlignment contentAlignment;
  final int activeIndex;

  @override
  State<_ToolbarDemoHost> createState() => _ToolbarDemoHostState();
}

class _ToolbarDemoHostState extends State<_ToolbarDemoHost> {
  late bool _expanded = widget.expanded;
  late int _activeIndex = widget.activeIndex;
  M3EToolbarScrollBehavior? _scrollBehavior;

  @override
  void initState() {
    super.initState();
    if (widget.hideOnScroll) {
      _scrollBehavior = M3EToolbarScrollBehavior.exitAlways(
        exitDirection: widget.exitDirection,
      );
    } else if (widget.collapseOnScroll) {
      _scrollBehavior = M3EToolbarScrollBehavior.collapseAlways();
    }
  }

  @override
  void dispose() {
    _scrollBehavior?.controller.dispose();
    super.dispose();
  }

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
    final List<M3EToolbarItem> actions = <M3EToolbarItem>[
      M3EToolbarAction(icon: M3EIcons.edit, onPressed: () {}),
      M3EToolbarAction(
        icon: M3EIcons.share,
        onPressed: () {},
        isExpandTrigger: true,
      ),
      M3EToolbarAction(icon: M3EIcons.favorite, onPressed: () {}),
    ];
    if (widget.overflow) {
      actions.addAll(<M3EToolbarItem>[
        M3EToolbarAction(icon: M3EIcons.delete, onPressed: () {}),
        M3EToolbarAction(icon: M3EIcons.settings, onPressed: () {}),
      ]);
    }
    return actions;
  }

  Widget _toolbar() {
    if (widget.placement == M3EToolbarPlacement.docked) {
      return M3EToolbar.docked(
        colorStyle: widget.colorStyle,
        contentAlignment: widget.contentAlignment,
        maxInlineActions: widget.overflow ? 3 : 4,
        dockEdge: M3EToolbarDockEdge.bottom,
        scrollBehavior: _scrollBehavior,
        activeIndex: widget.labeled ? _activeIndex : null,
        onActiveIndexChanged: widget.labeled
            ? (int i) => setState(() => _activeIndex = i)
            : null,
        actions: _actions,
      );
    }
    return M3EToolbar(
      colorStyle: widget.colorStyle,
      maxInlineActions: widget.overflow ? 3 : 4,
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
      scrollBehavior: _scrollBehavior,
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
    return M3EList.scrollable(
      color: M3ETheme.of(context).colorScheme.surfaceContainerHighest,
      itemCount: 16,
      listPadding: EdgeInsets.fromLTRB(16, 16, 16, bottom),
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Note ${index + 1}',
          supportingText: switch ((
            widget.hideOnScroll,
            widget.collapseOnScroll,
          )) {
            (true, _) => 'Scroll to hide and show the toolbar',
            (_, true) => 'Scroll to collapse and expand the toolbar',
            _ => 'Scroll the page under the toolbar',
          },
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
    final Widget page = _scrollBehavior == null
        ? _page(
            context,
            floating: widget.placement != M3EToolbarPlacement.docked,
          )
        : M3EToolbarScrollWrapper(
            behavior: _scrollBehavior!,
            child: _page(
              context,
              floating: widget.placement != M3EToolbarPlacement.docked,
            ),
          );
    if (widget.placement == M3EToolbarPlacement.docked) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: appBar,
        body: page,
        bottomNavigationBar: _toolbar(),
      );
    }
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: appBar,
      body: Stack(children: <Widget>[page, _toolbar()]),
    );
  }
}
