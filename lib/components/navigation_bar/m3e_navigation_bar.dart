// Vendored from the `navigation_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e/lib).
// The logic is kept identical to the reference `NavigationBarM3E`; only the
// public class name carries the `M3E` prefix and theme tokens are read from
// this package's own `M3ETheme` instead of the external `m3e_design` package.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import 'enums/m3e_nav_bar_enums.dart';
import 'models/m3e_navigation_bar_destination.dart';
import 'styles/m3e_navigation_bar_theme.dart';

class M3ENavigationBar extends StatelessWidget {
  const M3ENavigationBar({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.labelBehavior = M3ENavBarLabelBehavior.alwaysShow,
    this.size = M3ENavBarSize.medium,
    this.shapeFamily = M3ENavBarShapeFamily.square,
    this.density = M3ENavBarDensity.regular,
    this.backgroundColor,
    this.elevation,
    this.indicatorStyle = M3ENavBarIndicatorStyle.pill,
    this.indicatorColor,
    this.padding,
    this.safeArea = true,
    this.semanticLabel,
  });

  final List<M3ENavigationBarDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  final M3ENavBarLabelBehavior labelBehavior;
  final M3ENavBarSize size;
  final M3ENavBarShapeFamily shapeFamily;
  final M3ENavBarDensity density;

  final Color? backgroundColor;
  final double? elevation;

  final M3ENavBarIndicatorStyle indicatorStyle;
  final Color? indicatorColor;

  final EdgeInsetsGeometry? padding;
  final bool safeArea;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    assert(destinations.isNotEmpty, 'Provide at least one destination');

    final m3e = M3ETheme.of(context);
    final navTheme = m3e.navigationBarTheme;
    final metrics = navTheme.metrics(density, m3e.spacing);

    final height = size == M3ENavBarSize.small
        ? metrics.heightSmall
        : metrics.heightMedium;
    final bg = backgroundColor ?? navTheme.containerColor(m3e.colorScheme);
    final shape = navTheme.containerShape(shapeFamily);

    final nav = Material(
      color: bg,
      elevation: elevation ?? 0,
      shape: shape,
      child: SizedBox(
        height: height,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: safeArea,
          child: NavigationBar(
          height: height,
          elevation: elevation ?? 0,
          indicatorColor: indicatorStyle == M3ENavBarIndicatorStyle.none
              ? Colors.transparent
              : (indicatorColor ?? navTheme.indicatorColor(m3e.colorScheme)),
          indicatorShape: switch (indicatorStyle) {
            M3ENavBarIndicatorStyle.pill => navTheme.indicatorShapePill(),
            M3ENavBarIndicatorStyle.underline =>
            const StadiumBorder(), // we'll fake underline via decoration below
            M3ENavBarIndicatorStyle.none => const StadiumBorder(),
          },
          backgroundColor:
          Colors.transparent, // outer Material supplies bg + shape
          labelBehavior: switch (labelBehavior) {
            M3ENavBarLabelBehavior.alwaysShow =>
            NavigationDestinationLabelBehavior.alwaysShow,
            M3ENavBarLabelBehavior.onlySelected =>
            NavigationDestinationLabelBehavior.onlyShowSelected,
            M3ENavBarLabelBehavior.alwaysHide =>
            NavigationDestinationLabelBehavior.alwaysHide,
          },
          selectedIndex: selectedIndex,
          destinations: List.generate(destinations.length, (i) {
            final d = destinations[i];
            return NavigationDestination(
              icon: _icon(context, false, d, metrics.iconSize),
              selectedIcon: _selectedIcon(
                  context, true, d, metrics.iconSize, navTheme, indicatorStyle),
              label: d.label,
              tooltip: d.semanticLabel,
            );
          }),
          onDestinationSelected: onDestinationSelected,
        ),
        ),
      ),
    );

    final padded = Padding(
      padding: padding ?? EdgeInsets.zero,
      child: nav,
    );

    final content = DefaultTextStyle.merge(
      style: navTheme.labelStyle(m3e.typeScale).copyWith(
        color: m3e.colorScheme.onSurfaceVariant,
      ),
      child: IconTheme.merge(
        data: IconThemeData(
            size: metrics.iconSize, color: m3e.colorScheme.onSurfaceVariant),
        child: padded,
      ),
    );

    if (!safeArea && semanticLabel == null) return content;
    final wrapped = SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: safeArea,
        child: content);

    if (semanticLabel == null) return wrapped;
    return Semantics(container: true, label: semanticLabel!, child: wrapped);
  }

  Widget _icon(BuildContext context, bool selected,
      M3ENavigationBarDestination d, double iconSize) {
    return SizedBox(
      width: iconSize + 8, // give a little space for underline
      height: iconSize + 8,
      child: Center(child: d.buildIcon(selected)),
    );
  }

  Widget _selectedIcon(
      BuildContext context,
      bool selected,
      M3ENavigationBarDestination d,
      double iconSize,
      M3ENavigationBarTheme navTheme,
      M3ENavBarIndicatorStyle style,
      ) {
    final w = _icon(context, selected, d, iconSize);
    if (style != M3ENavBarIndicatorStyle.underline) return w;

    final metrics = navTheme.metrics(density, M3ETheme.of(context).spacing);
    final deco = navTheme.underlineDecoration(
        navTheme.indicatorColor(M3ETheme.of(context).colorScheme),
        metrics.indicatorThickness);
    return DecoratedBox(
      decoration: deco,
      child: w,
    );
  }
}
