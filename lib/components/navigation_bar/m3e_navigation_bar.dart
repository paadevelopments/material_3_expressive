import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:material_ui/material_ui.dart';

import '../../../foundations/foundations.dart';
import '../navigation_rail/components/m3e_nav_selection_indicator.dart';
import 'components/m3e_nav_bar_destination_button.dart';
import 'enums/m3e_nav_bar_enums.dart';
import 'models/m3e_nav_metrics.dart';
import 'models/m3e_navigation_bar_destination.dart';
import 'res/m3e_nav_bar_constants.dart';
import 'styles/m3e_navigation_bar_theme.dart';

export 'enums/m3e_nav_bar_enums.dart';
export 'models/m3e_nav_metrics.dart';
export 'models/m3e_navigation_bar_destination.dart';
export 'res/m3e_nav_bar_constants.dart';
export 'styles/m3e_navigation_bar_theme.dart';

/// A Material 3 Expressive navigation bar.
///
/// Pill selection uses a lead/trail spring indicator that stretches between
/// destinations (spatial springs motion spec).
///
/// When [autoLayout] is true (default), the bar switches to
/// [M3ENavBarLayout.wide] once its own width reaches the effective breakpoint
/// ([wideBreakpoint], or [M3ENavBarConstants.minWideBarWidth] for the current
/// destinations and [wideDestinationWidth]). Wide mode keeps the bar full
/// width and only aligns the destination group via [alignment]. Each wide
/// destination uses a fixed chip width so the fluid pill never clips when
/// icons/labels appear or disappear.
class M3ENavigationBar extends StatefulWidget {
  /// M3ENavigationBar.
  const M3ENavigationBar({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.onDestinationSelected,
    this.labelBehavior = M3ENavBarLabelBehavior.alwaysShow,
    this.iconBehavior = M3ENavBarIconBehavior.alwaysShow,
    this.autoLayout = true,
    this.layout = M3ENavBarLayout.compact,
    this.alignment = M3ENavBarAlignment.center,
    this.wideBreakpoint,
    this.wideDestinationWidth,
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

  /// iconBehavior.
  final M3ENavBarIconBehavior iconBehavior;

  /// When true, pick compact vs wide from the bar’s own width.
  final bool autoLayout;

  /// Used only when [autoLayout] is false.
  final M3ENavBarLayout layout;

  /// Destination-group placement in wide layout (bar stays full width).
  final M3ENavBarAlignment alignment;

  /// Auto-layout width threshold. When null, uses
  /// [M3ENavBarConstants.minWideBarWidth] for [destinations] and
  /// [wideDestinationWidth] so wide mode only activates when all chips fit.
  final double? wideBreakpoint;

  /// Fixed width of each destination chip in wide layout. When null, uses
  /// [M3ENavBarConstants.wideDestinationWidth].
  final double? wideDestinationWidth;

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

  double get _resolvedWideDestinationWidth =>
      widget.wideDestinationWidth ?? M3ENavBarConstants.wideDestinationWidth;

  double get _resolvedWideBreakpoint =>
      widget.wideBreakpoint ??
      M3ENavBarConstants.minWideBarWidth(
        widget.destinations.length,
        itemWidth: _resolvedWideDestinationWidth,
      );

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

  M3ENavBarLayout _resolveLayout(double maxWidth) {
    if (!widget.autoLayout) {
      return widget.layout;
    }
    return maxWidth >= _resolvedWideBreakpoint
        ? M3ENavBarLayout.wide
        : M3ENavBarLayout.compact;
  }

  MainAxisAlignment _wideMainAxisAlignment() {
    return switch (widget.alignment) {
      M3ENavBarAlignment.start => MainAxisAlignment.start,
      M3ENavBarAlignment.center => MainAxisAlignment.center,
      M3ENavBarAlignment.end => MainAxisAlignment.end,
    };
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

    Widget nav = Material(
      color: bg,
      elevation: widget.elevation ?? 0,
      shape: shape,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final M3ENavBarLayout effective = _resolveLayout(
                constraints.maxWidth,
              );
              return _buildDestinationsBody(
                m3e: m3e,
                navTheme: navTheme,
                scheme: scheme,
                metrics: metrics,
                indicator: indicator,
                bottomInset: bottomInset,
                barWidth: constraints.maxWidth,
                barHeight: height,
                layout: effective,
              );
            },
          ),
        ),
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
    required double barWidth,
    required double barHeight,
    required M3ENavBarLayout layout,
  }) {
    final Color selected = navTheme.selectedColor(scheme);
    final Color unselected = navTheme.unselectedColor(scheme);
    final TextStyle labelBase = navTheme.labelStyle(m3e.typeScale);
    final Widget destinationsRow = layout == M3ENavBarLayout.wide
        ? _buildWideRow(
            selected: selected,
            unselected: unselected,
            labelBase: labelBase,
            metrics: metrics,
            indicator: indicator,
            barHeight: barHeight,
          )
        : _buildCompactRow(
            selected: selected,
            unselected: unselected,
            labelBase: labelBase,
            metrics: metrics,
            indicator: indicator,
          );

    if (widget.indicatorStyle != M3ENavBarIndicatorStyle.pill) {
      return destinationsRow;
    }
    // Remeasure whenever geometry-affecting specs change (alignment, behaviors,
    // size, etc.) — not only width / compact↔wide.
    return M3ENavSelectionIndicator(
      selectedIndex: widget.selectedIndex,
      targetKeys: _keys,
      axis: Axis.horizontal,
      color: indicator,
      layoutSettleDuration: M3ENavBarConstants.layoutSettleDuration,
      layoutToken: (
        bottomInset,
        barWidth,
        layout,
        barHeight,
        widget.alignment,
        widget.labelBehavior,
        widget.iconBehavior,
        widget.size,
        widget.density,
        widget.indicatorStyle,
        widget.destinations.length,
        _resolvedWideDestinationWidth,
        _resolvedWideBreakpoint,
      ),
      onTravelingChanged: _onTravelingChanged,
      child: destinationsRow,
    );
  }

  Widget _buildCompactRow({
    required Color selected,
    required Color unselected,
    required TextStyle labelBase,
    required M3ENavMetrics metrics,
    required Color indicator,
  }) {
    return Row(
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
              iconBehavior: widget.iconBehavior,
              layout: M3ENavBarLayout.compact,
              indicatorStyle: widget.indicatorStyle,
              indicatorKey: _keys[i],
              indicatorWidth: M3ENavBarConstants.compactIndicatorWidth,
              indicatorHeight: M3ENavBarConstants.indicatorHeight,
              underlineThickness: metrics.indicatorThickness,
              underlineColor: indicator,
              indicatorColor: indicator,
              showRestingPill: !_traveling,
              onTap: () => widget.onDestinationSelected?.call(i),
            ),
          ),
      ],
    );
  }

  Widget _buildWideRow({
    required Color selected,
    required Color unselected,
    required TextStyle labelBase,
    required M3ENavMetrics metrics,
    required Color indicator,
    required double barHeight,
  }) {
    // Content SizedBox height already excludes system-nav bottom inset.
    final double widePillHeight = math.max(
      M3ENavBarConstants.indicatorHeight,
      barHeight - M3ENavBarConstants.wideIndicatorHeightReduction,
    );
    final double chipWidth = _resolvedWideDestinationWidth;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: M3ENavBarConstants.wideBarHorizontalPadding,
      ),
      child: Row(
        mainAxisAlignment: _wideMainAxisAlignment(),
        children: <Widget>[
          for (int i = 0; i < widget.destinations.length; i++) ...<Widget>[
            if (i > 0)
              const SizedBox(width: M3ENavBarConstants.wideDestinationGap),
            M3ENavBarDestinationButton(
              destination: widget.destinations[i],
              selected: i == widget.selectedIndex,
              selectedColor: selected,
              unselectedColor: unselected,
              labelStyle: labelBase,
              iconSize: metrics.iconSize,
              labelBehavior: widget.labelBehavior,
              iconBehavior: widget.iconBehavior,
              layout: M3ENavBarLayout.wide,
              indicatorStyle: widget.indicatorStyle,
              indicatorKey: _keys[i],
              indicatorWidth: M3ENavBarConstants.compactIndicatorWidth,
              indicatorHeight: widePillHeight,
              wideDestinationWidth: chipWidth,
              underlineThickness: metrics.indicatorThickness,
              underlineColor: indicator,
              indicatorColor: indicator,
              showRestingPill: !_traveling,
              onTap: () => widget.onDestinationSelected?.call(i),
            ),
          ],
        ],
      ),
    );
  }
}
