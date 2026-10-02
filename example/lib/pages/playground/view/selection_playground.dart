import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Idle (nothing selected) bar shown by the selection app bar.
enum _IdleBar { search, top }

/// Live playground for [M3ESelection] and [M3ESelectionAppBar].
class SelectionPlayground extends PlaygroundWidget {
  /// Creates the selection playground.
  const SelectionPlayground({super.key});

  @override
  PlaygroundState<SelectionPlayground> createState() =>
      _SelectionPlaygroundState();
}

class _SelectionPlaygroundState extends PlaygroundState<SelectionPlayground> {
  final M3ESelectionController _selection = M3ESelectionController();
  final M3ESearchController _search = M3ESearchController();

  _IdleBar _idle = _IdleBar.search;
  bool _showSelectAll = true;
  String _selectAllLabel = 'Select all';
  double _actionCount = 2;
  bool _customHighlight = false;
  bool _dismissible = false;
  bool _selectedIcon = true;
  M3EHapticFeedback _haptic = M3EHapticFeedback.medium;

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

  static const List<(IconData, String)> _actions = <(IconData, String)>[
    (M3EIcons.archive, 'Archive'),
    (M3EIcons.delete, 'Delete'),
    (M3EIcons.share, 'Share'),
  ];

  @override
  void initState() {
    super.initState();
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

  void _onTap(int index) {
    if (_selection.isSelectionMode) {
      _selection.toggle(index);
    } else {
      M3ESnackbar.show(context, message: 'Open ${_items[index].title}');
    }
  }

  void _onLongPress(int index) {
    M3EHaptics.trigger(_haptic);
    if (!_selection.isSelected(index)) {
      _selection.select(index);
    }
  }

  Widget _item(BuildContext context, int index) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EColorScheme scheme = theme.colorScheme;
    return M3EListItem(
      headline: _items[index].title,
      supportingText: _items[index].subtitle,
      leading: CircleAvatar(
        backgroundColor: _avatarColor(index, scheme),
        child: Text(
          _items[index].title.substring(0, 1),
          style: theme.typeScale.titleMedium.copyWith(color: scheme.onPrimary),
        ),
      ),
      swipe: _dismissible
          ? M3EListItemSwipe(
              onDismiss: (DismissDirection direction) async {
                M3ESnackbar.show(
                  context,
                  message: 'Dismissed ${_items[index].title}',
                );
                return false;
              },
            )
          : null,
    );
  }

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    final M3EThemeData theme = M3ETheme.of(context);
    Widget list = M3EList.scrollable(
      controller: PrimaryScrollController.of(context),
      color: theme.colorScheme.surfaceContainerHighest,
      selection: true,
      selectionState: _selectedIcon
          ? const M3EListSelectionState(
              selectedIcon: Icon(M3EIcons.check_circle),
            )
          : null,
      itemCount: _items.length,
      listPadding: padding,
      onTap: _onTap,
      onLongPress: _onLongPress,
      itemBuilder: _item,
    );
    if (_customHighlight) {
      list = M3ETheme(
        data: theme.copyWith(
          selectionTheme: theme.selectionTheme.copyWith(
            highlightColor: theme.colorScheme.tertiaryContainer,
          ),
        ),
        child: list,
      );
    }
    return PopScope(
      canPop: !_selection.isSelectionMode,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _selection.clear();
        }
      },
      child: M3ESelectionScope(
        controller: _selection,
        itemCount: _items.length,
        child: list,
      ),
    );
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    final PreferredSizeWidget idle = switch (_idle) {
      _IdleBar.search => M3EAppBar.search(
        searchController: _search,
        suggestionsBuilder: (BuildContext context, M3ESearchController c) {
          return const <Widget>[];
        },
        barHintText: 'Search items',
        leading: chrome.leading,
        actions: chrome.trailingActions,
      ),
      _IdleBar.top => M3EAppBar.top(
        titleText: 'Inbox',
        leading: chrome.leading,
        actions: chrome.trailingActions,
      ),
    };
    return PlaygroundSlots(
      header: M3ESelectionAppBar(
        controller: _selection,
        itemCount: _items.length,
        showSelectAll: _showSelectAll,
        selectAllLabel: _selectAllLabel,
        idle: idle,
        actions: <Widget>[
          for (final (IconData icon, String label) in _actions.take(
            _actionCount.round(),
          ))
            M3EIconButton(
              variant: M3EIconButtonVariant.standard,
              icon: Icon(icon),
              tooltip: label,
              onPressed: () => M3ESnackbar.show(
                context,
                message: '$label ${_selection.selectedCount} items',
              ),
            ),
        ],
      ),
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer actions = StringBuffer();
    for (final (IconData _, String label) in _actions.take(
      _actionCount.round(),
    )) {
      actions.writeln(
        '      M3EIconButton(\n'
        '        icon: const Icon(M3EIcons.${label.toLowerCase()}),\n'
        "        tooltip: '$label',\n"
        '        onPressed: () {},\n'
        '      ),',
      );
    }
    final String idle = _idle == _IdleBar.search
        ? 'M3EAppBar.search(\n'
              '      searchController: search,\n'
              '      suggestionsBuilder: (context, controller) => [],\n'
              "      barHintText: 'Search items',\n"
              '    )'
        : "M3EAppBar.top(titleText: 'Inbox')";
    final String highlight = _customHighlight
        ? '  selectedColor: scheme.tertiaryContainer,\n'
        : '';
    final String selectAll = _showSelectAll
        ? "    selectAllLabel: ${playDartString(_selectAllLabel)},\n"
        : '';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Selection',
        code:
            '''
$kPlaySnippetImport

PopScope(
  canPop: !selection.isSelectionMode,
  onPopInvokedWithResult: (didPop, _) {
    if (!didPop) selection.clear();
  },
  child: M3ESelection(
  controller: selection,
  itemCount: items.length,
$highlight  appBar: M3ESelectionAppBar(
    showSelectAll: $_showSelectAll,
$selectAll    idle: $idle,
    actions: <Widget>[
$actions    ],
  ),
  body: M3EList.scrollable(
    selection: true,
    itemCount: items.length,
    onTap: (index) => selection.toggle(index),
    onLongPress: (index) => selection.select(index),
    itemBuilder: itemBuilder,
  ),
  ),
);''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'App bar',
        children: <Widget>[
          PlayEnumChoice<_IdleBar>(
            label: 'Idle bar',
            value: _idle,
            values: _IdleBar.values,
            labelOf: (_IdleBar v) => switch (v) {
              _IdleBar.search => 'search app bar',
              _IdleBar.top => 'top app bar',
            },
            onChanged: (_IdleBar v) => setState(() => _idle = v),
          ),
          PlaySlider(
            label: 'Contextual actions',
            value: _actionCount,
            max: _actions.length.toDouble(),
            divisions: _actions.length,
            onChanged: (double v) => setState(() => _actionCount = v),
          ),
          PlaySwitchItem(
            label: 'Select all',
            description: 'Row with a select-all checkbox while selecting',
            value: _showSelectAll,
            onChanged: (bool v) => setState(() => _showSelectAll = v),
          ),
          if (_showSelectAll)
            PlayTextField(
              label: 'Select all label',
              value: _selectAllLabel,
              onChanged: (String v) => setState(() => _selectAllLabel = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'List',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Custom highlight',
            description: 'Tertiary container for selected rows',
            value: _customHighlight,
            onChanged: (bool v) => setState(() => _customHighlight = v),
          ),
          PlaySwitchItem(
            label: 'Selected icon',
            description: 'Check icon replaces the avatar',
            value: _selectedIcon,
            onChanged: (bool v) => setState(() => _selectedIcon = v),
          ),
          PlaySwitchItem(
            label: 'Swipe to dismiss',
            value: _dismissible,
            onChanged: (bool v) => setState(() => _dismissible = v),
          ),
          PlayEnumChoice<M3EHapticFeedback>(
            label: 'Long-press haptic',
            value: _haptic,
            values: M3EHapticFeedback.values,
            labelOf: (M3EHapticFeedback v) => v.name,
            onChanged: (M3EHapticFeedback v) => setState(() => _haptic = v),
          ),
        ],
      ),
    ];
  }
}
