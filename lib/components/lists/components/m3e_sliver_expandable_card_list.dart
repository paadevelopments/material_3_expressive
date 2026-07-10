import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../styles/m3e_expandable_style.dart';
import 'm3e_expandable_builders.dart';
import 'm3e_expandable_data.dart';
import 'm3e_expandable_list_base.dart';

/// Sliver variant of the expandable card list for use inside a [CustomScrollView].
class M3ESliverExpandableCardList extends M3EExpandableListBase {
  M3ESliverExpandableCardList({
    super.key,
    required List<M3EExpandableData> data,
    super.allowMultipleExpanded,
    super.initiallyExpanded,
    super.style,
    super.expandMotion,
    super.collapseMotion,
    super.onExpansionChanged,
  }) : super(
          itemCount: data.length,
          headerBuilder: m3eSimpleHeaderBuilder(data),
          bodyBuilder: m3eSimpleBodyBuilder(
            data,
            style ?? const M3EExpandableStyle(),
          ),
        );

  const M3ESliverExpandableCardList.builder({
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
  });

  @override
  State<M3ESliverExpandableCardList> createState() =>
      _M3ESliverExpandableCardListState();
}

class _M3ESliverExpandableCardListState
    extends State<M3ESliverExpandableCardList>
    with M3EExpandableStateMixin<M3ESliverExpandableCardList> {
  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: (context) => SliverList.builder(
        itemCount: widget.itemCount,
        itemBuilder: (context, index) => buildItem(context, index),
      ),
    );
  }
}
