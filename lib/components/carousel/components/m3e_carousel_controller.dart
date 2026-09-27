part of 'm3e_carousel_view.dart';

/// A controller for [M3ECarouselView].
///
/// Using a carousel controller helps to show the first visible item on the
/// carousel list.
class M3ECarouselController extends ScrollController {
  /// Creates a carousel controller.
  M3ECarouselController({this.initialItem = 0});

  /// The item that expands to the maximum size when first creating the [M3ECarouselView].
  final int initialItem;

  /// Main-axis extents for a multi-aspect carousel.
  ///
  /// When set, [animateToItem] scrolls by these extents instead of a weighted
  /// carousel position.
  List<double>? variedItemExtents;

  /// Space before the first multi-aspect item. Later items sit flush.
  double variedLeadingGap = 0;

  /// The current leading item index in the [M3ECarouselView].
  int get leadingItem {
    assert(
      positions.isNotEmpty,
      'CarouselController.leadingItem cannot be accessed before a CarouselView is built with it.',
    );
    assert(
      positions.length == 1,
      'CarouselController.leadingItem cannot be read when multiple CarouselViews '
      'are attached to the same controller.',
    );
    final List<double>? extents = variedItemExtents;
    if (extents != null && position is! _CarouselPosition) {
      return _leadingFromExtents(position.pixels, extents);
    }
    return (position as _CarouselPosition).leadingItem;
  }

  int _leadingFromExtents(double pixels, List<double> extents) {
    double origin = variedLeadingGap;
    for (int i = 0; i < extents.length; i++) {
      if (pixels < origin + extents[i] / 2) {
        return i;
      }
      origin += extents[i];
    }
    return extents.isEmpty ? 0 : extents.length - 1;
  }

  _CarouselViewState? _carouselState;

  void _detach(_CarouselViewState anchor) {
    if (_carouselState == anchor) {
      _carouselState = null;
    }
  }

  /// Animates the controlled carousel to the given item index.
  Future<void> animateToItem(
    int index, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.ease,
  }) async {
    if (!hasClients) {
      return;
    }
    final List<double>? extents = variedItemExtents;
    if (extents != null && extents.isNotEmpty) {
      final int target = index.clamp(0, extents.length - 1);
      double offset = 0;
      for (int i = 0; i < target; i++) {
        offset += extents[i];
      }
      await animateTo(offset, duration: duration, curve: curve);
      return;
    }
    if (_carouselState == null) {
      return;
    }

    final bool hasFlexWeights =
        _carouselState!._flexWeights?.isNotEmpty ?? false;
    var targetIndex = index;
    if (_carouselState!.widget.itemBuilder != null) {
      final int? itemCount = _carouselState!.widget.itemCount;
      targetIndex = itemCount != null ? index.clamp(0, itemCount - 1) : 0;
    } else {
      targetIndex = index.clamp(0, _carouselState!.widget.children.length - 1);
    }

    await Future.wait<void>(<Future<void>>[
      for (final _CarouselPosition position
          in positions.cast<_CarouselPosition>())
        position.animateTo(
          _getTargetOffset(position, targetIndex, hasFlexWeights),
          duration: duration,
          curve: curve,
        ),
    ]);
  }

  double _getTargetOffset(
    _CarouselPosition position,
    int index,
    bool hasFlexWeights,
  ) {
    if (!hasFlexWeights) {
      final double targetInFirstCycle = index * _carouselState!._itemExtent!;
      if (!_carouselState!.widget.infinite) {
        return targetInFirstCycle;
      }
      return _adjustForInfiniteCycle(position, targetInFirstCycle);
    }

    final _CarouselViewState carouselState = _carouselState!;
    final List<int> weights = carouselState._flexWeights!;
    final int totalWeight = weights.reduce((int a, int b) => a + b);
    final double dimension = position.viewportDimension;

    final int maxWeightIndex = weights.indexOf(weights.max);
    int leadingIndex = carouselState._consumeMaxWeight
        ? index
        : index - maxWeightIndex;
    if (carouselState.widget.itemBuilder != null) {
      final int? itemCount = carouselState.widget.itemCount;
      leadingIndex = itemCount != null
          ? leadingIndex.clamp(0, itemCount - 1)
          : 0;
    } else {
      final int itemCount = carouselState.widget.children.length;
      leadingIndex = leadingIndex.clamp(0, itemCount - 1);
    }

    final double targetInFirstCycle =
        dimension * (weights.first / totalWeight) * leadingIndex;
    if (!carouselState.widget.infinite) {
      return targetInFirstCycle;
    }
    return _adjustForInfiniteCycle(position, targetInFirstCycle);
  }

  /// Adjusts a target offset (computed for the first cycle) to always scroll
  /// forward from the current position.
  double _adjustForInfiniteCycle(
    _CarouselPosition position,
    double targetInFirstCycle,
  ) {
    final double cycleLength = position._getCycleLengthInPixels();
    if (cycleLength <= 0) {
      return targetInFirstCycle;
    }
    final double currentPixels = position.pixels;
    final double currentCycleStart =
        (currentPixels / cycleLength).floorToDouble() * cycleLength;
    final double sameCycleTarget = currentCycleStart + targetInFirstCycle;

    if (sameCycleTarget >= currentPixels) {
      return sameCycleTarget;
    }
    return sameCycleTarget + cycleLength;
  }

  int? _getItemCount() {
    if (_carouselState == null) {
      return null;
    }
    if (_carouselState!.widget.itemBuilder != null) {
      return _carouselState!.widget.itemCount;
    }
    return _carouselState!.widget.children.length;
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    if (variedItemExtents != null) {
      return super.createScrollPosition(physics, context, oldPosition);
    }
    assert(_carouselState != null, 'carousel invariant');
    return _CarouselPosition(
      physics: physics,
      context: context,
      initialItem: initialItem,
      itemExtent: _carouselState!._itemExtent,
      consumeMaxWeight: _carouselState!._consumeMaxWeight,
      flexWeights: _carouselState!._flexWeights,
      infinite: _carouselState!.widget.infinite,
      itemCount: _getItemCount(),
      oldPosition: oldPosition,
    );
  }

  @override
  void attach(ScrollPosition position) {
    super.attach(position);
    if (position is! _CarouselPosition || _carouselState == null) {
      return;
    }
    position
      ..flexWeights = _carouselState!._flexWeights
      ..itemExtent = _carouselState!._itemExtent
      ..consumeMaxWeight = _carouselState!._consumeMaxWeight
      ..infinite = _carouselState!.widget.infinite
      ..itemCount = _getItemCount();
  }
}
