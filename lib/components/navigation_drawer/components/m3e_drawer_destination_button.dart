import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../navigation_rail/components/m3e_nav_icon_scale.dart';
import '../models/m3e_navigation_destination.dart';
import '../styles/m3e_navigation_drawer_theme.dart';

/// Single destination row in [M3ENavigationDrawer].
///
/// No ink splash — selection feedback comes from the shared liquid indicator.
class M3EDrawerDestinationButton extends StatelessWidget {
  const M3EDrawerDestinationButton({
    required this.destination,
    required this.selected,
    required this.onTap,
    required this.indicatorKey,
    super.key,
  });

  final M3ENavigationDestination destination;
  final bool selected;
  final VoidCallback onTap;
  final GlobalKey indicatorKey;

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
                  // Fill drawn by [M3ENavSelectionIndicator].
                  color: const Color(0x00000000),
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
