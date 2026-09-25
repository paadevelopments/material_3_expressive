part of '../m3e_lists.dart';

enum _M3EListLayout { column, scrollable, sliver }

/// One list for selection, variant, reorder, swipe, and expand.
///
/// List-level fields apply to every row. A row opts into swipe with
/// [M3EListItem.swipe] and into expand with [M3EListItem.expanded].
/// A sub-list expansion is its own nested [M3EList].
class M3EList extends StatefulWidget {
  /// Non-scrollable column.
  const M3EList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.outerRadius = M3EListCardListTheme.defaultOuterRadius,
    this.innerRadius = M3EListCardListTheme.defaultInnerRadius,
    this.gap = M3EListCardListTheme.defaultGap,
    this.color,
    this.colorBuilder,
    this.borderRadiusBuilder,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.semanticLabelBuilder,
    this.mouseCursor,
    this.haptic = M3EHapticFeedback.none,
    this.variant,
    this.border,
    this.emptyBuilder,
    this.selection = false,
    this.reorder = false,
    this.selectionController,
    this.onSelectionChanged,
    this.onReorder,
    this.selectionState,
    this.reorderState,
    this.embedded = false,
    this.semanticsLabel,
    this.dismissController,
    this.dismissStyle = const M3EDismissibleListStyle(),
    this.allowMultipleExpanded,
    this.initiallyExpanded = const <int>{},
    this.expandStyle,
    this.expandMotion,
    this.collapseMotion,
    this.onExpansionChanged,
    this.expandController,
  }) : assert(
         !reorder || onReorder != null,
         'onReorder is required when reorder is true',
       ),
       _layout = _M3EListLayout.column,
       controller = null,
       physics = null,
       shrinkWrap = false,
       listPadding = null,
       clipBehavior = Clip.hardEdge;

  /// Scrollable list.
  const M3EList.scrollable({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.outerRadius = M3EListCardListTheme.defaultOuterRadius,
    this.innerRadius = M3EListCardListTheme.defaultInnerRadius,
    this.gap = M3EListCardListTheme.defaultGap,
    this.color,
    this.colorBuilder,
    this.borderRadiusBuilder,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.semanticLabelBuilder,
    this.mouseCursor,
    this.haptic = M3EHapticFeedback.none,
    this.variant,
    this.border,
    this.emptyBuilder,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.listPadding,
    this.clipBehavior = Clip.hardEdge,
    this.selection = false,
    this.reorder = false,
    this.selectionController,
    this.onSelectionChanged,
    this.onReorder,
    this.selectionState,
    this.reorderState,
    this.embedded = false,
    this.semanticsLabel,
    this.dismissController,
    this.dismissStyle = const M3EDismissibleListStyle(),
    this.allowMultipleExpanded,
    this.initiallyExpanded = const <int>{},
    this.expandStyle,
    this.expandMotion,
    this.collapseMotion,
    this.onExpansionChanged,
    this.expandController,
  }) : assert(
         !reorder || onReorder != null,
         'onReorder is required when reorder is true',
       ),
       _layout = _M3EListLayout.scrollable;

  /// Sliver list. Selection stays; reorder is not supported.
  const M3EList.sliver({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.outerRadius = M3EListCardListTheme.defaultOuterRadius,
    this.innerRadius = M3EListCardListTheme.defaultInnerRadius,
    this.gap = M3EListCardListTheme.defaultGap,
    this.color,
    this.colorBuilder,
    this.borderRadiusBuilder,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.semanticLabelBuilder,
    this.mouseCursor,
    this.haptic = M3EHapticFeedback.none,
    this.variant,
    this.border,
    this.emptyBuilder,
    this.selection = false,
    this.selectionController,
    this.onSelectionChanged,
    this.selectionState,
    this.embedded = false,
    this.semanticsLabel,
    this.dismissController,
    this.dismissStyle = const M3EDismissibleListStyle(),
    this.allowMultipleExpanded,
    this.initiallyExpanded = const <int>{},
    this.expandStyle,
    this.expandMotion,
    this.collapseMotion,
    this.onExpansionChanged,
    this.expandController,
  }) : _layout = _M3EListLayout.sliver,
       reorder = false,
       onReorder = null,
       reorderState = null,
       controller = null,
       physics = null,
       shrinkWrap = false,
       listPadding = null,
       clipBehavior = Clip.hardEdge;

  final _M3EListLayout _layout;

  /// Number of rows.
  final int itemCount;

  /// Builds the row at the given index. A list item can set swipe and expanded.
  final IndexedWidgetBuilder itemBuilder;

  /// Outer corner radius.
  final double outerRadius;

  /// Inner corner radius.
  final double innerRadius;

  /// Gap between rows.
  final double gap;

  /// Shared row fill. Null lets the variant or a parent nest choose.
  final Color? color;

  /// Per-index fill. Non-null wins over [color].
  final Color? Function(int index)? colorBuilder;

  /// Per-index radius. Non-null wins over position radii.
  final BorderRadius? Function(int index, M3ECardPosition position)?
  borderRadiusBuilder;

  /// Padding inside each non-expanding row.
  final EdgeInsetsGeometry? padding;

  /// Margin around the whole list.
  final EdgeInsetsGeometry? margin;

  /// Called when a non-expanding row is tapped.
  final void Function(int index)? onTap;

  /// Called when a non-expanding row is long-pressed.
  final void Function(int index)? onLongPress;

  /// Semantic label for a row.
  final String Function(int index)? semanticLabelBuilder;

  /// Cursor for a row.
  final MouseCursor? mouseCursor;

  /// Haptic on a non-expanding row tap.
  final M3EHapticFeedback haptic;

  /// Filled, outlined, or elevated. A nested list inherits the parent variant.
  final M3ECardVariant? variant;

  /// Outline override.
  final BorderSide? border;

  /// Shown when [itemCount] is 0.
  final Widget? emptyBuilder;

  /// Scroll controller for [M3EList.scrollable].
  final ScrollController? controller;

  /// Scroll physics for [M3EList.scrollable].
  final ScrollPhysics? physics;

  /// Sizes the scroll view to its children.
  final bool shrinkWrap;

  /// Padding around the scrollable list.
  final EdgeInsetsGeometry? listPadding;

  /// Clip for [M3EList.scrollable].
  final Clip clipBehavior;

  /// Enables selection.
  final bool selection;

  /// Enables long-press reorder. Requires [onReorder].
  final bool reorder;

  /// Optional selection controller. An ancestor scope wins.
  final M3ESelectionController? selectionController;

  /// Called when selection changes.
  final ValueChanged<Set<int>>? onSelectionChanged;

  /// Called after a reorder drop.
  final ReorderCallback? onReorder;

  /// Selection state override.
  final M3EListSelectionState? selectionState;

  /// Reorder state override.
  final M3EListReorderState? reorderState;

  /// Forces nested corner radii even when this list is not under a parent.
  final bool embedded;

  /// List-box description.
  final String? semanticsLabel;

  /// Reveals or dismisses a swiping row by index.
  final M3EDismissibleListController? dismissController;

  /// Shared swipe chrome (springs, action metrics, default background).
  final M3EDismissibleListStyle dismissStyle;

  /// When false, opening one row closes the others.
  final bool? allowMultipleExpanded;

  /// Rows that start expanded.
  final Set<int> initiallyExpanded;

  /// Expandable row decoration override.
  final M3EExpandableStyle? expandStyle;

  /// Spring used while expanding.
  final M3ESpring? expandMotion;

  /// Spring used while collapsing.
  final M3ESpring? collapseMotion;

  /// Called when a row expands or collapses.
  final void Function(int index, {required bool isExpanded})?
  onExpansionChanged;

  /// Opens a row container transform by index.
  final M3EExpandableListController? expandController;

  @override
  State<M3EList> createState() => _M3EListState();
}

class _M3EListState extends State<M3EList>
    with
        TickerProviderStateMixin,
        M3EDismissibleCardMixin,
        M3EDismissibleCardDragMixin,
        M3EDismissibleCardBuildMixin {
  final List<Widget> _built = <Widget>[];
  final List<M3EListItemSwipe?> _swipes = <M3EListItemSwipe?>[];
  final List<M3EExpandableExpanded?> _expanded = <M3EExpandableExpanded?>[];
  final List<Widget?> _transforms = <Widget?>[];

  late Set<int> _expandedIndices;
  final Map<int, BuildContext> _transformAnchors = <int, BuildContext>{};
  M3ECardContainerTransformHandle<void>? _transformHandle;
  int? _collapsedForReorder;
  bool _snapCollapse = false;
  bool _embeddedActive = false;
  int? _styleDataIndex;

  @override
  int get swipeItemCount => widget.itemCount;

  @override
  M3EDismissibleListStyle get style {
    final M3EDismissibleListStyle base = widget.dismissStyle;
    final int? index = _styleDataIndex;
    if (index == null) {
      return base;
    }
    final M3EListItemSwipe? swipe = _swipeAt(index);
    if (swipe == null ||
        (swipe.background == null && swipe.secondaryBackground == null)) {
      return base;
    }
    return base.copyWith(
      background: swipe.background,
      secondaryBackground: swipe.secondaryBackground,
    );
  }

  @override
  bool get embedded => _embeddedActive;

  @override
  bool get listReorderEnabled => widget.reorder;

  @override
  Future<bool> Function(int, DismissDirection)? get onDismissCallback =>
      _dismissAt;

  @override
  void Function(int)? get onTapCallback => widget.onTap;

  @override
  void Function(int)? get onLongPressCallback => widget.onLongPress;

  @override
  Color? Function(int index)? get colorBuilder => widget.colorBuilder;

  @override
  BorderRadius? Function(int index, M3ECardPosition position)?
  get borderRadiusBuilder => widget.borderRadiusBuilder;

  @override
  List<M3EListSwipeAction> Function(int index)? get leadingActionsBuilder =>
      (int index) => _swipeAt(index)?.leading ?? const <M3EListSwipeAction>[];

  @override
  List<M3EListSwipeAction> Function(int index)? get trailingActionsBuilder =>
      (int index) => _swipeAt(index)?.trailing ?? const <M3EListSwipeAction>[];

  @override
  M3EListSwipeMode get swipeMode =>
      _swipeAt(activeSwipeIndex ?? -1)?.mode ?? M3EListSwipeMode.both;

  @override
  M3EListSwipeEdge get dismissEdge =>
      _swipeAt(activeSwipeIndex ?? -1)?.edge ?? M3EListSwipeEdge.both;

  @override
  bool swipeItemPaintsSurface(int dataIndex) => _expandedAt(dataIndex) != null;

  @override
  Widget swipeItemBuilder(BuildContext context, int dataIndex) {
    return M3EListItemIndex(
      index: dataIndex,
      child: _childAt(context, dataIndex),
    );
  }

  @override
  void initState() {
    super.initState();
    _expandedIndices = Set<int>.from(widget.initiallyExpanded);
    initSlots();
    bindSwipeController(widget.dismissController);
    _bindExpandController(widget.expandController);
  }

  @override
  void didUpdateWidget(M3EList oldWidget) {
    super.didUpdateWidget(oldWidget);
    syncSlotsIfNeeded(oldWidget.itemCount);
    bindSwipeController(widget.dismissController);
    if (oldWidget.expandController != widget.expandController) {
      oldWidget.expandController?.detach();
      _bindExpandController(widget.expandController);
    }
  }

  @override
  void dispose() {
    widget.expandController?.detach();
    unbindSwipeController();
    disposeSlots();
    super.dispose();
  }

  Future<bool> _dismissAt(int index, DismissDirection direction) {
    final Future<bool> Function(DismissDirection direction)? dismiss = _swipeAt(
      index,
    )?.onDismiss;
    if (dismiss == null) {
      return Future<bool>.value(true);
    }
    return dismiss(direction);
  }

  void _bindExpandController(M3EExpandableListController? controller) {
    controller?.attach(open: openTransform, close: closeTransform);
  }

  void _snapshot(BuildContext context) {
    _built.clear();
    _swipes.clear();
    _expanded.clear();
    _transforms.clear();
    for (var index = 0; index < widget.itemCount; index++) {
      final child = widget.itemBuilder(context, index);
      _built.add(child);
      if (child is M3EListItem) {
        _swipes.add(child.swipe);
        _expanded.add(child.expanded);
        _transforms.add(child.transform);
      } else {
        _swipes.add(null);
        _expanded.add(null);
        _transforms.add(null);
      }
    }
  }

  M3EListItemSwipe? _swipeAt(int index) {
    if (index < 0 || index >= _swipes.length) {
      return null;
    }
    return _swipes[index];
  }

  M3EExpandableExpanded? _expandedAt(int index) {
    if (index < 0 || index >= _expanded.length) {
      return null;
    }
    return _expanded[index];
  }

  bool _enabledAt(int index) {
    if (index < 0 || index >= _built.length) {
      return true;
    }
    final Widget child = _built[index];
    return child is! M3EListItem || child.enabled;
  }

  @override
  Widget buildSlot(BuildContext context, int slotIndex, [List<int>? visible]) {
    final List<int> shown = visible ?? computeVisibleIndices();
    final int dataIndex = shown.indexOf(slotIndex);
    _styleDataIndex = dataIndex < 0 ? null : dataIndex;
    final Widget child = super.buildSlot(context, slotIndex, shown);
    _styleDataIndex = null;
    return child;
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget._layout != _M3EListLayout.sliver || !widget.reorder,
      'M3EList.sliver does not support reorder.',
    );
    return M3EComponentTheme(builder: _buildList);
  }

  Widget _buildList(BuildContext context) {
    _snapshot(context);
    final M3EExpandableNestScope? nest = M3EExpandableNestScope.maybeOf(
      context,
    );
    _embeddedActive = widget.embedded || nest != null;
    final Widget? empty = _empty();
    if (empty != null) {
      return empty;
    }
    Widget list = M3EListKeyboardGroup(
      itemCount: widget.itemCount,
      semanticsLabel: widget.semanticsLabel,
      child: _layout(context),
    );
    if (widget.selection || widget.reorder) {
      list = M3EListFeatureHost(
        itemCount: widget.itemCount,
        selection: widget.selection,
        reorder: widget.reorder,
        selectionController: widget.selectionController,
        onSelectionChanged: widget.onSelectionChanged,
        selectionState: widget.selectionState,
        reorderState: widget.reorderState,
        child: list,
      );
    }
    list = M3EExpandableSnapCollapse(snap: _snapCollapse, child: list);
    return _margin(list);
  }

  Widget? _empty() {
    final Widget? empty = widget.emptyBuilder;
    if (widget.itemCount != 0 || empty == null) {
      return null;
    }
    return _margin(empty);
  }

  Widget _margin(Widget child) {
    final EdgeInsetsGeometry? margin = widget.margin;
    if (margin == null) {
      return child;
    }
    return Padding(padding: margin, child: child);
  }

  Widget _layout(BuildContext context) {
    if (widget.reorder && widget._layout != _M3EListLayout.sliver) {
      return _reorder(context);
    }
    switch (widget._layout) {
      case _M3EListLayout.column:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _children(context),
        );
      case _M3EListLayout.scrollable:
        return ListView.builder(
          controller: widget.controller,
          physics: widget.physics,
          shrinkWrap: widget.shrinkWrap,
          padding: widget.listPadding,
          clipBehavior: widget.clipBehavior,
          itemCount: slots.length,
          itemBuilder: (BuildContext context, int index) =>
              _row(context, index),
        );
      case _M3EListLayout.sliver:
        return SliverList.builder(
          itemCount: slots.length,
          itemBuilder: (BuildContext context, int index) =>
              _row(context, index),
        );
    }
  }

  List<Widget> _children(BuildContext context) {
    return <Widget>[
      for (int index = 0; index < slots.length; index++) _row(context, index),
    ];
  }

  Widget _reorder(BuildContext context) {
    final M3EListReorderState reorderState =
        widget.reorderState ?? M3ETheme.of(context).listTheme.reorder;
    return M3EListReorderHost(
      itemCount: slots.length,
      onReorder: widget.onReorder!,
      reorderState: reorderState,
      gap: widget.gap,
      scrollable: widget._layout == _M3EListLayout.scrollable,
      controller: widget.controller,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.listPadding,
      prepareDrag: prepareReorderDrag,
      onDragSettled: settleReorderDrag,
      canStartDrag: (int index) =>
          !isInteractionLocked &&
          index >= 0 &&
          index < slots.length &&
          slots[index].isVisible,
      itemBuilder: (BuildContext context, int index) => _row(context, index),
    );
  }

  Widget _row(BuildContext context, int slotIndex) {
    return Builder(
      builder: (BuildContext context) => _rowBuilt(context, slotIndex),
    );
  }

  Widget _rowBuilt(BuildContext context, int slotIndex) {
    final List<int> visible = computeVisibleIndices();
    final int dataIndex = visible.indexOf(slotIndex);
    final bool collapsing =
        slotIndex >= 0 &&
        slotIndex < slots.length &&
        !slots[slotIndex].isVisible;
    if (collapsing || (dataIndex >= 0 && _swipeAt(dataIndex) != null)) {
      return buildSlot(context, slotIndex, visible);
    }
    if (dataIndex < 0) {
      return const SizedBox.shrink();
    }
    return _plain(context, dataIndex, visible.length);
  }

  Widget _plain(BuildContext context, int index, int total) {
    if (_expandedAt(index) != null) {
      return M3EListItemIndex(index: index, child: _expandable(context, index));
    }
    return _card(context, index, total);
  }

  Widget _childAt(BuildContext context, int index) {
    if (_expandedAt(index) != null) {
      return _expandable(context, index);
    }
    if (index < 0 || index >= _built.length) {
      return const SizedBox.shrink();
    }
    return _built[index];
  }

  Widget _card(BuildContext context, int index, int total) {
    final M3EListItemTheme itemTheme = M3ETheme.of(context).listTheme.item;
    final M3EListCardListTheme cardList = M3ETheme.of(context)
        .listTheme
        .cardList;
    final double usedOuter = _baselineOr(
      itemTheme,
      widget.outerRadius,
      M3EListCardListTheme.defaultOuterRadius,
    );
    final double usedInner = _baselineOr(
      itemTheme,
      widget.innerRadius,
      M3EListCardListTheme.defaultInnerRadius,
    );
    final double usedGap = _baselineOr(
      itemTheme,
      widget.gap,
      M3EListCardListTheme.defaultGap,
    );
    final M3ECardPosition position = calculateCardPosition(index, total);
    final M3EListFeatureScope? features = M3EListFeatureScope.maybeOf(context);
    final bool enabled = _enabledAt(index);
    return M3EListTapBinder(
      onTap: _tapFor(features, index),
      onDoubleTap: _doubleTap(features, index),
      builder: (BuildContext context, VoidCallback? onPressed) {
        return M3ECardListItem(
          index: index,
          position: position,
          outerRadius: usedOuter,
          innerRadius: usedInner,
          gap: usedGap,
          embedded: _embeddedActive,
          color: widget.color,
          resolvedColor:
              widget.colorBuilder?.call(index) ??
              m3eSelectionFill(context, index),
          resolvedBorderRadius:
              widget.borderRadiusBuilder?.call(index, position) ??
              m3eSelectionRadius(
                context,
                index,
                outerRadius: itemTheme.selectedRadius,
              ),
          padding: widget.padding,
          onTap: !enabled || onPressed == null ? null : (_) => onPressed(),
          onLongPress: widget.reorder ? null : widget.onLongPress,
          semanticLabel: widget.semanticLabelBuilder?.call(index),
          mouseCursor: widget.mouseCursor,
          haptic: widget.haptic,
          variant: _variant(context, cardList),
          border: widget.border ?? cardList.border,
          child: M3EListItemIndex(
            index: index,
            child: index < _built.length
                ? _built[index]
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  M3ECardVariant _variant(BuildContext context, M3EListCardListTheme cardList) {
    final M3EExpandableNestScope? nest = M3EExpandableNestScope.maybeOf(
      context,
    );
    return widget.variant ?? nest?.variant ?? cardList.variant;
  }

  double _baselineOr(M3EListItemTheme theme, double value, double specDefault) {
    if (theme.isBaseline && value == specDefault) {
      return 0;
    }
    return value;
  }

  VoidCallback? _tapFor(M3EListFeatureScope? features, int index) {
    if (features == null || !features.selectionEnabled) {
      if (widget.onTap == null) {
        return null;
      }
      return () => widget.onTap!(index);
    }
    return () {
      final bool inMode = features.controller?.isSelectionMode ?? false;
      if (inMode) {
        features.onToggleSelection(index);
        return;
      }
      widget.onTap?.call(index);
    };
  }

  VoidCallback? _doubleTap(M3EListFeatureScope? features, int index) {
    if (features == null || !features.selectionEnabled) {
      return null;
    }
    if (features.selectionState.trigger != M3EListSelectionTrigger.doubleTap) {
      return null;
    }
    return () => features.onToggleSelection(index);
  }

  Widget _expandable(BuildContext context, int index) {
    final M3EListExpandableTheme expandable = M3ETheme.of(context)
        .listTheme
        .expandable;
    final M3EExpandableExpanded? expanded = _expandedAt(index);
    final bool hasList = expanded != null && expanded.isList;
    final M3EExpandableStyle decoration = _decoration(context, expandable);
    final M3ESpring expandMotion =
        widget.expandMotion ??
        (hasList ? M3EMotion.expressiveSpatialPress : expandable.expandMotion);
    final M3ESpring collapseMotion =
        widget.collapseMotion ??
        (hasList
            ? M3EMotion.expressiveSpatialPress
            : expandable.collapseMotion);
    final bool allowMultiple =
        widget.allowMultipleExpanded ?? expandable.allowMultipleExpanded;
    final M3EListCardListTheme cardList = M3ETheme.of(context)
        .listTheme
        .cardList;
    return M3EExpandableItem(
      index: index,
      totalCount: widget.itemCount,
      isExpanded: _expandedIndices.contains(index),
      headerBuilder: (BuildContext context, int i, double progress) {
        if (i < 0 || i >= _built.length) {
          return const SizedBox.shrink();
        }
        return _built[i];
      },
      bodyBuilder: (BuildContext context, int i, double progress) {
        return _expandBody(context, i, progress, decoration);
      },
      expanded: expanded,
      decoration: decoration,
      expandMotion: expandMotion,
      collapseMotion: collapseMotion,
      nestVariant: _variant(context, cardList),
      onToggle: () {
        if (!_enabledAt(index)) {
          return;
        }
        if (expanded != null && expanded.isTransform) {
          openTransform(index);
          return;
        }
        _toggle(index, allowMultiple: allowMultiple, haptic: decoration.haptic);
      },
      onTransform: () => openTransform(index),
      onTransformAnchor: (BuildContext anchor) {
        _transformAnchors[index] = anchor;
      },
    );
  }

  M3EExpandableStyle _decoration(
    BuildContext context,
    M3EListExpandableTheme expandable,
  ) {
    final M3EExpandableStyle base =
        widget.expandStyle ?? M3EExpandableStyle.fromTheme(expandable);
    final Color? color = widget.color;
    if (color == null) {
      return base;
    }
    return base.copyWith(color: color);
  }

  Widget _expandBody(
    BuildContext context,
    int index,
    double progress,
    M3EExpandableStyle decoration,
  ) {
    final M3EExpandableExpanded? expanded = _expandedAt(index);
    if (expanded == null ||
        expanded.isList ||
        expanded.isTransform ||
        progress <= 0) {
      return const SizedBox.shrink();
    }
    return ClipRect(
      child: Align(
        alignment: decoration.bodyAlignment,
        heightFactor: progress.clamp(0.0, 1.0),
        child: expanded.child,
      ),
    );
  }

  void _toggle(
    int index, {
    required bool allowMultiple,
    required M3EHapticFeedback haptic,
  }) {
    M3EHaptics.trigger(haptic);
    final bool opening = !_expandedIndices.contains(index);
    setState(() {
      if (opening) {
        if (!allowMultiple) {
          _expandedIndices.clear();
        }
        _expandedIndices.add(index);
      } else {
        _expandedIndices.remove(index);
      }
    });
    widget.onExpansionChanged?.call(index, isExpanded: opening);
  }

  /// Morphs [index] into its transform destination.
  void openTransform(int index) {
    final BuildContext? itemContext = _transformAnchors[index];
    if (itemContext == null || !itemContext.mounted) {
      return;
    }
    final RenderObject? object = itemContext.findRenderObject();
    if (object is! RenderBox || !object.hasSize) {
      return;
    }
    final M3EExpandableExpanded? expanded = _expandedAt(index);
    final Widget? destination = expanded != null && expanded.isTransform
        ? expanded.child
        : (index >= 0 && index < _transforms.length
              ? _transforms[index]
              : null);
    if (destination == null) {
      return;
    }
    final M3EThemeData theme = M3ETheme.of(itemContext);
    final M3ECardContainerTransformHandle<void>? previous = _transformHandle;
    _transformHandle = null;
    previous?.close();
    final M3ECardContainerTransformHandle<void> handle =
        M3ECardContainerTransform.show<void>(
          context: itemContext,
          origin: object.localToGlobal(Offset.zero) & object.size,
          originRadius: theme.listTheme.cardList.outerRadius,
          originColor: theme.colorScheme.surfaceContainerHighest,
          builder: (BuildContext context) => destination,
        );
    _transformHandle = handle;
    handle.future.whenComplete(() {
      if (identical(_transformHandle, handle)) {
        _transformHandle = null;
      }
    });
  }

  /// Reverses the open container transform.
  void closeTransform() {
    _transformHandle?.close();
    _transformHandle = null;
  }

  /// Snap-collapses [index] so reorder can measure the header.
  Future<void> prepareReorderDrag(int index) async {
    _collapsedForReorder = null;
    if (!_expandedIndices.contains(index)) {
      return;
    }
    _collapsedForReorder = index;
    _snapCollapse = true;
    setState(() => _expandedIndices.remove(index));
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) {
      return;
    }
    await WidgetsBinding.instance.endOfFrame;
  }

  /// Restores a row collapsed for reorder and remaps indices.
  void settleReorderDrag(int from, int to) {
    final int? pending = _collapsedForReorder;
    _collapsedForReorder = null;
    _snapCollapse = false;
    setState(() {
      _expandedIndices = _expandedIndices
          .map((int i) => _remapListIndex(i, from, to))
          .toSet();
      if (pending != null && pending == from) {
        _expandedIndices.add(to);
      }
    });
    if (from != to) {
      _remapSelection(from, to);
    }
  }

  void _remapSelection(int from, int to) {
    final M3EListFeatureScope? scope = M3EListFeatureScope.maybeOf(context);
    final M3ESelectionController? controller = scope?.controller;
    if (controller == null || scope == null || !scope.selectionEnabled) {
      return;
    }
    final Set<int> remapped = controller.selectedIndices
        .map((int i) => _remapListIndex(i, from, to))
        .toSet();
    if (remapped.length == controller.selectedIndices.length &&
        remapped.containsAll(controller.selectedIndices)) {
      return;
    }
    controller.clear();
    remapped.forEach(controller.select);
    widget.onSelectionChanged?.call(controller.selectedIndices);
  }
}

int _remapListIndex(int index, int from, int to) {
  if (index == from) {
    return to;
  }
  if (from < to && index > from && index <= to) {
    return index - 1;
  }
  if (from > to && index >= to && index < from) {
    return index + 1;
  }
  return index;
}
