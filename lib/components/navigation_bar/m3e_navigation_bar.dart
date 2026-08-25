import 'package:flutter/scheduler.dart';
import 'package:material_ui/material_ui.dart';

import '../../../foundations/foundations.dart';
import '../navigation_rail/components/m3e_nav_selection_indicator.dart';
import 'components/m3e_nav_bar_destination_button.dart';
import 'enums/m3e_nav_bar_enums.dart';
import 'models/m3e_nav_metrics.dart';
import 'models/m3e_navigation_bar_destination.dart';
import 'styles/m3e_navigation_bar_theme.dart';

export 'enums/m3e_nav_bar_enums.dart';
export 'models/m3e_nav_metrics.dart';
export 'models/m3e_navigation_bar_destination.dart';
export 'styles/m3e_navigation_bar_theme.dart';

/// A Material 3 Expressive navigation bar.
///
/// Pill selection uses a lead/trail spring indicator that stretches between
/// destinations (spatial springs motion spec).
class M3ENavigationBar extends StatefulWidget {
  /// M3ENavigationBar.
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

  /// destinations.

  final List<M3ENavigationBarDestination> destinations;

  /// selectedIndex.
  final int selectedIndex;

  /// onDestinationSelected.
  final ValueChanged<int>? onDestinationSelected;

  /// labelBehavior.

  final M3ENavBarLabelBehavior labelBehavior;

  /// size.
  final M3ENavBarSize size;

  /// shapeFamily.
  final M3ENavBarShapeFamily shapeFamily;

  /// density.
  final M3ENavBarDensity density;

  /// backgroundColor.

  final Color? backgroundColor;

  /// elevation.
  final double? elevation;

  /// indicatorStyle.

  final M3ENavBarIndicatorStyle indicatorStyle;

  /// indicatorColor.
  final Color? indicatorColor;

  /// padding.

  final EdgeInsetsGeometry? padding;

  /// safeArea.
  final bool safeArea;

  /// semanticLabel.

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
    // Indicator may notify from a motion status during build; defer rebuild.
    final SchedulerPhase phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks) {
      setState(() => _traveling = traveling);
      return;
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _traveling == traveling) {
        return;
      }
      setState(() => _traveling = traveling);
    });
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
    final double bottomInset = widget.safeArea
        ? M3ESafeArea.bottomOf(context)
        : 0.0;
    final Color indicator =
        widget.indicatorColor ?? navTheme.indicatorColor(scheme);
    final Widget body = _buildDestinationsBody(
      m3e: m3e,
      navTheme: navTheme,
      scheme: scheme,
      metrics: metrics,
      indicator: indicator,
      bottomInset: bottomInset,
    );

    Widget nav = Material(
      color: bg,
      elevation: widget.elevation ?? 0,
      shape: shape,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SizedBox(height: height, child: body),
      ),
    );
    nav = Padding(padding: widget.padding ?? EdgeInsets.zero, child: nav);
    if (widget.semanticLabel != null) {
      nav = Semantics(container: true, label: widget.semanticLabel, child: nav);
    }
    return nav;
  }

  Widget _buildDestinationsBody({
    required M3EThemeData m3e,
    required M3ENavigationBarTheme navTheme,
    required M3EColorScheme scheme,
    required M3ENavMetrics metrics,
    required Color indicator,
    required double bottomInset,
  }) {
    final Color selected = navTheme.selectedColor(scheme);
    final Color unselected = navTheme.unselectedColor(scheme);
    final TextStyle labelBase = navTheme.labelStyle(m3e.typeScale);
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
              showRestingPill: !_traveling,
              onTap: () => widget.onDestinationSelected?.call(i),
            ),
          ),
      ],
    );
    if (widget.indicatorStyle != M3ENavBarIndicatorStyle.pill) {
      return destinationsRow;
    }
    // Include bar width so horizontal window resize invalidates geometry
    // (bottomInset alone does not change when only width changes).
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return M3ENavSelectionIndicator(
          selectedIndex: widget.selectedIndex,
          targetKeys: _keys,
          axis: Axis.horizontal,
          color: indicator,
          layoutToken: (bottomInset, constraints.maxWidth),
          onTravelingChanged: _onTravelingChanged,
          child: destinationsRow,
        );
      },
    );
  }
}
