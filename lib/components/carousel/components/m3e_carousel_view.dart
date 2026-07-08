// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Vendored verbatim from `package:m3_carousel/base_layout.dart` (itself derived
// from Flutter's `CarouselView`). The only changes are that the three public
// classes are renamed with the `M3E` prefix (`M3ECarouselView`,
// `M3ECarouselController`, `M3ECarouselScrollPhysics`). The layout maths,
// slivers, physics, metrics and scroll position are kept byte-for-byte
// identical to the reference so behaviour matches exactly.
//
// Because this is vendored third-party code kept intentionally identical to its
// source, the project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../foundations/foundations.dart';
import '../styles/m3e_carousel_theme.dart';

/// A Material Design carousel widget.
///
/// The [M3ECarouselView] presents a scrollable list of items, each of which can
/// dynamically change size based on the chosen layout.
class M3ECarouselView extends StatefulWidget {
  /// Creates a Material Design carousel.
  const M3ECarouselView({
    super.key,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.itemClipBehavior,
    this.overlayColor,
    this.itemSnapping = false,
    this.shrinkExtent = 0.0,
    this.controller,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.onTap,
    this.enableSplash = true,
    this.infinite = false,
    this.physics,
    required double this.itemExtent,
    required this.children,
    this.onIndexChanged,
  })  : consumeMaxWeight = true,
        flexWeights = null,
        itemBuilder = null,
        itemCount = null;

  /// Creates a scrollable list where the size of each child widget is dynamically
  /// determined by the provided [flexWeights].
  const M3ECarouselView.weighted({
    super.key,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.itemClipBehavior,
    this.overlayColor,
    this.itemSnapping = false,
    this.shrinkExtent = 0.0,
    this.controller,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.consumeMaxWeight = true,
    this.onTap,
    this.enableSplash = true,
    this.infinite = false,
    this.physics,
    required List<int> this.flexWeights,
    required this.children,
    this.onIndexChanged,
  })  : itemExtent = null,
        itemBuilder = null,
        itemCount = null;

  /// Creates a scrollable carousel with fixed-sized items created on demand.
  const M3ECarouselView.builder({
    super.key,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.itemClipBehavior,
    this.overlayColor,
    this.itemSnapping = false,
    this.shrinkExtent = 0.0,
    this.controller,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.onTap,
    this.enableSplash = true,
    required double this.itemExtent,
    required this.itemBuilder,
    this.itemCount,
    this.onIndexChanged,
    this.infinite = false,
    this.physics,
  })  : consumeMaxWeight = true,
        flexWeights = null,
        children = const <Widget>[];

  /// Creates a scrollable carousel with weighted items created on demand.
  const M3ECarouselView.weightedBuilder({
    super.key,
    this.padding,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.itemClipBehavior,
    this.overlayColor,
    this.itemSnapping = false,
    this.shrinkExtent = 0.0,
    this.controller,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.consumeMaxWeight = true,
    this.onTap,
    this.enableSplash = true,
    required List<int> this.flexWeights,
    required this.itemBuilder,
    this.itemCount,
    this.onIndexChanged,
    this.infinite = false,
    this.physics,
  })  : itemExtent = null,
        children = const <Widget>[];

  /// The amount of space to surround each carousel item with.
  ///
  /// Defaults to [EdgeInsets.all] of 4 pixels.
  final EdgeInsets? padding;

  /// The background color for each carousel item.
  ///
  /// Defaults to [ColorScheme.surface].
  final Color? backgroundColor;

  /// The z-coordinate of each carousel item.
  ///
  /// Defaults to 0.0.
  final double? elevation;

  /// The shape of each carousel item's [Material].
  ///
  /// Defines each item's [Material.shape].
  ///
  /// Defaults to a [RoundedRectangleBorder] with a circular corner radius
  /// of 28.0.
  final ShapeBorder? shape;

  /// The clip behavior for each carousel item.
  ///
  /// The item content will be clipped (or not) according to this option.
  /// Refer to the [Clip] enum for more details on the different clip options.
  ///
  /// Defaults to [Clip.antiAlias].
  final Clip? itemClipBehavior;

  /// The highlight color to indicate the carousel items are in pressed, hovered
  /// or focused states.
  ///
  /// The default values are:
  ///   * [WidgetState.pressed] - [ColorScheme.onSurface] with an opacity of 0.1
  ///   * [WidgetState.hovered] - [ColorScheme.onSurface] with an opacity of 0.08
  ///   * [WidgetState.focused] - [ColorScheme.onSurface] with an opacity of 0.1
  final WidgetStateProperty<Color?>? overlayColor;

  /// The minimum allowable extent (size) in the main axis for carousel items
  /// during scrolling transitions.
  ///
  /// As the carousel scrolls, the first visible item is pinned and gradually
  /// shrinks until it reaches this minimum extent before scrolling off-screen.
  /// Similarly, the last visible item enters the viewport at this minimum size
  /// and expands to its full [itemExtent].
  ///
  /// In cases where the remaining viewport space for the last visible item is
  /// larger than the defined [shrinkExtent], the [shrinkExtent] is dynamically
  /// adjusted to match this remaining space, ensuring a smooth size transition.
  ///
  /// Defaults to 0.0. Setting to 0.0 allows items to shrink/expand completely,
  /// transitioning between 0.0 and the full item size. In cases where the
  /// remaining viewport space for the last visible item is larger than the
  /// defined [shrinkExtent], the [shrinkExtent] is dynamically adjusted to match
  /// this remaining space, ensuring a smooth size transition.
  final double shrinkExtent;

  /// Whether the carousel should keep scrolling to the next/previous items to
  /// maintain the original layout.
  ///
  /// Defaults to false.
  final bool itemSnapping;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  final M3ECarouselController? controller;

  /// The [Axis] along which the scroll view's offset increases with each item.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Whether the carousel list scrolls in the reading direction.
  ///
  /// Defaults to false.
  final bool reverse;

  /// Whether the collapsed items are allowed to expand to the max size.
  ///
  /// Defaults to true.
  final bool consumeMaxWeight;

  /// Called when one of the [children] is tapped.
  final ValueChanged<int>? onTap;

  /// Determines whether an [InkWell] will cover each Carousel item.
  ///
  /// Defaults to true.
  final bool enableSplash;

  /// The extent the children are forced to have in the main axis.
  ///
  /// This is required for [M3ECarouselView]. In [M3ECarouselView.weighted], this
  /// is null.
  final double? itemExtent;

  /// The scrollPhysics to apply to the carousel layout.
  ///
  /// Defaults to [NeverScrollableScrollPhysics] to allow scroll control only
  /// by horizontal swipe gesture.
  final ScrollPhysics? physics;

  /// The weights that each visible child should occupy in the viewport.
  ///
  /// This is a required property in [M3ECarouselView.weighted]. This is null
  /// for default [M3ECarouselView]. The integers must be greater than 0.
  final List<int>? flexWeights;

  /// The child widgets for the carousel.
  final List<Widget> children;

  /// A callback invoked when the leading item changes.
  final ValueChanged<int>? onIndexChanged;

  /// Called to build carousel item on demand.
  final NullableIndexedWidgetBuilder? itemBuilder;

  /// The number of items in the carousel.
  final int? itemCount;

  /// Whether the carousel should loop infinitely.
  ///
  /// Defaults to false.
  final bool infinite;

  @override
  State<M3ECarouselView> createState() => _CarouselViewState();
}

class _CarouselViewState extends State<M3ECarouselView> {
  double? _itemExtent;

  List<int>? get _flexWeights => widget.flexWeights;

  bool get _consumeMaxWeight => widget.consumeMaxWeight;
  M3ECarouselController? _internalController;

  M3ECarouselController get _controller =>
      widget.controller ?? _internalController!;
  late int _lastReportedLeadingItem;

  @override
  void initState() {
    super.initState();
    _itemExtent = widget.itemExtent;
    if (widget.controller == null) {
      _internalController = M3ECarouselController();
    }
    _lastReportedLeadingItem = _getInitialLeadingItem();
    _controller._attach(this);
    _controller.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(covariant M3ECarouselView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?._detach(this);
      if (widget.controller != null) {
        _internalController?._detach(this);
        _internalController = null;
        widget.controller?._attach(this);
      } else {
        // widget.controller == null && oldWidget.controller != null
        assert(_internalController == null);
        _internalController = M3ECarouselController();
        _controller._attach(this);
      }
    }
    if (widget.flexWeights != oldWidget.flexWeights) {
      (_controller.position as _CarouselPosition).flexWeights = _flexWeights;
    }
    if (widget.itemExtent != oldWidget.itemExtent) {
      _itemExtent = widget.itemExtent;
      (_controller.position as _CarouselPosition).itemExtent = _itemExtent;
    }
    if (widget.consumeMaxWeight != oldWidget.consumeMaxWeight) {
      (_controller.position as _CarouselPosition).consumeMaxWeight =
          _consumeMaxWeight;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    _controller._detach(this);
    _internalController?.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (widget.onIndexChanged == null) {
      return;
    }

    final ScrollPosition position = _controller.position;
    final int currentLeadingIndex = (position as _CarouselPosition).leadingItem;

    if (currentLeadingIndex != _lastReportedLeadingItem) {
      _lastReportedLeadingItem = currentLeadingIndex;
      widget.onIndexChanged!(currentLeadingIndex);
    }
  }

  // For weighted carousel, the initialItem means the index of the item to occupy the first maximum weight
  // in flexWeights. To get the initial leading item, it should be initialItem - index of the first max weight in flexWeights.
  // So it might be negative when initialItem value is small but the first max weight index is large. In that case,
  // the initial leading item should be 0.
  int _getInitialLeadingItem() {
    if (widget.flexWeights != null) {
      final int maxWeight = widget.flexWeights!.max;
      final int firstMaxWeightIndex = widget.flexWeights!.indexOf(maxWeight);
      return math.max(_controller.initialItem - firstMaxWeightIndex, 0);
    }
    return _controller.initialItem;
  }

  Widget _buildCarouselItem(int index) {
    // For infinite scrolling, wrap the index to the actual children range.
    if (widget.infinite && widget.children.isNotEmpty) {
      index = index % widget.children.length;
    }
    final M3EThemeData m3eTheme = M3ETheme.of(context);
    final M3ECarouselTheme carouselTheme = m3eTheme.carouselTheme;
    final M3EColorScheme scheme = m3eTheme.colorScheme;
    final EdgeInsets effectivePadding =
        widget.padding ?? carouselTheme.itemPadding as EdgeInsets;
    final Color effectiveBackgroundColor = widget.backgroundColor ??
        carouselTheme.backgroundColor(scheme);
    final double effectiveElevation =
        widget.elevation ?? carouselTheme.elevation;
    final ShapeBorder effectiveShape =
        widget.shape ?? carouselTheme.shape;
    final Clip effectiveItemClipBehavior =
        widget.itemClipBehavior ?? carouselTheme.itemClipBehavior;
    final WidgetStateProperty<Color?> effectiveOverlayColor =
        widget.overlayColor ?? carouselTheme.overlayColor(scheme);

    Widget contents = widget.children[index];

    if (widget.enableSplash) {
      contents = Stack(
        fit: StackFit.expand,
        children: <Widget>[
          contents,
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => widget.onTap?.call(index),
              overlayColor: effectiveOverlayColor,
            ),
          ),
        ],
      );
    } else if (widget.onTap != null) {
      contents =
          GestureDetector(onTap: () => widget.onTap!(index), child: contents);
    }

    return Padding(
      padding: effectivePadding,
      child: Material(
        clipBehavior: effectiveItemClipBehavior,
        color: effectiveBackgroundColor,
        elevation: effectiveElevation,
        shape: effectiveShape,
        child: contents,
      ),
    );
  }

  Widget _buildSliverCarousel() {
    // Determine the child count and builder based on whether we're using lazy loading
    final int? childCount = widget.infinite
        ? null
        : widget.itemBuilder != null
            ? widget.itemCount
            : widget.children.length;

    NullableIndexedWidgetBuilder effectiveBuilder;
    if (widget.itemBuilder != null) {
      if (widget.infinite &&
          widget.itemCount != null &&
          widget.itemCount! > 0) {
        final int itemCount = widget.itemCount!;
        effectiveBuilder = (BuildContext context, int index) {
          return widget.itemBuilder!(context, index % itemCount);
        };
      } else {
        effectiveBuilder = widget.itemBuilder!;
      }
    } else {
      effectiveBuilder =
          (BuildContext context, int index) => _buildCarouselItem(index);
    }

    if (_itemExtent != null) {
      return _SliverFixedExtentCarousel(
        itemExtent: _itemExtent!,
        minExtent: widget.shrinkExtent,
        infinite: widget.infinite,
        delegate: SliverChildBuilderDelegate(effectiveBuilder,
            childCount: childCount),
      );
    }

    assert(
      _flexWeights != null && _flexWeights!.every((int weight) => weight > 0),
      'flexWeights is null or it contains non-positive integers',
    );
    return _SliverWeightedCarousel(
      consumeMaxWeight: _consumeMaxWeight,
      shrinkExtent: widget.shrinkExtent,
      weights: _flexWeights!,
      infinite: widget.infinite,
      delegate:
          SliverChildBuilderDelegate(effectiveBuilder, childCount: childCount),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ScrollPhysics physics = widget.itemSnapping
        ? const M3ECarouselScrollPhysics()
        : ScrollConfiguration.of(context).getScrollPhysics(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double mainAxisExtent = switch (widget.scrollDirection) {
          Axis.horizontal => constraints.maxWidth,
          Axis.vertical => constraints.maxHeight,
        };

        _itemExtent = widget.itemExtent == null
            ? null
            : clampDouble(widget.itemExtent!, 0, mainAxisExtent);
        return CustomScrollView(
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          controller: _controller,
          physics: widget.physics ?? physics,
          clipBehavior: Clip.antiAlias,
          scrollCacheExtent: const ScrollCacheExtent.viewport(0.0),
          slivers: <Widget>[_buildSliverCarousel()],
        );
      },
    );
  }
}

/// A sliver that displays its box children in a linear array with a fixed extent
/// per item.
class _SliverFixedExtentCarousel extends SliverMultiBoxAdaptorWidget {
  const _SliverFixedExtentCarousel({
    required super.delegate,
    required this.minExtent,
    required this.itemExtent,
    required this.infinite,
  });

  final double itemExtent;
  final double minExtent;
  final bool infinite;

  @override
  RenderSliverFixedExtentBoxAdaptor createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;
    return _RenderSliverFixedExtentCarousel(
      childManager: element,
      minExtent: minExtent,
      maxExtent: itemExtent,
      infinite: infinite,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderSliverFixedExtentCarousel renderObject) {
    renderObject.maxExtent = itemExtent;
    renderObject.minExtent = minExtent;
    renderObject.infinite = infinite;
  }
}

class _RenderSliverFixedExtentCarousel
    extends RenderSliverFixedExtentBoxAdaptor {
  _RenderSliverFixedExtentCarousel({
    required super.childManager,
    required double maxExtent,
    required double minExtent,
    required bool infinite,
  })  : _maxExtent = maxExtent,
        _minExtent = minExtent,
        _infinite = infinite;

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
      int index, SliverLayoutDimensions currentLayoutDimensions) {
    if (maxExtent == 0.0) {
      return maxExtent;
    }

    final int firstVisibleIndex =
        (constraints.scrollOffset / maxExtent).floor();

    // Calculate how many items have been completely scroll off screen.
    final int offscreenItems = (constraints.scrollOffset / maxExtent).floor();

    // If an item is partially off screen and partially on screen,
    // `constraints.scrollOffset` must be greater than
    // `offscreenItems * maxExtent`, so the difference between these two is how
    // much the current first visible item is off screen.
    final double offscreenExtent =
        constraints.scrollOffset - offscreenItems * maxExtent;

    // If there is not enough space to place the last visible item but the remaining
    // space is larger than `minExtent`, the extent for last item should be at
    // least the remaining extent to ensure a smooth size transition.
    final double effectiveMinExtent = math.max(
      constraints.remainingPaintExtent % maxExtent,
      minExtent,
    );

    // Two special cases are the first and last visible items. Other items' extent
    // should all return `maxExtent`.
    if (index == firstVisibleIndex) {
      final double effectiveExtent = maxExtent - offscreenExtent;
      return math.max(effectiveExtent, effectiveMinExtent);
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
    if (maxExtent == 0.0) {
      return maxExtent;
    }

    final int firstVisibleIndex =
        (constraints.scrollOffset / maxExtent).floor();

    // If there is not enough space to place the last visible item but the remaining
    // space is larger than `minExtent`, the extent for last item should be at
    // least the remaining extent to make sure a smooth size transition.
    final double effectiveMinExtent = math.max(
      constraints.remainingPaintExtent % maxExtent,
      minExtent,
    );
    if (index == firstVisibleIndex) {
      final double firstVisibleItemExtent =
          _buildItemExtent(index, layoutDimensions);

      // If the first item is collapsed to be less than `effectiveMinExtent`,
      // then it should stop changing its size and should start to scroll off screen.
      if (firstVisibleItemExtent <= effectiveMinExtent) {
        return maxExtent * index - effectiveMinExtent + maxExtent;
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
  double? get itemExtent => null;

  @override
  ItemExtentBuilder? get itemExtentBuilder => _buildItemExtent;
}

/// A sliver that arranges its box children in a linear array, constraining them
/// to specific weights determined by the [weights] property.
class _SliverWeightedCarousel extends SliverMultiBoxAdaptorWidget {
  const _SliverWeightedCarousel({
    required super.delegate,
    required this.consumeMaxWeight,
    required this.shrinkExtent,
    required this.weights,
    required this.infinite,
  });

  final bool consumeMaxWeight;
  final double shrinkExtent;
  final List<int> weights;
  final bool infinite;

  @override
  RenderSliverFixedExtentBoxAdaptor createRenderObject(BuildContext context) {
    final element = context as SliverMultiBoxAdaptorElement;
    return _RenderSliverWeightedCarousel(
      childManager: element,
      consumeMaxWeight: consumeMaxWeight,
      shrinkExtent: shrinkExtent,
      weights: weights,
      infinite: infinite,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderSliverWeightedCarousel renderObject) {
    renderObject
      ..consumeMaxWeight = consumeMaxWeight
      ..shrinkExtent = shrinkExtent
      ..weights = weights
      ..infinite = infinite;
  }
}

// A sliver that places its box children in a linear array and constrains them
// to have the corresponding weight which is determined by [weights].
class _RenderSliverWeightedCarousel extends RenderSliverFixedExtentBoxAdaptor {
  _RenderSliverWeightedCarousel({
    required super.childManager,
    required bool consumeMaxWeight,
    required double shrinkExtent,
    required List<int> weights,
    required bool infinite,
  })  : _consumeMaxWeight = consumeMaxWeight,
        _shrinkExtent = shrinkExtent,
        _weights = weights,
        _infinite = infinite;

  bool get consumeMaxWeight => _consumeMaxWeight;
  bool _consumeMaxWeight;

  set consumeMaxWeight(bool value) {
    if (_consumeMaxWeight == value) {
      return;
    }
    _consumeMaxWeight = value;
    markNeedsLayout();
  }

  double get shrinkExtent => _shrinkExtent;
  double _shrinkExtent;

  set shrinkExtent(double value) {
    if (_shrinkExtent == value) {
      return;
    }
    _shrinkExtent = value;
    markNeedsLayout();
  }

  List<int> get weights => _weights;
  List<int> _weights;

  set weights(List<int> value) {
    if (_weights == value) {
      return;
    }
    _weights = value;
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

  // This is to implement the itemExtentBuilder callback to return each item extent
  // while scrolling.
  //
  // The given `index` is compared with `_firstVisibleItemIndex` to know how
  // many items are placed before the current one in the view.
  double _buildItemExtent(
      int index, SliverLayoutDimensions currentLayoutDimensions) {
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
      assert(index - _firstVisibleItemIndex < weights.length);
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
      final double safeMinExtent = math.max(minChildExtent, 1.0);
      final int estimatedUpperBound = _firstVisibleItemIndex +
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
    );
    assert(itemExtentBuilder != null ||
        (itemExtent!.isFinite && itemExtent! >= 0));

    final SliverConstraints constraints = this.constraints;
    childManager.didStartLayout();
    childManager.setDidUnderflow(false);

    final double scrollOffset =
        constraints.scrollOffset + constraints.cacheOrigin;
    assert(scrollOffset >= 0.0);
    final double remainingExtent = constraints.remainingCacheExtent;
    assert(remainingExtent >= 0.0);
    final double targetEndScrollOffset = scrollOffset + remainingExtent;
    // TODO(Piinks): Clean up when deprecation expires.
    const double deprecatedExtraItemExtent = -1;

    final int firstIndex = getMinChildIndexForScrollOffset(
        scrollOffset, deprecatedExtraItemExtent);
    final int? targetLastIndex = targetEndScrollOffset.isFinite
        ? getMaxChildIndexForScrollOffset(
            targetEndScrollOffset, deprecatedExtraItemExtent)
        : null;

    if (firstChild != null) {
      final int leadingGarbage =
          calculateLeadingGarbage(firstIndex: firstIndex);
      final int trailingGarbage = targetLastIndex != null
          ? calculateTrailingGarbage(lastIndex: targetLastIndex)
          : 0;
      collectGarbage(leadingGarbage, trailingGarbage);
    } else {
      collectGarbage(0, 0);
    }

    if (firstChild == null) {
      final double layoutOffset =
          indexToLayoutOffset(deprecatedExtraItemExtent, firstIndex);
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
      final RenderBox? child =
          insertAndLayoutLeadingChild(_getChildConstraints(index));
      if (child == null) {
        // Items before the previously first child are no longer present.
        // Reset the scroll offset to offset all items prior and up to the
        // missing item. Let parent re-layout everything.
        geometry = SliverGeometry(
          scrollOffsetCorrection:
              indexToLayoutOffset(deprecatedExtraItemExtent, index),
        );
        return;
      }
      final childParentData =
          child.parentData! as SliverMultiBoxAdaptorParentData;
      childParentData.layoutOffset =
          indexToLayoutOffset(deprecatedExtraItemExtent, index);
      assert(childParentData.index == index);
      trailingChildWithLayout ??= child;
    }

    if (trailingChildWithLayout == null) {
      firstChild!.layout(_getChildConstraints(indexOf(firstChild!)));
      final childParentData =
          firstChild!.parentData! as SliverMultiBoxAdaptorParentData;
      childParentData.layoutOffset =
          indexToLayoutOffset(deprecatedExtraItemExtent, firstIndex);
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
    for (int index = indexOf(trailingChildWithLayout!) + 1;
        targetLastIndex == null || index <= targetLastIndex;
        ++index) {
      RenderBox? child = childAfter(trailingChildWithLayout!);
      if (child == null || indexOf(child) != index) {
        child = insertAndLayoutChild(_getChildConstraints(index),
            after: trailingChildWithLayout);
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
      assert(childParentData.index == index);
      childParentData.layoutOffset = indexToLayoutOffset(
        deprecatedExtraItemExtent,
        childParentData.index!,
      );
    }

    final int lastIndex = indexOf(lastChild!);
    final double leadingScrollOffset =
        indexToLayoutOffset(deprecatedExtraItemExtent, firstIndex);
    double trailingScrollOffset;

    if (!infinite && lastIndex + 1 == childManager.childCount) {
      trailingScrollOffset =
          indexToLayoutOffset(deprecatedExtraItemExtent, lastIndex);

      trailingScrollOffset += math.max(
        weights.last * extentUnit,
        _buildItemExtent(lastIndex, layoutDimensions),
      );
      trailingScrollOffset += extraLayoutOffset;
    } else {
      trailingScrollOffset =
          indexToLayoutOffset(deprecatedExtraItemExtent, lastIndex + 1);
    }

    assert(debugAssertChildListIsNonEmptyAndContiguous());
    assert(indexOf(firstChild!) == firstIndex);
    assert(targetLastIndex == null || lastIndex <= targetLastIndex);

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
            targetEndScrollOffsetForPaint, deprecatedExtraItemExtent)
        : null;

    geometry = SliverGeometry(
      scrollExtent: estimatedMaxScrollOffset,
      paintExtent: paintExtent,
      cacheExtent: cacheExtent,
      maxPaintExtent: estimatedMaxScrollOffset,
      // Conservative to avoid flickering away the clip during scroll.
      hasVisualOverflow: (targetLastIndexForPaint != null &&
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

/// Scroll physics used by a [M3ECarouselView].
///
/// These physics cause the carousel item to snap to item boundaries.
class M3ECarouselScrollPhysics extends ScrollPhysics {
  /// Creates physics for a [M3ECarouselView].
  const M3ECarouselScrollPhysics({super.parent});

  @override
  M3ECarouselScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return M3ECarouselScrollPhysics(parent: buildParent(ancestor));
  }

  double _getTargetPixels(
      _CarouselPosition position, Tolerance tolerance, double velocity) {
    double fraction;

    if (position.itemExtent != null) {
      fraction = position.itemExtent! / position.viewportDimension;
    } else {
      assert(position.flexWeights != null);
      fraction = position.flexWeights!.first / position.flexWeights!.sum;
    }

    final double itemWidth = position.viewportDimension * fraction;

    final double actual = math.max(0.0, position.pixels) / itemWidth;
    final double round = actual.roundToDouble();
    double item;
    if ((actual - round).abs() < precisionErrorTolerance) {
      item = round;
    } else {
      item = actual;
    }
    if (velocity < -tolerance.velocity) {
      item -= 0.5;
    } else if (velocity > tolerance.velocity) {
      item += 0.5;
    }
    return item.roundToDouble() * itemWidth;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    assert(
      position is _CarouselPosition,
      'CarouselScrollPhysics can only be used with Scrollables that uses '
      'the CarouselController',
    );

    final metrics = position as _CarouselPosition;
    if ((velocity <= 0.0 && metrics.pixels <= metrics.minScrollExtent) ||
        (velocity >= 0.0 && metrics.pixels >= metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    final Tolerance tolerance = toleranceFor(metrics);
    final double target = _getTargetPixels(metrics, tolerance, velocity);
    if (target != metrics.pixels) {
      return ScrollSpringSimulation(spring, metrics.pixels, target, velocity,
          tolerance: tolerance);
    }
    return null;
  }

  @override
  bool get allowImplicitScrolling => true;
}

/// Metrics for a [M3ECarouselView].
class _CarouselMetrics extends FixedScrollMetrics {
  /// Creates an immutable snapshot of values associated with a [M3ECarouselView].
  _CarouselMetrics({
    required super.minScrollExtent,
    required super.maxScrollExtent,
    required super.pixels,
    required super.viewportDimension,
    required super.axisDirection,
    this.itemExtent,
    this.flexWeights,
    this.consumeMaxWeight,
    required super.devicePixelRatio,
  });

  /// Extent for the carousel item.
  final double? itemExtent;

  /// The fraction of the viewport that the first item occupies.
  final List<int>? flexWeights;

  /// Determine whether each child can be expanded to occupy the maximum weight while scrolling.
  final bool? consumeMaxWeight;

  @override
  _CarouselMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? itemExtent,
    List<int>? flexWeights,
    bool? consumeMaxWeight,
    double? devicePixelRatio,
  }) {
    return _CarouselMetrics(
      minScrollExtent: minScrollExtent ??
          (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent: maxScrollExtent ??
          (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension: viewportDimension ??
          (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      itemExtent: itemExtent ?? this.itemExtent,
      flexWeights: flexWeights ?? this.flexWeights,
      consumeMaxWeight: consumeMaxWeight ?? this.consumeMaxWeight,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
    );
  }
}

class _CarouselPosition extends ScrollPositionWithSingleContext
    implements _CarouselMetrics {
  _CarouselPosition({
    required super.physics,
    required super.context,
    this.initialItem = 0,
    double? itemExtent,
    List<int>? flexWeights,
    bool consumeMaxWeight = true,
    bool infinite = false,
    int? itemCount,
    super.oldPosition,
  })  : assert(
          flexWeights != null && itemExtent == null ||
              flexWeights == null && itemExtent != null,
        ),
        _itemToShowOnStartup = initialItem.toDouble(),
        _consumeMaxWeight = consumeMaxWeight,
        _infinite = infinite,
        _itemCount = itemCount,
        super(initialPixels: null);

  int initialItem;
  final double _itemToShowOnStartup;

  /// The number of items in the carousel for infinite scrolling wrapping.
  int? get itemCount => _itemCount;
  int? _itemCount;

  set itemCount(int? value) {
    if (_itemCount == value) {
      return;
    }
    _itemCount = value;
  }

  /// Whether the carousel scrolls infinitely in both directions.
  bool get infinite => _infinite;
  bool _infinite;

  set infinite(bool value) {
    if (_infinite == value) {
      return;
    }
    _infinite = value;
  }

  // When the viewport has a zero-size, the item can not
  // be retrieved by `getItemFromPixels`, so we need to cache the item
  // for use when resizing the viewport to non-zero next time.
  double? _cachedItem;

  @override
  bool get consumeMaxWeight => _consumeMaxWeight;
  bool _consumeMaxWeight;

  set consumeMaxWeight(bool value) {
    if (_consumeMaxWeight == value) {
      return;
    }
    if (hasPixels && flexWeights != null) {
      final double leadingItem = updateLeadingItem(flexWeights, value);
      final double newPixel =
          getPixelsFromItem(leadingItem, flexWeights, itemExtent);
      forcePixels(newPixel);
    }
    _consumeMaxWeight = value;
  }

  @override
  double? get itemExtent => _itemExtent;
  double? _itemExtent;

  set itemExtent(double? value) {
    if (_itemExtent == value) {
      return;
    }
    if (hasPixels && _itemExtent != null && viewportDimension != 0.0) {
      final double leadingItem = getItemFromPixels(pixels, viewportDimension);
      final double newPixel =
          getPixelsFromItem(leadingItem, flexWeights, value);
      forcePixels(newPixel);
    }
    _itemExtent = value;
  }

  @override
  List<int>? get flexWeights => _flexWeights;
  List<int>? _flexWeights;

  set flexWeights(List<int>? value) {
    if (flexWeights == value) {
      return;
    }
    final List<int>? oldWeights = _flexWeights;
    if (hasPixels && oldWeights != null) {
      final double leadingItem = updateLeadingItem(value, consumeMaxWeight);
      final double newPixel = getPixelsFromItem(leadingItem, value, itemExtent);
      forcePixels(newPixel);
    }
    _flexWeights = value;
  }

  // The index of the leading item in the carousel.
  int get leadingItem {
    int leadingItem = getItemFromPixels(pixels, viewportDimension).toInt();
    if (consumeMaxWeight && flexWeights != null) {
      leadingItem =
          math.max(leadingItem - flexWeights!.indexOf(flexWeights!.max), 0);
    }
    // For infinite scrolling, wrap the index to the range [0, itemCount - 1].
    if (infinite && itemCount != null && itemCount! > 0) {
      leadingItem = leadingItem % itemCount!;
    }
    return leadingItem;
  }

  double updateLeadingItem(
      List<int>? newFlexWeights, bool newConsumeMaxWeight) {
    final double maxItem;
    if (hasPixels && flexWeights != null) {
      final double leadingItem = getItemFromPixels(pixels, viewportDimension);
      maxItem = consumeMaxWeight
          ? leadingItem
          : leadingItem + flexWeights!.indexOf(flexWeights!.max);
    } else {
      if (!newConsumeMaxWeight) {
        return _itemToShowOnStartup;
      }
      maxItem = _itemToShowOnStartup;
    }
    if (newFlexWeights != null && !newConsumeMaxWeight) {
      var smallerWeights = 0;
      for (final int weight in newFlexWeights) {
        if (weight == newFlexWeights.max) {
          break;
        }
        smallerWeights += 1;
      }
      return maxItem - smallerWeights;
    }
    return maxItem;
  }

  double getItemFromPixels(double pixels, double viewportDimension) {
    assert(viewportDimension > 0.0);
    double fraction;
    if (itemExtent != null) {
      fraction = itemExtent! / viewportDimension;
    } else {
      // If itemExtent is null, flexWeights cannot be null.
      assert(flexWeights != null);
      fraction = flexWeights!.first / flexWeights!.sum;
    }

    final double actual =
        math.max(0.0, pixels) / (viewportDimension * fraction);
    final double round = actual.roundToDouble();
    if ((actual - round).abs() < precisionErrorTolerance) {
      return round;
    }
    return actual;
  }

  double getPixelsFromItem(
      double item, List<int>? flexWeights, double? itemExtent) {
    double fraction;
    if (viewportDimension == 0.0) {
      return 0.0;
    }
    if (itemExtent != null) {
      fraction = itemExtent / viewportDimension;
    } else {
      // If itemExtent is null, flexWeights cannot be null.
      assert(flexWeights != null);
      fraction = flexWeights!.first / flexWeights.sum;
    }

    return item * viewportDimension * fraction;
  }

  @override
  bool applyViewportDimension(double viewportDimension) {
    final double? oldViewportDimensions =
        hasViewportDimension ? this.viewportDimension : null;
    if (viewportDimension == oldViewportDimensions) {
      return true;
    }
    final bool result = super.applyViewportDimension(viewportDimension);
    final double? oldPixels = hasPixels ? pixels : null;
    double item;
    if (oldPixels == null) {
      item = updateLeadingItem(flexWeights, consumeMaxWeight);
    } else if (oldViewportDimensions == 0.0) {
      // If resize from zero, we should use the _cachedItem to recover the state.
      item = _cachedItem!;
    } else {
      item = getItemFromPixels(
          oldPixels, oldViewportDimensions ?? viewportDimension);
    }
    final double newPixels = getPixelsFromItem(item, flexWeights, itemExtent);
    // If the viewportDimension is zero, cache the item
    // in case the viewport is resized to be non-zero.
    _cachedItem = (viewportDimension == 0.0) ? item : null;

    if (newPixels != oldPixels) {
      correctPixels(newPixels);
      return false;
    }
    return result;
  }

  @override
  void absorb(ScrollPosition other) {
    super.absorb(other);

    if (other is! _CarouselPosition) {
      return;
    }

    _cachedItem = other._cachedItem;
    _itemExtent = other._itemExtent;
  }

  /// Returns the length of one complete cycle in pixels.
  double _getCycleLengthInPixels() {
    if (itemCount == null ||
        itemCount! <= 0 ||
        !hasViewportDimension ||
        viewportDimension == 0) {
      return 0.0;
    }
    double fraction;
    if (itemExtent != null) {
      fraction = itemExtent! / viewportDimension;
    } else if (flexWeights != null) {
      fraction = flexWeights!.first / flexWeights!.sum;
    } else {
      return 0.0;
    }
    return itemCount! * viewportDimension * fraction;
  }

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    // For infinite scrolling, dynamically add cycles when approaching the boundary.
    if (infinite && hasPixels) {
      final double cycleLength = _getCycleLengthInPixels();
      if (cycleLength > 0 && pixels < cycleLength) {
        final int cyclesToAdd = ((cycleLength - pixels) / cycleLength).ceil();
        correctPixels(pixels + cyclesToAdd * cycleLength);
        return false;
      }
    }
    return super.applyContentDimensions(
        infinite ? 0.0 : minScrollExtent, maxScrollExtent);
  }

  @override
  _CarouselMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    double? itemExtent,
    List<int>? flexWeights,
    bool? consumeMaxWeight,
    double? devicePixelRatio,
  }) {
    return _CarouselMetrics(
      minScrollExtent: minScrollExtent ??
          (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent: maxScrollExtent ??
          (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension: viewportDimension ??
          (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      itemExtent: itemExtent ?? this.itemExtent,
      flexWeights: flexWeights ?? this.flexWeights,
      consumeMaxWeight: consumeMaxWeight ?? this.consumeMaxWeight,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
    );
  }
}

/// A controller for [M3ECarouselView].
///
/// Using a carousel controller helps to show the first visible item on the
/// carousel list.
class M3ECarouselController extends ScrollController {
  /// Creates a carousel controller.
  M3ECarouselController({this.initialItem = 0});

  /// The item that expands to the maximum size when first creating the [M3ECarouselView].
  final int initialItem;

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
    return (position as _CarouselPosition).leadingItem;
  }

  _CarouselViewState? _carouselState;

  // ignore: use_setters_to_change_properties
  void _attach(_CarouselViewState anchor) {
    _carouselState = anchor;
  }

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
    if (!hasClients || _carouselState == null) {
      return;
    }

    final bool hasFlexWeights =
        _carouselState!._flexWeights?.isNotEmpty ?? false;
    if (_carouselState!.widget.itemBuilder != null) {
      final int? itemCount = _carouselState!.widget.itemCount;
      index = itemCount != null ? index.clamp(0, itemCount - 1) : 0;
    } else {
      index = index.clamp(0, _carouselState!.widget.children.length - 1);
    }

    await Future.wait<void>(<Future<void>>[
      for (final _CarouselPosition position
          in positions.cast<_CarouselPosition>())
        position.animateTo(
          _getTargetOffset(position, index, hasFlexWeights),
          duration: duration,
          curve: curve,
        ),
    ]);
  }

  double _getTargetOffset(
      _CarouselPosition position, int index, bool hasFlexWeights) {
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
    int leadingIndex =
        carouselState._consumeMaxWeight ? index : index - maxWeightIndex;
    if (carouselState.widget.itemBuilder != null) {
      final int? itemCount = carouselState.widget.itemCount;
      leadingIndex =
          itemCount != null ? leadingIndex.clamp(0, itemCount - 1) : 0;
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
      _CarouselPosition position, double targetInFirstCycle) {
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
    assert(_carouselState != null);
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
    final carouselPosition = position as _CarouselPosition;
    carouselPosition.flexWeights = _carouselState!._flexWeights;
    carouselPosition.itemExtent = _carouselState!._itemExtent;
    carouselPosition.consumeMaxWeight = _carouselState!._consumeMaxWeight;
    carouselPosition.infinite = _carouselState!.widget.infinite;
    carouselPosition.itemCount = _getItemCount();
  }
}
