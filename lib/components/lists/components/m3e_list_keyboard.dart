import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'm3e_expandable_nest_scope.dart';
import 'm3e_list_feature_scope.dart';

/// One focusable list row or trailing action registered with
/// [M3EListKeyboardGroup].
class M3EListKeyboardRegistration {
  M3EListKeyboardRegistration._(this._state, this.node, this.index, this.slot);

  final _M3EListKeyboardGroupState _state;

  /// Focus node owned by the group.
  final FocusNode node;

  /// Row index.
  final int index;

  /// `0` is the row. Higher slots are trailing actions.
  final int slot;

  /// Whether this target can be focused.
  bool enabled = true;

  /// Whether Tab should land on this node.
  bool get tabStop => _state._isTabStop(node);

  bool _disposed = false;

  /// Drops this target.
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    _state._remove(this);
  }
}

/// Arrow-key list navigation.
///
/// Tab enters on the selected row, or the first row. Arrows move and wrap.
/// Space and Enter activate the focused target.
class M3EListKeyboardGroup extends StatefulWidget {
  /// Creates a list keyboard group.
  const M3EListKeyboardGroup({
    required this.itemCount,
    required this.child,
    this.semanticsLabel,
    super.key,
  });

  /// Number of rows. Used to clamp the entry index.
  final int itemCount;

  /// List box description for assistive tech.
  final String? semanticsLabel;

  /// List body.
  final Widget child;

  /// Nearest group, if any.
  static M3EListKeyboardBinding? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_M3EListKeyboardScope>()
        ?.binding;
  }

  @override
  State<M3EListKeyboardGroup> createState() => _M3EListKeyboardGroupState();
}

/// Focus registration for one [M3EListKeyboardGroup].
class M3EListKeyboardBinding {
  M3EListKeyboardBinding._(this._state);

  final _M3EListKeyboardGroupState _state;

  /// Registers a row (`slot` 0) or a trailing action.
  M3EListKeyboardRegistration register({required int index, int slot = 0}) {
    return _state.register(index: index, slot: slot);
  }
}

class _M3EListKeyboardScope extends InheritedWidget {
  const _M3EListKeyboardScope({
    required this._state,
    required this.binding,
    required super.child,
  });

  final _M3EListKeyboardGroupState _state;

  final M3EListKeyboardBinding binding;

  @override
  bool updateShouldNotify(_M3EListKeyboardScope oldWidget) =>
      _state != oldWidget._state;
}

class _M3EListKeyboardGroupState extends State<M3EListKeyboardGroup> {
  final List<M3EListKeyboardRegistration> _members =
      <M3EListKeyboardRegistration>[];
  final Map<int, _M3EListKeyboardGroupState> _nests =
      <int, _M3EListKeyboardGroupState>{};
  FocusNode? _pinned;
  _M3EListKeyboardGroupState? _parent;
  int? _nestIndex;
  late final M3EListKeyboardBinding _binding = M3EListKeyboardBinding._(this);
  late final _M3EListTraversalPolicy _policy = _M3EListTraversalPolicy(this);
  late final _M3EListShortcutManager _shortcuts = _M3EListShortcutManager(
    state: this,
    shortcuts: <ShortcutActivator, Intent>{
      const SingleActivator(LogicalKeyboardKey.arrowDown): VoidCallbackIntent(
        _moveNext,
      ),
      const SingleActivator(LogicalKeyboardKey.arrowRight): VoidCallbackIntent(
        _moveNext,
      ),
      const SingleActivator(LogicalKeyboardKey.arrowUp): VoidCallbackIntent(
        _movePrevious,
      ),
      const SingleActivator(LogicalKeyboardKey.arrowLeft): VoidCallbackIntent(
        _movePrevious,
      ),
    },
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncNestLink();
  }

  @override
  void dispose() {
    _parent?._nests.remove(_nestIndex);
    _parent = null;
    _shortcuts.dispose();
    for (final member in List<M3EListKeyboardRegistration>.of(_members)) {
      member.dispose();
    }
    super.dispose();
  }

  void _syncNestLink() {
    final _M3EListKeyboardScope? parentScope = context
        .dependOnInheritedWidgetOfExactType<_M3EListKeyboardScope>();
    final int? index = M3EExpandableNestScope.maybeOf(context)?.rowIndex;
    final _M3EListKeyboardGroupState? parent = parentScope?._state;
    if (identical(_parent, parent) && _nestIndex == index) {
      return;
    }
    _parent?._nests.remove(_nestIndex);
    _parent = null;
    _nestIndex = null;
    if (parent == null || index == null) {
      return;
    }
    _parent = parent;
    _nestIndex = index;
    parent._nests[index] = this;
  }

  /// Registers a row or trailing action and returns its focus node.
  M3EListKeyboardRegistration register({required int index, int slot = 0}) {
    final node = FocusNode(debugLabel: 'list $index.$slot')
      ..addListener(_onMemberFocus);
    final registration = M3EListKeyboardRegistration._(this, node, index, slot);
    _members.add(registration);
    return registration;
  }

  void _remove(M3EListKeyboardRegistration registration) {
    registration.node.removeListener(_onMemberFocus);
    _members.remove(registration);
    if (_pinned == registration.node) {
      _pinned = null;
    }
    registration.node.dispose();
  }

  void _onMemberFocus() {
    final bool inside = _members.any(
      (M3EListKeyboardRegistration member) => member.node.hasFocus,
    );
    if (!inside && _pinned != null) {
      setState(() => _pinned = null);
    }
  }

  bool _owns(FocusNode node) {
    for (final M3EListKeyboardRegistration member in _members) {
      if (member.node == node) {
        return true;
      }
    }
    return false;
  }

  bool _memberHasFocus() {
    for (final M3EListKeyboardRegistration member in _members) {
      if (member.node.hasPrimaryFocus) {
        return true;
      }
    }
    return false;
  }

  bool _isTabStop(FocusNode node) {
    final List<M3EListKeyboardRegistration> rows = _ordered()
        .where((M3EListKeyboardRegistration member) => member.slot == 0)
        .toList();
    if (_parent != null) {
      return rows.any(
        (M3EListKeyboardRegistration member) => member.node == node,
      );
    }
    if (rows.isEmpty) {
      return false;
    }
    if (rows.first.node == node || rows.last.node == node) {
      return true;
    }
    final FocusNode? entry = _entryNode();
    return entry != null && entry == node;
  }

  List<M3EListKeyboardRegistration> _ordered() {
    final List<M3EListKeyboardRegistration> rows =
        _members.where((M3EListKeyboardRegistration member) {
          return member.enabled;
        }).toList()..sort((
          M3EListKeyboardRegistration a,
          M3EListKeyboardRegistration b,
        ) {
          final int byIndex = a.index.compareTo(b.index);
          if (byIndex != 0) {
            return byIndex;
          }
          return a.slot.compareTo(b.slot);
        });
    return rows;
  }

  int? _selectedIndex() {
    final M3EListFeatureScope? features = M3EListFeatureScope.maybeOf(context);
    final Set<int>? selected = features?.controller?.selectedIndices;
    if (selected == null || selected.isEmpty) {
      return null;
    }
    final List<int> sorted = selected.toList()..sort();
    return sorted.first;
  }

  FocusNode? _entryNode() {
    final List<M3EListKeyboardRegistration> ordered = _ordered();
    if (ordered.isEmpty) {
      return null;
    }
    final FocusNode? pinned = _pinnedEntry(ordered);
    if (pinned != null) {
      return pinned;
    }
    final FocusNode? selected = _selectedEntry(ordered);
    if (selected != null) {
      return selected;
    }
    return ordered.first.node;
  }

  FocusNode? _pinnedEntry(List<M3EListKeyboardRegistration> ordered) {
    if (_pinned == null) {
      return null;
    }
    final bool stillPresent = ordered.any(
      (M3EListKeyboardRegistration member) =>
          member.node == _pinned && member.slot == 0,
    );
    return stillPresent ? _pinned : null;
  }

  FocusNode? _selectedEntry(List<M3EListKeyboardRegistration> ordered) {
    final int? selected = _selectedIndex();
    if (selected == null) {
      return null;
    }
    for (final member in ordered) {
      if (member.index == selected && member.slot == 0) {
        return member.node;
      }
    }
    return null;
  }

  void _moveNext() => _move(1);

  void _movePrevious() => _move(-1);

  void _focusMember(M3EListKeyboardRegistration member) {
    setState(() => _pinned = member.node);
    member.node.requestFocus();
  }

  bool _focusEdge({required bool first}) {
    if (!mounted) {
      return false;
    }
    final List<M3EListKeyboardRegistration> ordered = _ordered();
    if (ordered.isEmpty) {
      return false;
    }
    final FocusNode node = (first ? ordered.first : ordered.last).node;
    if (!node.canRequestFocus) {
      return false;
    }
    _focusMember(first ? ordered.first : ordered.last);
    return true;
  }

  bool _moveFromNest(int nestIndex, int delta) {
    final List<M3EListKeyboardRegistration> ordered = _ordered();
    final int header = ordered.indexWhere(
      (M3EListKeyboardRegistration member) =>
          member.index == nestIndex && member.slot == 0,
    );
    if (header < 0) {
      return false;
    }
    if (delta < 0) {
      _focusMember(ordered[header]);
      return true;
    }
    final int next = header + 1;
    if (next >= ordered.length) {
      if (_parent != null && _nestIndex != null) {
        return _parent!._moveFromNest(_nestIndex!, delta);
      }
      _focusMember(ordered.first);
      return true;
    }
    _focusMember(ordered[next]);
    return true;
  }

  void _move(int delta) {
    final List<M3EListKeyboardRegistration> ordered = _ordered();
    if (ordered.isEmpty) {
      return;
    }
    final int index = _focusedIndex(ordered, delta);
    if (_tryEnterNestAtRowEnd(ordered, index, delta)) {
      return;
    }
    final int? next = _resolveNextIndex(ordered, index, delta);
    if (next == null) {
      return;
    }
    _focusMember(ordered[next]);
  }

  int _focusedIndex(List<M3EListKeyboardRegistration> ordered, int delta) {
    final int index = ordered.indexWhere(
      (M3EListKeyboardRegistration member) => member.node.hasPrimaryFocus,
    );
    if (index >= 0) {
      return index;
    }
    return delta > 0 ? -1 : 0;
  }

  /// True when the focused row is the last of a nested-list header and the
  /// nested list swallowed the move by focusing its own edge.
  bool _tryEnterNestAtRowEnd(
    List<M3EListKeyboardRegistration> ordered,
    int index,
    int delta,
  ) {
    if (delta <= 0 || index < 0) {
      return false;
    }
    final M3EListKeyboardRegistration current = ordered[index];
    final bool endOfRow =
        index == ordered.length - 1 ||
        ordered[index + 1].index != current.index;
    if (!endOfRow) {
      return false;
    }
    final _M3EListKeyboardGroupState? nest = _nests[current.index];
    return nest != null && nest._focusEdge(first: true);
  }

  /// The target index to focus, or null when a nested/parent group already
  /// handled the move.
  int? _resolveNextIndex(
    List<M3EListKeyboardRegistration> ordered,
    int index,
    int delta,
  ) {
    final int next = index + delta;
    if (next < 0 || next >= ordered.length) {
      return _resolveWrappedIndex(ordered, next, delta);
    }
    if (delta < 0 && ordered[next].index != ordered[index].index) {
      final _M3EListKeyboardGroupState? nest = _nests[ordered[next].index];
      if (nest != null && nest._focusEdge(first: false)) {
        return null;
      }
    }
    return next;
  }

  int? _resolveWrappedIndex(
    List<M3EListKeyboardRegistration> ordered,
    int next,
    int delta,
  ) {
    if (_parent != null &&
        _nestIndex != null &&
        _parent!._moveFromNest(_nestIndex!, delta)) {
      return null;
    }
    if (next < 0) {
      final _M3EListKeyboardGroupState? nest = _nests[ordered.last.index];
      if (delta < 0 && nest != null && nest._focusEdge(first: false)) {
        return null;
      }
      return ordered.length - 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return _M3EListKeyboardScope(
      state: this,
      binding: _binding,
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: widget.semanticsLabel,
        child: Shortcuts.manager(
          manager: _shortcuts,
          child: FocusTraversalGroup(policy: _policy, child: widget.child),
        ),
      ),
    );
  }
}

class _M3EListShortcutManager extends ShortcutManager {
  _M3EListShortcutManager({required super.shortcuts, required this.state});

  final _M3EListKeyboardGroupState state;

  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    if (!state._memberHasFocus()) {
      return KeyEventResult.ignored;
    }
    return super.handleKeypress(context, event);
  }
}

class _M3EListTraversalPolicy extends ReadingOrderTraversalPolicy {
  _M3EListTraversalPolicy(this._group);

  final _M3EListKeyboardGroupState _group;

  @override
  bool inDirection(FocusNode currentNode, TraversalDirection direction) {
    if (!_group._owns(currentNode)) {
      return super.inDirection(currentNode, direction);
    }
    switch (direction) {
      case TraversalDirection.down:
      case TraversalDirection.right:
        _group._move(1);
        return true;
      case TraversalDirection.up:
      case TraversalDirection.left:
        _group._move(-1);
        return true;
    }
  }
}
