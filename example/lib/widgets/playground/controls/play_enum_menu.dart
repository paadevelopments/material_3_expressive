import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Discrete enum control via [M3EDropdownMenu] (better for many options).
class PlayEnumMenu<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(label, style: theme.typeScale.bodyLarge),
          const SizedBox(height: 8),
          M3EDropdownMenu<T>(
            key: ValueKey<T>(value),
            singleSelect: true,
            items: <M3EDropdownItem<T>>[
              for (final T item in values)
                M3EDropdownItem<T>(
                  label: labelOf(item),
                  value: item,
                  selected: item == value,
                ),
            ],
            fieldStyle: M3EDropdownFieldStyle(hintText: label),
            onSelectionChanged: (List<M3EDropdownItem<T>> items) {
              if (items.isNotEmpty) {
                onChanged(items.first.value);
              }
            },
          ),
        ],
      ),
    );
  }
}
