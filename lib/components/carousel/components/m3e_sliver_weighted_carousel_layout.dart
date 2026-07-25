// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Vendored from `package:m3_carousel/base_layout.dart` (Flutter CarouselView).
// Split into part files for klin_dart file_length; behaviour unchanged.
part of 'm3e_carousel_view.dart';

mixin _M3EWeightedCarouselLayoutMixin on RenderSliverFixedExtentBoxAdaptor {
  bool get consumeMaxWeight;
  set consumeMaxWeight(bool value);

  double get shrinkExtent;
  set shrinkExtent(double value);

  List<int> get weights;
  set weights(List<int> value);

  bool get infinite;
  set infinite(bool value);

  // This is to implement the itemExtentBuilder callback to return each item extent
  // while scrolling.
  //
  // The given `index` is compared with `_firstVisibleItemIndex` to know how
  // many items are placed before the current one in the view.
  double _buildItemExtent(
    int index,
    SliverLayoutDimensions currentLayoutDimensions,
  ) {
    // If constraints.viewportMainAxisExtent is 0, firstChildExtent will be 0 and cause division error.
    if (constraints.viewportMainAxisExtent == 0) {
      return 0;
    }

    double extent;
    if (index == _firstVisibleItemIndex) {
      extent = math.max(_distanceToLeadingEdge, effectiveShrinkExtent);
    }
    // Calculate the extents of items located within the range defined by the
    // weights array relative to the first visible item. This allows us to
    // precisely determine each item's extent based on its initial extent
    // (calculated from the weights) and the scrolling progress (the off-screen
    // portion of the first item).
    else if (index > _firstVisibleItemIndex &&
        index - _firstVisibleItemIndex + 1 <= weights.length) {
      assert(
        index - _firstVisibleItemIndex < weights.length,
        'carousel layout invariant',
      );
      final int currIndexOnWeightList = index - _firstVisibleItemIndex;
      final int currWeight = weights[currIndexOnWeightList];
      extent = extentUnit * currWeight; // initial extent
      final double progress =
          _firstVisibleItemOffscreenExtent / firstChildExtent;

      final int prevWeight = weights[currIndexOnWeightList - 1];
      final double finalIncrease = (prevWeight - currWeight) / weights.max;
      extent = extent + finalIncrease * progress * maxChildExtent;
    }
    // Calculate the extents of items located beyond the range defined by the
    // weights array relative to the first visible item. During scrolling transition,
    // it is possible that the number of visible items is larger than the length
    // of `weights`. The extra item extent should be calculated here to fill
    // the remaining space.
    else if (index > _firstVisibleItemIndex &&
        index - _firstVisibleItemIndex + 1 > weights.length) {
      double visibleItemsTotalExtent = _distanceToLeadingEdge;
      for (int i = _firstVisibleItemIndex + 1; i < index; i++) {
        visibleItemsTotalExtent += _buildItemExtent(i, currentLayoutDimensions);
      }
      extent = math.max(
        constraints.remainingPaintExtent - visibleItemsTotalExtent,
        effectiveShrinkExtent,
      );
    } else {
      extent = math.max(minChildExtent, effectiveShrinkExtent);
    }
    return extent;
  }

  // To ge the extent unit based on the viewport extent and the sum of weights.
  double get extentUnit =>
      constraints.viewportMainAxisExtent /
      (weights.reduce((int total, int extent) => total + extent));

  double get firstChildExtent => weights.first * extentUnit;

  double get maxChildExtent => weights.max * extentUnit;

  double get minChildExtent => weights.min * extentUnit;

  // The shrink extent for first and last visible items should be no larger
  // than [minChildExtent] to ensure a smooth transition.
  double get effectiveShrinkExtent =>
      clampDouble(shrinkExtent, 0, minChildExtent);

  // The index of the first visible item. The returned value can be negative when
  // the leading items with smaller weights need to be fully expanded. For example,
  // assuming a weights [1, 7, 1], when item 0 is expanding to the maximum size
  // (with weight 7), we leave some space before item 0 assuming there is another
  // item -1 as the first visible item.
  int get _firstVisibleItemIndex {
    // If constraints.viewportMainAxisExtent is 0, firstChildExtent will be 0 and cause division error.
    if (constraints.viewportMainAxisExtent == 0.0) {
      return 0;
    }
    var smallerWeightCount = 0;
    for (final int weight in weights) {
      if (weight == weights.max) {
        break;
      }
      smallerWeightCount += 1;
    }
    int index;

    final double actual = constraints.scrollOffset / firstChildExtent;
    final int round = (constraints.scrollOffset / firstChildExtent).round();
    if ((actual - round).abs() < precisionErrorTolerance) {
      index = round;
    } else {
      index = actual.floor();
    }
    return consumeMaxWeight ? index - smallerWeightCount : index;
  }

  // This value indicates the scrolling progress of items following the first
  // item. It informs them how much the first item has moved off-screen,
  // enabling them to adjust their sizes (grow or shrink) accordingly.
  double get _firstVisibleItemOffscreenExtent {
    // If constraints.viewportMainAxisExtent is 0, firstChildExtent will be 0 and cause division error.
    if (constraints.viewportMainAxisExtent == 0.0) {
      return 0;
    }
    int index;
    final double actual = constraints.scrollOffset / firstChildExtent;
    final int round = (constraints.scrollOffset / firstChildExtent).round();
    if ((actual - round).abs() < precisionErrorTolerance) {
      index = round;
    } else {
      index = actual.floor();
    }
    return constraints.scrollOffset - index * firstChildExtent;
  }

  // Given the off-screen extent for the first visible item, we can know the
  // on-screen extent for the first visible item.
  double get _distanceToLeadingEdge =>
      firstChildExtent - _firstVisibleItemOffscreenExtent;

  // Given an index, this method returns the layout offset for the item. The `index`
  // is firstly compared to `_firstVisibleItemIndex` and compute the distance
  // between them, then compute all the current extents for items that are located
  // in front.
  @override
  double indexToLayoutOffset(
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
    int index,
  ) {
    if (index == _firstVisibleItemIndex) {
      if (_distanceToLeadingEdge <= effectiveShrinkExtent) {
        return constraints.scrollOffset -
            effectiveShrinkExtent +
            _distanceToLeadingEdge;
      }
      return constraints.scrollOffset;
    }
    double visibleItemsTotalExtent = _distanceToLeadingEdge;
    for (int i = _firstVisibleItemIndex + 1; i < index; i++) {
      visibleItemsTotalExtent += _buildItemExtent(i, layoutDimensions);
    }
    return constraints.scrollOffset + visibleItemsTotalExtent;
  }

  @override
  int getMinChildIndexForScrollOffset(
    double scrollOffset,
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
  ) {
    return math.max(_firstVisibleItemIndex, 0);
  }

  @override
  int getMaxChildIndexForScrollOffset(
    double scrollOffset,
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
  ) {
    final int? childCount = childManager.estimatedChildCount;

    // For infinite scrolling, calculate how many items fit in the viewport
    if (infinite && childCount == null) {
      double visibleItemsTotalExtent = _distanceToLeadingEdge;
      int index = _firstVisibleItemIndex + 1;
      // Calculate upper bound based on viewport extent and minimum possible item extent.
      // In worst case, all items would be at minimum extent i.e. minChildExtent.
      final double safeMinExtent = math.max(minChildExtent, 1);
      final int estimatedUpperBound =
          _firstVisibleItemIndex +
          (constraints.viewportMainAxisExtent / safeMinExtent).ceil();
      while (visibleItemsTotalExtent < constraints.viewportMainAxisExtent &&
          index < estimatedUpperBound) {
        visibleItemsTotalExtent += _buildItemExtent(index, layoutDimensions);
        if (visibleItemsTotalExtent >= constraints.viewportMainAxisExtent) {
          return index;
        }
        index++;
      }
      return index;
    }

    if (childCount != null) {
      double visibleItemsTotalExtent = _distanceToLeadingEdge;
      for (int i = _firstVisibleItemIndex + 1; i < childCount; i++) {
        visibleItemsTotalExtent += _buildItemExtent(i, layoutDimensions);
        if (visibleItemsTotalExtent >= constraints.viewportMainAxisExtent) {
          return i;
        }
      }
    }
    return childCount ?? 0;
  }

  @override
  double computeMaxScrollOffset(
    SliverConstraints constraints,
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
  ) {
    if (infinite) {
      return double.infinity;
    }
    return childManager.childCount * maxChildExtent;
  }

  BoxConstraints _getChildConstraints(int index) {
    final double extent = itemExtentBuilder!(index, layoutDimensions)!;
    return constraints.asBoxConstraints(minExtent: extent, maxExtent: extent);
  }

  // This method is mostly the same as its parent class [RenderSliverFixedExtentList].
  // The difference is when we allow some space before the leading items or after
  // the trailing items with smaller weights, we leave extra scroll offset.
  // TODO(quncCccccc): add the calculation for the extra scroll offset on the super class to simplify the implementation here.
  @override
  void performLayout() {
    assert(
      (itemExtent != null && itemExtentBuilder == null) ||
          (itemExtent == null && itemExtentBuilder != null),
      'Exactly one of itemExtent or itemExtentBuilder must be non-null',
    );
    assert(
      itemExtentBuilder != null || (itemExtent!.isFinite && itemExtent! >= 0),
      'itemExtent must be finite and non-negative when itemExtentBuilder is null',
    );

    final SliverConstraints constraints = this.constraints;
    childManager
      ..didStartLayout()
      ..setDidUnderflow(false);

    final double scrollOffset =
        constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0, 'scrollOffset must be non-negative');
    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0, 'remainingCacheExtent must be non-negative');
    final double targetEndScrollOffset = scrollOffset + remainingExtent;
    // TODO(Piinks): Clean up when deprecation expires.
    const double deprecatedExtraItemExtent = -1;

    final int firstIndex = getMinChildIndexForScrollOffset(
      scrollOffset,
      deprecatedExtraItemExtent,
    );
    final int? targetLastIndex = targetEndScrollOffset.isFinite
        ? getMaxChildIndexForScrollOffset(
            targetEndScrollOffset,
            deprecatedExtraItemExtent,
          )
        : null;

    if (firstChild != null) {
      final int leadingGarbage = calculateLeadingGarbage(
        firstIndex: firstIndex,
      );
      final int trailingGarbage = targetLastIndex != null
          ? calculateTrailingGarbage(lastIndex: targetLastIndex)
          : 0;
      collectGarbage(leadingGarbage, trailingGarbage);
    } else {
      collectGarbage(0, 0);
    }

    if (firstChild == null) {
      final double layoutOffset = indexToLayoutOffset(
        deprecatedExtraItemExtent,
        firstIndex,
      );
      if (!addInitialChild(index: firstIndex, layoutOffset: layoutOffset)) {
        // There are either no children, or we are past the end of all our children.
        final double max;
        if (firstIndex <= 0) {
          max = 0.0;
        } else {
          max = computeMaxScrollOffset(constraints, deprecatedExtraItemExtent);
        }
        geometry = SliverGeometry(scrollExtent: max, maxPaintExtent: max);
        childManager.didFinishLayout();
        return;
      }
    }

    RenderBox? trailingChildWithLayout;

    for (int index = indexOf(firstChild!) - 1; index >= firstIndex; --index) {
      final RenderBox? child = insertAndLayoutLeadingChild(
        _getChildConstraints(index),
      );
      if (child == null) {
        // Items before the previously first child are no longer present.
        // Reset the scroll offset to offset all items prior and up to the
        // missing item. Let parent re-layout everything.
        geometry = SliverGeometry(
          scrollOffsetCorrection: indexToLayoutOffset(
            deprecatedExtraItemExtent,
            index,
          ),
        );
        return;
      }
      final childParentData =
          child.parentData! as SliverMultiBoxAdaptorParentData
            ..layoutOffset = indexToLayoutOffset(
              deprecatedExtraItemExtent,
              index,
            );
      assert(childParentData.index == index, 'carousel invariant');
      trailingChildWithLayout ??= child;
    }

    if (trailingChildWithLayout == null) {
      firstChild!.layout(_getChildConstraints(indexOf(firstChild!)));
      (firstChild!.parentData! as SliverMultiBoxAdaptorParentData)
          .layoutOffset = indexToLayoutOffset(
        deprecatedExtraItemExtent,
        firstIndex,
      );
      trailingChildWithLayout = firstChild;
    }

    // From the last item to the firstly encountered max item
    double extraLayoutOffset = 0;
    if (consumeMaxWeight) {
      for (int i = weights.length - 1; i >= 0; i--) {
        if (weights[i] == weights.max) {
          break;
        }
        extraLayoutOffset += weights[i] * extentUnit;
      }
    }

    double estimatedMaxScrollOffset = double.infinity;
    // Layout visible items after the first visible item.
    for (
      int index = indexOf(trailingChildWithLayout!) + 1;
      targetLastIndex == null || index <= targetLastIndex;
      ++index
    ) {
      RenderBox? child = childAfter(trailingChildWithLayout!);
      if (child == null || indexOf(child) != index) {
        child = insertAndLayoutChild(
          _getChildConstraints(index),
          after: trailingChildWithLayout,
        );
        if (child == null) {
          // We have run out of children.
          estimatedMaxScrollOffset =
              indexToLayoutOffset(deprecatedExtraItemExtent, index) +
              extraLayoutOffset;
          break;
        }
      } else {
        child.layout(_getChildConstraints(index));
      }
      trailingChildWithLayout = child;
      final childParentData =
          child.parentData! as SliverMultiBoxAdaptorParentData;
      assert(childParentData.index == index, 'carousel invariant');
      childParentData.layoutOffset = indexToLayoutOffset(
        deprecatedExtraItemExtent,
        childParentData.index!,
      );
    }

    final int lastIndex = indexOf(lastChild!);
    final double leadingScrollOffset = indexToLayoutOffset(
      deprecatedExtraItemExtent,
      firstIndex,
    );
    double trailingScrollOffset;

    if (!infinite && lastIndex + 1 == childManager.childCount) {
      trailingScrollOffset = indexToLayoutOffset(
        deprecatedExtraItemExtent,
        lastIndex,
      );

      trailingScrollOffset += math.max(
        weights.last * extentUnit,
        _buildItemExtent(lastIndex, layoutDimensions),
      );
      trailingScrollOffset += extraLayoutOffset;
    } else {
      trailingScrollOffset = indexToLayoutOffset(
        deprecatedExtraItemExtent,
        lastIndex + 1,
      );
    }

    assert(debugAssertChildListIsNonEmptyAndContiguous(), 'carousel invariant');
    assert(indexOf(firstChild!) == firstIndex, 'carousel invariant');
    assert(
      targetLastIndex == null || lastIndex <= targetLastIndex,
      'carousel invariant',
    );

    estimatedMaxScrollOffset = math.min(
      estimatedMaxScrollOffset,
      estimateMaxScrollOffset(
        constraints,
        firstIndex: firstIndex,
        lastIndex: lastIndex,
        leadingScrollOffset: leadingScrollOffset,
        trailingScrollOffset: trailingScrollOffset,
      ),
    );

    final double paintExtent = calculatePaintOffset(
      constraints,
      from: consumeMaxWeight ? 0 : leadingScrollOffset,
      to: trailingScrollOffset,
    );

    final double cacheExtent = calculateCacheOffset(
      constraints,
      from: consumeMaxWeight ? 0 : leadingScrollOffset,
      to: trailingScrollOffset,
    );

    final double targetEndScrollOffsetForPaint =
        constraints.scrollOffset + constraints.remainingPaintExtent;
    final int? targetLastIndexForPaint = targetEndScrollOffsetForPaint.isFinite
        ? getMaxChildIndexForScrollOffset(
            targetEndScrollOffsetForPaint,
            deprecatedExtraItemExtent,
          )
        : null;

    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      // Conservative to avoid flickering away the clip during scroll.
      hasVisualOverflow:
          (targetLastIndexForPaint != null &&
              lastIndex >= targetLastIndexForPaint) ||
          constraints.scrollOffset > 0.0,
    );

    // We may have started the layout while scrolled to the end, which would not
    // expose a new child.
    if (estimatedMaxScrollOffset == trailingScrollOffset) {
      childManager.setDidUnderflow(true);
    }
    childManager.didFinishLayout();
  }

  @override
  double? get itemExtent => null;

  /// The main-axis extent builder of each item.
  ///
  /// If this is non-null, the [itemExtent] must be null.
  /// If this is null, the [itemExtent] must be non-null.
  @override
  ItemExtentBuilder? get itemExtentBuilder => _buildItemExtent;
}
