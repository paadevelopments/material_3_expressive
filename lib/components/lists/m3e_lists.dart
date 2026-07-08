import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../buttons/enums/m3e_button_enums.dart';
import 'components/m3e_card_list_item.dart';
import 'controllers/m3e_dismissible_card_controller.dart';
import 'styles/m3e_card_list_tokens.dart';
import 'styles/m3e_dismissible_list_style.dart';
import 'styles/m3e_list_item_tokens.dart';

export 'components/m3e_expandable_card_column.dart';
export 'components/m3e_expandable_card_list.dart';
export 'components/m3e_expandable_data.dart';
export 'components/m3e_expandable_item.dart';
export 'components/sliver_m3e_expandable_card_list.dart';
export 'enums/m3e_expandable_enums.dart';
export 'enums/m3e_list_enums.dart';
export 'styles/m3e_card_list_tokens.dart';
export 'styles/m3e_dismissible_list_style.dart';
export 'styles/m3e_dismissible_list_tokens.dart';
export 'styles/m3e_expandable_list_tokens.dart';
export 'styles/m3e_expandable_style.dart';
export 'styles/m3e_expandable_theme.dart';
export 'styles/m3e_list_item_tokens.dart';

/// A Material 3 Expressive list item.
///
/// A single row of a list with optional leading and trailing widgets, a
/// headline and up to three lines of supporting text. Becomes interactive with
/// state layers when [onTap] is supplied.
class M3EListItem extends StatelessWidget {
  const M3EListItem({
    required this.headline,
    this.supportingText,
    this.overline,
    this.leading,
    this.trailing,
    this.onTap,
    this.selected = false,
    super.key,
  });

  final String headline;
  final String? supportingText;
  final String? overline;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    if (onTap == null) {
      return _buildRow(theme, const M3EInteractionState());
    }
    return M3ETappable(
      onTap: onTap,
      semanticButton: false,
      semanticLabel: headline,
      builder: (BuildContext context, M3EInteractionState state) {
        return _buildRow(theme, state);
      },
    );
  }

  Widget _buildRow(M3EThemeData theme, M3EInteractionState state) {
    final scheme = theme.colorScheme;
    final bool threeLine = _isThreeLine;
    final CrossAxisAlignment alignment =
        threeLine ? CrossAxisAlignment.start : CrossAxisAlignment.center;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: IgnorePointer(
            child: ColoredBox(
              color: selected
                  ? M3EListItemTokens.selectedColor(scheme)
                  : scheme.onSurface.withValues(alpha: state.opacity),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: M3EListItemTokens.horizontalPadding,
            vertical: threeLine
                ? M3EListItemTokens.threeLineVerticalPadding
                : M3EListItemTokens.verticalPadding,
          ),
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(minHeight: M3EListItemTokens.minHeight),
            child: Row(
              crossAxisAlignment: alignment,
              children: _buildChildren(theme),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildren(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    return <Widget>[
      if (leading != null) ...<Widget>[
        IconTheme.merge(
          data: IconThemeData(
            color: M3EListItemTokens.iconColor(scheme),
            size: M3EListItemTokens.iconSize,
          ),
          child: leading!,
        ),
        const SizedBox(width: M3EListItemTokens.gap),
      ],
      Expanded(child: _buildText(theme)),
      if (trailing != null) ...<Widget>[
        const SizedBox(width: M3EListItemTokens.gap),
        IconTheme.merge(
          data: IconThemeData(
            color: M3EListItemTokens.iconColor(scheme),
            size: M3EListItemTokens.iconSize,
          ),
          child: trailing!,
        ),
      ],
    ];
  }

  Widget _buildText(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    final type = theme.typeScale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (overline != null)
          Text(
            overline!,
            style: M3EListItemTokens.overlineStyle(type, scheme),
          ),
        Text(
          headline,
          style: M3EListItemTokens.headlineStyle(type, scheme),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (supportingText != null)
          Text(
            supportingText!,
            style: M3EListItemTokens.supportingStyle(type, scheme),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  bool get _isThreeLine => supportingText != null && overline != null;
}

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
  /// Defaults to [M3ECardListTokens.outerRadius].
  final double outerRadius;

  /// The radius used for the inner corners of adjoining items.
  ///
  /// Defaults to [M3ECardListTokens.innerRadius].
  final double innerRadius;

  /// The gap space between adjacent items.
  ///
  /// Defaults to [M3ECardListTokens.gap].
  final double gap;

  /// The background color for each card.
  ///
  /// Defaults to [M3ECardListTokens.backgroundColor] if null.
  final Color? color;

  /// The inner padding applied to the [itemBuilder] child of each item.
  ///
  /// Defaults to [M3ECardListTokens.itemPadding] via [M3ECardListItem].
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

  /// Widget displayed when the list is empty (itemCount is 0).
  ///
  /// If null, an empty container is shown.
  final Widget? emptyBuilder;

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
    this.outerRadius = M3ECardListTokens.outerRadius,
    this.innerRadius = M3ECardListTokens.innerRadius,
    this.gap = M3ECardListTokens.gap,
    this.color,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.semanticLabelBuilder,
    this.mouseCursor,
    this.haptic = M3EHapticFeedback.none,
    this.emptyBuilder,
  })  : _isBuilder = false,
        controller = null,
        physics = null,
        shrinkWrap = false,
        listPadding = null;

  /// Creates a [M3ECardList] that uses a [ListView.builder] internally.
  const M3ECardList.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.outerRadius = M3ECardListTokens.outerRadius,
    this.innerRadius = M3ECardListTokens.innerRadius,
    this.gap = M3ECardListTokens.gap,
    this.color,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.semanticLabelBuilder,
    this.mouseCursor,
    this.haptic = M3EHapticFeedback.none,
    this.emptyBuilder,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.listPadding,
  }) : _isBuilder = true;

  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry? localMargin = margin;
    final Widget? localEmptyBuilder = emptyBuilder;

    if (itemCount == 0 && localEmptyBuilder != null) {
      return localMargin != null
          ? Padding(padding: localMargin, child: localEmptyBuilder)
          : localEmptyBuilder;
    }

    if (_isBuilder) {
      final Widget list = ListView.builder(
        controller: controller,
        physics: physics,
        shrinkWrap: shrinkWrap,
        padding: listPadding,
        itemCount: itemCount,
        itemBuilder: (context, index) => _buildItem(context, index, itemCount),
      );
      return localMargin != null
          ? Padding(padding: localMargin, child: list)
          : list;
    }

    final Widget column = Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        itemCount,
        (index) => _buildItem(context, index, itemCount),
      ),
    );
    return localMargin != null
        ? Padding(padding: localMargin, child: column)
        : column;
  }

  Widget _buildItem(BuildContext context, int index, int total) {
    return M3ECardListItem(
      index: index,
      position: calculateCardPosition(index, total),
      outerRadius: outerRadius,
      innerRadius: innerRadius,
      gap: gap,
      color: color,
      padding: padding,
      onTap: onTap,
      onLongPress: onLongPress,
      semanticLabel: semanticLabelBuilder?.call(index),
      mouseCursor: mouseCursor,
      haptic: haptic,
      child: itemBuilder(context, index),
    );
  }
}

/// A dismissible Material 3 list backed by [ListView.builder].
///
/// Suitable for large or lazily-loaded data sets. Only visible items are
/// materialized.
class M3EDismissibleList extends StatefulWidget {
  const M3EDismissibleList({
    required this.itemCount,
    required this.itemBuilder,
    this.onDismiss,
    this.onTap,
    this.style = const M3EDismissibleListStyle(),
    this.physics,
    this.scrollController,
    this.listPadding,
    this.shrinkWrap = false,
    this.clipBehavior = Clip.hardEdge,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Future<bool> Function(int index, DismissDirection direction)? onDismiss;
  final void Function(int index)? onTap;
  final M3EDismissibleListStyle style;
  final ScrollPhysics? physics;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? listPadding;
  final bool shrinkWrap;
  final Clip clipBehavior;

  @override
  State<M3EDismissibleList> createState() => _M3EDismissibleListState();
}

class _M3EDismissibleListState extends State<M3EDismissibleList>
    with TickerProviderStateMixin, M3EDismissibleCardMixin {
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
  const M3EDismissibleColumn({
    required this.itemCount,
    required this.itemBuilder,
    this.onDismiss,
    this.onTap,
    this.style = const M3EDismissibleListStyle(),
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Future<bool> Function(int index, DismissDirection direction)? onDismiss;
  final void Function(int index)? onTap;
  final M3EDismissibleListStyle style;

  factory M3EDismissibleColumn.of({
    required List<Widget> children,
    Future<bool> Function(int index, DismissDirection direction)? onDismiss,
    void Function(int index)? onTap,
    M3EDismissibleListStyle style = const M3EDismissibleListStyle(),
    Key? key,
  }) {
    return M3EDismissibleColumn(
      key: key,
      itemCount: children.length,
      itemBuilder: (_, i) => children[i],
      onDismiss: onDismiss,
      onTap: onTap,
      style: style,
    );
  }

  @override
  State<M3EDismissibleColumn> createState() => _M3EDismissibleColumnState();
}

class _M3EDismissibleColumnState extends State<M3EDismissibleColumn>
    with TickerProviderStateMixin, M3EDismissibleCardMixin {
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
