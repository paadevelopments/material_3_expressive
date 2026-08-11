import 'package:flutter/material.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Full-screen multi-select demo (opened from Containment).
class SelectionDemoPage extends StatefulWidget {
  /// Creates the selection demo page.
  const SelectionDemoPage({super.key});

  @override
  State<SelectionDemoPage> createState() => _SelectionDemoPageState();
}

class _SelectionDemoPageState extends State<SelectionDemoPage> {
  final M3ESelectionController _selection = M3ESelectionController();
  late final M3ESearchController _search;
  bool _dismissible = false;

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

  void _onSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _selection.removeListener(_onSelection);
    _selection.dispose();
    _search.dispose();
    super.dispose();
  }

  Color _avatarColor(int index, M3EColorScheme scheme) {
    switch (index % 4) {
      case 0:
        return scheme.primary;
      case 1:
        return scheme.secondary;
      case 2:
        return scheme.tertiary;
      default:
        return scheme.error;
    }
  }

  Iterable<Widget> _suggestions(
    BuildContext context,
    M3ESearchController controller,
  ) {
    return const <Widget>[];
  }

  Widget _leading(BuildContext context, int index) {
    final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
    final bool selected = _selection.isSelected(index);
    return M3ESelectionLeading(
      selected: selected,
      onTap: () => _selection.toggle(index),
      selectedChild: CircleAvatar(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        child: const Icon(M3EIcons.check, size: 20),
      ),
      child: CircleAvatar(
        backgroundColor: _avatarColor(index, scheme),
        foregroundColor: scheme.onPrimary,
        child: Text(_items[index].title.substring(0, 1)),
      ),
    );
  }

  Widget _item(BuildContext context, int index) {
    final item = _items[index];
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Open ${_items[index].title}')));
    }
  }

  void _onLongPress(int index) {
    M3EHaptics.trigger(M3EHapticFeedback.medium);
    if (!_selection.isSelected(index)) {
      _selection.select(index);
    }
  }

  Color? _colorBuilder(int index) {
    if (!_selection.isSelected(index)) {
      return null;
    }
    return M3ETheme.of(context).colorScheme.secondaryContainer;
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

  Widget _cardListBody() {
    return M3ECardList.builder(
      itemCount: _items.length,
      listPadding: _listPadding,
      colorBuilder: _colorBuilder,
      borderRadiusBuilder: _radiusBuilder,
      onTap: _onTap,
      onLongPress: _onLongPress,
      haptic: M3EHapticFeedback.medium,
      itemBuilder: _item,
    );
  }

  Widget _dismissibleBody(M3EThemeData theme) {
    return M3EDismissibleList(
      itemCount: _items.length,
      listPadding: _listPadding,
      colorBuilder: _colorBuilder,
      borderRadiusBuilder: _radiusBuilder,
      onTap: _onTap,
      onLongPress: _onLongPress,
      onDismiss: (int index, DismissDirection direction) async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dismissed ${_items[index].title}')),
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
        controller: _selection,
        itemCount: _items.length,
        appBar: M3ESelectionAppBar(
          idle: M3EAppBar.search(
            searchController: _search,
            suggestionsBuilder: _suggestions,
            barHintText: 'Search items',
            leading: M3EIconButton(
              icon: const Icon(M3EIcons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: 'Back',
            ),
            actions: <Widget>[
              M3EIconButton(
                icon: Icon(_dismissible ? M3EIcons.swipe : M3EIcons.view_list),
                onPressed: () {
                  setState(() => _dismissible = !_dismissible);
                },
                tooltip: _dismissible
                    ? 'Show card list'
                    : 'Show dismissible list',
              ),
            ],
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
            M3EIconButton(
              icon: const Icon(M3EIcons.more_vert),
              onPressed: () {},
              tooltip: 'More',
            ),
          ],
        ),
        body: _dismissible ? _dismissibleBody(theme) : _cardListBody(),
      ),
    );
  }
}
