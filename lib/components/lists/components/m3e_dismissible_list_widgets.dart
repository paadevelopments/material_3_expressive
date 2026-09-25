part of '../m3e_lists.dart';

/// M3EDismissibleList.

class M3EDismissibleList extends StatefulWidget {
  /// M3EDismissibleList.
  const M3EDismissibleList({
    required this.itemCount,
    required this.itemBuilder,
    this.onDismiss,
    this.onTap,
    this.onLongPress,
    this.colorBuilder,
    this.borderRadiusBuilder,
    this.leadingActionsBuilder,
    this.trailingActionsBuilder,
    this.swipeMode = M3EListSwipeMode.both,
    this.dismissEdge = M3EListSwipeEdge.both,
    this.controller,
    this.style = const M3EDismissibleListStyle(),
    this.physics,
    this.scrollController,
    this.listPadding,
    this.shrinkWrap = false,
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
    super.key,
  }) : assert(
         !reorder || onReorder != null,
         'onReorder is required when reorder is true',
       );

  /// itemCount.

  final int itemCount;

  /// itemBuilder.
  final IndexedWidgetBuilder itemBuilder;

  /// Function.
  final Future<bool> Function(int index, DismissDirection direction)? onDismiss;

  /// Function.
  final void Function(int index)? onTap;

  /// Optional long-press callback.
  final void Function(int index)? onLongPress;

  /// Optional per-index card color.
  final Color? Function(int index)? colorBuilder;

  /// Optional per-index border radius.
  final BorderRadius? Function(int index, M3ECardPosition position)?
  borderRadiusBuilder;

  /// Start-to-end (LTR leading) swipe actions for the given index.
  final List<M3EListSwipeAction> Function(int index)? leadingActionsBuilder;

  /// End-to-start (LTR trailing) swipe actions for the given index.
  final List<M3EListSwipeAction> Function(int index)? trailingActionsBuilder;

  /// Reveal only, dismiss only, or reveal then dismiss.
  final M3EListSwipeMode swipeMode;

  /// Which manual swipe direction can dismiss.
  final M3EListSwipeEdge dismissEdge;

  /// Reveals or dismisses a row without a pointer drag.
  final M3EDismissibleListController? controller;

  /// style.
  final M3EDismissibleListStyle style;

  /// physics.
  final ScrollPhysics? physics;

  /// scrollController.
  final ScrollController? scrollController;

  /// listPadding.
  final EdgeInsetsGeometry? listPadding;

  /// shrinkWrap.
  final bool shrinkWrap;

  /// clipBehavior.
  final Clip clipBehavior;

  /// Enables list selection.
  final bool selection;

  /// Enables long-press reorder. Requires [onReorder].
  final bool reorder;

  /// Optional selection controller; ancestor scope wins.
  final M3ESelectionController? selectionController;

  /// Called when selection indices change.
  final ValueChanged<Set<int>>? onSelectionChanged;

  /// Called after a reorder drop. Required when [reorder] is true.
  final ReorderCallback? onReorder;

  /// Optional selection state override.
  final M3EListSelectionState? selectionState;

  /// Optional reorder state override.
  final M3EListReorderState? reorderState;

  /// When true, all cards use inner radius (no first/last outer extremities).
  /// When true, corner radii stay inset for a nested list.
  final bool embedded;

  /// List-box description for assistive tech.
  final String? semanticsLabel;

  @override
  State<M3EDismissibleList> createState() => _M3EDismissibleListState();
}

class _M3EDismissibleListState extends State<M3EDismissibleList>
    with
        TickerProviderStateMixin,
        M3EDismissibleCardMixin,
        M3EDismissibleCardDragMixin,
        M3EDismissibleCardBuildMixin {
  @override
  int get swipeItemCount => widget.itemCount;

  @override
  Widget swipeItemBuilder(BuildContext context, int dataIndex) {
    return Builder(
      builder: (BuildContext context) {
        return M3EListItemIndex(
          index: dataIndex,
          child: widget.itemBuilder(context, dataIndex),
        );
      },
    );
  }

  @override
  M3EDismissibleListStyle get style => widget.style;

  @override
  bool get embedded => widget.embedded;

  @override
  bool get listReorderEnabled => widget.reorder;

  @override
  Future<bool> Function(int, DismissDirection)? get onDismissCallback =>
      widget.onDismiss;

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
      widget.leadingActionsBuilder;

  @override
  List<M3EListSwipeAction> Function(int index)? get trailingActionsBuilder =>
      widget.trailingActionsBuilder;

  @override
  M3EListSwipeMode get swipeMode => widget.swipeMode;

  @override
  M3EListSwipeEdge get dismissEdge => widget.dismissEdge;

  @override
  void initState() {
    super.initState();
    initSlots();
    bindSwipeController(widget.controller);
  }

  @override
  void didUpdateWidget(M3EDismissibleList old) {
    super.didUpdateWidget(old);
    syncSlotsIfNeeded(old.itemCount);
    bindSwipeController(widget.controller);
  }

  @override
  void dispose() {
    unbindSwipeController();
    disposeSlots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildList);
  }

  Widget _buildList(BuildContext context) {
    final List<int> visible = computeVisibleIndices();
    Widget list;
    if (widget.reorder) {
      final M3EListReorderState rs =
          widget.reorderState ?? M3ETheme.of(context).listTheme.reorder;
      list = M3EListReorderHost(
        itemCount: slots.length,
        onReorder: widget.onReorder!,
        reorderState: rs,
        gap: 0,
        scrollable: true,
        controller: widget.scrollController,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        padding: widget.listPadding,
        canStartDrag: (int index) =>
            !isInteractionLocked &&
            index >= 0 &&
            index < slots.length &&
            slots[index].isVisible,
        itemBuilder: (BuildContext context, int index) =>
            buildSlot(context, index, visible),
      );
    } else {
      list = ListView.builder(
        controller: widget.scrollController,
        physics: widget.physics,
        padding: widget.listPadding,
        shrinkWrap: widget.shrinkWrap,
        clipBehavior: widget.clipBehavior,
        itemCount: slots.length,
        itemBuilder: (BuildContext ctx, int i) => buildSlot(ctx, i, visible),
      );
    }

    list = M3EListKeyboardGroup(
      itemCount: widget.itemCount,
      semanticsLabel: widget.semanticsLabel,
      child: list,
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

    return list;
  }
}

/// A dismissible Material 3 list backed by a [Column].
///
/// Ideal for small, fixed-size lists. All items are materialized up-front.
class M3EDismissibleColumn extends StatefulWidget {
  /// M3EDismissibleColumn.
  const M3EDismissibleColumn({
    required this.itemCount,
    required this.itemBuilder,
    this.onDismiss,
    this.onTap,
    this.onLongPress,
    this.colorBuilder,
    this.borderRadiusBuilder,
    this.leadingActionsBuilder,
    this.trailingActionsBuilder,
    this.swipeMode = M3EListSwipeMode.both,
    this.dismissEdge = M3EListSwipeEdge.both,
    this.controller,
    this.style = const M3EDismissibleListStyle(),
    this.selection = false,
    this.reorder = false,
    this.selectionController,
    this.onSelectionChanged,
    this.onReorder,
    this.selectionState,
    this.reorderState,
    this.embedded = false,
    this.semanticsLabel,
    super.key,
  }) : assert(
         !reorder || onReorder != null,
         'onReorder is required when reorder is true',
       );

  /// itemCount.

  final int itemCount;

  /// itemBuilder.
  final IndexedWidgetBuilder itemBuilder;

  /// Function.
  final Future<bool> Function(int index, DismissDirection direction)? onDismiss;

  /// Function.
  final void Function(int index)? onTap;

  /// Optional long-press callback.
  final void Function(int index)? onLongPress;

  /// Optional per-index card color.
  final Color? Function(int index)? colorBuilder;

  /// Optional per-index border radius.
  final BorderRadius? Function(int index, M3ECardPosition position)?
  borderRadiusBuilder;

  /// Start-to-end (LTR leading) swipe actions for the given index.
  final List<M3EListSwipeAction> Function(int index)? leadingActionsBuilder;

  /// End-to-start (LTR trailing) swipe actions for the given index.
  final List<M3EListSwipeAction> Function(int index)? trailingActionsBuilder;

  /// Reveal only, dismiss only, or reveal then dismiss.
  final M3EListSwipeMode swipeMode;

  /// Which manual swipe direction can dismiss.
  final M3EListSwipeEdge dismissEdge;

  /// Reveals or dismisses a row without a pointer drag.
  final M3EDismissibleListController? controller;

  /// style.
  final M3EDismissibleListStyle style;

  /// Enables list selection.
  final bool selection;

  /// Enables long-press reorder. Requires [onReorder].
  final bool reorder;

  /// Optional selection controller.
  final M3ESelectionController? selectionController;

  /// Called when selection indices change.
  final ValueChanged<Set<int>>? onSelectionChanged;

  /// Called after a reorder drop. Required when [reorder] is true.
  final ReorderCallback? onReorder;

  /// Optional selection state override.
  final M3EListSelectionState? selectionState;

  /// Optional reorder state override.
  final M3EListReorderState? reorderState;

  /// When true, all cards use inner radius (no first/last outer extremities).
  /// When true, corner radii stay inset for a nested list.
  final bool embedded;

  /// List-box description for assistive tech.
  final String? semanticsLabel;

  /// of.

  factory M3EDismissibleColumn.of({
    required List<Widget> children,
    Future<bool> Function(int index, DismissDirection direction)? onDismiss,
    void Function(int index)? onTap,
    void Function(int index)? onLongPress,
    Color? Function(int index)? colorBuilder,
    BorderRadius? Function(int index, M3ECardPosition position)?
    borderRadiusBuilder,
    List<M3EListSwipeAction> Function(int index)? leadingActionsBuilder,
    List<M3EListSwipeAction> Function(int index)? trailingActionsBuilder,
    M3EListSwipeMode swipeMode = M3EListSwipeMode.both,
    M3EListSwipeEdge dismissEdge = M3EListSwipeEdge.both,
    M3EDismissibleListController? controller,
    M3EDismissibleListStyle style = const M3EDismissibleListStyle(),
    bool selection = false,
    bool reorder = false,
    M3ESelectionController? selectionController,
    ValueChanged<Set<int>>? onSelectionChanged,
    ReorderCallback? onReorder,
    M3EListSelectionState? selectionState,
    M3EListReorderState? reorderState,
    bool embedded = false,
    Key? key,
  }) {
    return M3EDismissibleColumn(
      key: key,
      itemCount: children.length,
      itemBuilder: (_, i) => children[i],
      onDismiss: onDismiss,
      onTap: onTap,
      onLongPress: onLongPress,
      colorBuilder: colorBuilder,
      borderRadiusBuilder: borderRadiusBuilder,
      leadingActionsBuilder: leadingActionsBuilder,
      trailingActionsBuilder: trailingActionsBuilder,
      swipeMode: swipeMode,
      dismissEdge: dismissEdge,
      controller: controller,
      style: style,
      selection: selection,
      reorder: reorder,
      selectionController: selectionController,
      onSelectionChanged: onSelectionChanged,
      onReorder: onReorder,
      selectionState: selectionState,
      reorderState: reorderState,
      embedded: embedded,
    );
  }

  @override
  State<M3EDismissibleColumn> createState() => _M3EDismissibleColumnState();
}

class _M3EDismissibleColumnState extends State<M3EDismissibleColumn>
    with
        TickerProviderStateMixin,
        M3EDismissibleCardMixin,
        M3EDismissibleCardDragMixin,
        M3EDismissibleCardBuildMixin {
  @override
  int get swipeItemCount => widget.itemCount;

  @override
  Widget swipeItemBuilder(BuildContext context, int dataIndex) {
    return Builder(
      builder: (BuildContext context) {
        return M3EListItemIndex(
          index: dataIndex,
          child: widget.itemBuilder(context, dataIndex),
        );
      },
    );
  }

  @override
  M3EDismissibleListStyle get style => widget.style;

  @override
  bool get embedded => widget.embedded;

  @override
  bool get listReorderEnabled => widget.reorder;

  @override
  Future<bool> Function(int, DismissDirection)? get onDismissCallback =>
      widget.onDismiss;

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
      widget.leadingActionsBuilder;

  @override
  List<M3EListSwipeAction> Function(int index)? get trailingActionsBuilder =>
      widget.trailingActionsBuilder;

  @override
  M3EListSwipeMode get swipeMode => widget.swipeMode;

  @override
  M3EListSwipeEdge get dismissEdge => widget.dismissEdge;

  @override
  void initState() {
    super.initState();
    initSlots();
    bindSwipeController(widget.controller);
  }

  @override
  void didUpdateWidget(M3EDismissibleColumn old) {
    super.didUpdateWidget(old);
    syncSlotsIfNeeded(old.itemCount);
    bindSwipeController(widget.controller);
  }

  @override
  void dispose() {
    unbindSwipeController();
    disposeSlots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildColumn);
  }

  Widget _buildColumn(BuildContext context) {
    final List<int> visible = computeVisibleIndices();
    Widget column;
    if (widget.reorder) {
      final M3EListReorderState rs =
          widget.reorderState ?? M3ETheme.of(context).listTheme.reorder;
      column = M3EListReorderHost(
        itemCount: slots.length,
        onReorder: widget.onReorder!,
        reorderState: rs,
        gap: 0,
        canStartDrag: (int index) =>
            !isInteractionLocked &&
            index >= 0 &&
            index < slots.length &&
            slots[index].isVisible,
        itemBuilder: (BuildContext context, int index) =>
            buildSlot(context, index, visible),
      );
    } else {
      column = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < slots.length; i++) buildSlot(context, i, visible),
        ],
      );
    }

    column = M3EListKeyboardGroup(
      itemCount: widget.itemCount,
      semanticsLabel: widget.semanticsLabel,
      child: column,
    );
    if (widget.selection || widget.reorder) {
      column = M3EListFeatureHost(
        itemCount: widget.itemCount,
        selection: widget.selection,
        reorder: widget.reorder,
        selectionController: widget.selectionController,
        onSelectionChanged: widget.onSelectionChanged,
        selectionState: widget.selectionState,
        reorderState: widget.reorderState,
        child: column,
      );
    }

    return column;
  }
}
