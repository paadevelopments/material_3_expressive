import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

enum _ListKind { item, cardList, dismissible, expandable }

/// Live playground for list components.
class ListsPlayground extends StatefulWidget {
  /// Creates the lists playground.
  const ListsPlayground({super.key});

  @override
  State<ListsPlayground> createState() => _ListsPlaygroundState();
}

class _ListsPlaygroundState extends State<ListsPlayground> {
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
  bool _showSelectedIcon = true;
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

  List<PlaySnippet> get _snippets {
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
  onTap: () {},
);''',
      _ListKind.cardList =>
        '''
M3ECardList(
  variant: M3ECardVariant.${_variant.name},$features
  itemCount: 3,
  itemBuilder: (BuildContext context, int index) {
    return M3EListItem(
      headline: $headline,
      supportingText: $supporting,${_showLeading ? '\n      leading: const Icon(M3EIcons.inbox),' : ''}${_showTrailing ? '\n      trailing: const Icon(M3EIcons.chevron_right),' : ''}
    );
  },
);''',
      _ListKind.dismissible =>
        '''
M3EDismissibleColumn(
  itemCount: 3,$selectionFeature${_reorder ? '\n  reorder: true,\n  onReorder: (int a, int b) {},' : ''}
  onDismiss: (int index, DismissDirection direction) async => true,
  itemBuilder: (BuildContext context, int index) {
    return M3EListItem(
      headline: $headline,${_showLeading ? '\n      leading: const Icon(M3EIcons.schedule),' : ''}
    );
  },
);''',
      _ListKind.expandable =>
        '''
M3EExpandableList(${_selection ? '\n  selection: true,' : ''}${_reorder ? '\n  reorder: true,\n  onReorder: (int a, int b) {},' : ''}
  data: <M3EExpandableData>[
    M3EExpandableData(
      title: $headline,
      subtitle: $supporting,${_showLeading ? '\n      leading: const Icon(M3EIcons.battery_alert),' : ''}
      expanded: ${_useSublist ? '''M3EExpandableExpanded.list(
        M3ECardList(
          embedded: true,
          itemCount: 2,${_nestedSelection ? '\n          selection: true,' : ''}
          itemBuilder: (BuildContext context, int index) {
            return M3EListItem(headline: 'Child \${index + 1}');
          },
        ),
      ),''' : '''M3EExpandableExpanded.content(
        const Text('Expanded body'),
      ),'''}
    ),
  ],
);''',
    };
    return <PlaySnippet>[
      PlaySnippet(label: 'List', code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  void _openDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _ListDemoHost(
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
            showSelectedIcon: _showSelectedIcon,
            headline: _headline,
            supporting: _supporting,
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
          label: 'List demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a full page for the selected list. Swipe, expand, '
                'select, and reorder there.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open list demo'),
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
            PlayEnumMenu<_ListKind>(
              label: 'Kind',
              value: _kind,
              values: _ListKind.values,
              labelOf: (_ListKind v) => v.name,
              onChanged: (_ListKind v) => setState(() => _kind = v),
            ),
            if (_kind == _ListKind.cardList)
              PlayEnumMenu<M3ECardVariant>(
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
            PlaySwitch(
              label: 'Leading',
              value: _showLeading,
              onChanged: (bool v) => setState(() => _showLeading = v),
            ),
            PlaySwitch(
              label: 'Trailing',
              value: _showTrailing,
              onChanged: (bool v) => setState(() => _showTrailing = v),
            ),
            if (_kind == _ListKind.expandable)
              PlaySwitch(
                label: 'List expansion',
                value: _useSublist,
                onChanged: (bool v) => setState(() => _useSublist = v),
              ),
          ],
        ),
        if (_kind == _ListKind.expandable)
          PlayControlPanel(
            title: 'Header selection & reorder',
            children: <Widget>[
              PlaySwitch(
                label: 'Selection',
                value: _selection,
                onChanged: (bool v) => setState(() => _selection = v),
              ),
              PlaySwitch(
                label: 'Reorder',
                value: _reorder,
                onChanged: (bool v) => setState(() => _reorder = v),
              ),
              if (_selection) ...<Widget>[
                PlaySwitch(
                  label: 'Single select',
                  value: _singleSelect,
                  onChanged: (bool v) => setState(() => _singleSelect = v),
                ),
                PlaySwitch(
                  label: 'Selected icon (leading flip)',
                  value: _showSelectedIcon,
                  onChanged: _setShowSelectedIcon,
                ),
                PlaySwitch(
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
          PlayControlPanel(
            title: _kind == _ListKind.expandable
                ? 'Sublist selection'
                : 'Selection & reorder',
            children: <Widget>[
              PlaySwitch(
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
                PlaySwitch(
                  label: 'Reorder',
                  value: _reorder,
                  onChanged: (bool v) => setState(() => _reorder = v),
                ),
              if ((_kind == _ListKind.expandable
                      ? _nestedSelection
                      : _selection) &&
                  _kind != _ListKind.expandable) ...<Widget>[
                PlaySwitch(
                  label: 'Single select',
                  value: _singleSelect,
                  onChanged: (bool v) => setState(() => _singleSelect = v),
                ),
                PlaySwitch(
                  label: 'Selected icon (leading flip)',
                  value: _showSelectedIcon,
                  onChanged: _setShowSelectedIcon,
                ),
                PlaySwitch(
                  label: 'Double-tap trigger',
                  value: _doubleTapTrigger,
                  onChanged: _setDoubleTapTrigger,
                ),
              ],
            ],
          ),
      ],
    );
  }
}

class _ListDemoHost extends StatefulWidget {
  const _ListDemoHost({
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
    required this.showSelectedIcon,
    required this.headline,
    required this.supporting,
  });

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
  final bool showSelectedIcon;
  final String headline;
  final String supporting;

  @override
  State<_ListDemoHost> createState() => _ListDemoHostState();
}

class _ListDemoHostState extends State<_ListDemoHost> {
  static const EdgeInsets _listPadding = EdgeInsets.all(16);

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
    return switch (widget.kind) {
      _ListKind.item => Column(
        spacing: M3EListCardListTheme.defaultGap,
        children: <Widget>[
          for (int i = 0; i < 5; i++)
            _ItemPreview(
              headline: '${widget.headline} ${i + 1}',
              supporting: widget.supporting,
              showLeading: widget.showLeading,
              showTrailing: widget.showTrailing,
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
      ),
      _ListKind.dismissible => _DismissiblePreview(
        headline: widget.headline,
        showLeading: widget.showLeading,
        selection: widget.selection,
        reorder: widget.reorder,
        selectionState: _selectionState,
        order: _order,
        onReorder: _onReorder,
      ),
      _ListKind.expandable => _ExpandablePreview(
        headline: widget.headline,
        supporting: widget.supporting,
        showLeading: widget.showLeading,
        useSublist: widget.useSublist,
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
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final Widget list = _list();
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: M3EAppBar.top(
        titleText: widget.kind.name,
        leading: M3EIconButton(
          variant: M3EIconButtonVariant.standard,
          icon: const Icon(M3EIcons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SingleChildScrollView(padding: _listPadding, child: list),
    );
  }
}

class _ItemPreview extends StatelessWidget {
  const _ItemPreview({
    required this.headline,
    required this.supporting,
    required this.showLeading,
    required this.showTrailing,
  });

  final String headline;
  final String supporting;
  final bool showLeading;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return M3EListItem(
      headline: headline,
      supportingText: supporting,
      leading: showLeading ? const Icon(M3EIcons.schedule) : null,
      trailing: showTrailing ? const Icon(M3EIcons.chevron_right) : null,
      onTap: () {},
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

  @override
  Widget build(BuildContext context) {
    return M3ECardList(
      variant: variant,
      selection: selection,
      reorder: reorder,
      selectionState: selectionState,
      onReorder: reorder ? onReorder : null,
      itemCount: order.length,
      itemBuilder: (BuildContext context, int index) {
        final String id = order[index];
        return M3EListItem(
          headline: '$headline $id',
          supportingText: supporting,
          leading: showLeading ? const Icon(M3EIcons.inbox) : null,
          trailing: showTrailing ? const Icon(M3EIcons.chevron_right) : null,
        );
      },
    );
  }
}

class _DismissiblePreview extends StatelessWidget {
  const _DismissiblePreview({
    required this.headline,
    required this.showLeading,
    required this.selection,
    required this.reorder,
    required this.selectionState,
    required this.order,
    required this.onReorder,
  });

  final String headline;
  final bool showLeading;
  final bool selection;
  final bool reorder;
  final M3EListSelectionState selectionState;
  final List<String> order;
  final ReorderCallback onReorder;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return M3EDismissibleColumn(
      selection: selection,
      reorder: reorder,
      selectionState: selectionState,
      onReorder: reorder ? onReorder : null,
      itemCount: order.length,
      onDismiss: (int index, DismissDirection direction) async => true,
      // Leading: classic full-dismiss strip (no actions).
      // Trailing: multi-action preview snap.
      trailingActionsBuilder: (int index) => <M3EListSwipeAction>[
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
      style: M3EDismissibleListStyle(
        background: ColoredBox(
          color: theme.colorScheme.success,
          child: const Center(
            child: Icon(M3EIcons.check, color: Color(0xFFFFFFFF)),
          ),
        ),
      ),
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: '$headline ${order[index]}',
          supportingText: 'Swipe for actions or dismiss',
          leading: showLeading ? const Icon(M3EIcons.schedule) : null,
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
      expanded: useSublist && isPrimary
          ? M3EExpandableExpanded.list(
              M3ECardList(
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
    return M3EExpandableList(
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: onExpansionChanged,
      selection: selection,
      selectionState: selectionState,
      reorder: reorder,
      onReorder: reorder ? onReorder : null,
      data: <M3EExpandableData>[
        for (final String id in order) _section(context, id),
      ],
    );
  }
}
