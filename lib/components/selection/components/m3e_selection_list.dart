import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../cards/m3e_cards.dart';
import '../../lists/m3e_lists.dart';
import '../controllers/m3e_selection_controller.dart';
import '../styles/m3e_selection_theme.dart';
import 'm3e_selection_leading.dart';
import 'm3e_selection_scope.dart';

enum _M3ESelectionListLayout { list, column }

/// Multi-select list with card radii, leading flip, and selection gestures.
class M3ESelectionList extends StatefulWidget {
  /// Scrollable selection list ([ListView.builder]).
  const M3ESelectionList({
    required this.itemCount,
    required this.itemBuilder,
    required this.leadingBuilder,
    required this.selectedLeadingBuilder,
    this.controller,
    this.onTap,
    this.onSelected,
    this.onSelectionChanged,
    this.onAllSelected,
    this.padding,
    this.physics,
    this.primary,
    this.shrinkWrap = false,
    this.haptic = M3EHapticFeedback.medium,
    this.outerRadius,
    this.innerRadius,
    this.gap,
    this.itemPadding,
    this.variant,
    this.border,
    this.selectedColor,
    this.theme,
    super.key,
  }) : _layout = _M3ESelectionListLayout.list;

  /// Non-scrolling column of selection rows.
  const M3ESelectionList.column({
    required this.itemCount,
    required this.itemBuilder,
    required this.leadingBuilder,
    required this.selectedLeadingBuilder,
    this.controller,
    this.onTap,
    this.onSelected,
    this.onSelectionChanged,
    this.onAllSelected,
    this.padding,
    this.haptic = M3EHapticFeedback.medium,
    this.outerRadius,
    this.innerRadius,
    this.gap,
    this.itemPadding,
    this.variant,
    this.border,
    this.selectedColor,
    this.theme,
    super.key,
  }) : _layout = _M3ESelectionListLayout.column,
       physics = null,
       primary = null,
       shrinkWrap = true;

  final _M3ESelectionListLayout _layout;

  /// Selection controller. Optional when under [M3ESelectionScope].
  final M3ESelectionController? controller;

  /// Number of items.
  final int itemCount;

  /// Builds row content (typically a list item without a leading widget).
  final IndexedWidgetBuilder itemBuilder;

  /// Builds the idle leading widget for each index.
  final IndexedWidgetBuilder leadingBuilder;

  /// Builds the selected leading widget for each index.
  final IndexedWidgetBuilder selectedLeadingBuilder;

  /// Idle body tap (no selection change).
  final ValueChanged<int>? onTap;

  /// Called when an index is selected or deselected.
  // ignore: avoid_positional_boolean_parameters
  final void Function(int index, bool selected)? onSelected;

  /// Called whenever the selected set changes.
  final ValueChanged<Set<int>>? onSelectionChanged;

  /// Called when select-all / clear-all runs (`true` = all selected).
  final ValueChanged<bool>? onAllSelected;

  /// List padding.
  final EdgeInsetsGeometry? padding;

  /// Scroll physics (list layout only).
  final ScrollPhysics? physics;

  /// Whether this is the primary scroll view.
  final bool? primary;

  /// Whether the list should shrink-wrap its contents.
  final bool shrinkWrap;

  /// Haptic on long-press enter / toggle.
  final M3EHapticFeedback haptic;

  /// Outer card radius override.
  final double? outerRadius;

  /// Inner card radius override.
  final double? innerRadius;

  /// Gap between cards.
  final double? gap;

  /// Padding inside each card.
  final EdgeInsetsGeometry? itemPadding;

  /// Card variant override.
  final M3ECardVariant? variant;

  /// Card outline override.
  final BorderSide? border;

  /// Selected card fill override.
  final Color? selectedColor;

  /// Theme override.
  final M3ESelectionTheme? theme;

  @override
  State<M3ESelectionList> createState() => _M3ESelectionListState();
}

class _M3ESelectionListState extends State<M3ESelectionList> {
  M3ESelectionController? _listened;

  M3ESelectionController _resolveController(BuildContext context) {
    final M3ESelectionController? explicit = widget.controller;
    if (explicit != null) {
      return explicit;
    }
    final M3ESelectionScope? scope = M3ESelectionScope.maybeOf(context);
    assert(
      scope != null,
      'M3ESelectionList requires a controller or an M3ESelectionScope ancestor.',
    );
    return scope!.controller;
  }

  void _attach(M3ESelectionController controller) {
    if (_listened == controller) {
      return;
    }
    _listened?.removeListener(_onControllerChanged);
    _listened = controller;
    _listened!.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attach(_resolveController(context));
  }

  @override
  void didUpdateWidget(M3ESelectionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _attach(_resolveController(context));
  }

  @override
  void dispose() {
    _listened?.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _notifySelection(
    M3ESelectionController controller,
    int index,
    bool selected,
  ) {
    widget.onSelected?.call(index, selected);
    widget.onSelectionChanged?.call(controller.selectedIndices);
  }

  void _toggle(M3ESelectionController controller, int index) {
    M3EHaptics.trigger(widget.haptic);
    final bool selected = controller.toggle(index);
    _notifySelection(controller, index, selected);
  }

  void _longPress(M3ESelectionController controller, int index) {
    M3EHaptics.trigger(widget.haptic);
    if (!controller.isSelected(index)) {
      controller.select(index);
      _notifySelection(controller, index, true);
    }
  }

  void _bodyTap(M3ESelectionController controller, int index) {
    if (controller.isSelectionMode) {
      _toggle(controller, index);
    } else {
      widget.onTap?.call(index);
    }
  }

  Widget _buildRow(BuildContext context, int index) {
    final M3ESelectionController controller = _resolveController(context);
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EColorScheme scheme = theme.colorScheme;
    final M3ESelectionTheme selectionTheme =
        widget.theme ?? theme.selectionTheme;
    final double outer = widget.outerRadius ?? selectionTheme.outerRadius;
    final double inner = widget.innerRadius ?? selectionTheme.innerRadius;
    final double gap = widget.gap ?? selectionTheme.gap;
    final bool selected = controller.isSelected(index);
    final M3ECardPosition position = calculateCardPosition(
      index,
      widget.itemCount,
    );
    final BorderRadius radius = selected
        ? BorderRadius.circular(outer)
        : calculateCardRadius(
            position: position,
            outerRadius: outer,
            innerRadius: inner,
          );
    final Color color = selected
        ? (widget.selectedColor ?? selectionTheme.selectedColor(scheme))
        : theme.listTheme.cardList.backgroundColor(scheme);
    final bool isLast =
        position == M3ECardPosition.last || position == M3ECardPosition.single;
    final double leadingGap = theme.listTheme.item.gap;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : gap),
      child: M3ECard(
        variant: widget.variant ?? selectionTheme.variant,
        border: widget.border ?? selectionTheme.border,
        borderRadius: radius,
        color: color,
        padding: widget.itemPadding ?? selectionTheme.itemPadding,
        animationDuration: selectionTheme.leadingFlipDuration,
        animationCurve: const Cubic(0.2, 0, 0, 1),
        onPressed: () => _bodyTap(controller, index),
        onLongPress: () => _longPress(controller, index),
        width: double.infinity,
        child: M3EListItemScope(
          child: Row(
            children: <Widget>[
              M3ESelectionLeading(
                selected: selected,
                duration: selectionTheme.leadingFlipDuration,
                onTap: () => _toggle(controller, index),
                selectedChild: widget.selectedLeadingBuilder(context, index),
                child: widget.leadingBuilder(context, index),
              ),
              SizedBox(width: leadingGap),
              Expanded(child: widget.itemBuilder(context, index)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _attach(_resolveController(context));
    final EdgeInsetsGeometry padding =
        widget.padding ?? const EdgeInsets.symmetric(horizontal: 16);

    switch (widget._layout) {
      case _M3ESelectionListLayout.column:
        return Padding(
          padding: padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (var i = 0; i < widget.itemCount; i++) _buildRow(context, i),
            ],
          ),
        );
      case _M3ESelectionListLayout.list:
        return ListView.builder(
          padding: padding,
          physics: widget.physics,
          primary: widget.primary,
          shrinkWrap: widget.shrinkWrap,
          itemCount: widget.itemCount,
          itemBuilder: _buildRow,
        );
    }
  }
}
