import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../../foundations/foundations.dart';
import '../badges/m3e_badges.dart';
import 'controllers/m3e_tabs_controller.dart';
import 'enums/m3e_tabs_alignment.dart';
import 'enums/m3e_tabs_variant.dart';
import 'models/m3e_tab.dart';
import 'styles/m3e_tab_theme.dart';

export 'controllers/m3e_tabs_controller.dart';
export 'enums/m3e_tabs_alignment.dart';
export 'enums/m3e_tabs_variant.dart';
export 'm3e_tabs_view.dart';
export 'models/m3e_tab.dart';
export 'styles/m3e_tab_theme.dart';

/// A Material 3 tab bar.
///
/// Primary tabs stack an optional icon above the label. Secondary tabs place
/// an optional icon before the label. The active indicator springs to the
/// selected tab. Arrow keys move focus. Space or Enter selects.
class M3ETabs extends StatefulWidget {
  /// A fixed bar. Set [scrollable] to force or forbid horizontal scrolling.
  const M3ETabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.variant = M3ETabsVariant.primary,
    this.scrollable,
    this.alignment = M3ETabsAlignment.fill,
    this.controller,
    super.key,
  }) : assert(tabs.length >= 2, 'A tab bar needs 2+ tabs.'),
       floating = false,
       _sliver = false;

  /// A bar inside a [CustomScrollView].
  ///
  /// When [floating] is true the bar scrolls away and returns on an upward
  /// scroll. When false it stays pinned at the top of the scroll view.
  const M3ETabs.sliver({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.variant = M3ETabsVariant.primary,
    this.scrollable,
    this.alignment = M3ETabsAlignment.fill,
    this.controller,
    this.floating = true,
    super.key,
  }) : assert(tabs.length >= 2, 'A tab bar needs 2+ tabs.'),
       _sliver = true;

  /// Tabs, left to right in LTR.
  final List<M3ETab> tabs;

  /// Selected index.
  final int selectedIndex;

  /// Called when a tab is chosen.
  final ValueChanged<int> onTabSelected;

  /// Primary or secondary.
  final M3ETabsVariant variant;

  /// Forces scrollable tabs when true, and equal slots when false.
  ///
  /// Null scrolls only when a label does not fit its equal slot.
  final bool? scrollable;

  /// How fixed tabs share the width. Ignored while scrolling.
  final M3ETabsAlignment alignment;

  /// Optional selection controller.
  final M3ETabsController? controller;

  /// Whether a sliver bar scrolls away and returns.
  final bool floating;

  final bool _sliver;

  @override
  State<M3ETabs> createState() => _M3ETabsState();
}

class _M3ETabsState extends State<M3ETabs> with TickerProviderStateMixin {
  final GlobalKey _barKey = GlobalKey();
  final ScrollController _scroll = ScrollController();
  late final SingleMotionController _indicatorLeft;
  late final SingleMotionController _indicatorWidth;
  late final ValueChanged<int> _controllerSelect = _selectFromController;

  late List<GlobalKey> _slotKeys;
  late List<GlobalKey> _contentKeys;
  late List<FocusNode> _nodes;

  M3ETabsController? _bound;
  bool _placed = false;
  bool _inside = false;
  bool _redirecting = false;

  @override
  void initState() {
    super.initState();
    final spring = SpringMotion(M3EMotion.spatialDefault.toDescription());
    _indicatorLeft = SingleMotionController(motion: spring, vsync: this);
    _indicatorWidth = SingleMotionController(motion: spring, vsync: this);
    _alloc(widget.tabs.length);
    _scheduleMeasure();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bindController();
  }

  @override
  void didUpdateWidget(covariant M3ETabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      _disposeNodes();
      _alloc(widget.tabs.length);
      _placed = false;
    }
    if (oldWidget.controller != widget.controller) {
      _bindController();
    } else {
      _bound?.updateIndex(_index);
    }
    _scheduleMeasure();
  }

  @override
  void dispose() {
    _bound?.detach(_controllerSelect);
    _disposeNodes();
    _indicatorLeft.dispose();
    _indicatorWidth.dispose();
    _scroll.dispose();
    super.dispose();
  }

  int get _index => widget.selectedIndex.clamp(0, widget.tabs.length - 1);

  void _alloc(int count) {
    _slotKeys = List<GlobalKey>.generate(count, (_) => GlobalKey());
    _contentKeys = List<GlobalKey>.generate(count, (_) => GlobalKey());
    _nodes = List<FocusNode>.generate(count, (int i) {
      return FocusNode(debugLabel: 'tab $i')..addListener(() => _onFocus(i));
    });
  }

  void _disposeNodes() {
    for (final FocusNode node in _nodes) {
      node.dispose();
    }
  }

  void _bindController() {
    final M3ETabsController? next = widget.controller;
    if (identical(_bound, next)) {
      _bound?.updateIndex(_index);
      return;
    }
    _bound?.detach(_controllerSelect);
    _bound = next;
    next?.attach(_controllerSelect, _index);
  }

  void _selectFromController(int index) {
    widget.onTabSelected(index);
  }

  void _scheduleMeasure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _measure();
      }
    });
  }

  void _measure() {
    final bar = _barKey.currentContext?.findRenderObject() as RenderBox?;
    if (bar == null || !bar.hasSize) {
      return;
    }
    final theme = M3ETheme.of(context).tabTheme;
    final full = theme.indicatorFullWidth(widget.variant);
    final key = full ? _slotKeys[_index] : _contentKeys[_index];
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return;
    }
    final Offset origin = box.localToGlobal(Offset.zero, ancestor: bar);
    final double scroll = _scroll.hasClients ? _scroll.offset : 0;
    late final double left;
    late final double width;
    if (full) {
      left = origin.dx + scroll;
      width = box.size.width;
    } else {
      final double inset = theme.indicatorInset;
      final double raw = box.size.width - inset * 2;
      width = math.max(theme.indicatorMinLength, raw);
      left = origin.dx + scroll + (box.size.width - width) / 2;
    }
    final spring = SpringMotion(theme.indicatorSpring.toDescription());
    _indicatorLeft.motion = spring;
    _indicatorWidth.motion = spring;
    if (!_placed) {
      _indicatorLeft.value = left;
      _indicatorWidth.value = width;
      _placed = true;
      return;
    }
    if ((_indicatorLeft.value - left).abs() > 0.5) {
      _indicatorLeft.animateTo(left);
    }
    if ((_indicatorWidth.value - width).abs() > 0.5) {
      _indicatorWidth.animateTo(width);
    }
  }

  void _onFocus(int index) {
    final bool any = _nodes.any((FocusNode node) => node.hasFocus);
    if (!any) {
      _inside = false;
      return;
    }
    if (_redirecting) {
      _reveal(index);
      return;
    }
    if (!_inside) {
      _inside = true;
      if (index != _index) {
        _redirecting = true;
        _nodes[_index].requestFocus();
        _redirecting = false;
        return;
      }
    }
    _reveal(index);
  }

  void _reveal(int index) {
    final BuildContext? target = _slotKeys[index].currentContext;
    if (target == null) {
      return;
    }
    Scrollable.ensureVisible(
      target,
      alignment: 0.5,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
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
    _inside = true;
    _nodes[next].requestFocus();
  }

  bool _stacked(M3ETabTheme theme) {
    if (widget.variant != M3ETabsVariant.primary) {
      return false;
    }
    return widget.tabs.any(
      (M3ETab tab) => tab.icon != null && tab.label != null,
    );
  }

  double _contentWidth(M3ETab tab, TextStyle style, M3ETabTheme theme) {
    var textWidth = 0.0;
    final String? label = tab.label;
    if (label != null) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        maxLines: 1,
        textDirection: Directionality.of(context),
      )..layout();
      textWidth = painter.width;
      painter.dispose();
    }
    final bool stacked =
        widget.variant == M3ETabsVariant.primary &&
        tab.icon != null &&
        tab.label != null;
    if (stacked) {
      return math.max(theme.iconSize, textWidth);
    }
    var width = textWidth;
    if (tab.icon != null) {
      width += theme.iconSize;
      if (tab.label != null) {
        width += theme.inlineIconLabelGap;
      }
    }
    if (_inlineBadge(tab)) {
      width += theme.inlineBadgeGap + 24;
    }
    return width;
  }

  bool _useScroll(double maxWidth, M3ETabTheme theme, TextStyle style) {
    if (!maxWidth.isFinite) {
      return false;
    }
    final bool? forced = widget.scrollable;
    if (forced != null) {
      return forced;
    }
    if (widget.alignment == M3ETabsAlignment.fill) {
      final double slot = maxWidth / widget.tabs.length;
      for (final M3ETab tab in widget.tabs) {
        if (_contentWidth(tab, style, theme) > slot) {
          return true;
        }
      }
      return false;
    }
    final double widest = widget.tabs
        .map((M3ETab tab) => _contentWidth(tab, style, theme))
        .reduce(math.max);
    return widest * widget.tabs.length > maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final tabTheme = theme.tabTheme;
    final scheme = theme.colorScheme;
    final bar = _bar(theme, tabTheme, scheme);
    if (!widget._sliver) {
      return bar;
    }
    if (widget.floating) {
      return SliverFloatingHeader(child: bar);
    }
    return PinnedHeaderSliver(child: bar);
  }

  Widget _bar(M3EThemeData theme, M3ETabTheme tabTheme, M3EColorScheme scheme) {
    final bool stacked = _stacked(tabTheme);
    final double barHeight = tabTheme.barHeight(
      widget.variant,
      stacked: stacked,
    );
    final style = tabTheme.labelStyle(
      theme.typeScale,
      scheme,
      selected: true,
      variant: widget.variant,
    );
    final primary = widget.variant == M3ETabsVariant.primary;
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.arrowRight): () {
          _move(_step(1));
        },
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
          _move(_step(-1));
        },
      },
      child: Material(
        key: _barKey,
        color: tabTheme.backgroundColor(scheme),
        elevation: tabTheme.elevation,
        shadowColor: tabTheme.shadowColor(scheme),
        surfaceTintColor: const Color(0x00000000),
        child: SizedBox(
          height: barHeight,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final scroll = _useScroll(constraints.maxWidth, tabTheme, style);
              return Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  if (scroll)
                    _scrollable(tabTheme)
                  else
                    _fixed(tabTheme, style),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: tabTheme.dividerHeight,
                    child: ColoredBox(color: tabTheme.dividerColor(scheme)),
                  ),
                  AnimatedBuilder(
                    animation: Listenable.merge(<Listenable>[
                      _indicatorLeft,
                      _indicatorWidth,
                      _scroll,
                    ]),
                    builder: (BuildContext context, Widget? _) {
                      final double dx =
                          _indicatorLeft.value -
                          (_scroll.hasClients ? _scroll.offset : 0);
                      return Positioned(
                        left: dx,
                        width: math.max(0, _indicatorWidth.value),
                        bottom: 0,
                        height: tabTheme.indicatorExtent(widget.variant),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: tabTheme.indicatorColor(scheme),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                primary ? tabTheme.indicatorCornerRadius : 0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  int _step(int towardTrailing) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return rtl ? -towardTrailing : towardTrailing;
  }

  Widget _fixed(M3ETabTheme theme, TextStyle style) {
    if (widget.alignment == M3ETabsAlignment.fill) {
      return Row(
        children: <Widget>[
          for (var i = 0; i < widget.tabs.length; i++)
            Expanded(child: _tab(theme, i, scrollable: false)),
        ],
      );
    }
    final double widest = widget.tabs
        .map((M3ETab tab) => _contentWidth(tab, style, theme))
        .reduce(math.max);
    return Row(
      mainAxisAlignment: widget.alignment == M3ETabsAlignment.center
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: <Widget>[
        for (var i = 0; i < widget.tabs.length; i++)
          SizedBox(width: widest, child: _tab(theme, i, scrollable: false)),
      ],
    );
  }

  Widget _scrollable(M3ETabTheme theme) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        _measure();
        return false;
      },
      child: SingleChildScrollView(
        controller: _scroll,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: EdgeInsetsDirectional.only(
          start: theme.scrollableLeadingOffset,
          end: theme.scrollableLeadingOffset,
        ),
        child: Row(
          children: <Widget>[
            for (var i = 0; i < widget.tabs.length; i++)
              _tab(theme, i, scrollable: true),
          ],
        ),
      ),
    );
  }

  Widget _tab(M3ETabTheme theme, int index, {required bool scrollable}) {
    final M3ETab tab = widget.tabs[index];
    final selected = index == _index;
    final Widget body = M3ETappable(
      focusNode: _nodes[index],
      focusOverlay: false,
      semanticButton: false,
      semanticLabel: tab.semanticLabel ?? tab.label,
      onTap: () => widget.onTabSelected(index),
      builder: (BuildContext context, M3EInteractionState state) {
        final scheme = M3ETheme.of(context).colorScheme;
        final bool interacting =
            state.hovered || state.focused || state.pressed;
        final double opacity = theme.stateOpacity(
          hovered: state.hovered,
          focused: state.focused,
          pressed: state.pressed,
        );
        final Color layer = theme.stateLayerColor(
          scheme,
          variant: widget.variant,
          selected: selected,
        );
        final Widget label = KeyedSubtree(
          key: _contentKeys[index],
          child: _content(theme, tab, selected, interacting),
        );
        final Widget ring = Padding(
          padding: EdgeInsets.all(theme.focusInset),
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.focusColor(scheme),
                  width: theme.focusThickness,
                ),
              ),
            ),
          ),
        );
        if (scrollable) {
          return SizedBox(
            height: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.scrollableTabPadding,
                  ),
                  child: label,
                ),
                Positioned.fill(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if (opacity > 0)
                        ColoredBox(color: layer.withValues(alpha: opacity)),
                      if (state.focused) ring,
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return SizedBox.expand(
          child: Stack(
            clipBehavior: Clip.none,
            fit: StackFit.expand,
            children: <Widget>[
              if (opacity > 0)
                ColoredBox(color: layer.withValues(alpha: opacity)),
              if (state.focused) ring,
              Center(child: label),
            ],
          ),
        );
      },
    );
    return KeyedSubtree(
      key: _slotKeys[index],
      child: Semantics(selected: selected, child: body),
    );
  }

  Widget _content(
    M3ETabTheme theme,
    M3ETab tab,
    bool selected,
    bool interacting,
  ) {
    final data = M3ETheme.of(context);
    final scheme = data.colorScheme;
    final Color color = theme.contentColor(
      scheme,
      variant: widget.variant,
      selected: selected,
      interacting: interacting,
    );
    final Widget? icon = tab.icon == null
        ? null
        : IconTheme.merge(
            data: IconThemeData(color: color, size: theme.iconSize),
            child: tab.icon!,
          );
    final Widget? label = tab.label == null
        ? null
        : Text(
            tab.label!,
            maxLines: theme.labelMaxLines,
            overflow: TextOverflow.ellipsis,
            style: theme.labelStyle(
              data.typeScale,
              scheme,
              selected: selected,
              variant: widget.variant,
              interacting: interacting,
            ),
          );
    final bool stack =
        widget.variant == M3ETabsVariant.primary &&
        icon != null &&
        label != null;
    final bool inlineBadge = _inlineBadge(tab);
    final Widget? badgeIcon = icon == null || inlineBadge
        ? icon
        : _badge(tab, child: icon);
    if (stack) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          badgeIcon!,
          SizedBox(height: theme.stackedIconLabelGap),
          _labeled(theme, tab, label, inlineBadge),
        ],
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ?badgeIcon,
        if (badgeIcon != null && label != null)
          SizedBox(width: theme.inlineIconLabelGap),
        if (label != null) _labeled(theme, tab, label, inlineBadge),
        if (label == null && inlineBadge) _badge(tab, inline: true),
      ],
    );
  }

  /// Secondary badges stay after the label, including when an icon is set.
  bool _inlineBadge(M3ETab tab) {
    return tab.hasBadge &&
        (widget.variant == M3ETabsVariant.secondary ||
            tab.badgeInline ||
            tab.icon == null);
  }

  Widget _labeled(
    M3ETabTheme theme,
    M3ETab tab,
    Widget label,
    bool inlineBadge,
  ) {
    if (!inlineBadge) {
      return label;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(child: label),
        SizedBox(width: theme.inlineBadgeGap),
        _badge(tab, inline: true),
      ],
    );
  }

  Widget _badge(M3ETab tab, {Widget? child, bool inline = false}) {
    final String? raw = tab.badgeLabel;
    final String? label = raw == null
        ? null
        : (raw.length <= 4 ? raw : raw.substring(0, 4));
    final bool dot = tab.badgeDot;
    final badges = M3ETheme.of(context).badgeTheme;
    final double mark = dot ? badges.dotSize : badges.labelMinSize;
    return M3EBadge(
      showDot: dot,
      label: dot ? null : label,
      count: dot || label != null ? null : tab.badgeCount,
      // Null keeps the badge theme corner placement, so the mark sits on the
      // icon and the icon and label stay where they are.
      offset: inline ? Offset(0, mark) : null,
      alignment: inline
          ? M3EBadgeAlignment.topCenter
          : M3EBadgeAlignment.topRight,
      child: child ?? SizedBox(width: dot ? 6 : 32, height: mark),
    );
  }
}
