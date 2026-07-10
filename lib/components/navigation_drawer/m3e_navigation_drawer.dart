import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'models/m3e_navigation_destination.dart';

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
    final drawerTheme = theme.navigationDrawerTheme;
    final scheme = theme.colorScheme;
    return M3EComponentTheme(builder: (context) => Container(
        width: drawerTheme.width,
        color: drawerTheme.containerColor(scheme),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (headline != null)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: drawerTheme.headlineHorizontalPadding,
                    vertical: drawerTheme.headlineVerticalPadding,
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
      ),
    );
  }

  Widget _buildDestination(BuildContext context, int index) {
    final theme = M3ETheme.of(context);
    final drawerTheme = theme.navigationDrawerTheme;
    final scheme = theme.colorScheme;
    final selected = index == selectedIndex;
    final M3ENavigationDestination dest = destinations[index];
    final Color foreground = drawerTheme.destinationForegroundColor(
      scheme,
      selected: selected,
    );
    final border = drawerTheme.destinationShape();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: drawerTheme.destinationHorizontalPadding,
        vertical: drawerTheme.destinationVerticalPadding,
      ),
      child: M3ETappable(
        onTap: () => onDestinationSelected(index),
        semanticLabel: dest.label,
        materialInk: true,
        builder: (BuildContext context, M3EInteractionState state) {
          return Container(
            height: drawerTheme.destinationHeight,
            decoration: ShapeDecoration(
              shape: border,
              color: drawerTheme.destinationBackgroundColor(
                scheme,
                selected: selected,
              ),
            ),
            child: M3EStateLayerOverlay(
              state: state,
              color: scheme.onSurface,
              shape: border,
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: drawerTheme.destinationInnerHorizontalPadding,
                  ),
                  child: Row(
                    children: <Widget>[
                      IconTheme.merge(
                        data: IconThemeData(
                          color: foreground,
                          size: drawerTheme.iconSize,
                        ),
                        child: selected
                            ? (dest.selectedIcon ?? dest.icon)
                            : dest.icon,
                      ),
                      SizedBox(width: drawerTheme.iconLabelGap),
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
