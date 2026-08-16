import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ESelection], adapted from [SelectionDemoPage].
class SelectionPlayground extends StatefulWidget {
  /// Creates the selection playground.
  const SelectionPlayground({super.key});

  @override
  State<SelectionPlayground> createState() => _SelectionPlaygroundState();
}

class _SelectionPlaygroundState extends State<SelectionPlayground> {
  bool _dismissible = false;
  bool _showSelectAll = true;
  bool _customHighlight = false;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Selection demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Long-press a row or tap a leading avatar to enter selection '
                'mode. System back clears selection first.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return _SelectionDemoHost(
                          dismissible: _dismissible,
                          showSelectAll: _showSelectAll,
                          customHighlight: _customHighlight,
                        );
                      },
                    ),
                  );
                },
                child: const Text('Open selection demo'),
              ),
            ],
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Demo options',
          children: <Widget>[
            PlaySwitch(
              label: 'Dismissible list',
              value: _dismissible,
              onChanged: (bool v) => setState(() => _dismissible = v),
            ),
            PlaySwitch(
              label: 'Show select all',
              value: _showSelectAll,
              onChanged: (bool v) => setState(() => _showSelectAll = v),
            ),
            PlaySwitch(
              label: 'Custom highlight',
              value: _customHighlight,
              onChanged: (bool v) => setState(() => _customHighlight = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _SelectionDemoHost extends StatefulWidget {
  const _SelectionDemoHost({
    required this.dismissible,
    required this.showSelectAll,
    required this.customHighlight,
  });

  final bool dismissible;
  final bool showSelectAll;
  final bool customHighlight;

  @override
  State<_SelectionDemoHost> createState() => _SelectionDemoHostState();
}

class _SelectionDemoHostState extends State<_SelectionDemoHost> {
  final M3ESelectionController _selection = M3ESelectionController();
  late final M3ESearchController _search;

  static const List<({String title, String subtitle})> _items =
      <({String title, String subtitle})>[
        (title: 'Design review', subtitle: 'Expressive shapes and motion'),
        (title: 'Release checklist', subtitle: 'Ship blockers and owners'),
        (title: 'Weekly sync notes', subtitle: 'Decisions from Monday'),
        (title: 'Accessibility audit', subtitle: 'Contrast and focus order'),
        (title: 'Theme tokens', subtitle: 'Spacing and type scale'),
        (title: 'Demo gallery', subtitle: 'Containment samples'),
        (title: 'Toolbar polish', subtitle: 'Pill spacing and springs'),
        (title: 'Selection patterns', subtitle: 'Multi-select with app bar'),
      ];

  @override
  void initState() {
    super.initState();
    _search = M3ESearchController();
    _selection.addListener(_onSelection);
  }

  void _onSelection() => setState(() {});

  @override
  void dispose() {
    _selection.removeListener(_onSelection);
    _selection.dispose();
    _search.dispose();
    super.dispose();
  }

  Color _avatarColor(int index, M3EColorScheme scheme) {
    return switch (index % 4) {
      0 => scheme.primary,
      1 => scheme.secondary,
      2 => scheme.tertiary,
      _ => scheme.error,
    };
  }

  Widget _leading(BuildContext context, int index) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EColorScheme scheme = theme.colorScheme;
    final bool selected = _selection.isSelected(index);
    return M3ESelectionLeading(
      selected: selected,
      onTap: () => _selection.toggle(index),
      selectedChild: CircleAvatar(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        child: Icon(M3EIcons.check, size: 20, color: scheme.onPrimary),
      ),
      child: CircleAvatar(
        backgroundColor: _avatarColor(index, scheme),
        foregroundColor: scheme.onPrimary,
        child: Text(
          _items[index].title.substring(0, 1),
          style: theme.typeScale.titleMedium.copyWith(color: scheme.onPrimary),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, int index) {
    final ({String title, String subtitle}) item = _items[index];
    return M3EListItem(
      headline: item.title,
      supportingText: item.subtitle,
      leading: _leading(context, index),
    );
  }

  void _onTap(int index) {
    if (_selection.isSelectionMode) {
      _selection.toggle(index);
    } else {
      M3ESnackbar.show(context, message: 'Open ${_items[index].title}');
    }
  }

  void _onLongPress(int index) {
    M3EHaptics.trigger(M3EHapticFeedback.medium);
    if (!_selection.isSelected(index)) {
      _selection.select(index);
    }
  }

  BorderRadius? _radiusBuilder(int index, M3ECardPosition position) {
    if (!_selection.isSelected(index)) {
      return null;
    }
    return BorderRadius.circular(M3EListCardListTheme.defaultOuterRadius);
  }

  static const EdgeInsets _listPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  Widget _body(M3EThemeData theme) {
    if (widget.dismissible) {
      return M3EDismissibleList(
        itemCount: _items.length,
        listPadding: _listPadding,
        borderRadiusBuilder: _radiusBuilder,
        onTap: _onTap,
        onLongPress: _onLongPress,
        onDismiss: (int index, DismissDirection direction) async {
          M3ESnackbar.show(
            context,
            message: 'Dismissed ${_items[index].title}',
          );
          return true;
        },
        style: M3EDismissibleListStyle(
          background: Container(
            color: theme.colorScheme.success,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Icon(M3EIcons.check, color: theme.colorScheme.onSurface),
          ),
          secondaryBackground: Container(
            color: theme.colorScheme.danger,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Icon(M3EIcons.close, color: theme.colorScheme.onSurface),
          ),
        ),
        itemBuilder: _item,
      );
    }
    return M3ECardList.builder(
      itemCount: _items.length,
      listPadding: _listPadding,
      borderRadiusBuilder: _radiusBuilder,
      onTap: _onTap,
      onLongPress: _onLongPress,
      haptic: M3EHapticFeedback.medium,
      itemBuilder: _item,
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PopScope(
      canPop: !_selection.isSelectionMode,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _selection.clear();
        }
      },
      child: M3ESelection(
        backgroundColor: theme.colorScheme.surface,
        controller: _selection,
        itemCount: _items.length,
        selectedColor: widget.customHighlight ? Colors.green : null,
        appBar: M3ESelectionAppBar(
          showSelectAll: widget.showSelectAll,
          idle: M3EAppBar.search(
            searchController: _search,
            suggestionsBuilder: (BuildContext context, M3ESearchController c) {
              return const <Widget>[];
            },
            barHintText: 'Search items',
            leading: M3EIconButton(
              icon: const Icon(M3EIcons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: 'Back',
            ),
          ),
          actions: <Widget>[
            M3EIconButton(
              icon: const Icon(M3EIcons.archive),
              onPressed: () {},
              tooltip: 'Archive',
            ),
            M3EIconButton(
              icon: const Icon(M3EIcons.delete),
              onPressed: () {},
              tooltip: 'Delete',
            ),
          ],
        ),
        body: Padding(padding: EdgeInsets.only(top: 8), child: _body(theme)),
      ),
    );
  }
}
