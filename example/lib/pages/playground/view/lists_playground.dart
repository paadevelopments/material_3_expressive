import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

enum _ListKind { item, cardList, dismissible, expandable }

/// Live playground for list components.
class ListsPlayground extends PlaygroundWidget {
  /// Creates the lists playground.
  const ListsPlayground({super.key});

  @override
  PlaygroundState<ListsPlayground> createState() => _ListsPlaygroundState();
}

class _ListsPlaygroundState extends PlaygroundState<ListsPlayground> {
  _ListKind _kind = _ListKind.item;
  M3ECardVariant _variant = M3ECardVariant.outlined;
  bool _showLeading = true;
  bool _showTrailing = true;
  bool _selection = false;
  bool _nestedSelection = false;
  bool _reorder = false;
  bool _singleSelect = false;
  bool _doubleTapTrigger = false;
  bool _useSublist = true;
  bool _expandedStateFill = true;
  bool _roundSublistBottom = true;
  bool _showSelectedIcon = true;
  bool _baseline = false;
  bool _containerTransform = false;
  M3EListStyle _style = M3EListStyle.segmented;
  bool _disabled = false;
  bool _selected = false;
  M3EListSwipeMode _swipeMode = M3EListSwipeMode.both;
  M3EListSwipeEdge _dismissEdge = M3EListSwipeEdge.both;
  String _headline = 'Wireless charging';
  String _supporting = 'On · Fast charge enabled';

  void _setShowSelectedIcon(bool value) {
    setState(() {
      _showSelectedIcon = value;
      if (value) {
        _doubleTapTrigger = false;
      }
    });
  }

  void _setDoubleTapTrigger(bool value) {
    setState(() {
      _doubleTapTrigger = value;
      if (value) {
        _showSelectedIcon = false;
      }
    });
  }

  @override
  List<PlaySnippet> get snippets {
    final String headline = playDartString(_headline);
    final String supporting = playDartString(_supporting);
    final String selectionFeature = _selection ? '\n  selection: true,' : '';
    final String features =
        '$selectionFeature${_reorder ? '\n  reorder: true,\n  onReorder: (int a, int b) {},' : ''}';
    final String sample = switch (_kind) {
      _ListKind.item =>
        '''
M3EListItem(
  headline: $headline,
  supportingText: $supporting,${_showLeading ? '\n  leading: const Icon(M3EIcons.schedule),' : ''}${_showTrailing ? '\n  trailing: const Icon(M3EIcons.chevron_right),' : ''}
  onTap: () {},${_containerTransform ? '\n  transform: const Text(\'Full screen destination\'),' : ''}
);''',
      _ListKind.cardList =>
        '''
M3EList(
  variant: M3ECardVariant.${_variant.name},$features
  itemCount: 3,
  itemBuilder: (BuildContext context, int index) {
    return M3EListItem(
      headline: $headline,
      supportingText: $supporting,${_showLeading ? '\n      leading: const Icon(M3EIcons.inbox),' : ''}${_showTrailing ? '\n      trailing: const Icon(M3EIcons.chevron_right),' : ''}${_containerTransform ? '\n      transform: const Text(\'Full screen destination\'),' : ''}
    );
  },
);''',
      _ListKind.dismissible =>
        '''
M3EList(
  itemCount: 3,$selectionFeature${_reorder ? '\n  reorder: true,\n  onReorder: (int a, int b) {},' : ''}
  itemBuilder: (BuildContext context, int index) {
    return M3EListItem(
      headline: $headline,${_showLeading ? '\n      leading: const Icon(M3EIcons.schedule),' : ''}${_containerTransform ? '\n      transform: const Text(\'Full screen destination\'),' : ''}
      swipe: M3EListItemSwipe(
        mode: M3EListSwipeMode.${_swipeMode.name},
        edge: M3EListSwipeEdge.${_dismissEdge.name},
        onDismiss: (DismissDirection direction) async => true,
      ),
    );
  },
);''',
      _ListKind.expandable =>
        '''
M3EList(${_selection ? '\n  selection: true,' : ''}${_reorder ? '\n  reorder: true,\n  onReorder: (int a, int b) {},' : ''}${_expandedStateFill && _roundSublistBottom ? '' : '\n  expandStyle: const M3EExpandableStyle(${_expandedStateFill ? '' : 'expandedStateFill: false'}${!_expandedStateFill && !_roundSublistBottom ? ', ' : ''}${_roundSublistBottom ? '' : 'roundSublistBottom: false'}),'}
  itemCount: 1,
  itemBuilder: (BuildContext context, int index) {
    return M3EListItem(
      headline: $headline,
      supportingText: $supporting,${_showLeading ? '\n      leading: const Icon(M3EIcons.battery_alert),' : ''}
      expanded: ${_containerTransform
            ? '''M3EExpandableExpanded.transform(
        const Text('Full screen destination'),
      ),'''
            : _useSublist
            ? '''M3EExpandableExpanded.list(
        M3EList(
          embedded: true,
          itemCount: 2,${_nestedSelection ? '\n          selection: true,' : ''}
          itemBuilder: (BuildContext context, int index) {
            return M3EListItem(headline: 'Child \${index + 1}');
          },
        ),
      ),'''
            : '''M3EExpandableExpanded.content(
        const Text('Expanded body'),
      ),'''}
    );
  },
);''',
    };
    return <PlaySnippet>[
      PlaySnippet(label: 'List', code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    return _ListDemoHost(
      padding: padding,
      kind: _kind,
      variant: _variant,
      showLeading: _showLeading,
      showTrailing: _showTrailing,
      selection: _selection,
      nestedSelection: _nestedSelection,
      reorder: _reorder,
      singleSelect: _singleSelect,
      doubleTapTrigger: _doubleTapTrigger,
      useSublist: _useSublist,
      expandedStateFill: _expandedStateFill,
      roundSublistBottom: _roundSublistBottom,
      showSelectedIcon: _showSelectedIcon,
      baseline: _baseline,
      listStyle: _style,
      containerTransform: _containerTransform,
      disabled: _disabled,
      selected: _selected,
      headline: _headline,
      supporting: _supporting,
      swipeMode: _swipeMode,
      dismissEdge: _dismissEdge,
    );
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlayEnumChoice<_ListKind>(
            label: 'Variant',
            value: _kind,
            values: _ListKind.values,
            labelOf: (_ListKind v) => v.name,
            onChanged: (_ListKind v) => setState(() => _kind = v),
          ),
          if (_kind == _ListKind.cardList)
            PlayEnumChoice<M3ECardVariant>(
              label: 'Card variant',
              value: _variant,
              values: M3ECardVariant.values,
              labelOf: (M3ECardVariant v) => v.name,
              onChanged: (M3ECardVariant v) {
                setState(() => _variant = v);
              },
            ),
          PlayTextField(
            label: 'Headline',
            value: _headline,
            onChanged: (String v) => setState(() => _headline = v),
          ),
          PlayTextField(
            label: 'Supporting',
            value: _supporting,
            onChanged: (String v) => setState(() => _supporting = v),
          ),
          PlaySwitchItem(
            label: 'Leading',
            value: _showLeading,
            onChanged: (bool v) => setState(() => _showLeading = v),
          ),
          PlaySwitchItem(
            label: 'Trailing',
            value: _showTrailing,
            onChanged: (bool v) => setState(() => _showTrailing = v),
          ),
          PlaySwitchItem(
            label: 'Baseline',
            value: _baseline,
            onChanged: (bool v) => setState(() => _baseline = v),
          ),
          PlayEnumChoice<M3EListStyle>(
            label: 'Style',
            value: _style,
            values: M3EListStyle.values,
            labelOf: (M3EListStyle value) => value.name,
            onChanged: (M3EListStyle value) => setState(() => _style = value),
          ),
          PlaySwitchItem(
            label: 'Container transform',
            value: _containerTransform,
            onChanged: (bool v) => setState(() => _containerTransform = v),
          ),
          PlaySwitchItem(
            label: 'Disabled sample',
            value: _disabled,
            onChanged: (bool v) => setState(() => _disabled = v),
          ),
          PlaySwitchItem(
            label: 'Selected sample',
            value: _selected,
            onChanged: (bool v) => setState(() => _selected = v),
          ),
          if (_kind == _ListKind.dismissible) ...<Widget>[
            PlayEnumChoice<M3EListSwipeMode>(
              label: 'Swipe',
              value: _swipeMode,
              values: M3EListSwipeMode.values,
              labelOf: (M3EListSwipeMode value) => value.name,
              onChanged: (M3EListSwipeMode value) =>
                  setState(() => _swipeMode = value),
            ),
            PlayEnumChoice<M3EListSwipeEdge>(
              label: 'Dismiss direction',
              value: _dismissEdge,
              values: M3EListSwipeEdge.values,
              labelOf: (M3EListSwipeEdge value) => value.name,
              onChanged: (M3EListSwipeEdge value) =>
                  setState(() => _dismissEdge = value),
            ),
          ],
          if (_kind == _ListKind.expandable) ...<Widget>[
            PlaySwitchItem(
              label: 'List expansion',
              value: _useSublist,
              onChanged: (bool v) => setState(() => _useSublist = v),
            ),
            PlaySwitchItem(
              label: 'Expanded state fill',
              value: _expandedStateFill,
              onChanged: (bool v) => setState(() => _expandedStateFill = v),
            ),
            if (_useSublist)
              PlaySwitchItem(
                label: 'Round sublist bottom',
                value: _roundSublistBottom,
                onChanged: (bool v) => setState(() => _roundSublistBottom = v),
              ),
          ],
        ],
      ),
      if (_kind == _ListKind.expandable)
        PlayControlGroup(
          title: 'Header selection & reorder',
          children: <Widget>[
            PlaySwitchItem(
              label: 'Selection',
              value: _selection,
              onChanged: (bool v) => setState(() => _selection = v),
            ),
            PlaySwitchItem(
              label: 'Reorder',
              value: _reorder,
              onChanged: (bool v) => setState(() => _reorder = v),
            ),
            if (_selection) ...<Widget>[
              PlaySwitchItem(
                label: 'Single select',
                value: _singleSelect,
                onChanged: (bool v) => setState(() => _singleSelect = v),
              ),
              PlaySwitchItem(
                label: 'Selected icon (leading flip)',
                value: _showSelectedIcon,
                onChanged: _setShowSelectedIcon,
              ),
              PlaySwitchItem(
                label: 'Double-tap trigger',
                value: _doubleTapTrigger,
                onChanged: _setDoubleTapTrigger,
              ),
            ],
          ],
        ),
      if (_kind == _ListKind.cardList ||
          _kind == _ListKind.dismissible ||
          (_kind == _ListKind.expandable && _useSublist))
        PlayControlGroup(
          title: _kind == _ListKind.expandable
              ? 'Sublist selection'
              : 'Selection & reorder',
          children: <Widget>[
            PlaySwitchItem(
              label: 'Selection',
              value: _kind == _ListKind.expandable
                  ? _nestedSelection
                  : _selection,
              onChanged: (bool v) => setState(() {
                if (_kind == _ListKind.expandable) {
                  _nestedSelection = v;
                } else {
                  _selection = v;
                }
              }),
            ),
            if (_kind == _ListKind.cardList || _kind == _ListKind.dismissible)
              PlaySwitchItem(
                label: 'Reorder',
                value: _reorder,
                onChanged: (bool v) => setState(() => _reorder = v),
              ),
            if ((_kind == _ListKind.expandable
                    ? _nestedSelection
                    : _selection) &&
                _kind != _ListKind.expandable) ...<Widget>[
              PlaySwitchItem(
                label: 'Single select',
                value: _singleSelect,
                onChanged: (bool v) => setState(() => _singleSelect = v),
              ),
              PlaySwitchItem(
                label: 'Selected icon (leading flip)',
                value: _showSelectedIcon,
                onChanged: _setShowSelectedIcon,
              ),
              PlaySwitchItem(
                label: 'Double-tap trigger',
                value: _doubleTapTrigger,
                onChanged: _setDoubleTapTrigger,
              ),
            ],
          ],
        ),
    ];
  }
}

class _ListDemoHost extends StatefulWidget {
  const _ListDemoHost({
    required this.padding,
    required this.kind,
    required this.variant,
    required this.showLeading,
    required this.showTrailing,
    required this.selection,
    required this.nestedSelection,
    required this.reorder,
    required this.singleSelect,
    required this.doubleTapTrigger,
    required this.useSublist,
    required this.expandedStateFill,
    required this.roundSublistBottom,
    required this.showSelectedIcon,
    required this.baseline,
    required this.listStyle,
    required this.containerTransform,
    required this.disabled,
    required this.selected,
    required this.headline,
    required this.supporting,
    required this.swipeMode,
    required this.dismissEdge,
  });

  final EdgeInsets padding;
  final _ListKind kind;
  final M3ECardVariant variant;
  final bool showLeading;
  final bool showTrailing;
  final bool selection;
  final bool nestedSelection;
  final bool reorder;
  final bool singleSelect;
  final bool doubleTapTrigger;
  final bool useSublist;
  final bool expandedStateFill;
  final bool roundSublistBottom;
  final bool showSelectedIcon;
  final bool baseline;
  final M3EListStyle listStyle;
  final bool containerTransform;
  final bool disabled;
  final bool selected;
  final String headline;
  final String supporting;
  final M3EListSwipeMode swipeMode;
  final M3EListSwipeEdge dismissEdge;

  @override
  State<_ListDemoHost> createState() => _ListDemoHostState();
}

class _ListDemoHostState extends State<_ListDemoHost> {
  final M3EExpandableListController _transformController =
      M3EExpandableListController();

  final List<String> _order = <String>['0', '1', '2', '3', '4'];
  Set<int> _expanded = <int>{0};

  M3EListSelectionState get _selectionState => M3EListSelectionState(
    mode: widget.singleSelect
        ? M3EListSelectionMode.single
        : M3EListSelectionMode.multiple,
    selectedIcon: widget.showSelectedIcon
        ? const Icon(M3EIcons.check_circle)
        : null,
    trigger: widget.doubleTapTrigger
        ? M3EListSelectionTrigger.doubleTap
        : M3EListSelectionTrigger.icon,
  );

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final String item = _order.removeAt(oldIndex);
      _order.insert(newIndex, item);
      _expanded = _expanded
          .map((int i) => _remapIndexAfterMove(i, oldIndex, newIndex))
          .toSet();
    });
  }

  static int _remapIndexAfterMove(int index, int from, int to) {
    if (index == from) {
      return to;
    }
    if (from < to) {
      if (index > from && index <= to) {
        return index - 1;
      }
    } else if (from > to) {
      if (index >= to && index < from) {
        return index + 1;
      }
    }
    return index;
  }

  void _onExpansionChanged(int index, {required bool isExpanded}) {
    setState(() {
      if (isExpanded) {
        _expanded = <int>{index};
      } else {
        _expanded = Set<int>.from(_expanded)..remove(index);
      }
    });
  }

  Widget _list() {
    final Widget list = switch (widget.kind) {
      _ListKind.item => Column(
        spacing: M3EListCardListTheme.defaultGap,
        children: <Widget>[
          for (int i = 0; i < 5; i++)
            _ItemPreview(
              headline: '${widget.headline} ${i + 1}',
              supporting: widget.supporting,
              showLeading: widget.showLeading,
              showTrailing: widget.showTrailing,
              selected: widget.selected && i == 0,
              enabled: !(widget.disabled && i == 1),
              appearance: widget.baseline
                  ? M3EListAppearance.baseline
                  : M3EListAppearance.expressive,
              transform: widget.containerTransform
                  ? _ListTransformPage(title: '${widget.headline} ${i + 1}')
                  : null,
            ),
          const M3EListItem(
            headline: 'Avatar',
            supportingText: '40dp circle',
            leading: M3EListAvatar(label: 'A'),
          ),
          const M3EListItem(
            headline: 'Image',
            supportingText: '56dp',
            leading: M3EListImage(child: ColoredBox(color: Color(0xFF6750A4))),
          ),
          const M3EListItem(
            headline: 'Video',
            supportingText: '100 by 56',
            leading: M3EListVideo(child: ColoredBox(color: Color(0xFF6750A4))),
          ),
          const M3EListItem(
            headline: 'Large video',
            supportingText: '114 by 64',
            largeLeading: true,
            leading: M3EListVideo(
              large: true,
              child: ColoredBox(color: Color(0xFF6750A4)),
            ),
          ),
        ],
      ),
      _ListKind.cardList => _CardListPreview(
        headline: widget.headline,
        supporting: widget.supporting,
        variant: widget.variant,
        showLeading: widget.showLeading,
        showTrailing: widget.showTrailing,
        selection: widget.selection,
        reorder: widget.reorder,
        selectionState: _selectionState,
        order: _order,
        onReorder: _onReorder,
        disabled: widget.disabled,
        selected: widget.selected,
        containerTransform: widget.containerTransform,
      ),
      _ListKind.dismissible => _DismissiblePreview(
        headline: widget.headline,
        showLeading: widget.showLeading,
        selection: widget.selection,
        reorder: widget.reorder,
        selectionState: _selectionState,
        order: _order,
        onReorder: _onReorder,
        swipeMode: widget.swipeMode,
        dismissEdge: widget.dismissEdge,
        containerTransform: widget.containerTransform,
      ),
      _ListKind.expandable => _ExpandablePreview(
        headline: widget.headline,
        supporting: widget.supporting,
        showLeading: widget.showLeading,
        useSublist: widget.useSublist,
        expandedStateFill: widget.expandedStateFill,
        roundSublistBottom: widget.roundSublistBottom,
        containerTransform: widget.containerTransform,
        transformController: _transformController,
        selection: widget.selection,
        nestedSelection: widget.nestedSelection,
        reorder: widget.reorder,
        selectionState: _selectionState,
        order: _order,
        onReorder: _onReorder,
        nestedOrder: _order,
        initiallyExpanded: _expanded,
        onExpansionChanged: _onExpansionChanged,
      ),
    };
    return Builder(
      builder: (BuildContext context) {
        final M3EThemeData theme = M3ETheme.of(context);
        return M3ETheme(
          data: theme.copyWith(
            listTheme: theme.listTheme.copyWith(
              item: theme.listTheme.item.copyWith(
                appearance: widget.baseline
                    ? M3EListAppearance.baseline
                    : M3EListAppearance.expressive,
                style: widget.listStyle,
              ),
            ),
          ),
          child: list,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      primary: true,
      padding: widget.padding,
      child: _list(),
    );
  }
}

class _ItemPreview extends StatelessWidget {
  const _ItemPreview({
    required this.headline,
    required this.supporting,
    required this.showLeading,
    required this.showTrailing,
    required this.selected,
    required this.enabled,
    required this.appearance,
    this.transform,
  });

  final String headline;
  final String supporting;
  final bool showLeading;
  final bool showTrailing;
  final bool selected;
  final bool enabled;
  final M3EListAppearance appearance;
  final Widget? transform;

  @override
  Widget build(BuildContext context) {
    return M3EListItem(
      headline: headline,
      supportingText: supporting,
      trailingText: '32',
      leading: showLeading ? const Icon(M3EIcons.schedule) : null,
      trailing: showTrailing ? const Icon(M3EIcons.chevron_right) : null,
      selected: selected,
      enabled: enabled,
      appearance: appearance,
      onTap: enabled ? () {} : null,
      transform: enabled ? transform : null,
    );
  }
}

class _CardListPreview extends StatelessWidget {
  const _CardListPreview({
    required this.headline,
    required this.supporting,
    required this.variant,
    required this.showLeading,
    required this.showTrailing,
    required this.selection,
    required this.reorder,
    required this.selectionState,
    required this.order,
    required this.onReorder,
    required this.disabled,
    required this.selected,
    required this.containerTransform,
  });

  final String headline;
  final String supporting;
  final M3ECardVariant variant;
  final bool showLeading;
  final bool showTrailing;
  final bool selection;
  final bool reorder;
  final M3EListSelectionState selectionState;
  final List<String> order;
  final ReorderCallback onReorder;
  final bool disabled;
  final bool selected;
  final bool containerTransform;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return M3EList(
      variant: variant,
      semanticsLabel: 'Sample list',
      selection: selection,
      reorder: reorder,
      selectionState: selectionState,
      onReorder: reorder ? onReorder : null,
      itemCount: order.length,
      colorBuilder: (int index) {
        if (selected && index == 0) {
          return theme.colorScheme.secondaryContainer;
        }
        return null;
      },
      itemBuilder: (BuildContext context, int index) {
        final String id = order[index];
        return M3EListItem(
          headline: '$headline $id',
          supportingText: supporting,
          trailingText: '32',
          leading: showLeading ? const Icon(M3EIcons.inbox) : null,
          trailing: showTrailing ? const Icon(M3EIcons.chevron_right) : null,
          selected: selected && index == 0,
          enabled: !(disabled && index == 1),
          onTap: () {},
          transform: containerTransform && !(disabled && index == 1)
              ? _ListTransformPage(title: '$headline $id')
              : null,
        );
      },
    );
  }
}

class _DismissiblePreview extends StatefulWidget {
  const _DismissiblePreview({
    required this.headline,
    required this.showLeading,
    required this.selection,
    required this.reorder,
    required this.selectionState,
    required this.order,
    required this.onReorder,
    required this.swipeMode,
    required this.dismissEdge,
    required this.containerTransform,
  });

  final String headline;
  final bool showLeading;
  final bool selection;
  final bool reorder;
  final M3EListSelectionState selectionState;
  final List<String> order;
  final ReorderCallback onReorder;
  final M3EListSwipeMode swipeMode;
  final M3EListSwipeEdge dismissEdge;
  final bool containerTransform;

  @override
  State<_DismissiblePreview> createState() => _DismissiblePreviewState();
}

class _DismissiblePreviewState extends State<_DismissiblePreview> {
  final M3EDismissibleListController _controller =
      M3EDismissibleListController();

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            M3EButton(
              style: M3EButtonStyle.tonal,
              onPressed: () => _controller.reveal(0),
              child: const Text('Reveal'),
            ),
            const SizedBox(width: 8),
            M3EButton(
              style: M3EButtonStyle.tonal,
              onPressed: () => _controller.dismiss(0),
              child: const Text('Dismiss'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _column(theme),
      ],
    );
  }

  Widget _column(M3EThemeData theme) {
    return M3EList(
      dismissController: _controller,
      selection: widget.selection,
      reorder: widget.reorder,
      selectionState: widget.selectionState,
      onReorder: widget.reorder ? widget.onReorder : null,
      itemCount: widget.order.length,
      dismissStyle: M3EDismissibleListStyle(
        background: ColoredBox(
          color: theme.colorScheme.success,
          child: const Center(
            child: Icon(M3EIcons.check, color: Color(0xFFFFFFFF)),
          ),
        ),
      ),
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: '${widget.headline} ${widget.order[index]}',
          supportingText: 'Swipe for actions or dismiss',
          leading: widget.showLeading ? const Icon(M3EIcons.schedule) : null,
          transform: widget.containerTransform
              ? _ListTransformPage(
                  title: '${widget.headline} ${widget.order[index]}',
                )
              : null,
          swipe: M3EListItemSwipe(
            mode: widget.swipeMode,
            edge: widget.dismissEdge,
            onDismiss: (DismissDirection direction) async => true,
            leading: <M3EListSwipeAction>[
              M3EListSwipeAction(
                icon: const Icon(M3EIcons.push_pin),
                onPressed: () {},
              ),
            ],
            trailing: <M3EListSwipeAction>[
              M3EListSwipeAction(
                icon: const Icon(M3EIcons.archive),
                onPressed: () {},
              ),
              M3EListSwipeAction(
                icon: const Icon(M3EIcons.delete),
                isPrimary: true,
                backgroundColor: theme.colorScheme.danger,
                foregroundColor: theme.colorScheme.onError,
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExpandablePreview extends StatelessWidget {
  const _ExpandablePreview({
    required this.headline,
    required this.supporting,
    required this.showLeading,
    required this.useSublist,
    required this.expandedStateFill,
    required this.roundSublistBottom,
    required this.containerTransform,
    required this.transformController,
    required this.selection,
    required this.nestedSelection,
    required this.reorder,
    required this.selectionState,
    required this.order,
    required this.onReorder,
    required this.nestedOrder,
    required this.initiallyExpanded,
    required this.onExpansionChanged,
  });

  final String headline;
  final String supporting;
  final bool showLeading;
  final bool useSublist;
  final bool expandedStateFill;
  final bool roundSublistBottom;
  final bool containerTransform;
  final M3EExpandableListController transformController;
  final bool selection;
  final bool nestedSelection;
  final bool reorder;
  final M3EListSelectionState selectionState;
  final List<String> order;
  final ReorderCallback onReorder;
  final List<String> nestedOrder;
  final Set<int> initiallyExpanded;
  final void Function(int index, {required bool isExpanded}) onExpansionChanged;

  M3EExpandableData _section(BuildContext context, String id) {
    final M3EThemeData theme = M3ETheme.of(context);
    final bool isPrimary = id == '0';
    return M3EExpandableData(
      title: isPrimary ? headline : 'System update $id',
      subtitle: isPrimary ? supporting : 'Version 2.4.0 is ready',
      leading: showLeading
          ? Icon(isPrimary ? M3EIcons.battery_alert : M3EIcons.system_update)
          : null,
      expanded: containerTransform && isPrimary
          ? M3EExpandableExpanded.transform(
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text('Full screen destination'),
              ),
            )
          : useSublist && isPrimary
          ? M3EExpandableExpanded.list(
              M3EList(
                embedded: true,
                selection: nestedSelection,
                selectionState: selectionState,
                itemCount: nestedOrder.length,
                onTap: nestedSelection ? null : (int index) {},
                itemBuilder: (BuildContext context, int index) {
                  final String nestedId = nestedOrder[index];
                  return M3EListItem(
                    headline: 'Nested $nestedId',
                    supportingText: 'Sublist row',
                    leading: const Icon(M3EIcons.folder),
                  );
                },
              ),
            )
          : M3EExpandableExpanded.content(
              isPrimary
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Expanded body content for the list item.',
                          style: theme.typeScale.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        M3EButton(
                          style: M3EButtonStyle.tonal,
                          onPressed: () {},
                          child: const Text('Action'),
                        ),
                      ],
                    )
                  : Text(
                      'Security fixes and performance improvements.',
                      style: theme.typeScale.bodyMedium,
                    ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<M3EExpandableData> sections = <M3EExpandableData>[
      for (final String id in order) _section(context, id),
    ];
    final Widget list = M3EList(
      expandStyle: expandedStateFill && roundSublistBottom
          ? null
          : M3EExpandableStyle.fromTheme(
              M3ETheme.of(context).listTheme.expandable,
            ).copyWith(
              expandedStateFill: expandedStateFill,
              roundSublistBottom: roundSublistBottom,
            ),
      expandController: transformController,
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
      selection: selection,
      selectionState: selectionState,
      reorder: reorder,
      onReorder: reorder ? onReorder : null,
      itemCount: sections.length,
      itemBuilder: (BuildContext context, int index) {
        final M3EExpandableData item = sections[index];
        return M3EListItem(
          headline: item.title,
          supportingText: item.subtitle,
          leading: item.leading,
          trailing: item.trailing,
          expanded: item.expanded,
        );
      },
    );
    if (!containerTransform) {
      return list;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        M3EButton(
          onPressed: () => transformController.open(0),
          child: const Text('Open transform'),
        ),
        const SizedBox(height: 12),
        list,
      ],
    );
  }
}

class _ListTransformPage extends StatelessWidget {
  const _ListTransformPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: theme.typeScale.headlineSmall),
            const SizedBox(height: 16),
            M3EButton(
              onPressed: () => M3ECardContainerTransformScope.closeOf(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
