import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../cards/m3e_cards.dart';
import 'components/m3e_card_list_item.dart';
import 'components/m3e_expandable_builders.dart';
import 'components/m3e_expandable_data.dart';
import 'components/m3e_expandable_list_base.dart';
import 'components/m3e_list_item_scope.dart';
import 'controllers/m3e_dismissible_card_controller.dart';
import 'enums/m3e_list_enums.dart';
import 'styles/m3e_dismissible_list_style.dart';
import 'styles/m3e_expandable_style.dart';
import 'styles/m3e_list_theme.dart';
import 'utils/m3e_list_selection_fill.dart';

export 'components/m3e_card_list_item.dart'
    show calculateCardPosition, calculateCardRadius;
export 'components/m3e_expandable_data.dart';
export 'components/m3e_expandable_item.dart';
export 'components/m3e_list_item_scope.dart';
export 'controllers/m3e_dismissible_card_controller.dart';
export 'enums/m3e_expandable_enums.dart';
export 'enums/m3e_list_enums.dart';
export 'models/m3e_dismissible_slot.dart';
export 'styles/m3e_dismissible_list_style.dart';
export 'styles/m3e_expandable_style.dart';
export 'styles/m3e_list_theme.dart';
export 'utils/m3e_measure_size.dart';

part 'components/m3e_dismissible_list_widgets.dart';

enum _M3EExpandableListLayout { column, scrollable, sliver }

/// A Material 3 Expressive list item.
///
/// A single row of a list with optional leading and trailing widgets, a
/// headline and up to three lines of supporting text. Becomes interactive with
/// state layers when [onTap] is supplied.
///
/// Inside card-backed lists, the parent list owns the outer card surface
/// automatically.
class M3EListItem extends StatelessWidget {
  /// M3EListItem.
  const M3EListItem({
    required this.headline,
    this.supportingText,
    this.overline,
    this.leading,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.variant,
    this.border,
    super.key,
  });

  /// headline.

  final String headline;

  /// supportingText.
  final String? supportingText;

  /// overline.
  final String? overline;

  /// leading.
  final Widget? leading;

  /// trailing.
  final Widget? trailing;

  /// onTap.
  final VoidCallback? onTap;

  /// selected.
  final bool selected;

  /// Card variant override; falls back to [M3EListItemTheme.variant].
  final M3ECardVariant? variant;

  /// Card outline override; falls back to [M3EListItemTheme.border].
  final BorderSide? border;

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildItem);
  }

  Widget _buildItem(BuildContext context) {
    final body = _buildBody(context);
    if (M3EListItemScope.isEmbedded(context)) {
      return body;
    }

    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final listTheme = theme.listTheme.item;
    final bool threeLine = _isThreeLine;

    return M3ECard(
      variant: variant ?? listTheme.variant,
      border: border ?? listTheme.border,
      color: selected ? listTheme.selectedColor(scheme) : null,
      onPressed: onTap,
      semanticLabel: headline,
      padding: EdgeInsets.symmetric(
        horizontal: listTheme.horizontalPadding,
        vertical: threeLine
            ? listTheme.threeLineVerticalPadding
            : listTheme.verticalPadding,
      ),
      width: double.infinity,
      child: body,
    );
  }

  Widget _buildBody(BuildContext context) {
    final theme = M3ETheme.of(context);
    final listTheme = theme.listTheme.item;
    final bool threeLine = _isThreeLine;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: listTheme.minHeight),
      child: Row(
        crossAxisAlignment: threeLine
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: _buildChildren(theme),
      ),
    );
  }

  List<Widget> _buildChildren(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    final listTheme = theme.listTheme.item;
    return <Widget>[
      if (leading != null) ...<Widget>[
        IconTheme.merge(
          data: IconThemeData(
            color: listTheme.iconColor(scheme),
            size: listTheme.iconSize,
          ),
          child: leading!,
        ),
        SizedBox(width: listTheme.gap),
      ],
      Expanded(child: _buildText(theme)),
      if (trailing != null) ...<Widget>[
        SizedBox(width: listTheme.gap),
        IconTheme.merge(
          data: IconThemeData(
            color: listTheme.iconColor(scheme),
            size: listTheme.iconSize,
          ),
          child: trailing!,
        ),
      ],
    ];
  }

  Widget _buildText(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    final type = theme.typeScale;
    final listTheme = theme.listTheme.item;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (overline != null)
          Text(overline!, style: listTheme.overlineStyle(type, scheme)),
        Text(
          headline,
          style: listTheme.headlineStyle(type, scheme),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (supportingText != null)
          Text(
            supportingText!,
            style: listTheme.supportingStyle(type, scheme),
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
  }) : _isBuilder = false,
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
  }) : _isBuilder = true;

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildList);
  }

  Widget _buildList(BuildContext context) {
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
    final cardListTheme = M3ETheme.of(context).listTheme.cardList;
    final M3ECardPosition position = calculateCardPosition(index, total);
    return M3ECardListItem(
      index: index,
      position: position,
      outerRadius: outerRadius,
      innerRadius: innerRadius,
      gap: gap,
      color: color,
      resolvedColor:
          colorBuilder?.call(index) ?? m3eSelectionFill(context, index),
      resolvedBorderRadius: borderRadiusBuilder?.call(index, position),
      padding: padding,
      onTap: onTap,
      onLongPress: onLongPress,
      semanticLabel: semanticLabelBuilder?.call(index),
      mouseCursor: mouseCursor,
      haptic: haptic,
      variant: variant ?? cardListTheme.variant,
      border: border ?? cardListTheme.border,
      child: itemBuilder(context, index),
    );
  }
}

/// A spring-animated expandable card list.
///
/// Supports three layouts via named constructors:
/// - default / [M3EExpandableList.builder]: non-scrollable [Column]
/// - [M3EExpandableList.scrollable] / [M3EExpandableList.scrollableBuilder]:
///   [ListView.builder]
/// - [M3EExpandableList.sliver] / [M3EExpandableList.sliverBuilder]:
///   [SliverList.builder] for [CustomScrollView]
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
  }) : _layout = _M3EExpandableListLayout.column,
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
       );

  /// builder.

  const M3EExpandableList.builder({
    super.key,
    required super.itemCount,
    required super.headerBuilder,
    required super.bodyBuilder,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
  }) : _layout = _M3EExpandableListLayout.column,
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
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
  }) : _layout = _M3EExpandableListLayout.scrollable,
       super(
         itemCount: data.length,
         headerBuilder: m3eSimpleHeaderBuilder(data),
         bodyBuilder: m3eSimpleBodyBuilder(
           data,
           style ?? const M3EExpandableStyle(),
         ),
       );

  /// scrollableBuilder.

  const M3EExpandableList.scrollableBuilder({
    super.key,
    required super.itemCount,
    required super.headerBuilder,
    required super.bodyBuilder,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
  }) : _layout = _M3EExpandableListLayout.scrollable;

  /// sliver.

  M3EExpandableList.sliver({
    super.key,
    required List<M3EExpandableData> data,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
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
       );

  /// sliverBuilder.

  const M3EExpandableList.sliverBuilder({
    super.key,
    required super.itemCount,
    required super.headerBuilder,
    required super.bodyBuilder,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
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
  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (context) {
        switch (widget._layout) {
          case _M3EExpandableListLayout.column:
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.itemCount,
                (index) => buildItem(context, index),
              ),
            );
          case _M3EExpandableListLayout.scrollable:
            return ListView.builder(
              controller: widget.controller,
              physics: widget.physics,
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              itemCount: widget.itemCount,
              itemBuilder: (context, index) => buildItem(context, index),
            );
          case _M3EExpandableListLayout.sliver:
            return SliverList.builder(
              itemCount: widget.itemCount,
              itemBuilder: (context, index) => buildItem(context, index),
            );
        }
      },
    );
  }
}

/// A dismissible Material 3 list backed by [ListView.builder].
///
/// Suitable for large or lazily-loaded data sets. Only visible items are
/// materialized.
