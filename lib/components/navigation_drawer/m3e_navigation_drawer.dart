import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'components/m3e_drawer_destination_button.dart';
import 'models/m3e_navigation_destination.dart';

export 'models/m3e_navigation_destination.dart';
export 'styles/m3e_navigation_drawer_theme.dart';

/// A Material 3 Expressive navigation drawer.
///
/// Each destination scales and fades its own selection fill.
class M3ENavigationDrawer extends StatefulWidget {
  /// M3ENavigationDrawer.
  const M3ENavigationDrawer({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.headline,
    super.key,
  }) : assert(destinations.length >= 1, 'A drawer needs 1+ destinations.');

  /// destinations.

  final List<M3ENavigationDestination> destinations;

  /// selectedIndex.
  final int selectedIndex;

  /// onDestinationSelected.
  final ValueChanged<int> onDestinationSelected;

  /// headline.
  final String? headline;

  @override
  State<M3ENavigationDrawer> createState() => _M3ENavigationDrawerState();
}

class _M3ENavigationDrawerState extends State<M3ENavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildDrawer);
  }

  Widget _buildDrawer(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final drawerTheme = theme.navigationDrawerTheme;
    final M3EColorScheme scheme = theme.colorScheme;

    final Widget list = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (widget.headline != null)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: drawerTheme.headlineHorizontalPadding,
              vertical: drawerTheme.headlineVerticalPadding,
            ),
            child: Text(
              widget.headline!,
              style: theme.typeScale.titleSmall.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        for (int i = 0; i < widget.destinations.length; i++)
          M3EDrawerDestinationButton(
            destination: widget.destinations[i],
            selected: i == widget.selectedIndex,
            onTap: () => widget.onDestinationSelected(i),
          ),
      ],
    );

    return Container(
      width: drawerTheme.width,
      color: drawerTheme.containerColor(scheme),
      child: SafeArea(child: list),
    );
  }
}
