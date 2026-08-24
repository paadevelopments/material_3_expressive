part of '../m3e_toggle_button_group.dart';

/// A widget that controls how a child of a [M3EButtonGroup] aligns itself
/// along the cross axis.
class M3EButtonGroupAlign extends ParentDataWidget<M3EButtonGroupParentData> {
  /// Creates an alignment widget for a button group item.
  const M3EButtonGroupAlign({
    super.key,
    required this.alignment,
    required super.child,
  });

  /// The cross axis alignment to apply to the child.
  final CrossAxisAlignment alignment;

  @override
  void applyParentData(RenderObject renderObject) {
    assert(
      renderObject.parentData is M3EButtonGroupParentData,
      'parentData must be M3EButtonGroupParentData',
    );
    final parentData = renderObject.parentData! as M3EButtonGroupParentData;
    var needsLayout = false;

    if (parentData.alignment != alignment) {
      parentData.alignment = alignment;
      needsLayout = true;
    }

    if (needsLayout) {
      final targetParent = renderObject.parent;
      if (targetParent is RenderObject) {
        targetParent.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => M3EButtonGroup;
}
