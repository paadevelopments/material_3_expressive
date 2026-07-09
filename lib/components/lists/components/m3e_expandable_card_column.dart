import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../styles/m3e_expandable_style.dart';
import 'm3e_expandable_builders.dart';
import 'm3e_expandable_data.dart';
import 'm3e_expandable_list_base.dart';

class M3EExpandableCardColumn extends M3EExpandableListBase {
  M3EExpandableCardColumn({
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

  const M3EExpandableCardColumn.builder({
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
  State<M3EExpandableCardColumn> createState() =>
      _M3EExpandableCardColumnState();
}

class _M3EExpandableCardColumnState extends State<M3EExpandableCardColumn>
    with M3EExpandableStateMixin<M3EExpandableCardColumn> {
  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.itemCount,
          (index) => buildItem(context, index),
        ),
      ),
    );
  }
}
