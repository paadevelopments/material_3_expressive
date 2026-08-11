import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Discrete enum control via [M3ESegmentedButton].
class PlayEnumSegmented<T> extends StatelessWidget {
  /// Creates a segmented enum control.
  const PlayEnumSegmented({
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
    super.key,
  });

  /// Row label.
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
          M3ESegmentedButton<T>(
            segments: <M3ESegment<T>>[
              for (final T item in values)
                M3ESegment<T>(value: item, label: labelOf(item)),
            ],
            selected: <T>{value},
            onSelectionChanged: (Set<T> next) {
              if (next.isNotEmpty) {
                onChanged(next.first);
              }
            },
          ),
        ],
      ),
    );
  }
}
