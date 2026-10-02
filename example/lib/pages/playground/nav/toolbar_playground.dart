import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3EToolbar].
class ToolbarPlayground extends PlaygroundWidget {
  /// Creates the toolbar playground.
  const ToolbarPlayground({super.key});

  @override
  PlaygroundState<ToolbarPlayground> createState() => _ToolbarPlaygroundState();
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

class _ToolbarPlaygroundState extends PlaygroundState<ToolbarPlayground> {
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
  M3EToolbarScrollBehavior? _scrollBehavior;
  String? _scrollBehaviorKey;

  @override
  void dispose() {
    _scrollBehavior?.controller.dispose();
    super.dispose();
  }

  /// The scroll behavior for the current options, rebuilt when they change.
  M3EToolbarScrollBehavior? get _behavior {
    final String key = _hideOnScroll
        ? 'exit-${_exitDirection.name}'
        : _effectiveCollapseOnScroll
        ? 'collapse'
        : 'none';
    if (key != _scrollBehaviorKey) {
      final M3EToolbarScrollBehavior? old = _scrollBehavior;
      if (old != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => old.controller.dispose(),
        );
      }
      _scrollBehaviorKey = key;
      _scrollBehavior = switch (key) {
        'none' => null,
        'collapse' => M3EToolbarScrollBehavior.collapseAlways(),
        _ => M3EToolbarScrollBehavior.exitAlways(exitDirection: _exitDirection),
      };
    }
    return _scrollBehavior;
  }

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
        dockEdge: M3EToolbarDockEdge.bottom,
        scrollBehavior: _behavior,
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
      safeArea: true,
      dockEdge: M3EToolbarDockEdge.bottom,
      scrollBehavior: _behavior,
      actions: _actions,
    );
  }

  bool get _docked => _placement == M3EToolbarPlacement.docked;

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    final double bottom = _docked
        ? padding.bottom
        : padding.bottom + _screenOffset + M3EToolbarTokens.containerSize;
    final Widget list = M3EList.scrollable(
      controller: PrimaryScrollController.of(context),
      color: M3ETheme.of(context).colorScheme.surfaceContainerHighest,
      itemCount: 16,
      listPadding: padding.copyWith(bottom: bottom),
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Note ${index + 1}',
          supportingText: switch ((_hideOnScroll, _effectiveCollapseOnScroll)) {
            (true, _) => 'Scroll to hide and show the toolbar',
            (_, true) => 'Scroll to collapse and expand the toolbar',
            _ => 'Scroll the page under the toolbar',
          },
          leading: const Icon(M3EIcons.edit),
        );
      },
    );
    final M3EToolbarScrollBehavior? behavior = _behavior;
    final Widget page = behavior == null
        ? list
        : M3EToolbarScrollWrapper(behavior: behavior, child: list);
    if (_docked) {
      return page;
    }
    return Stack(
      children: <Widget>[
        Positioned.fill(child: page),
        _buildToolbar(),
      ],
    );
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    return PlaygroundSlots(
      bottomNavigationBar: _docked ? _buildToolbar() : null,
    );
  }

  @override
  List<PlaySnippet> get snippets {
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

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlayEnumChoice<M3EToolbarPlacement>(
            label: 'Placement',
            value: _placement,
            values: M3EToolbarPlacement.values,
            labelOf: (M3EToolbarPlacement v) => v.name,
            onChanged: (M3EToolbarPlacement v) {
              setState(() => _placement = v);
            },
          ),
          PlayEnumChoice<M3EToolbarColorStyle>(
            label: 'Color',
            value: _colorStyle,
            values: M3EToolbarColorStyle.values,
            labelOf: (M3EToolbarColorStyle v) => v.name,
            onChanged: (M3EToolbarColorStyle v) {
              setState(() => _colorStyle = v);
            },
          ),
          if (_placement == M3EToolbarPlacement.docked)
            PlayEnumChoice<M3EToolbarContentAlignment>(
              label: 'Content alignment',
              value: _contentAlignment,
              values: M3EToolbarContentAlignment.values,
              labelOf: (M3EToolbarContentAlignment v) => v.name,
              onChanged: (M3EToolbarContentAlignment v) {
                setState(() => _contentAlignment = v);
              },
            ),
          if (_placement == M3EToolbarPlacement.floating) ...<Widget>[
            PlayEnumChoice<Axis>(
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
            PlayEnumChoice<_ToolbarAlign>(
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
      PlayControlGroup(
        title: 'Behavior',
        children: <Widget>[
          if (_placement == M3EToolbarPlacement.floating &&
              !(_showFab && !_fabExpands))
            PlaySwitchItem(
              label: 'Expanded',
              value: _expanded,
              onChanged: (bool v) => setState(() => _expanded = v),
            ),
          if (_placement == M3EToolbarPlacement.floating)
            PlaySwitchItem(
              label: 'Show FAB',
              value: _showFab,
              onChanged: (bool v) => setState(() => _showFab = v),
            ),
          if (_placement == M3EToolbarPlacement.floating && _showFab)
            PlaySwitchItem(
              label: 'FAB expands',
              value: _fabExpands,
              onChanged: (bool v) => setState(() => _fabExpands = v),
            ),
          PlaySwitchItem(
            label: 'Labeled selection',
            value: _labeled,
            onChanged: (bool v) => setState(() => _labeled = v),
          ),
          PlaySwitchItem(
            label: 'Overflow',
            value: _overflow,
            onChanged: (bool v) => setState(() => _overflow = v),
          ),
          PlaySwitchItem(
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
            PlaySwitchItem(
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
    ];
  }
}
