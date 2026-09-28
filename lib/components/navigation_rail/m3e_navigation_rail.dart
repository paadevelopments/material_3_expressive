import 'dart:ui' show SemanticsRole;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../extended_fabs/m3e_extended_fabs.dart';
import '../floating_action_buttons/m3e_floating_action_buttons.dart';
import '../icon_buttons/m3e_icon_buttons.dart';
import 'components/m3e_rail_item.dart';
import 'controllers/m3e_navigation_rail_controller.dart';
import 'enums/m3e_navigation_rail_enums.dart';
import 'models/m3e_navigation_rail_destination.dart';
import 'models/m3e_navigation_rail_fab_slot.dart';
import 'models/m3e_navigation_rail_section.dart';
import 'res/m3e_navigation_rail_layout.dart';
import 'styles/m3e_navigation_rail_theme.dart';

export 'controllers/m3e_navigation_rail_controller.dart';
export 'enums/m3e_navigation_rail_enums.dart';
export 'models/m3e_navigation_rail_destination.dart';
export 'models/m3e_navigation_rail_fab_slot.dart';
export 'models/m3e_navigation_rail_section.dart';
export 'res/m3e_navigation_rail_layout.dart';
export 'styles/m3e_navigation_rail_theme.dart';

part 'components/m3e_navigation_rail_children_mixin.dart';

/// Material 3 Expressive navigation rail.
class M3ENavigationRail extends StatefulWidget {
  /// Creates a Material 3 Expressive navigation rail.
  const M3ENavigationRail({
    super.key,
    this.type = M3ENavigationRailType.expanded,
    this.modality = M3ENavigationRailModality.standard,
    required this.sections,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.fab,
    this.hideWhenCollapsed = false,
    this.expandedWidth,
    this.onDismissModal,
    this.onTypeChanged,
    this.labelBehavior = M3ENavigationRailLabelBehavior.alwaysShow,
    this.scrollable = true,
    this.trailing,
    this.trailingAtBottom = true,
    this.background,
    this.expandTooltip = 'Expand',
    this.collapseTooltip = 'Collapse',
    this.alignment = M3ENavigationRailAlignment.top,
    this.leading,
    this.showDivider = false,
    this.scrollUnder = true,
    this.controller,
  });

  /// type.
  final M3ENavigationRailType type;

  /// modality.
  final M3ENavigationRailModality modality;

  /// sections.
  final List<M3ENavigationRailSection> sections;

  /// selectedIndex.
  final int selectedIndex;

  /// onDestinationSelected.
  final ValueChanged<int> onDestinationSelected;

  /// fab.
  final M3ENavigationRailFabSlot? fab;

  /// hideWhenCollapsed.
  final bool hideWhenCollapsed;

  /// expandedWidth.
  final double? expandedWidth;

  /// onDismissModal.
  final VoidCallback? onDismissModal;

  /// onTypeChanged.
  final ValueChanged<M3ENavigationRailType>? onTypeChanged;

  /// labelBehavior.
  final M3ENavigationRailLabelBehavior labelBehavior;

  /// scrollable.
  final bool scrollable;

  /// trailing.
  final Widget? trailing;

  /// trailingAtBottom.
  final bool trailingAtBottom;

  /// background.
  final Color? background;

  /// Tooltip shown for the button that expands the rail.
  final String expandTooltip;

  /// Tooltip shown for the button that collapses the rail.
  final String collapseTooltip;

  /// Destination group alignment. Menu and FAB stay at the top.
  final M3ENavigationRailAlignment alignment;

  /// Optional logo above the menu. It is not a menu button.
  final Widget? leading;

  /// Draws a divider on the content edge.
  final bool showDivider;

  /// When true, horizontal body scroll raises the rail.
  final bool scrollUnder;

  /// Optional external control for selection and expansion.
  final M3ENavigationRailController? controller;

  @override
  State<M3ENavigationRail> createState() => _M3ENavigationRailState();
}

class _M3ENavigationRailState extends State<M3ENavigationRail>
    with TickerProviderStateMixin, _M3ENavigationRailChildrenMixin {
  OverlayEntry? _modalEntry;
  final FocusNode _modalFocus = FocusNode(debugLabel: 'rail modal');
  OverlayEntry? _collapsedPeekEntry;
  final LayerLink _anchor = LayerLink();
  late final SingleMotionController _width;
  ScrollNotificationObserverState? _scrollObserver;
  M3ENavigationRailController? _bound;
  bool _widthSeeded = false;
  bool _scrolledUnder = false;
  bool _modalShown = false;
  @override
  bool _suppressInk = false;
  bool _expanded = false;

  bool get _isExpanded => _expanded;

  FocusNode? _menuFocus;
  FocusNode? _fabFocus;

  @override
  List<FocusNode> get _destinationNodes => _destinations;

  final List<FocusNode> _destinations = <FocusNode>[];

  bool get _isModal => widget.modality == M3ENavigationRailModality.modal;

  bool get _canToggle =>
      widget.type == M3ENavigationRailType.collapsed ||
      widget.type == M3ENavigationRailType.expanded;

  bool get _overlayVisible => _modalShown;

  bool get _needsCollapsedPeek =>
      !_isExpanded && !_isModal && widget.hideWhenCollapsed && _canToggle;

  M3ENavigationRailType get _notifiedType => _expanded
      ? M3ENavigationRailType.expanded
      : M3ENavigationRailType.collapsed;

  bool get _immersive => widget.hideWhenCollapsed && !_isModal;

  @override
  bool get _showExpandedItems {
    if (_isModal && (_modalShown || _isExpanded)) {
      return true;
    }
    if (_immersive && (_isExpanded || _width.value > 0.5)) {
      return true;
    }
    if (!_isExpanded) {
      return false;
    }
    final double target = _expandedTarget(context);
    return _width.value + 1 >= target;
  }

  double _collapsedInset(M3ENavigationRailTheme theme) {
    final bool narrow =
        (theme.collapsedWidth - theme.narrowCollapsedWidth).abs() < 0.5;
    return narrow
        ? theme.narrowHorizontalPadding
        : theme.collapsedHorizontalPadding;
  }

  /// Leading edge of the destination icon for the current layout.
  double _iconOrigin(M3ENavigationRailTheme theme, {required bool expanded}) {
    if (expanded) {
      return theme.expandedItemInset + theme.indicatorLeading;
    }
    return _collapsedInset(theme) +
        (theme.verticalIndicatorWidth - theme.iconSize) / 2;
  }

  @override
  void initState() {
    super.initState();
    _expanded = _expandedFor(widget.type);
    _width = SingleMotionController(
      motion: const MaterialSpringMotion.expressiveSpatialDefault(),
      vsync: this,
    )..addListener(_onWidth);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());
  }

  bool _expandedFor(M3ENavigationRailType type) {
    return type == M3ENavigationRailType.expanded ||
        type == M3ENavigationRailType.alwaysExpand;
  }

  void _onWidth() {
    if (!mounted) {
      return;
    }
    setState(() {});
    _modalEntry?.markNeedsBuild();
    if (_modalShown && !_isExpanded && _width.value <= 0.5) {
      _modalShown = false;
      _removeOverlay();
      _animateWidth();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isModal && _isExpanded) {
      _modalShown = true;
    } else if (!_isModal) {
      _modalShown = false;
    }
    _bindScroll();
    _bindController();
    _syncNodes();
    _animateWidth();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());
  }

  @override
  void didUpdateWidget(covariant M3ENavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncTypeInkSuppression(oldWidget);
    _syncExpandedFromType(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _bindController();
    } else {
      _bound?.updateIndex(widget.selectedIndex);
    }
    _syncNodes();
    _animateWidth();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());
  }

  @override
  void dispose() {
    _scrollObserver?.removeListener(_onScroll);
    _bound?.removeListener(_onController);
    _bound?.detach(_controllerSelect);
    _width
      ..removeListener(_onWidth)
      ..dispose();
    _menuFocus?.dispose();
    _fabFocus?.dispose();
    for (final FocusNode node in _destinations) {
      node.dispose();
    }
    _removeOverlay();
    _removeCollapsedPeekOverlay();
    _modalFocus.dispose();
    super.dispose();
  }

  void _syncNodes() {
    final int count = widget.sections.fold<int>(
      0,
      (int total, M3ENavigationRailSection section) =>
          total + section.destinations.length,
    );
    while (_destinations.length < count) {
      _destinations.add(FocusNode(debugLabel: 'rail ${_destinations.length}'));
    }
    while (_destinations.length > count) {
      _destinations.removeLast().dispose();
    }
    if (_canToggle) {
      _menuFocus ??= FocusNode(debugLabel: 'rail menu');
    } else {
      _menuFocus?.dispose();
      _menuFocus = null;
    }
    if (widget.fab != null) {
      _fabFocus ??= FocusNode(debugLabel: 'rail fab');
    } else {
      _fabFocus?.dispose();
      _fabFocus = null;
    }
  }

  void _bindScroll() {
    if (!widget.scrollUnder) {
      _scrollObserver?.removeListener(_onScroll);
      _scrollObserver = null;
      if (_scrolledUnder) {
        _scrolledUnder = false;
      }
      return;
    }
    final ScrollNotificationObserverState? next =
        ScrollNotificationObserver.maybeOf(context);
    if (identical(next, _scrollObserver)) {
      return;
    }
    _scrollObserver?.removeListener(_onScroll);
    _scrollObserver = next;
    _scrollObserver?.addListener(_onScroll);
  }

  void _onScroll(ScrollNotification notification) {
    if (!mounted || !widget.scrollUnder) {
      return;
    }
    if (notification.metrics.axis != Axis.horizontal) {
      return;
    }
    final bool under = notification.metrics.pixels > 0;
    if (under == _scrolledUnder) {
      return;
    }
    setState(() => _scrolledUnder = under);
  }

  void _bindController() {
    final M3ENavigationRailController? next = widget.controller;
    if (identical(_bound, next)) {
      _bound?.updateIndex(widget.selectedIndex);
      _bound?.updateExpanded(expanded: _expanded);
      return;
    }
    _bound?.removeListener(_onController);
    _bound?.detach(_controllerSelect);
    _bound = next;
    next?.attach(
      select: _controllerSelect,
      setExpanded: _controllerExpanded,
      setVisible: _controllerVisible,
      index: widget.selectedIndex,
      expanded: _expanded,
      visible: !_needsCollapsedPeek,
    );
    next?.addListener(_onController);
  }

  void _controllerSelect(int index) {
    widget.onDestinationSelected(index);
  }

  void _controllerExpanded(bool expanded) {
    _setExpanded(expanded);
  }

  void _controllerVisible(bool visible) {
    _setExpanded(visible);
  }

  void _onController() {
    if (!mounted || _bound == null) {
      return;
    }
    if (_bound!.index != widget.selectedIndex) {
      widget.onDestinationSelected(_bound!.index);
    }
    if (_bound!.expanded != _expanded) {
      _setExpanded(_bound!.expanded);
    }
  }

  void _syncTypeInkSuppression(M3ENavigationRail oldWidget) {
    if (oldWidget.type == widget.type) {
      return;
    }
    setState(() => _suppressInk = true);
    Future<void>.delayed(M3ENavigationRailLayout.selectionDelay, () {
      if (mounted) {
        setState(() => _suppressInk = false);
      }
    });
  }

  void _syncExpandedFromType(M3ENavigationRail oldWidget) {
    if (oldWidget.type == widget.type) {
      return;
    }
    final bool next = _expandedFor(widget.type);
    if (_expanded == next) {
      return;
    }
    setState(() => _expanded = next);
  }

  void _syncOverlay() {
    if (!mounted) {
      return;
    }
    if (_isModal && _isExpanded) {
      _modalShown = true;
    }
    if (_overlayVisible) {
      if (_modalEntry == null) {
        _insertOverlay();
      } else {
        _modalEntry!.markNeedsBuild();
      }
    } else {
      _removeOverlay();
    }
    if (_needsCollapsedPeek) {
      if (_collapsedPeekEntry == null) {
        _insertCollapsedPeekOverlay();
      } else {
        _collapsedPeekEntry!.markNeedsBuild();
      }
    } else {
      _removeCollapsedPeekOverlay();
    }
  }

  void _insertOverlay() {
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);
    _modalEntry = OverlayEntry(builder: _buildModalOverlay);
    overlay.insert(_modalEntry!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _modalShown) {
        _modalFocus.requestFocus();
      }
    });
  }

  void _removeOverlay() {
    _modalEntry?.remove();
    _modalEntry = null;
  }

  void _insertCollapsedPeekOverlay() {
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);
    _collapsedPeekEntry = OverlayEntry(builder: _buildCollapsedPeekOverlay);
    overlay.insert(_collapsedPeekEntry!);
  }

  void _removeCollapsedPeekOverlay() {
    _collapsedPeekEntry?.remove();
    _collapsedPeekEntry = null;
  }

  void _setExpanded(bool value) {
    if ((!_canToggle && !_isModal) || _expanded == value) {
      return;
    }
    setState(() {
      _expanded = value;
      _suppressInk = true;
      if (_isModal && value) {
        _modalShown = true;
      }
    });
    if (_isModal && value) {
      _width.value = 0;
    }
    _bound?.updateExpanded(expanded: value);
    _bound?.updateVisible(visible: value || !widget.hideWhenCollapsed);
    Future<void>.delayed(M3ENavigationRailLayout.selectionDelay, () {
      if (mounted) {
        setState(() => _suppressInk = false);
      }
    });
    widget.onTypeChanged?.call(_notifiedType);
    _animateWidth();
  }

  void _dismissModal() {
    if (!_isExpanded) {
      return;
    }
    widget.onDismissModal?.call();
    _setExpanded(false);
  }

  double _expandedTarget(BuildContext context) {
    final M3ENavigationRailTheme theme = M3ETheme.of(context)
        .navigationRailTheme;
    return (widget.expandedWidth ?? theme.expandedMinWidth).clamp(
      theme.expandedMinWidth,
      theme.expandedMaxWidth,
    );
  }

  double _targetWidth(BuildContext context) {
    final M3ENavigationRailTheme theme = M3ETheme.of(context)
        .navigationRailTheme;
    if (_isModal) {
      return _modalShown && _isExpanded ? _expandedTarget(context) : 0;
    }
    if (!_isExpanded && widget.hideWhenCollapsed) {
      return 0;
    }
    return _isExpanded ? _expandedTarget(context) : theme.collapsedWidth;
  }

  void _animateWidth() {
    final M3ENavigationRailTheme theme = M3ETheme.of(context)
        .navigationRailTheme;
    final double target = _targetWidth(context);
    _width.motion = const MaterialSpringMotion.expressiveSpatialDefault()
        .copyWith(
          stiffness: theme.widthSpring.stiffness,
          damping: theme.widthSpring.damping,
        );
    if (!_widthSeeded) {
      _width.value = target;
      _widthSeeded = true;
      return;
    }
    if ((_width.value - target).abs() < 0.5) {
      return;
    }
    _width.animateTo(target);
  }

  List<FocusNode> get _arrowNodes {
    return <FocusNode>[?_menuFocus, ?_fabFocus, ..._destinations];
  }

  void _move(int delta) {
    final nodes = _arrowNodes;
    final int current = nodes.indexWhere((FocusNode node) => node.hasFocus);
    if (current < 0) {
      return;
    }
    final int next = current + delta;
    if (next < 0 || next >= nodes.length) {
      return;
    }
    nodes[next].requestFocus();
  }

  int _arrowDelta(LogicalKeyboardKey key) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    if (key == LogicalKeyboardKey.arrowDown) {
      return 1;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      return -1;
    }
    if (key == LogicalKeyboardKey.arrowRight) {
      return rtl ? -1 : 1;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      return rtl ? 1 : -1;
    }
    return 0;
  }

  Widget _buildModalOverlay(BuildContext context) {
    final theme = M3ETheme.of(context).navigationRailTheme;
    final double span = _expandedTarget(context);
    final double reveal = span <= 0 ? 0 : (_width.value / span).clamp(0, 1);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return M3EScrimSystemUi.wrap(
      CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.escape): _dismissModal,
        },
        child: Focus(
          focusNode: _modalFocus,
          autofocus: true,
          skipTraversal: true,
          onKeyEvent: (FocusNode node, KeyEvent event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.escape) {
              _dismissModal();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: GestureDetector(
                  onTap: _dismissModal,
                  child: ColoredBox(
                    color: M3ETheme.of(context).colorScheme.scrim
                        .withValues(alpha: theme.modalScrimOpacity * reveal),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: FractionalTranslation(
                  translation: Offset(rtl ? 1 - reveal : reveal - 1, 0),
                  child: Material(
                    type: MaterialType.transparency,
                    child: _buildRailCore(context, modal: true),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedPeekOverlay(BuildContext context) {
    final M3ENavigationRailTheme theme = M3ETheme.of(context)
        .navigationRailTheme;
    final Widget button = M3EIconButton(
      variant: M3EIconButtonVariant.standard,
      icon: const Icon(M3EIcons.menu),
      tooltip: widget.expandTooltip,
      onPressed: _canToggle ? () => _setExpanded(true) : null,
      suppressInk: _suppressInk,
      focusNode: _menuFocus,
    );
    return CompositedTransformFollower(
      link: _anchor,
      showWhenUnlinked: false,
      offset: Offset(8, theme.topSpace),
      child: Material(type: MaterialType.transparency, child: button),
    );
  }

  @override
  Widget _buildMenuButton(BuildContext context) {
    if (!_canToggle) {
      return const SizedBox.shrink();
    }
    final M3ENavigationRailTheme theme = M3ETheme.of(context)
        .navigationRailTheme;
    final Widget button = IconTheme(
      data: IconThemeData(
        color: theme.menuColorResolved(M3ETheme.of(context).colorScheme),
        size: theme.iconSize,
      ),
      child: M3EIconButton(
        variant: M3EIconButtonVariant.standard,
        icon: Icon(_isExpanded ? M3EIcons.menu_open : M3EIcons.menu),
        tooltip: _isExpanded ? widget.collapseTooltip : widget.expandTooltip,
        onPressed: () => _setExpanded(!_isExpanded),
        suppressInk: _suppressInk,
        focusNode: _menuFocus,
      ),
    );
    final double target = M3ETheme.of(context).iconButtonTheme
        .target(M3EIconButtonSize.sm, M3EIconButtonWidth.defaultWidth)
        .width;
    final double iconInset = (target - theme.iconSize) / 2;
    final double start =
        _iconOrigin(theme, expanded: _showExpandedItems) - iconInset;
    return Padding(
      padding: EdgeInsetsDirectional.only(start: start, end: 16, bottom: 12),
      child: Align(alignment: AlignmentDirectional.centerStart, child: button),
    );
  }

  @override
  Widget? _buildFab(BuildContext context, {required bool showLabels}) {
    final M3ENavigationRailFabSlot? fab = widget.fab;
    if (fab == null) {
      return null;
    }
    final double elevation = fab.elevation ?? 0;
    final M3ENavigationRailTheme theme = M3ETheme.of(context)
        .navigationRailTheme;
    final double inset = showLabels
        ? theme.expandedItemInset
        : _collapsedInset(theme);
    return Padding(
      padding: EdgeInsetsDirectional.only(start: inset, end: 16, bottom: 12),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: showLabels
            ? M3EExtendedFab(
                label: fab.label,
                icon: fab.icon,
                onPressed: fab.onPressed,
                color: fab.color,
                elevation: elevation,
                hoverElevation: fab.hoverElevation ?? elevation,
                focusNode: _fabFocus,
              )
            : M3EFab(
                icon: fab.icon,
                onPressed: fab.onPressed,
                tooltip: fab.semanticLabel ?? fab.tooltip,
                color: fab.color,
                size: fab.size,
                elevation: elevation,
                hoverElevation: fab.hoverElevation ?? elevation,
                focusNode: _fabFocus,
              ),
      ),
    );
  }

  Widget _buildRailCore(BuildContext context, {required bool modal}) {
    final M3EThemeData m3e = M3ETheme.of(context);
    final M3ENavigationRailTheme theme = m3e.navigationRailTheme;
    final M3EColorScheme scheme = m3e.colorScheme;
    final bool raised = widget.scrollUnder && _scrolledUnder && !modal;
    final Color color =
        widget.background ??
        (modal
            ? theme.modalContainerColorResolved(scheme)
            : raised
            ? theme.scrolledContainerColorResolved(scheme)
            : theme.containerColorResolved(scheme));
    final double elevation = raised ? theme.scrolledElevation : theme.elevation;
    final double corner = modal
        ? theme.modalContainerRadius
        : theme.containerRadius;
    final double raw = modal ? _expandedTarget(context) : _width.value;
    final double width = raw < 0 ? 0 : raw;
    final bool revealExpanded = !modal && _immersive && _showExpandedItems;
    final double contentWidth = revealExpanded
        ? _expandedTarget(context)
        : width;
    final BorderRadius? radius = corner > 0
        ? BorderRadius.circular(corner)
        : null;
    Widget rail = DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: radius,
        boxShadow: M3EElevation.shadows(elevation, shadowColor: scheme.shadow),
      ),
      child: Material(type: MaterialType.transparency, child: _body(context)),
    );
    if (widget.showDivider) {
      rail = Stack(
        children: <Widget>[
          rail,
          PositionedDirectional(
            top: 0,
            bottom: 0,
            end: 0,
            width: theme.dividerThickness,
            child: ColoredBox(color: theme.dividerColorResolved(scheme)),
          ),
        ],
      );
    }
    if (radius != null) {
      rail = ClipRRect(borderRadius: radius, child: rail);
    }
    rail = SizedBox(width: contentWidth, child: rail);
    if (revealExpanded && contentWidth > width) {
      rail = ClipRect(
        child: OverflowBox(
          alignment: AlignmentDirectional.centerStart,
          minWidth: contentWidth,
          maxWidth: contentWidth,
          child: rail,
        ),
      );
    }
    return _shortcuts(SizedBox(width: width, child: rail));
  }

  double _destinationListTop(M3ENavigationRailTheme theme) {
    final bool controls =
        widget.leading != null || widget.fab != null || _canToggle;
    if (!controls) {
      return 0;
    }
    return theme.destinationTopPadding;
  }

  Widget _body(BuildContext context) {
    final M3ENavigationRailTheme theme = M3ETheme.of(context)
        .navigationRailTheme;
    final double listTop = _destinationListTop(theme);
    final listPadding = EdgeInsets.only(top: listTop);
    final List<Widget> header = _headerChildren(context);
    final List<Widget> destinations = _destinationChildren(context);
    final Widget? trailing = widget.trailing != null && widget.trailingAtBottom
        ? _buildTrailing(context)
        : null;
    final Widget group = widget.alignment == M3ENavigationRailAlignment.center
        ? Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double minHeight = constraints.maxHeight - listTop;
                return SingleChildScrollView(
                  padding: listPadding,
                  physics: widget.scrollable
                      ? const ClampingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: minHeight < 0 ? 0 : minHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: destinations,
                    ),
                  ),
                );
              },
            ),
          )
        : Expanded(
            child: widget.scrollable
                ? ListView(padding: listPadding, children: destinations)
                : SingleChildScrollView(
                    padding: listPadding,
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: destinations,
                    ),
                  ),
          );
    final int destinationsCount = widget.sections.fold<int>(0, (
      int count,
      M3ENavigationRailSection section,
    ) {
      return count + section.destinations.length;
    });
    return Semantics(
      role: destinationsCount > 0 ? SemanticsRole.menu : null,
      explicitChildNodes: true,
      child: Column(children: <Widget>[...header, group, ?trailing]),
    );
  }

  Widget _shortcuts(Widget child) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.arrowDown): () => _move(1),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => _move(-1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () =>
            _move(_arrowDelta(LogicalKeyboardKey.arrowRight)),
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () =>
            _move(_arrowDelta(LogicalKeyboardKey.arrowLeft)),
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());
    return M3EComponentTheme(
      builder: (BuildContext context) {
        final Widget child = _overlayVisible || (_isModal && !_isExpanded)
            ? const SizedBox.shrink()
            : _buildRailCore(context, modal: false);
        return PopScope(
          canPop: !_overlayVisible,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (!didPop && _overlayVisible) {
              _dismissModal();
            }
          },
          child: CompositedTransformTarget(link: _anchor, child: child),
        );
      },
    );
  }
}
