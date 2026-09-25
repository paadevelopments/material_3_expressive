part of '../m3e_lists.dart';

/// A Material 3 interactive card list with dynamically rounded corners.
///
/// `M3ECardList` renders a vertical list of items, where the first and last
/// items automatically have a larger outer radius, and the inner items have
/// a smaller inner radius, adhering to Material 3's expressive list design.
class M3ECardList extends StatelessWidget {
  /// The number of items in the list.
  final int itemCount;

  /// Signature for a function that creates a widget for a given index.
  final IndexedWidgetBuilder itemBuilder;

  /// The radius used for the top corners of the first item, the bottom corners
  /// of the last item, and all corners of a single item.
  ///
  /// Defaults to [M3EListCardListTheme.defaultOuterRadius].
  final double outerRadius;

  /// The radius used for the inner corners of adjoining items.
  ///
  /// Defaults to [M3EListCardListTheme.defaultInnerRadius].
  final double innerRadius;

  /// The gap space between adjacent items.
  ///
  /// Defaults to [M3EListCardListTheme.defaultGap].
  final double gap;

  /// The background color for each card.
  ///
  /// Defaults to `M3EListCardListTheme.defaults.backgroundColor` if null.
  /// Overridden per index when [colorBuilder] returns a non-null color.
  final Color? color;

  /// Optional per-index card color. Non-null wins over [color].
  final Color? Function(int index)? colorBuilder;

  /// Optional per-index border radius. Non-null wins over position radii.
  final BorderRadius? Function(int index, M3ECardPosition position)?
  borderRadiusBuilder;

  /// The inner padding applied to the [itemBuilder] child of each item.
  ///
  /// Defaults to [M3EListCardListTheme.defaultItemPadding] via [M3ECardListItem].
  final EdgeInsetsGeometry? padding;

  /// The outer margin applied around the entire list of cards.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry? margin;

  /// Optional callback invoked when an item is tapped.
  ///
  /// Provides the `index` of the tapped item.
  final void Function(int index)? onTap;

  /// Optional callback invoked when an item is long-pressed.
  ///
  /// Provides the `index` of the long-pressed item.
  final void Function(int index)? onLongPress;

  /// Optional semantic label builder for accessibility.
  ///
  /// Each card's label is derived from this builder for screen readers.
  final String Function(int index)? semanticLabelBuilder;

  /// The cursor for a mouse pointer when it enters a card's bounds.
  final MouseCursor? mouseCursor;

  /// The haptic feedback to provide on tap.
  ///
  /// Defaults to [M3EHapticFeedback.none].
  final M3EHapticFeedback haptic;

  /// Card variant override; falls back to [M3EListCardListTheme.variant].
  final M3ECardVariant? variant;

  /// Card outline override; falls back to [M3EListCardListTheme.border].
  final BorderSide? border;

  /// Widget displayed when the list is empty (itemCount is 0).
  ///
  /// If null, an empty container is shown.
  final Widget? emptyBuilder;

  /// Enables list selection (single/multiple via theme selection state).
  final bool selection;

  /// Enables long-press reorder. Requires [onReorder].
  final bool reorder;

  /// Optional selection controller; ancestor [M3ESelectionScope] wins.
  final M3ESelectionController? selectionController;

  /// Called when selection indices change.
  final ValueChanged<Set<int>>? onSelectionChanged;

  /// Called after a reorder drop. Required when [reorder] is true.
  final ReorderCallback? onReorder;

  /// Optional selection state override (else [M3EListTheme.selection]).
  final M3EListSelectionState? selectionState;

  /// Optional reorder state override (else [M3EListTheme.reorder]).
  final M3EListReorderState? reorderState;

  /// Optional list-box description for assistive tech.
  final String? semanticsLabel;

  /// When true, first/last/single cards use [innerRadius] on all corners
  /// (same as middle items). Use for nested lists under expandable headers.
  final bool embedded;

  /// Whether this list uses [ListView.builder] (true) or [Column] (false).
  final bool _isBuilder;

  /// Controls the scroll position of the list.
  ///
  /// Only used by [M3ECardList.builder].
  final ScrollController? controller;

  /// How the scroll view should respond to user input.
  ///
  /// Only used by [M3ECardList.builder].
  final ScrollPhysics? physics;

  /// Whether the scroll view should size itself to fit its children.
  ///
  /// When `false` (the default), the list expands to fill the available space.
  /// Set to `true` when embedding in another scrollable.
  ///
  /// Only used by [M3ECardList.builder].
  final bool shrinkWrap;

  /// Padding for the scrollable list itself.
  ///
  /// Adds empty space at the edges of the list. Distinct from [margin], which
  /// wraps the entire list, and [padding], which goes inside each card.
  ///
  /// Only used by [M3ECardList.builder].
  final EdgeInsetsGeometry? listPadding;

  /// Creates a [M3ECardList] that uses a [Column] internally.
  ///
  /// Best for short lists where lazy loading is not required.
  const M3ECardList({
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
  }) : assert(
         !reorder || onReorder != null,
         'onReorder is required when reorder is true',
       ),
       _isBuilder = false,
       controller = null,
       physics = null,
       shrinkWrap = false,
       listPadding = null;

  /// Creates a [M3ECardList] that uses a [ListView.builder] internally.
  const M3ECardList.builder({
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
    this.selection = false,
    this.reorder = false,
    this.selectionController,
    this.onSelectionChanged,
    this.onReorder,
    this.selectionState,
    this.reorderState,
    this.embedded = false,
    this.semanticsLabel,
  }) : assert(
         !reorder || onReorder != null,
         'onReorder is required when reorder is true',
       ),
       _isBuilder = true;

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildList);
  }

  Widget _buildList(BuildContext context) {
    final Widget? empty = _buildEmptyContent();
    if (empty != null) {
      return empty;
    }

    Widget list = _buildListBody(context);
    list = M3EListKeyboardGroup(
      itemCount: itemCount,
      semanticsLabel: semanticsLabel,
      child: list,
    );
    list = _wrapWithFeatures(list);
    return _wrapWithMargin(list);
  }

  Widget? _buildEmptyContent() {
    final Widget? localEmptyBuilder = emptyBuilder;
    if (itemCount != 0 || localEmptyBuilder == null) {
      return null;
    }
    return _wrapWithMargin(localEmptyBuilder);
  }

  Widget _buildListBody(BuildContext context) {
    if (reorder) {
      return _buildReorderHost(context);
    }
    if (_isBuilder) {
      return _buildScrollableList();
    }
    return _buildColumnList(context);
  }

  Widget _buildReorderHost(BuildContext context) {
    final M3EListReorderState rs =
        reorderState ?? M3ETheme.of(context).listTheme.reorder;
    return M3EListReorderHost(
      itemCount: itemCount,
      onReorder: onReorder!,
      reorderState: rs,
      gap: gap,
      scrollable: _isBuilder,
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: listPadding,
      itemBuilder: (BuildContext context, int index) =>
          _buildItem(context, index, itemCount),
    );
  }

  Widget _buildScrollableList() {
    return ListView.builder(
      controller: controller,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: listPadding,
      itemCount: itemCount,
      itemBuilder: (context, index) => _buildItem(context, index, itemCount),
    );
  }

  Widget _buildColumnList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        itemCount,
        (index) => _buildItem(context, index, itemCount),
      ),
    );
  }

  Widget _wrapWithFeatures(Widget list) {
    if (!selection && !reorder) {
      return list;
    }
    return M3EListFeatureHost(
      itemCount: itemCount,
      selection: selection,
      reorder: reorder,
      selectionController: selectionController,
      onSelectionChanged: onSelectionChanged,
      selectionState: selectionState,
      reorderState: reorderState,
      child: list,
    );
  }

  Widget _wrapWithMargin(Widget child) {
    final EdgeInsetsGeometry? localMargin = margin;
    if (localMargin == null) {
      return child;
    }
    return Padding(padding: localMargin, child: child);
  }

  Widget _buildItem(BuildContext context, int index, int total) {
    return Builder(
      builder: (BuildContext context) =>
          _buildIndexedItem(context, index, total),
    );
  }

  Widget _buildIndexedItem(BuildContext context, int index, int total) {
    final M3EListItemTheme itemTheme = M3ETheme.of(context).listTheme.item;
    final double usedOuter = _baselineOr(
      itemTheme,
      outerRadius,
      M3EListCardListTheme.defaultOuterRadius,
    );
    final double usedInner = _baselineOr(
      itemTheme,
      innerRadius,
      M3EListCardListTheme.defaultInnerRadius,
    );
    final double usedGap = _baselineOr(
      itemTheme,
      gap,
      M3EListCardListTheme.defaultGap,
    );
    final M3ECardPosition position = calculateCardPosition(index, total);
    final M3EListFeatureScope? features = M3EListFeatureScope.maybeOf(context);

    final Widget built = itemBuilder(context, index);
    final bool itemEnabled = built is! M3EListItem || built.enabled;
    final Widget child = M3EListItemIndex(index: index, child: built);

    return M3EListTapBinder(
      onTap: _tapCallbackForIndex(features, index),
      onDoubleTap: _doubleTapCallback(features, index),
      builder: (BuildContext context, VoidCallback? onPressed) {
        return _buildCardListItem(
          context: context,
          index: index,
          position: position,
          outerRadius: usedOuter,
          innerRadius: usedInner,
          gap: usedGap,
          selectedRadius: itemTheme.selectedRadius,
          itemEnabled: itemEnabled,
          child: child,
          onPressed: onPressed,
        );
      },
    );
  }

  double _baselineOr(M3EListItemTheme theme, double value, double specDefault) {
    if (theme.isBaseline && value == specDefault) {
      return 0;
    }
    return value;
  }

  VoidCallback? _tapCallbackForIndex(M3EListFeatureScope? features, int index) {
    final void Function(int index)? tapForIndex = _resolveOnTap(features);
    if (tapForIndex == null) {
      return null;
    }
    return () => tapForIndex(index);
  }

  VoidCallback? _doubleTapCallback(M3EListFeatureScope? features, int index) {
    if (features == null || !features.selectionEnabled) {
      return null;
    }
    if (features.selectionState.trigger != M3EListSelectionTrigger.doubleTap) {
      return null;
    }
    return () => features.onToggleSelection(index);
  }

  Widget _buildCardListItem({
    required BuildContext context,
    required int index,
    required M3ECardPosition position,
    required double outerRadius,
    required double innerRadius,
    required double gap,
    required double selectedRadius,
    required bool itemEnabled,
    required Widget child,
    required VoidCallback? onPressed,
  }) {
    final M3EListCardListTheme cardListTheme = M3ETheme.of(context)
        .listTheme
        .cardList;
    // When reorder is on, long-press is owned by the reorder host.
    final void Function(int index)? longPress = reorder ? null : onLongPress;
    return M3ECardListItem(
      index: index,
      position: position,
      outerRadius: outerRadius,
      innerRadius: innerRadius,
      gap: gap,
      embedded: embedded,
      color: color,
      resolvedColor:
          colorBuilder?.call(index) ?? m3eSelectionFill(context, index),
      resolvedBorderRadius:
          borderRadiusBuilder?.call(index, position) ??
          m3eSelectionRadius(context, index, outerRadius: selectedRadius),
      padding: padding,
      onTap: !itemEnabled || onPressed == null ? null : (_) => onPressed(),
      onLongPress: longPress,
      semanticLabel: semanticLabelBuilder?.call(index),
      mouseCursor: mouseCursor,
      haptic: haptic,
      variant: variant ?? cardListTheme.variant,
      border: border ?? cardListTheme.border,
      child: child,
    );
  }

  void Function(int index)? _resolveOnTap(M3EListFeatureScope? features) {
    if (features == null || !features.selectionEnabled) {
      return onTap;
    }
    return (int index) {
      final bool inMode = features.controller?.isSelectionMode ?? false;
      if (inMode) {
        features.onToggleSelection(index);
        return;
      }
      onTap?.call(index);
    };
  }
}
