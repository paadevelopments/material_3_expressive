import 'package:flutter/widgets.dart';

import '../components/app_bars/app_bars.dart';
import '../components/menus/menus.dart';
import '../components/navigation_bar/navigation_bar.dart';
import '../components/navigation_drawer/navigation_drawer.dart';
import '../components/navigation_rail/navigation_rail.dart';
import '../components/tabs/tabs.dart';
import '../components/toolbars/toolbars.dart';

/// Static factories for the Material 3 *Navigation* components, such as
/// `M3ENavigation.bar(...)` and `M3ENavigation.topAppBar(...)`.
class M3ENavigation {
  const M3ENavigation._();

  /// Creates a top app bar. See [M3ETopAppBar].
  static Widget topAppBar({
    required String title,
    Widget? leading,
    List<Widget> actions = const <Widget>[],
    M3ETopAppBarVariant variant = M3ETopAppBarVariant.small,
    Key? key,
  }) {
    return M3ETopAppBar(
      key: key,
      title: title,
      leading: leading,
      actions: actions,
      variant: variant,
    );
  }

  /// Creates a bottom app bar. See [M3EBottomAppBar].
  static Widget bottomAppBar({
    List<Widget> actions = const <Widget>[],
    Widget? floatingActionButton,
    Key? key,
  }) {
    return M3EBottomAppBar(
      key: key,
      actions: actions,
      floatingActionButton: floatingActionButton,
    );
  }

  /// Creates a navigation bar. See [M3ENavigationBar].
  static Widget bar({
    required List<M3ENavigationDestination> destinations,
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    Key? key,
  }) {
    return M3ENavigationBar(
      key: key,
      destinations: destinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }

  /// Creates a navigation rail. See [M3ENavigationRail].
  static Widget rail({
    required List<M3ENavigationDestination> destinations,
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    Widget? leading,
    Widget? trailing,
    M3ENavigationRailLabelType labelType = M3ENavigationRailLabelType.all,
    Key? key,
  }) {
    return M3ENavigationRail(
      key: key,
      destinations: destinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      leading: leading,
      trailing: trailing,
      labelType: labelType,
    );
  }

  /// Creates a navigation drawer. See [M3ENavigationDrawer].
  static Widget drawer({
    required List<M3ENavigationDestination> destinations,
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    String? headline,
    Key? key,
  }) {
    return M3ENavigationDrawer(
      key: key,
      destinations: destinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      headline: headline,
    );
  }

  /// Creates a tab bar. See [M3ETabs].
  static Widget tabs({
    required List<M3ETab> tabs,
    required int selectedIndex,
    required ValueChanged<int> onTabSelected,
    M3ETabsVariant variant = M3ETabsVariant.primary,
    Key? key,
  }) {
    return M3ETabs(
      key: key,
      tabs: tabs,
      selectedIndex: selectedIndex,
      onTabSelected: onTabSelected,
      variant: variant,
    );
  }

  /// Creates a floating toolbar. See [M3EToolbar].
  static Widget toolbar({
    required List<Widget> children,
    Axis axis = Axis.horizontal,
    M3EToolbarColor color = M3EToolbarColor.standard,
    Key? key,
  }) {
    return M3EToolbar(
      key: key,
      axis: axis,
      color: color,
      children: children,
    );
  }

  /// Creates a menu anchored to a widget. See [M3EMenu].
  static Widget menu({
    required M3EMenuAnchorBuilder anchorBuilder,
    required List<M3EMenuEntry> entries,
    Key? key,
  }) {
    return M3EMenu(key: key, anchorBuilder: anchorBuilder, entries: entries);
  }
}
