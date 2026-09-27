part of 'm3e_carousel_view.dart';

/// A sliver that displays its box children in a linear array with a fixed extent
/// per item.
class _SliverFixedExtentCarousel extends SliverMultiBoxAdaptorWidget {
  const _SliverFixedExtentCarousel({
    required super.delegate,
    required this.minExtent,
    required this.itemExtent,
    required this.scaleItems,
    required this.infinite,
  });

  final double itemExtent;
  final double minExtent;
  final bool scaleItems;
  final bool infinite;

  @override
  RenderSliverFixedExtentBoxAdaptor createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;
    return _RenderSliverFixedExtentCarousel(
      childManager: element,
      minExtent: minExtent,
      maxExtent: itemExtent,
      scaleItems: scaleItems,
      infinite: infinite,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSliverFixedExtentCarousel renderObject,
  ) {
    renderObject
      ..maxExtent = itemExtent
      ..minExtent = minExtent
      ..scaleItems = scaleItems
      ..infinite = infinite;
  }
}

class _RenderSliverFixedExtentCarousel
    extends RenderSliverFixedExtentBoxAdaptor {
  _RenderSliverFixedExtentCarousel({
    required super.childManager,
    required this._maxExtent,
    required this._minExtent,
    required bool scaleItems,
    required this._infinite,
  }) : _scaleItems = scaleItems;

  double get maxExtent => _maxExtent;
  double _maxExtent;

  set maxExtent(double value) {
    if (_maxExtent == value) {
      return;
    }
    _maxExtent = value;
    markNeedsLayout();
  }

  double get minExtent => _minExtent;
  double _minExtent;

  set minExtent(double value) {
    if (_minExtent == value) {
      return;
    }
    _minExtent = value;
    markNeedsLayout();
  }

  bool get scaleItems => _scaleItems;
  bool _scaleItems;

  set scaleItems(bool value) {
    if (_scaleItems == value) {
      return;
    }
    _scaleItems = value;
    markNeedsLayout();
  }

  bool get infinite => _infinite;
  bool _infinite;

  set infinite(bool value) {
    if (_infinite == value) {
      return;
    }
    _infinite = value;
    markNeedsLayout();
  }

  // This implements the [itemExtentBuilder] callback.
  double _buildItemExtent(
    int index,
    SliverLayoutDimensions currentLayoutDimensions,
  ) {
    if (maxExtent == 0.0 || !scaleItems) {
      return maxExtent;
    }

    final int firstVisibleIndex = (constraints.scrollOffset / maxExtent)
        .floor();
    final int offscreenItems = firstVisibleIndex;
    final double offscreenExtent =
        constraints.scrollOffset - offscreenItems * maxExtent;
    final double effectiveMinExtent = _effectiveMinExtent;

    // The leading item shrinks as it leaves. The trailing item grows into the
    // space that is left. Both stop at [effectiveMinExtent]; past that they
    // scroll off the edge instead of changing size.
    if (index == firstVisibleIndex) {
      return math.max(maxExtent - offscreenExtent, effectiveMinExtent);
    }

    final double scrollOffsetForLastIndex =
        constraints.scrollOffset + constraints.remainingPaintExtent;
    if (index ==
        getMaxChildIndexForScrollOffset(scrollOffsetForLastIndex, maxExtent)) {
      return clampDouble(
        scrollOffsetForLastIndex - maxExtent * index,
        effectiveMinExtent,
        maxExtent,
      );
    }

    return maxExtent;
  }

  /// Remainder of the viewport, and never smaller than [minExtent].
  ///
  /// Capped at [maxExtent] so a shrink extent larger than the item cannot
  /// invert [clampDouble].
  double get _effectiveMinExtent => math.min(
    maxExtent,
    math.max(constraints.remainingPaintExtent % maxExtent, minExtent),
  );

  /// The layout offset for the child with the given index.
  @override
  double indexToLayoutOffset(
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
    int index,
  ) {
    if (maxExtent == 0.0 || !scaleItems) {
      return maxExtent * index;
    }

    final int firstVisibleIndex = (constraints.scrollOffset / maxExtent)
        .floor();
    if (index == firstVisibleIndex) {
      final double firstVisibleItemExtent = _buildItemExtent(
        index,
        layoutDimensions,
      );
      // Past the shrink floor the item stops resizing and scrolls off.
      if (firstVisibleItemExtent <= _effectiveMinExtent) {
        return maxExtent * index - _effectiveMinExtent + maxExtent;
      }
      return constraints.scrollOffset;
    }
    return maxExtent * index;
  }

  /// The minimum child index that is visible at the given scroll offset.
  @override
  int getMinChildIndexForScrollOffset(
    double scrollOffset,
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
  ) {
    if (maxExtent == 0.0) {
      return 0;
    }

    final int firstVisibleIndex = (scrollOffset / maxExtent).floor();
    return math.max(firstVisibleIndex, 0);
  }

  /// The maximum child index that is visible at the given scroll offset.
  @override
  int getMaxChildIndexForScrollOffset(
    double scrollOffset,
    @Deprecated(
      'The itemExtent is already available within the scope of this function. '
      'This feature was deprecated after v3.20.0-7.0.pre.',
    )
    double itemExtent,
  ) {
    if (maxExtent > 0.0) {
      final double actual = scrollOffset / maxExtent - 1;
      final int round = actual.round();
      if ((actual * maxExtent - round * maxExtent).abs() <
          precisionErrorTolerance) {
        return math.max(0, round);
      }
      return math.max(0, actual.ceil());
    }
    return 0;
  }

  @override
  double computeMaxScrollOffset(
    SliverConstraints constraints,
    double itemExtent,
  ) {
    return super.computeMaxScrollOffset(constraints, itemExtent);
  }

  @override
  double? get itemExtent => null;

  @override
  ItemExtentBuilder? get itemExtentBuilder => _buildItemExtent;
}
