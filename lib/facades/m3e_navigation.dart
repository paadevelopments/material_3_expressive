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

  /// Creates a fixed top app bar. See [M3ETopAppBar].
  ///
  /// Pass [title] for a plain text title or [titleWidget] for a custom title.
  static Widget topAppBar({
    String? title,
    Widget? titleWidget,
    Widget? leading,
    List<Widget>? actions,
    bool centerTitle = false,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    M3EAppBarShapeFamily shapeFamily = M3EAppBarShapeFamily.round,
    M3EAppBarDensity density = M3EAppBarDensity.regular,
    double? toolbarHeight,
    bool automaticallyImplyLeading = true,
    Clip clipBehavior = Clip.none,
    String? semanticLabel,
    Key? key,
  }) {
    return M3ETopAppBar(
      key: key,
      leading: leading,
      title: titleWidget,
      titleText: title,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      shapeFamily: shapeFamily,
      density: density,
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: automaticallyImplyLeading,
      clipBehavior: clipBehavior,
      semanticLabel: semanticLabel,
    );
  }

  /// Creates a scrolling top app bar. See [M3ESliverAppBar].
  static Widget sliverAppBar({
    String? title,
    Widget? titleWidget,
    Widget? leading,
    List<Widget>? actions,
    bool centerTitle = false,
    Color? backgroundColor,
    Color? foregroundColor,
    bool pinned = true,
    bool floating = false,
    bool snap = false,
    M3EAppBarShapeFamily shapeFamily = M3EAppBarShapeFamily.round,
    M3EAppBarDensity density = M3EAppBarDensity.regular,
    M3EAppBarVariant variant = M3EAppBarVariant.medium,
    String? semanticLabel,
    Key? key,
  }) {
    return M3ESliverAppBar(
      key: key,
      leading: leading,
      title: titleWidget,
      titleText: title,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      pinned: pinned,
      floating: floating,
      snap: snap,
      shapeFamily: shapeFamily,
      density: density,
      variant: variant,
      semanticLabel: semanticLabel,
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
    required List<M3ENavigationBarDestination> destinations,
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    M3ENavBarLabelBehavior labelBehavior = M3ENavBarLabelBehavior.alwaysShow,
    M3ENavBarSize size = M3ENavBarSize.medium,
    M3ENavBarShapeFamily shapeFamily = M3ENavBarShapeFamily.round,
    M3ENavBarIndicatorStyle indicatorStyle = M3ENavBarIndicatorStyle.pill,
    Key? key,
  }) {
    return M3ENavigationBar(
      key: key,
      destinations: destinations,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelBehavior: labelBehavior,
      size: size,
      shapeFamily: shapeFamily,
      indicatorStyle: indicatorStyle,
    );
  }

  /// Creates a navigation rail. See [M3ENavigationRail].
  static Widget rail({
    required List<M3ENavigationRailSection> sections,
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    M3ENavigationRailType type = M3ENavigationRailType.expanded,
    M3ENavigationRailModality modality = M3ENavigationRailModality.standard,
    M3ENavigationRailLabelBehavior labelBehavior =
        M3ENavigationRailLabelBehavior.alwaysShow,
    M3ENavigationRailFabSlot? fab,
    Widget? trailing,
    Key? key,
  }) {
    return M3ENavigationRail(
      key: key,
      sections: sections,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      type: type,
      modality: modality,
      labelBehavior: labelBehavior,
      fab: fab,
      trailing: trailing,
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
