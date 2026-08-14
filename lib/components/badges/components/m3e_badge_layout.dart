import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../enums/m3e_badge_alignment.dart';

/// Parent data for the badge layout.
class M3EBadgeLayoutParentData extends ContainerBoxParentData<RenderBox> {}

/// Anchors an indicator to the top edge of its content.
///
/// The indicator is placed against the content's own box, so no sizing help is
/// needed from a parent. The reported size covers both boxes, which keeps any
/// overhang out of a parent's clip.
class M3EBadgeLayout extends MultiChildRenderObjectWidget {
  /// M3EBadgeLayout.
  M3EBadgeLayout({
    required this.alignment,
    required this.offset,
    required Widget content,
    required Widget indicator,
    super.key,
  }) : super(children: <Widget>[content, indicator]);

  /// Top-edge placement of the indicator.
  final M3EBadgeAlignment alignment;

  /// Nudge away from the anchored edge. `dx` is ignored when centered.
  final Offset offset;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderM3EBadgeLayout(alignment: alignment, offset: offset);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderM3EBadgeLayout renderObject,
  ) {
    renderObject
      ..alignment = alignment
      ..offset = offset;
  }
}

/// Lays out badge content with its indicator anchored to the content box.
class RenderM3EBadgeLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, M3EBadgeLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, M3EBadgeLayoutParentData> {
  /// Creates a badge layout render object.
  RenderM3EBadgeLayout({required this._alignment, required this._offset});

  M3EBadgeAlignment _alignment;
  Offset _offset;

  /// Top-edge placement of the indicator.
  M3EBadgeAlignment get alignment => _alignment;

  set alignment(M3EBadgeAlignment value) {
    if (value == _alignment) {
      return;
    }
    _alignment = value;
    markNeedsLayout();
  }

  /// Nudge away from the anchored edge.
  Offset get offset => _offset;

  set offset(Offset value) {
    if (value == _offset) {
      return;
    }
    _offset = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! M3EBadgeLayoutParentData) {
      child.parentData = M3EBadgeLayoutParentData();
    }
  }

  @override
  void performLayout() {
    final RenderBox? content = firstChild;
    final RenderBox? indicator = content == null ? null : childAfter(content);
    if (content == null || indicator == null) {
      size = constraints.smallest;
      return;
    }

    content.layout(constraints, parentUsesSize: true);
    indicator.layout(const BoxConstraints(), parentUsesSize: true);

    final Rect contentRect = Offset.zero & content.size;
    final Rect indicatorRect =
        _indicatorOrigin(content.size, indicator.size) & indicator.size;
    final Rect union = contentRect.expandToInclude(indicatorRect);

    size = constraints.constrain(union.size);
    // Only shift by what the (possibly constrained) size can absorb, so tight
    // parents keep the content inside the box.
    final shift = Offset(
      _shift(-union.left, size.width - content.size.width),
      _shift(-union.top, size.height - content.size.height),
    );
    _parentDataOf(content).offset = shift;
    _parentDataOf(indicator).offset = indicatorRect.topLeft + shift;
  }

  double _shift(double wanted, double available) =>
      wanted <= 0 || available <= 0 ? 0 : math.min(wanted, available);

  Offset _indicatorOrigin(Size content, Size indicator) {
    final double dx = switch (_alignment) {
      M3EBadgeAlignment.topLeft => -_offset.dx,
      M3EBadgeAlignment.topCenter => (content.width - indicator.width) / 2,
      M3EBadgeAlignment.topRight =>
        content.width - indicator.width + _offset.dx,
    };
    return Offset(dx, _offset.dy);
  }

  M3EBadgeLayoutParentData _parentDataOf(RenderBox child) =>
      child.parentData! as M3EBadgeLayoutParentData;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final RenderBox? content = firstChild;
    final RenderBox? indicator = content == null ? null : childAfter(content);
    if (content == null || indicator == null) {
      return constraints.smallest;
    }
    final Size contentSize = content.getDryLayout(constraints);
    final Size indicatorSize = indicator.getDryLayout(const BoxConstraints());
    final Rect union = (Offset.zero & contentSize).expandToInclude(
      _indicatorOrigin(contentSize, indicatorSize) & indicatorSize,
    );
    return constraints.constrain(union.size);
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      firstChild?.getMinIntrinsicWidth(height) ?? 0;

  @override
  double computeMaxIntrinsicWidth(double height) =>
      firstChild?.getMaxIntrinsicWidth(height) ?? 0;

  @override
  double computeMinIntrinsicHeight(double width) =>
      firstChild?.getMinIntrinsicHeight(width) ?? 0;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      firstChild?.getMaxIntrinsicHeight(width) ?? 0;

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
