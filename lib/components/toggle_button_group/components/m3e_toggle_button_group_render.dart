// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
part of '../m3e_toggle_button_group.dart';

class _ButtonGroupRenderObjectWidget extends MultiChildRenderObjectWidget {
  const _ButtonGroupRenderObjectWidget({
    required this.direction,
    required this.spacing,
    required this.pressedIndex,
    required this.animValue,
    required this.expandedRatio,
    required super.children,
  });

  final Axis direction;
  final double spacing;
  final int? pressedIndex;
  final double animValue;
  final double expandedRatio;

  @override
  M3ERenderButtonGroup createRenderObject(BuildContext context) {
    return M3ERenderButtonGroup(
      direction: direction,
      spacing: spacing,
      pressedIndex: pressedIndex,
      animValue: animValue,
      expandedRatio: expandedRatio,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    M3ERenderButtonGroup renderObject,
  ) {
    renderObject
      ..direction = direction
      ..spacing = spacing
      ..pressedIndex = pressedIndex
      ..animValue = animValue
      ..expandedRatio = expandedRatio;
  }
}

class M3ERenderButtonGroup extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, M3EButtonGroupParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, M3EButtonGroupParentData> {
  M3ERenderButtonGroup({
    required Axis direction,
    required double spacing,
    required int? pressedIndex,
    required double animValue,
    required double expandedRatio,
  }) : _direction = direction,
       _spacing = spacing,
       _pressedIndex = pressedIndex,
       _animValue = animValue,
       _expandedRatio = expandedRatio;

  Axis _direction;
  Axis get direction => _direction;
  set direction(Axis value) {
    if (_direction == value) return;
    _direction = value;
    markNeedsLayout();
  }

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  int? _pressedIndex;
  int? get pressedIndex => _pressedIndex;
  set pressedIndex(int? value) {
    if (_pressedIndex == value) return;
    _pressedIndex = value;
    markNeedsLayout();
  }

  double _animValue;
  double get animValue => _animValue;
  set animValue(double value) {
    if (_animValue == value) return;
    _animValue = value;
    markNeedsLayout();
  }

  double _expandedRatio;
  double get expandedRatio => _expandedRatio;
  set expandedRatio(double value) {
    if (_expandedRatio == value) return;
    _expandedRatio = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! M3EButtonGroupParentData) {
      child.parentData = M3EButtonGroupParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      computeMaxIntrinsicWidth(height);

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (direction == Axis.vertical) {
      double max = 0.0;
      RenderBox? child = firstChild;
      while (child != null) {
        max = math.max(max, child.computeMaxIntrinsicWidth(height));
        child = childAfter(child);
      }
      return max;
    } else {
      double total = 0.0;
      int count = 0;
      RenderBox? child = firstChild;
      while (child != null) {
        total += child.computeMaxIntrinsicWidth(height);
        count++;
        child = childAfter(child);
      }
      if (count > 0) total += spacing * (count - 1);
      return total;
    }
  }

  @override
  double computeMinIntrinsicHeight(double width) =>
      computeMaxIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (direction == Axis.horizontal) {
      double max = 0.0;
      RenderBox? child = firstChild;
      while (child != null) {
        max = math.max(max, child.computeMaxIntrinsicHeight(width));
        child = childAfter(child);
      }
      return max;
    } else {
      double total = 0.0;
      int count = 0;
      RenderBox? child = firstChild;
      while (child != null) {
        total += child.computeMaxIntrinsicHeight(width);
        count++;
        child = childAfter(child);
      }
      if (count > 0) total += spacing * (count - 1);
      return total;
    }
  }

  @override
  void performLayout() {
    int childCount = this.childCount;
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }

    final isHorizontal = direction == Axis.horizontal;

    // First pass: Calculate natural sizes for squish math
    final List<double> naturalSizes = [];
    RenderBox? child = firstChild;
    while (child != null) {
      final BoxConstraints dryConstraints = isHorizontal
          ? BoxConstraints(
              minWidth: 0.0,
              maxWidth: double.infinity,
              minHeight: 0.0,
              maxHeight: constraints.maxHeight,
            )
          : BoxConstraints(
              minWidth: 0.0,
              maxWidth: constraints.maxWidth,
              minHeight: 0.0,
              maxHeight: double.infinity,
            );
      // We cannot use getDryLayout or computeMaxIntrinsicWidth because children
      // may contain a LayoutBuilder which prohibits speculative sizing.
      // Instead, we perform a real layout pass with unconstrained main axis to
      // discover the true natural size.
      child.layout(dryConstraints, parentUsesSize: true);
      final double naturalMain = isHorizontal
          ? child.size.width
          : child.size.height;
      naturalSizes.add(naturalMain);
      child = childAfter(child);
    }

    // Apply squish
    final List<double> sizes = List.of(naturalSizes);
    if (pressedIndex != null &&
        pressedIndex! >= 0 &&
        pressedIndex! < childCount &&
        animValue > 0) {
      final int pIndex = pressedIndex!;
      final double childNaturalSize = naturalSizes[pIndex];
      final double growth = childNaturalSize * expandedRatio * animValue;

      sizes[pIndex] += growth;

      if (pIndex > 0 && pIndex < childCount - 1) {
        // Middle child
        sizes[pIndex - 1] = math.max(0.0, sizes[pIndex - 1] - growth / 2);
        sizes[pIndex + 1] = math.max(0.0, sizes[pIndex + 1] - growth / 2);
      } else if (pIndex == 0 && childCount > 1) {
        // First child
        sizes[pIndex + 1] = math.max(0.0, sizes[pIndex + 1] - growth);
      } else if (pIndex == childCount - 1 && childCount > 1) {
        // Last child
        sizes[pIndex - 1] = math.max(0.0, sizes[pIndex - 1] - growth);
      }
    }

    child = firstChild;
    double maxCross = 0.0;

    final List<RenderBox> children = [];
    while (child != null) {
      children.add(child);
      child = childAfter(child);
    }

    for (int i = 0; i < children.length; i++) {
      final c = children[i];
      final double mainSize = sizes[i];

      BoxConstraints childConstraints;
      if (isHorizontal) {
        childConstraints = BoxConstraints.tightFor(
          width: mainSize,
        ).copyWith(minHeight: 0, maxHeight: constraints.maxHeight);
      } else {
        childConstraints = BoxConstraints.tightFor(
          height: mainSize,
        ).copyWith(minWidth: 0, maxWidth: constraints.maxWidth);
      }
      c.layout(childConstraints, parentUsesSize: true);
      maxCross = math.max(
        maxCross,
        isHorizontal ? c.size.height : c.size.width,
      );
    }

    double totalMain =
        sizes.fold(0.0, (a, b) => a + b) +
        (childCount > 0 ? spacing * (childCount - 1) : 0.0);

    size = constraints.constrain(
      isHorizontal ? Size(totalMain, maxCross) : Size(maxCross, totalMain),
    );

    double currentMainOffset = 0.0;
    for (int i = 0; i < children.length; i++) {
      final c = children[i];
      final M3EButtonGroupParentData childParentData =
          c.parentData as M3EButtonGroupParentData;

      double crossOffset = 0.0;
      final CrossAxisAlignment alignment =
          childParentData.alignment ?? CrossAxisAlignment.center;

      final double childCross = isHorizontal ? c.size.height : c.size.width;
      final double freeSpace = maxCross - childCross;

      if (alignment == CrossAxisAlignment.center) {
        crossOffset = freeSpace / 2.0;
      } else if (alignment == CrossAxisAlignment.end) {
        crossOffset = freeSpace;
      }

      if (isHorizontal) {
        childParentData.offset = Offset(currentMainOffset, crossOffset);
      } else {
        childParentData.offset = Offset(crossOffset, currentMainOffset);
      }
      currentMainOffset += sizes[i] + spacing;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
