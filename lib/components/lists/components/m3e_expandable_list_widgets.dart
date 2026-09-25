part of '../m3e_lists.dart';

enum _M3EExpandableListLayout { column, scrollable, sliver }

/// A spring-animated expandable card list.
///
/// Supports three layouts via named constructors:
/// - default / [M3EExpandableList.builder]: non-scrollable [Column]
/// - [M3EExpandableList.scrollable] / [M3EExpandableList.scrollableBuilder]:
///   [ListView.builder]
/// - [M3EExpandableList.sliver] / [M3EExpandableList.sliverBuilder]:
///   [SliverList.builder] for [CustomScrollView]
///
/// Header **reorder** and **selection** are supported on main expandable rows
/// (`reorder` / `onReorder`, `selection` / `selectionState`, …). Nested
/// sublists keep their own APIs via [M3EExpandableExpanded.list]. If a row is
/// expanded when a reorder drag starts, it snap-collapses and restores after
/// settle. Sliver layout supports selection but not reorder.
class M3EExpandableList extends M3EExpandableListBase {
  /// M3EExpandableList.
  M3EExpandableList({
    super.key,
    required List<M3EExpandableData> data,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
    super.transformController,
    super.selection = false,
    super.selectionController,
    super.onSelectionChanged,
    super.selectionState,
    super.reorder = false,
    super.onReorder,
    super.reorderState,
  }) : assert(
         !reorder || onReorder != null,
         'onReorder is required when reorder is true',
       ),
       _layout = _M3EExpandableListLayout.column,
       controller = null,
       physics = null,
       shrinkWrap = false,
       padding = null,
       super(
         itemCount: data.length,
         headerBuilder: m3eSimpleHeaderBuilder(data),
         bodyBuilder: m3eSimpleBodyBuilder(
           data,
           style ?? const M3EExpandableStyle(),
         ),
         expandedBuilder: m3eSimpleExpandedBuilder(data),
       );

  /// builder.

  const M3EExpandableList.builder({
    super.key,
    required super.itemCount,
    required super.headerBuilder,
    required super.bodyBuilder,
    super.expandedBuilder,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
    super.transformController,
    super.selection = false,
    super.selectionController,
    super.onSelectionChanged,
    super.selectionState,
    super.reorder = false,
    super.onReorder,
    super.reorderState,
  }) : assert(
         !reorder || onReorder != null,
         'onReorder is required when reorder is true',
       ),
       _layout = _M3EExpandableListLayout.column,
       controller = null,
       physics = null,
       shrinkWrap = false,
       padding = null;

  /// scrollable.

  M3EExpandableList.scrollable({
    super.key,
    required List<M3EExpandableData> data,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
    super.transformController,
    super.selection = false,
    super.selectionController,
    super.onSelectionChanged,
    super.selectionState,
    super.reorder = false,
    super.onReorder,
    super.reorderState,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
  }) : assert(
         !reorder || onReorder != null,
         'onReorder is required when reorder is true',
       ),
       _layout = _M3EExpandableListLayout.scrollable,
       super(
         itemCount: data.length,
         headerBuilder: m3eSimpleHeaderBuilder(data),
         bodyBuilder: m3eSimpleBodyBuilder(
           data,
           style ?? const M3EExpandableStyle(),
         ),
         expandedBuilder: m3eSimpleExpandedBuilder(data),
       );

  /// scrollableBuilder.

  const M3EExpandableList.scrollableBuilder({
    super.key,
    required super.itemCount,
    required super.headerBuilder,
    required super.bodyBuilder,
    super.expandedBuilder,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
    super.transformController,
    super.selection = false,
    super.selectionController,
    super.onSelectionChanged,
    super.selectionState,
    super.reorder = false,
    super.onReorder,
    super.reorderState,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
  }) : assert(
         !reorder || onReorder != null,
         'onReorder is required when reorder is true',
       ),
       _layout = _M3EExpandableListLayout.scrollable;

  /// sliver.
  ///
  /// Header reorder is not supported for the sliver layout.
  M3EExpandableList.sliver({
    super.key,
    required List<M3EExpandableData> data,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
    super.transformController,
    super.selection = false,
    super.selectionController,
    super.onSelectionChanged,
    super.selectionState,
  }) : _layout = _M3EExpandableListLayout.sliver,
       controller = null,
       physics = null,
       shrinkWrap = false,
       padding = null,
       super(
         itemCount: data.length,
         headerBuilder: m3eSimpleHeaderBuilder(data),
         bodyBuilder: m3eSimpleBodyBuilder(
           data,
           style ?? const M3EExpandableStyle(),
         ),
         expandedBuilder: m3eSimpleExpandedBuilder(data),
       );

  /// sliverBuilder.

  const M3EExpandableList.sliverBuilder({
    super.key,
    required super.itemCount,
    required super.headerBuilder,
    required super.bodyBuilder,
    super.expandedBuilder,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
    super.transformController,
    super.selection = false,
    super.selectionController,
    super.onSelectionChanged,
    super.selectionState,
  }) : _layout = _M3EExpandableListLayout.sliver,
       controller = null,
       physics = null,
       shrinkWrap = false,
       padding = null;

  final _M3EExpandableListLayout _layout;

  /// controller.
  final ScrollController? controller;

  /// physics.
  final ScrollPhysics? physics;

  /// shrinkWrap.
  final bool shrinkWrap;

  /// padding.
  final EdgeInsetsGeometry? padding;

  @override
  State<M3EExpandableList> createState() => _M3EExpandableListState();
}

class _M3EExpandableListState extends State<M3EExpandableList>
    with M3EExpandableStateMixin<M3EExpandableList> {
  Widget _buildExpandableLayout(BuildContext context) {
    switch (widget._layout) {
      case _M3EExpandableListLayout.column:
        return _buildColumnLayout(context);
      case _M3EExpandableListLayout.scrollable:
        return _buildScrollableLayout(context);
      case _M3EExpandableListLayout.sliver:
        return _buildSliverLayout();
    }
  }

  Widget _buildColumnLayout(BuildContext context) {
    if (widget.reorder) {
      return _buildReorderHost(context, scrollable: false);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.itemCount,
        (int index) => buildItem(context, index),
      ),
    );
  }

  Widget _buildScrollableLayout(BuildContext context) {
    if (widget.reorder) {
      return _buildReorderHost(context, scrollable: true);
    }
    return ListView.builder(
      controller: widget.controller,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemCount: widget.itemCount,
      itemBuilder: (BuildContext context, int index) =>
          buildItem(context, index),
    );
  }

  Widget _buildSliverLayout() {
    return SliverList.builder(
      itemCount: widget.itemCount,
      itemBuilder: (BuildContext context, int index) =>
          buildItem(context, index),
    );
  }

  Widget _buildReorderHost(BuildContext context, {required bool scrollable}) {
    final M3EListReorderState rs =
        widget.reorderState ?? M3ETheme.of(context).listTheme.reorder;
    return M3EListReorderHost(
      itemCount: widget.itemCount,
      onReorder: widget.onReorder!,
      reorderState: rs,
      // Items already apply [M3EExpandableStyle.gap].
      gap: 0,
      scrollable: scrollable,
      controller: widget.controller,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      prepareDrag: prepareReorderDrag,
      onDragSettled: settleReorderDrag,
      itemBuilder: (BuildContext context, int index) =>
          buildItem(context, index),
    );
  }

  Widget _wrapWithFeatures(Widget list) {
    if (!widget.selection && !widget.reorder) {
      return list;
    }
    return M3EListFeatureHost(
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

  @override
  Widget build(BuildContext context) {
    assert(
      widget._layout != _M3EExpandableListLayout.sliver || !widget.reorder,
      'M3EExpandableList.sliver does not support reorder.',
    );
    return M3EComponentTheme(
      builder: (BuildContext context) {
        final Widget list = _wrapWithFeatures(
          M3EListKeyboardGroup(
            itemCount: widget.itemCount,
            child: _buildExpandableLayout(context),
          ),
        );
        return M3EExpandableSnapCollapse(
          snap: snapCollapseForReorder,
          child: list,
        );
      },
    );
  }
}
