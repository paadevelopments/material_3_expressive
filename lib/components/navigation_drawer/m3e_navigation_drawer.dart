import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../navigation_rail/components/m3e_nav_selection_indicator.dart';
import 'components/m3e_drawer_destination_button.dart';
import 'models/m3e_navigation_destination.dart';

export 'models/m3e_navigation_destination.dart';

/// A Material 3 Expressive navigation drawer.
///
/// Destinations use a shared liquid selection indicator (spatial springs).
class M3ENavigationDrawer extends StatefulWidget {
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
  State<M3ENavigationDrawer> createState() => _M3ENavigationDrawerState();
}

class _M3ENavigationDrawerState extends State<M3ENavigationDrawer> {
  late List<GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    _keys = _makeKeys(widget.destinations.length);
  }

  @override
  void didUpdateWidget(covariant M3ENavigationDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destinations.length != widget.destinations.length) {
      _keys = _makeKeys(widget.destinations.length);
    }
  }

  List<GlobalKey> _makeKeys(int count) =>
      List<GlobalKey>.generate(count, (_) => GlobalKey());

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
              style: theme.typeScale.titleSmall
                  .copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
        for (int i = 0; i < widget.destinations.length; i++)
          M3EDrawerDestinationButton(
            destination: widget.destinations[i],
            selected: i == widget.selectedIndex,
            indicatorKey: _keys[i],
            onTap: () => widget.onDestinationSelected(i),
          ),
      ],
    );

    return Container(
      width: drawerTheme.width,
      color: drawerTheme.containerColor(scheme),
      child: SafeArea(
        child: M3ENavSelectionIndicator(
          selectedIndex: widget.selectedIndex,
          targetKeys: _keys,
          axis: Axis.vertical,
          color: scheme.secondaryContainer,
          child: list,
        ),
      ),
    );
  }
}
