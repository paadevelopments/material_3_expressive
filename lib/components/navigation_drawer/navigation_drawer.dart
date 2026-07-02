import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'models/m3e_navigation_destination.dart';
import 'styles/m3e_nav_drawer_tokens.dart';

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
      width: M3ENavDrawerTokens.width,
      color: M3ENavDrawerTokens.containerColor(scheme),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (headline != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: M3ENavDrawerTokens.headlineHorizontalPadding,
                  vertical: M3ENavDrawerTokens.headlineVerticalPadding,
                ),
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
    final Color foreground = M3ENavDrawerTokens.destinationForegroundColor(
      scheme,
      selected: selected,
    );
    final border = M3ENavDrawerTokens.destinationShape(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: M3ETappable(
        onTap: () => onDestinationSelected(index),
        semanticLabel: dest.label,
        builder: (BuildContext context, M3EInteractionState state) {
          return Container(
            height: M3ENavDrawerTokens.destinationHeight,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: ShapeDecoration(
              shape: border,
              color: M3ENavDrawerTokens.destinationBackgroundColor(
                scheme,
                selected: selected,
              ),
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
                      data: IconThemeData(
                          color: foreground, size: M3ENavDrawerTokens.iconSize),
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
