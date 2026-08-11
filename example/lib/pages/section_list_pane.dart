import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../catalog/m3e_demo_entry.dart';
import '../catalog/m3e_demo_section.dart';

/// List of catalog entries for a section.
class SectionListPane extends StatelessWidget {
  /// Creates a section list pane.
  const SectionListPane({
    required this.section,
    required this.entries,
    required this.selectedId,
    required this.wide,
    required this.onSelect,
    super.key,
  });

  /// Current section.
  final M3EDemoSection section;

  /// Entries to show.
  final List<M3EDemoEntry> entries;

  /// Selected entry id when [wide]; otherwise unused for selection styling.
  final String? selectedId;

  /// Whether master–detail is active.
  final bool wide;

  /// Called when a row is tapped.
  final ValueChanged<M3EDemoEntry> onSelect;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: entries.length + 1,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 8);
      },
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(section.navLabel, style: theme.typeScale.headlineSmall),
          );
        }
        final M3EDemoEntry entry = entries[index - 1];
        final bool selected = wide && entry.id == selectedId;
        return M3EListItem(
          headline: entry.title,
          supportingText: entry.subtitle,
          leading: Icon(entry.icon),
          trailing: wide
              ? null
              : Icon(
                  M3EIcons.chevron_right,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
          selected: selected,
          onTap: () => onSelect(entry),
        );
      },
    );
  }
}
