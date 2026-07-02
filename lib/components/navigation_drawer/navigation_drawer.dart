import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'models/m3e_navigation_destination.dart';

export 'models/m3e_navigation_destination.dart';

/// A Material 3 Expressive navigation drawer.
///
/// A wide navigation surface for large layouts. Destinations render as
/// full-width rounded pills; the selected one fills with the secondary
/// container color. An optional [headline] labels the drawer.
class M3ENavigationDrawer extends StatelessWidget {
  const M3ENavigationDrawer({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.headline,
    super.key,
  }) : assert(destinations.length >= 1, 'A drawer needs 1+ destinations.');

  final List<M3ENavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final String? headline;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: 360,
      color: scheme.surfaceContainerLow,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (headline != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 16),
                child: Text(
                  headline!,
                  style: theme.typeScale.titleSmall
                      .copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            for (int i = 0; i < destinations.length; i++)
              _buildDestination(context, i),
          ],
        ),
      ),
    );
  }

  Widget _buildDestination(BuildContext context, int index) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final selected = index == selectedIndex;
    final M3ENavigationDestination dest = destinations[index];
    final Color foreground =
        selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;
    final border = RoundedRectangleBorder(borderRadius: M3EShapes.resolve(28));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: M3ETappable(
        onTap: () => onDestinationSelected(index),
        semanticLabel: dest.label,
        builder: (BuildContext context, M3EInteractionState state) {
          return Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              shape: border,
              color: selected
                  ? scheme.secondaryContainer
                  : const Color(0x00000000),
            ),
            child: Stack(
              children: <Widget>[
                M3EStateLayerOverlay(
                  state: state,
                  color: scheme.onSurface,
                  shape: border,
                ),
                Row(
                  children: <Widget>[
                    IconTheme.merge(
                      data: IconThemeData(color: foreground, size: 24),
                      child: selected
                          ? (dest.selectedIcon ?? dest.icon)
                          : dest.icon,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        dest.label,
                        style: theme.typeScale.labelLarge
                            .copyWith(color: foreground),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (dest.badgeLabel != null)
                      Text(
                        dest.badgeLabel!,
                        style: theme.typeScale.labelLarge
                            .copyWith(color: foreground),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
