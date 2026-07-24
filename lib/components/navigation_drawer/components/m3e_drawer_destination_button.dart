import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../navigation_rail/components/m3e_nav_icon_scale.dart';
import '../models/m3e_navigation_destination.dart';
import '../styles/m3e_navigation_drawer_theme.dart';

/// Single destination row in [M3ENavigationDrawer].
///
/// Resting selection fill is local; the shared liquid overlay paints while
/// traveling between destinations.
class M3EDrawerDestinationButton extends StatelessWidget {
  const M3EDrawerDestinationButton({
    required this.destination,
    required this.selected,
    required this.onTap,
    required this.indicatorKey,
    this.showRestingFill = true,
    super.key,
  });

  final M3ENavigationDestination destination;
  final bool selected;
  final VoidCallback onTap;
  final GlobalKey indicatorKey;

  /// When false, the shared liquid overlay owns the pill (during travel).
  final bool showRestingFill;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ENavigationDrawerTheme drawerTheme = theme.navigationDrawerTheme;
    final M3EColorScheme scheme = theme.colorScheme;
    final Color foreground = drawerTheme.destinationForegroundColor(
      scheme,
      selected: selected,
    );
    final ShapeBorder border = drawerTheme.destinationShape();
    final Color fill = selected && showRestingFill
        ? drawerTheme.destinationBackgroundColor(scheme, selected: true)
        : const Color(0x00000000);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: drawerTheme.destinationHorizontalPadding,
        vertical: drawerTheme.destinationVerticalPadding,
      ),
      child: Semantics(
        button: true,
        selected: selected,
        label: destination.label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: KeyedSubtree(
            key: indicatorKey,
            child: SizedBox(
              height: drawerTheme.destinationHeight,
              width: double.infinity,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: border,
                  color: fill,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: drawerTheme.destinationInnerHorizontalPadding,
                  ),
                  child: Row(
                    children: <Widget>[
                      M3ENavIconScale(
                        selected: selected,
                        child: IconTheme.merge(
                          data: IconThemeData(
                            color: foreground,
                            size: drawerTheme.iconSize,
                          ),
                          child: selected
                              ? (destination.selectedIcon ?? destination.icon)
                              : destination.icon,
                        ),
                      ),
                      SizedBox(width: drawerTheme.iconLabelGap),
                      Expanded(
                        child: Text(
                          destination.label,
                          style: theme.typeScale.labelLarge
                              .copyWith(color: foreground),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (destination.badgeLabel != null)
                        Text(
                          destination.badgeLabel!,
                          style: theme.typeScale.labelLarge
                              .copyWith(color: foreground),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
