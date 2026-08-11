import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Discrete enum control via [M3EDropdownMenu] (better for many options).
///
/// Ignores selection echoes from item sync during build (dropdown
/// [didUpdateWidget] → [M3EDropdownController.setItems] → [onSelectionChanged]).
class PlayEnumMenu<T> extends StatefulWidget {
  /// Creates a dropdown enum control.
  const PlayEnumMenu({
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
    super.key,
  });

  /// Field label.
  final String label;

  /// Selected value.
  final T value;

  /// All values.
  final List<T> values;

  /// Label for each value.
  final String Function(T value) labelOf;

  /// Change callback.
  final ValueChanged<T> onChanged;

  @override
  State<PlayEnumMenu<T>> createState() => _PlayEnumMenuState<T>();
}

class _PlayEnumMenuState<T> extends State<PlayEnumMenu<T>> {
  void _onSelectionChanged(List<M3EDropdownItem<T>> items) {
    if (items.isEmpty) {
      return;
    }
    final T next = items.first.value;
    if (next == widget.value) {
      return;
    }
    // Dropdown may report selection while syncing items in didUpdateWidget.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted || next == widget.value) {
        return;
      }
      widget.onChanged(next);
    });
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(widget.label, style: theme.typeScale.bodyLarge),
          const SizedBox(height: 8),
          M3EDropdownMenu<T>(
            singleSelect: true,
            items: <M3EDropdownItem<T>>[
              for (final T item in widget.values)
                M3EDropdownItem<T>(
                  label: widget.labelOf(item),
                  value: item,
                  selected: item == widget.value,
                ),
            ],
            fieldStyle: M3EDropdownFieldStyle(hintText: widget.label),
            onSelectionChanged: _onSelectionChanged,
          ),
        ],
      ),
    );
  }
}
