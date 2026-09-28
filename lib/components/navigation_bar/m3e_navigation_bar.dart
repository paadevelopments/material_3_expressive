import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../foundations/foundations.dart';
import 'components/m3e_nav_bar_destination_button.dart';
import 'controllers/m3e_navigation_bar_controller.dart';
import 'enums/m3e_nav_bar_enums.dart';
import 'models/m3e_nav_metrics.dart';
import 'models/m3e_navigation_bar_destination.dart';
import 'styles/m3e_navigation_bar_theme.dart';

export 'controllers/m3e_navigation_bar_controller.dart';
export 'enums/m3e_nav_bar_enums.dart';
export 'models/m3e_nav_metrics.dart';
export 'models/m3e_navigation_bar_destination.dart';
export 'res/m3e_nav_bar_constants.dart';
export 'styles/m3e_navigation_bar_theme.dart';

/// A Material 3 Expressive navigation bar.
///
/// The flexible size is 64. The baseline size is 80. Vertical items share the
/// width and keep the pill behind the icon. Horizontal items turn on in a
/// medium window, or when [layout] is [M3ENavBarLayout.wide]. Arrow keys move
/// focus. Space or Enter selects, including the active destination.
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
    this.controller,
    this.hideOnScroll = false,
    this.scrollController,
  });

  /// destinations.
  final List<M3ENavigationBarDestination> destinations;

  /// selectedIndex.
  final int selectedIndex;

  /// Called when a destination is chosen, including the active one.
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

  /// Auto-layout width threshold. When null, uses the theme breakpoint
  /// (600).
  final double? wideBreakpoint;

  /// Width of each horizontal destination. When null, every item uses the
  /// widest icon-plus-label content.
  final double? wideDestinationWidth;

  /// Flexible [M3ENavBarSize.small] or baseline [M3ENavBarSize.medium].
  ///
  /// Defaults to the baseline bar.
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

  /// When true, the system navigation inset is padding inside the bar.
  final bool safeArea;

  /// semanticLabel.
  final String? semanticLabel;

  /// Optional selection and visibility controller.
  final M3ENavigationBarController? controller;

  /// When true, [scrollController] hides the bar on a downward scroll.
  final bool hideOnScroll;

  /// Body scroll position. A bottom bar is not inside that scroll view.
  final ScrollController? scrollController;

  @override
  State<M3ENavigationBar> createState() => _M3ENavigationBarState();
}

class _M3ENavigationBarState extends State<M3ENavigationBar> {
  final List<FocusNode> _nodes = <FocusNode>[];
  M3ENavigationBarController? _bound;
  ScrollController? _scroll;
  late final ValueChanged<int> _controllerSelect = _selectFromController;
  bool _inside = false;
  bool _redirecting = false;
  int _focusIndex = 0;
  bool _visible = true;

  int get _selected {
    if (widget.destinations.isEmpty) {
      return 0;
    }
    return widget.selectedIndex.clamp(0, widget.destinations.length - 1);
  }

  @override
  void initState() {
    super.initState();
    _focusIndex = widget.selectedIndex;
    _syncNodes();
    _bindScroll();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bindController();
  }

  @override
  void didUpdateWidget(covariant M3ENavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destinations.length != widget.destinations.length) {
      _syncNodes();
    }
    if (oldWidget.controller != widget.controller) {
      _bindController();
    } else {
      _bound?.updateIndex(_selected);
    }
    if (oldWidget.scrollController != widget.scrollController ||
        oldWidget.hideOnScroll != widget.hideOnScroll) {
      _bindScroll();
    }
    if (!_inside) {
      _focusIndex = _selected;
    }
  }

  @override
  void dispose() {
    _bound?.removeListener(_onController);
    _bound?.detach(_controllerSelect);
    _scroll?.removeListener(_onScroll);
    for (final FocusNode node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _syncNodes() {
    final int count = widget.destinations.length;
    while (_nodes.length < count) {
      _nodes.add(
        FocusNode(debugLabel: 'nav ${_nodes.length}')..addListener(_onFocus),
      );
    }
    while (_nodes.length > count) {
      _nodes.removeLast()
        ..removeListener(_onFocus)
        ..dispose();
    }
    if (_nodes.isEmpty) {
      _focusIndex = 0;
      return;
    }
    _focusIndex = _focusIndex.clamp(0, _nodes.length - 1);
  }

  void _bindController() {
    final M3ENavigationBarController? next = widget.controller;
    if (identical(_bound, next)) {
      _bound?.updateIndex(_selected);
      return;
    }
    _bound?.removeListener(_onController);
    _bound?.detach(_controllerSelect);
    _bound = next;
    next?.attach(_controllerSelect, _selected);
    next?.addListener(_onController);
  }

  void _bindScroll() {
    final ScrollController? next = widget.hideOnScroll
        ? widget.scrollController
        : null;
    if (identical(_scroll, next)) {
      return;
    }
    _scroll?.removeListener(_onScroll);
    _scroll = next;
    _scroll?.addListener(_onScroll);
  }

  void _selectFromController(int index) {
    widget.onDestinationSelected?.call(index);
  }

  void _onController() {
    if (!mounted) {
      return;
    }
    final bool visible = _bound?.visible ?? _visible;
    if (visible == _visible) {
      return;
    }
    setState(() => _visible = visible);
  }

  void _onScroll() {
    if (!mounted || !widget.hideOnScroll) {
      return;
    }
    final ScrollController? scroll = _scroll;
    if (scroll == null || !scroll.hasClients) {
      return;
    }
    if (MediaQuery.accessibleNavigationOf(context)) {
      _applyVisible(true);
      return;
    }
    final ScrollDirection direction = scroll.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      _applyVisible(false);
    } else if (direction == ScrollDirection.forward) {
      _applyVisible(true);
    }
  }

  void _applyVisible(bool visible) {
    final M3ENavigationBarController? bound = _bound;
    if (bound != null) {
      bound.updateVisible(visible: visible);
      return;
    }
    if (_visible == visible) {
      return;
    }
    setState(() => _visible = visible);
  }

  bool _shown(BuildContext context) {
    if (!widget.hideOnScroll) {
      return true;
    }
    if (MediaQuery.accessibleNavigationOf(context)) {
      return true;
    }
    return _bound?.visible ?? _visible;
  }

  void _onFocus() {
    if (!mounted || _redirecting || _nodes.isEmpty) {
      return;
    }
    final bool any = _nodes.any((FocusNode node) => node.hasFocus);
    if (!any) {
      if (!_inside) {
        return;
      }
      setState(() {
        _inside = false;
        _focusIndex = _selected;
      });
      return;
    }
    final int focused = _nodes.indexWhere((FocusNode node) => node.hasFocus);
    if (!_inside) {
      _inside = true;
      if (focused != _selected) {
        _redirecting = true;
        _focusIndex = _selected;
        _nodes[_selected].requestFocus();
        _redirecting = false;
        setState(() {});
        return;
      }
    }
    if (focused >= 0 && focused != _focusIndex) {
      setState(() => _focusIndex = focused);
    }
  }

  void _move(int delta) {
    final int current = _nodes.indexWhere((FocusNode node) => node.hasFocus);
    if (current < 0) {
      return;
    }
    final int next = current + delta;
    if (next < 0 || next >= _nodes.length) {
      return;
    }
    setState(() {
      _inside = true;
      _focusIndex = next;
    });
    _nodes[next].requestFocus();
  }

  bool _tabStop(int index) {
    if (_inside) {
      return index == _focusIndex;
    }
    return index == _selected;
  }

  M3ENavBarLayout _resolveLayout(double maxWidth, M3ENavigationBarTheme theme) {
    if (!widget.autoLayout) {
      return widget.layout;
    }
    final double breakpoint = widget.wideBreakpoint ?? theme.wideBreakpoint;
    return maxWidth >= breakpoint
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

  bool _showsIcon(M3ENavigationBarDestination destination, bool selected) {
    if (!destination.hasIcon) {
      return false;
    }
    return switch (widget.iconBehavior) {
      M3ENavBarIconBehavior.alwaysShow => true,
      M3ENavBarIconBehavior.onlySelected => selected,
      M3ENavBarIconBehavior.alwaysHide => false,
    };
  }

  bool _showsLabel(M3ENavigationBarDestination destination, bool selected) {
    if (!destination.hasLabel) {
      return false;
    }
    return switch (widget.labelBehavior) {
      M3ENavBarLabelBehavior.alwaysShow => true,
      M3ENavBarLabelBehavior.onlySelected => selected,
      M3ENavBarLabelBehavior.alwaysHide => false,
    };
  }

  double _textWidth(String text, TextStyle style, TextScaler scaler) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textScaler: scaler,
      maxLines: 1,
      textDirection: Directionality.of(context),
    )..layout();
    final double width = painter.width;
    painter.dispose();
    return width;
  }

  double _textHeight(
    String text,
    TextStyle style,
    TextScaler scaler,
    int maxLines,
    double maxWidth,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textScaler: scaler,
      maxLines: maxLines,
      textDirection: Directionality.of(context),
    )..layout(maxWidth: math.max(1, maxWidth));
    final double height = painter.height;
    painter.dispose();
    return height;
  }

  double _slotWidth(
    M3ENavigationBarTheme theme,
    TextStyle style,
    TextScaler scaler,
  ) {
    final double? forced = widget.wideDestinationWidth;
    if (forced != null) {
      return forced;
    }
    var widest = 0.0;
    for (final M3ENavigationBarDestination destination in widget.destinations) {
      double widthFor({required bool icon, required bool label}) {
        var width = theme.horizontalIndicatorInset * 2;
        if (icon) {
          width += theme.iconSize;
        }
        if (icon && label) {
          width += theme.horizontalIconLabelGap;
        }
        if (label) {
          width += _textWidth(destination.label!, style, scaler);
        }
        return width;
      }

      widest = math.max(
        widest,
        math.max(
          widthFor(
            icon: _showsIcon(destination, true),
            label: _showsLabel(destination, true),
          ),
          widthFor(
            icon: _showsIcon(destination, false),
            label: _showsLabel(destination, false),
          ),
        ),
      );
    }
    return widest;
  }

  double _labelBlock({
    required bool wide,
    required double cellWidth,
    required M3ENavigationBarTheme theme,
    required TextStyle style,
    required TextScaler scaler,
    required int maxLines,
  }) {
    var tallest = 0.0;
    for (final M3ENavigationBarDestination destination in widget.destinations) {
      if (!_showsLabel(destination, true) && !_showsLabel(destination, false)) {
        continue;
      }
      final bool icon = _showsIcon(destination, true);
      final double maxWidth = wide
          ? cellWidth -
                theme.horizontalIndicatorInset * 2 -
                (icon ? theme.iconSize + theme.horizontalIconLabelGap : 0)
          : cellWidth;
      tallest = math.max(
        tallest,
        _textHeight(destination.label!, style, scaler, maxLines, maxWidth),
      );
    }
    return tallest;
  }

  ({double top, double bottom}) _bandPadding(
    M3ENavigationBarTheme theme,
    bool wide,
  ) {
    final double extra = widget.size == M3ENavBarSize.medium
        ? theme.baselineExtraPadding
        : 0;
    var top =
        (wide ? theme.horizontalPadding : theme.verticalPaddingTop) + extra;
    var bottom =
        (wide ? theme.horizontalPadding : theme.verticalPaddingBottom) + extra;
    if (widget.density == M3ENavBarDensity.compact) {
      final double cut = theme.compactHeightReduction / 2;
      top = math.max(0, top - cut);
      bottom = math.max(0, bottom - cut);
    }
    return (top: top, bottom: bottom);
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.destinations.isNotEmpty, 'Provide at least one destination');
    return M3EComponentTheme(builder: _buildNavigationBar);
  }

  Widget _buildNavigationBar(BuildContext context) {
    final M3EThemeData m3e = M3ETheme.of(context);
    final M3ENavigationBarTheme theme = m3e.navigationBarTheme;
    final M3EColorScheme scheme = m3e.colorScheme;
    final M3ENavMetrics metrics = theme.metrics(widget.density, m3e.spacing);
    final Color background =
        widget.backgroundColor ?? theme.containerColor(scheme);
    final ShapeBorder shape = theme.containerShape(widget.shapeFamily);
    final double bottomInset = widget.safeArea
        ? M3ESafeArea.bottomOf(context)
        : 0.0;
    final Color indicator =
        widget.indicatorColor ?? theme.indicatorColor(scheme);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final bool shown = _shown(context);

    Widget nav = Material(
      color: background,
      elevation: widget.elevation ?? theme.elevation,
      shadowColor: theme.shadowColor(scheme),
      surfaceTintColor: const Color(0x00000000),
      shape: shape,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return _buildBand(
              context,
              m3e: m3e,
              theme: theme,
              scheme: scheme,
              metrics: metrics,
              indicator: indicator,
              maxWidth: constraints.maxWidth,
            );
          },
        ),
      ),
    );
    nav = Padding(padding: widget.padding ?? EdgeInsets.zero, child: nav);
    nav = CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
            _move(rtl ? 1 : -1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
            _move(rtl ? -1 : 1),
      },
      child: ClipRect(
        child: AnimatedAlign(
          alignment: Alignment.bottomCenter,
          heightFactor: shown ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: nav,
        ),
      ),
    );
    nav = ExcludeSemantics(excluding: !shown, child: nav);
    if (widget.semanticLabel != null) {
      nav = Semantics(container: true, label: widget.semanticLabel, child: nav);
    }
    return nav;
  }

  Widget _buildBand(
    BuildContext context, {
    required M3EThemeData m3e,
    required M3ENavigationBarTheme theme,
    required M3EColorScheme scheme,
    required M3ENavMetrics metrics,
    required Color indicator,
    required double maxWidth,
  }) {
    final wide = _resolveLayout(maxWidth, theme) == M3ENavBarLayout.wide;
    final TextScaler scaler = MediaQuery.textScalerOf(context);
    final double scale = theme.labelFontSize == 0
        ? 1
        : scaler.scale(theme.labelFontSize) / theme.labelFontSize;
    final int maxLines = scale <= 1
        ? theme.restingLabelMaxLines
        : theme.scaledLabelMaxLines;
    final TextOverflow overflow = scale > theme.truncationTextScale
        ? TextOverflow.ellipsis
        : TextOverflow.clip;
    final TextStyle measure = theme.labelStyle(m3e.typeScale, selected: true);
    final TextStyle label = theme.labelStyle(m3e.typeScale);
    final double slot = _slotWidth(theme, measure, scaler);
    final double cell = wide
        ? slot
        : maxWidth / math.max(1, widget.destinations.length);
    final double labelHeight = _labelBlock(
      wide: wide,
      cellWidth: cell,
      theme: theme,
      style: measure,
      scaler: scaler,
      maxLines: maxLines,
    );
    final ({double top, double bottom}) pad = _bandPadding(theme, wide);
    final double indicatorHeight = wide
        ? math.max(theme.horizontalIndicatorHeight, labelHeight)
        : theme.verticalIndicatorHeight;
    final double natural = wide
        ? pad.top + indicatorHeight + pad.bottom
        : pad.top +
              theme.verticalIndicatorHeight +
              (labelHeight > 0 ? theme.verticalIconLabelGap : 0) +
              labelHeight +
              pad.bottom;
    var minHeight = widget.size == M3ENavBarSize.small
        ? theme.heightSmall
        : theme.heightMedium;
    if (widget.density == M3ENavBarDensity.compact) {
      minHeight -= theme.compactHeightReduction;
    }
    final double height = math.max(minHeight, natural);
    final double radius = wide
        ? indicatorHeight / 2
        : theme.verticalIndicatorRadius;
    final EdgeInsetsGeometry edgeInset = !wide
        ? EdgeInsets.zero
        : switch (widget.alignment) {
            M3ENavBarAlignment.start => EdgeInsetsDirectional.only(
              start: theme.wideEdgePadding,
            ),
            M3ENavBarAlignment.end => EdgeInsetsDirectional.only(
              end: theme.wideEdgePadding,
            ),
            M3ENavBarAlignment.center => EdgeInsets.zero,
          };

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Padding(
        padding: edgeInset,
        child: Row(
          spacing: wide ? theme.wideItemGap : theme.itemGap,
          mainAxisAlignment: wide
              ? _wideMainAxisAlignment()
              : MainAxisAlignment.start,
          children: <Widget>[
            for (int i = 0; i < widget.destinations.length; i++)
              if (wide)
                SizedBox(
                  width: slot,
                  child: _button(
                    index: i,
                    theme: theme,
                    scheme: scheme,
                    metrics: metrics,
                    indicator: indicator,
                    label: label,
                    wide: true,
                    slot: slot,
                    indicatorHeight: indicatorHeight,
                    radius: radius,
                    pad: pad,
                    maxLines: maxLines,
                    overflow: overflow,
                  ),
                )
              else
                Expanded(
                  child: _button(
                    index: i,
                    theme: theme,
                    scheme: scheme,
                    metrics: metrics,
                    indicator: indicator,
                    label: label,
                    wide: false,
                    slot: slot,
                    indicatorHeight: indicatorHeight,
                    radius: radius,
                    pad: pad,
                    maxLines: maxLines,
                    overflow: overflow,
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _button({
    required int index,
    required M3ENavigationBarTheme theme,
    required M3EColorScheme scheme,
    required M3ENavMetrics metrics,
    required Color indicator,
    required TextStyle label,
    required bool wide,
    required double slot,
    required double indicatorHeight,
    required double radius,
    required ({double top, double bottom}) pad,
    required int maxLines,
    required TextOverflow overflow,
  }) {
    return M3ENavBarDestinationButton(
      destination: widget.destinations[index],
      selected: index == _selected,
      selectedColor: theme.selectedColor(scheme),
      activeLabelColor: theme.activeLabelColor(scheme),
      unselectedColor: theme.unselectedColor(scheme),
      labelStyle: label,
      iconSize: metrics.iconSize,
      labelBehavior: widget.labelBehavior,
      iconBehavior: widget.iconBehavior,
      layout: wide ? M3ENavBarLayout.wide : M3ENavBarLayout.compact,
      indicatorStyle: widget.indicatorStyle,
      indicatorWidth: theme.verticalIndicatorWidth,
      indicatorHeight: indicatorHeight,
      indicatorRadius: radius,
      contentPadding: EdgeInsets.only(top: pad.top, bottom: pad.bottom),
      iconLabelGap: wide
          ? theme.horizontalIconLabelGap
          : theme.verticalIconLabelGap,
      labelMaxLines: maxLines,
      labelOverflow: overflow,
      wideDestinationWidth: wide ? slot : null,
      horizontalInset: wide ? theme.horizontalIndicatorInset : 0,
      underlineThickness: metrics.indicatorThickness,
      underlineColor: indicator,
      indicatorColor: indicator,
      focusNode: _nodes[index],
      skipTraversal: !_tabStop(index),
      onTap: () => widget.onDestinationSelected?.call(index),
    );
  }
}
