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
    this.style = const M3EDismissibleListStyle(),
    this.physics,
    this.scrollController,
    this.listPadding,
    this.shrinkWrap = false,
    this.clipBehavior = Clip.hardEdge,
    super.key,
  });

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
  Widget swipeItemBuilder(BuildContext context, int dataIndex) =>
      widget.itemBuilder(context, dataIndex);

  @override
  M3EDismissibleListStyle get style => widget.style;

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
  void initState() {
    super.initState();
    initSlots();
  }

  @override
  void didUpdateWidget(M3EDismissibleList old) {
    super.didUpdateWidget(old);
    syncSlotsIfNeeded(old.itemCount);
  }

  @override
  void dispose() {
    disposeSlots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildList);
  }

  Widget _buildList(BuildContext context) {
    final visible = computeVisibleIndices();
    return ListView.builder(
      controller: widget.scrollController,
      physics: widget.physics,
      padding: widget.listPadding,
      shrinkWrap: widget.shrinkWrap,
      clipBehavior: widget.clipBehavior,
      itemCount: slots.length,
      itemBuilder: (ctx, i) => buildSlot(ctx, i, visible),
    );
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
    this.style = const M3EDismissibleListStyle(),
    super.key,
  });

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

  /// style.
  final M3EDismissibleListStyle style;

  /// of.

  factory M3EDismissibleColumn.of({
    required List<Widget> children,
    Future<bool> Function(int index, DismissDirection direction)? onDismiss,
    void Function(int index)? onTap,
    void Function(int index)? onLongPress,
    Color? Function(int index)? colorBuilder,
    BorderRadius? Function(int index, M3ECardPosition position)?
    borderRadiusBuilder,
    M3EDismissibleListStyle style = const M3EDismissibleListStyle(),
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
      style: style,
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
  Widget swipeItemBuilder(BuildContext context, int dataIndex) =>
      widget.itemBuilder(context, dataIndex);

  @override
  M3EDismissibleListStyle get style => widget.style;

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
  void initState() {
    super.initState();
    initSlots();
  }

  @override
  void didUpdateWidget(M3EDismissibleColumn old) {
    super.didUpdateWidget(old);
    syncSlotsIfNeeded(old.itemCount);
  }

  @override
  void dispose() {
    disposeSlots();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildColumn);
  }

  Widget _buildColumn(BuildContext context) {
    final visible = computeVisibleIndices();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < slots.length; i++) buildSlot(context, i, visible),
      ],
    );
  }
}
