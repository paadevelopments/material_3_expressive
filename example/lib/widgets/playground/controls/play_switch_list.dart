import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// One label + switch control.
///
/// Neighboring items in a [PlayControlGroup] collapse into one
/// [PlaySwitchList]. A lone item renders as a one-row list.
class PlaySwitchItem extends StatelessWidget {
  /// Creates a switch item.
  const PlaySwitchItem({
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
    this.enabled = true,
    super.key,
  });

  /// Row headline.
  final String label;

  /// Optional supporting text.
  final String? description;

  /// Switch value.
  final bool value;

  /// Change callback.
  final ValueChanged<bool> onChanged;

  /// Whether the row can toggle.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PlaySwitchList(items: <PlaySwitchItem>[this]);
  }
}

/// Filled card list of [PlaySwitchItem]s.
///
/// Tapping a row toggles it. Focus stops on the row only; the switch is
/// excluded from traversal and pointer input.
class PlaySwitchList extends StatelessWidget {
  /// Creates a switch list.
  const PlaySwitchList({required this.items, super.key});

  /// Rows, top to bottom.
  final List<PlaySwitchItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: M3EList(
        variant: M3ECardVariant.filled,
        itemCount: items.length,
        onTap: (int index) {
          final PlaySwitchItem item = items[index];
          item.onChanged(!item.value);
        },
        itemBuilder: (BuildContext context, int index) {
          final PlaySwitchItem item = items[index];
          return M3EListItem(
            headline: item.label,
            supportingText: item.description,
            enabled: item.enabled,
            trailing: ExcludeFocus(
              child: IgnorePointer(
                child: M3ESwitch(
                  value: item.value,
                  onChanged: item.enabled ? item.onChanged : null,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
