import 'package:flutter/widgets.dart';
import '../styles/m3e_expandable_style.dart';
import 'm3e_expandable_builders.dart';
import 'm3e_expandable_data.dart';
import 'm3e_expandable_list_base.dart';

class M3EExpandableCardList extends M3EExpandableListBase {
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;

  M3EExpandableCardList({
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
  }) : super(
          itemCount: data.length,
          headerBuilder: m3eSimpleHeaderBuilder(data),
          bodyBuilder: m3eSimpleBodyBuilder(
            data,
            style ?? const M3EExpandableStyle(),
          ),
        );

  const M3EExpandableCardList.builder({
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
  });

  @override
  State<M3EExpandableCardList> createState() => _M3EExpandableCardListState();
}

class _M3EExpandableCardListState extends State<M3EExpandableCardList>
    with M3EExpandableStateMixin<M3EExpandableCardList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.controller,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) => buildItem(context, index),
    );
  }
}
