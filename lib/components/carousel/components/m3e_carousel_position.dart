// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Vendored from `package:m3_carousel/base_layout.dart` (Flutter CarouselView).
// Split into part files for klin_dart file_length; behaviour unchanged.
part of 'm3e_carousel_view.dart';

class _CarouselPosition extends ScrollPositionWithSingleContext
    implements _CarouselMetrics {
  _CarouselPosition({
    required super.physics,
    required super.context,
    this.initialItem = 0,
    double? itemExtent,
    List<int>? flexWeights,
    this._consumeMaxWeight = true,
    this._infinite = false,
    this._itemCount,
    super.oldPosition,
  }) : assert(
         flexWeights != null && itemExtent == null ||
             flexWeights == null && itemExtent != null,
         'Exactly one of flexWeights or itemExtent must be non-null',
       ),
       _itemToShowOnStartup = initialItem.toDouble(),
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
      final double leadingItem = updateLeadingItem(
        flexWeights,
        newConsumeMaxWeight: value,
      );
      final double newPixel = getPixelsFromItem(
        leadingItem,
        flexWeights,
        itemExtent,
      );
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
      final double newPixel = getPixelsFromItem(
        leadingItem,
        flexWeights,
        value,
      );
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
      final double leadingItem = updateLeadingItem(
        value,
        newConsumeMaxWeight: consumeMaxWeight,
      );
      final double newPixel = getPixelsFromItem(leadingItem, value, itemExtent);
      forcePixels(newPixel);
    }
    _flexWeights = value;
  }

  // The index of the leading item in the carousel.
  int get leadingItem {
    int leadingItem = getItemFromPixels(pixels, viewportDimension).toInt();
    if (consumeMaxWeight && flexWeights != null) {
      leadingItem = math.max(
        leadingItem - flexWeights!.indexOf(flexWeights!.max),
        0,
      );
    }
    // For infinite scrolling, wrap the index to the range [0, itemCount - 1].
    if (infinite && itemCount != null && itemCount! > 0) {
      leadingItem = leadingItem % itemCount!;
    }
    return leadingItem;
  }

  double updateLeadingItem(
    List<int>? newFlexWeights, {
    required bool newConsumeMaxWeight,
  }) {
    final double? maxItem = _maxItemForLeadingUpdate(newConsumeMaxWeight);
    if (maxItem == null) {
      return _itemToShowOnStartup;
    }
    if (newFlexWeights != null && !newConsumeMaxWeight) {
      return maxItem - _leadingSmallerWeightCount(newFlexWeights);
    }
    return maxItem;
  }

  /// Null means the caller should return [_itemToShowOnStartup] immediately.
  double? _maxItemForLeadingUpdate(bool newConsumeMaxWeight) {
    if (hasPixels && flexWeights != null) {
      final double leadingItem = getItemFromPixels(pixels, viewportDimension);
      return consumeMaxWeight
          ? leadingItem
          : leadingItem + flexWeights!.indexOf(flexWeights!.max);
    }
    if (!newConsumeMaxWeight) {
      return null;
    }
    return _itemToShowOnStartup;
  }

  int _leadingSmallerWeightCount(List<int> newFlexWeights) {
    var smallerWeights = 0;
    for (final weight in newFlexWeights) {
      if (weight == newFlexWeights.max) {
        break;
      }
      smallerWeights += 1;
    }
    return smallerWeights;
  }

  double getItemFromPixels(double pixels, double viewportDimension) {
    assert(viewportDimension > 0.0, 'carousel invariant');
    double fraction;
    if (itemExtent != null) {
      fraction = itemExtent! / viewportDimension;
    } else {
      // If itemExtent is null, flexWeights cannot be null.
      assert(flexWeights != null, 'carousel invariant');
      fraction = flexWeights!.first / flexWeights!.sum;
    }

    final double actual = math.max(0, pixels) / (viewportDimension * fraction);
    final double round = actual.roundToDouble();
    if ((actual - round).abs() < precisionErrorTolerance) {
      return round;
    }
    return actual;
  }

  double getPixelsFromItem(
    double item,
    List<int>? flexWeights,
    double? itemExtent,
  ) {
    double fraction;
    if (viewportDimension == 0.0) {
      return 0;
    }
    if (itemExtent != null) {
      fraction = itemExtent / viewportDimension;
    } else {
      // If itemExtent is null, flexWeights cannot be null.
      assert(flexWeights != null, 'carousel invariant');
      fraction = flexWeights!.first / flexWeights.sum;
    }

    return item * viewportDimension * fraction;
  }

  @override
  bool applyViewportDimension(double viewportDimension) {
    final double? oldViewportDimensions = hasViewportDimension
        ? this.viewportDimension
        : null;
    if (viewportDimension == oldViewportDimensions) {
      return true;
    }
    final bool result = super.applyViewportDimension(viewportDimension);
    final double? oldPixels = hasPixels ? pixels : null;
    double item;
    if (oldPixels == null) {
      item = updateLeadingItem(
        flexWeights,
        newConsumeMaxWeight: consumeMaxWeight,
      );
    } else if (oldViewportDimensions == 0.0) {
      // If resize from zero, we should use the _cachedItem to recover the state.
      item = _cachedItem!;
    } else {
      item = getItemFromPixels(
        oldPixels,
        oldViewportDimensions ?? viewportDimension,
      );
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
      return 0;
    }
    double fraction;
    if (itemExtent != null) {
      fraction = itemExtent! / viewportDimension;
    } else if (flexWeights != null) {
      fraction = flexWeights!.first / flexWeights!.sum;
    } else {
      return 0;
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
      infinite ? 0.0 : minScrollExtent,
      maxScrollExtent,
    );
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
      minScrollExtent:
          minScrollExtent ??
          (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent:
          maxScrollExtent ??
          (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension:
          viewportDimension ??
          (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      itemExtent: itemExtent ?? this.itemExtent,
      flexWeights: flexWeights ?? this.flexWeights,
      consumeMaxWeight: consumeMaxWeight ?? this.consumeMaxWeight,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
    );
  }
}
