import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../catalog/m3e_demo_entry.dart';
import '../widgets/playground/preview_scope.dart';

/// Catalog entries for a section: a card list on narrow screens and a card
/// grid on wide ones.
class SectionListPane extends StatelessWidget {
  /// Creates a section list pane.
  const SectionListPane({
    required this.entries,
    required this.onSelect,
    super.key,
  });

  /// Entries to show.
  final List<M3EDemoEntry> entries;

  /// Called when an entry is tapped.
  final ValueChanged<M3EDemoEntry> onSelect;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final bool wide =
        MediaQuery.sizeOf(context).width >= kM3EDemoWideBreakpoint;
    if (wide) {
      return GridView.builder(
        primary: true,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 320,
          mainAxisExtent: 140,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          final M3EDemoEntry entry = entries[index];
          return M3ECard(
            variant: M3ECardVariant.filled,
            color: theme.colorScheme.surfaceContainerHighest,
            onPressed: () => onSelect(entry),
            semanticLabel: '${entry.title}. ${entry.subtitle}',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(entry.icon, color: theme.colorScheme.primary),
                const Spacer(),
                Text(
                  entry.title,
                  style: theme.typeScale.titleMedium.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  entry.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.typeScale.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    return ListView(
      // Explicit so this list is the gallery app bar's scroll-under source
      // (desktop doesn't auto-inherit PrimaryScrollController for lists).
      primary: true,
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        M3EList(
          color: theme.colorScheme.surfaceContainerHighest,
          itemCount: entries.length,
          onTap: (int index) => onSelect(entries[index]),
          itemBuilder: (BuildContext context, int index) {
            final M3EDemoEntry entry = entries[index];
            return M3EListItem(
              headline: entry.title,
              supportingText: entry.subtitle,
              leading: Icon(entry.icon),
              trailing: Icon(
                M3EIcons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            );
          },
        ),
      ],
    );
  }
}
