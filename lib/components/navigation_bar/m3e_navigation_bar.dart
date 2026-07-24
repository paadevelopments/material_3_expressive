// Vendored from the `navigation_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e/lib).
// Adapted for material_3_expressive: liquid selection indicator (spatial springs).

import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../navigation_rail/components/m3e_nav_selection_indicator.dart';
import 'components/m3e_nav_bar_destination_button.dart';
import 'enums/m3e_nav_bar_enums.dart';
import 'models/m3e_navigation_bar_destination.dart';
import 'styles/m3e_navigation_bar_theme.dart';

/// A Material 3 Expressive navigation bar.
///
/// Pill selection uses a lead/trail spring indicator that stretches between
/// destinations (spatial springs motion spec).
class M3ENavigationBar extends StatefulWidget {
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
  State<M3ENavigationBar> createState() => _M3ENavigationBarState();
}

class _M3ENavigationBarState extends State<M3ENavigationBar> {
  late List<GlobalKey> _keys;
  bool _traveling = false;

  static const double _indicatorWidth = 64;
  static const double _indicatorHeight = 32;

  @override
  void initState() {
    super.initState();
    _keys = _makeKeys(widget.destinations.length);
  }

  @override
  void didUpdateWidget(covariant M3ENavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destinations.length != widget.destinations.length) {
      _keys = _makeKeys(widget.destinations.length);
    }
  }

  List<GlobalKey> _makeKeys(int count) =>
      List<GlobalKey>.generate(count, (_) => GlobalKey());

  void _onTravelingChanged(bool traveling) {
    if (_traveling == traveling || !mounted) {
      return;
    }
    setState(() => _traveling = traveling);
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.destinations.isNotEmpty, 'Provide at least one destination');
    return M3EComponentTheme(builder: _buildNavigationBar);
  }

  Widget _buildNavigationBar(BuildContext context) {
    final M3EThemeData m3e = M3ETheme.of(context);
    final M3ENavigationBarTheme navTheme = m3e.navigationBarTheme;
    final M3EColorScheme scheme = m3e.colorScheme;
    final metrics = navTheme.metrics(widget.density, m3e.spacing);

    final double height = widget.size == M3ENavBarSize.small
        ? metrics.heightSmall
        : metrics.heightMedium;
    final Color bg = widget.backgroundColor ?? navTheme.containerColor(scheme);
    final ShapeBorder shape = navTheme.containerShape(widget.shapeFamily);
    final double bottomInset =
        widget.safeArea ? MediaQuery.viewPaddingOf(context).bottom : 0.0;

    final Color selected = navTheme.selectedColor(scheme);
    final Color unselected = navTheme.unselectedColor(scheme);
    final TextStyle labelBase = navTheme.labelStyle(m3e.typeScale);
    final Color indicator =
        widget.indicatorColor ?? navTheme.indicatorColor(scheme);
    final bool usePill =
        widget.indicatorStyle == M3ENavBarIndicatorStyle.pill;

    final Widget destinationsRow = Row(
      children: <Widget>[
        for (int i = 0; i < widget.destinations.length; i++)
          Expanded(
            child: M3ENavBarDestinationButton(
              destination: widget.destinations[i],
              selected: i == widget.selectedIndex,
              selectedColor: selected,
              unselectedColor: unselected,
              labelStyle: labelBase,
              iconSize: metrics.iconSize,
              labelBehavior: widget.labelBehavior,
              indicatorStyle: widget.indicatorStyle,
              indicatorKey: _keys[i],
              indicatorWidth: _indicatorWidth,
              indicatorHeight: _indicatorHeight,
              underlineThickness: metrics.indicatorThickness,
              underlineColor: indicator,
              indicatorColor: indicator,
              // Resting fill is local so cold start never waits on measure.
              // Hide it while the liquid overlay is traveling.
              showRestingPill: !_traveling,
              onTap: () => widget.onDestinationSelected?.call(i),
            ),
          ),
      ],
    );

    final Widget body = usePill
        ? M3ENavSelectionIndicator(
            selectedIndex: widget.selectedIndex,
            targetKeys: _keys,
            axis: Axis.horizontal,
            color: indicator,
            layoutToken: bottomInset,
            onTravelingChanged: _onTravelingChanged,
            child: destinationsRow,
          )
        : destinationsRow;

    Widget nav = Material(
      color: bg,
      elevation: widget.elevation ?? 0,
      shape: shape,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SizedBox(
          height: height,
          child: body,
        ),
      ),
    );

    nav = Padding(
      padding: widget.padding ?? EdgeInsets.zero,
      child: nav,
    );

    if (widget.semanticLabel != null) {
      nav = Semantics(
        container: true,
        label: widget.semanticLabel,
        child: nav,
      );
    }
    return nav;
  }
}
