import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../foundations/foundations.dart';
import 'm3e_carousel_view.dart';

/// Wraps [M3ECarouselView] with tap handling and a neighbor pulse animation.
///
/// Item content is laid out at the largest slot size (plus pulse budget) and
/// clipped to the current item bounds. Scrolling and tap pulse only move that
/// clip "window"; the content layer stays still underneath.
class M3ECarouselWrapper extends StatefulWidget {
  /// Creates a carousel wrapper with optional pulse animation on tap.
  const M3ECarouselWrapper({
    super.key,
    this.freeScroll = false,
    this.padding,
    this.backgroundColor = Colors.transparent,
    this.elevation = 0.0,
    this.shape = const RoundedRectangleBorder(),
    this.itemClipBehavior = Clip.none,
    this.overlayColor,
    this.itemSnapping = false,
    this.consumeMaxWeight = true,
    this.shrinkExtent = 0.0,
    this.controller,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.onTap,
    this.haptic = M3EHapticFeedback.none,
    this.enableSplash = true,
    this.infinite = false,
    this.itemExtent,
    this.flexWeights,
    required this.children,
    this.onIndexChanged,

    /// Fixed logical pixels added or removed per animating edge at peak pulse.
    ///
    /// A value of `4` expands or squishes each active edge by up to 4px.
    /// When both sides animate, each edge uses the full delta independently.
    this.fixedPulseDelta = 4,
  }) : assert(
         (flexWeights != null && itemExtent == null) ||
             (flexWeights == null && itemExtent != null),
         'Provide either itemExtent for standard layouts OR flexWeights for weighted layouts.',
       );

  /// Whether free scrolling is enabled (passed through to scroll physics).
  final bool freeScroll;

  /// Padding around each carousel item.
  final EdgeInsets? padding;

  /// Background color for each item's [Material].
  final Color? backgroundColor;

  /// Elevation for each item's [Material].
  final double? elevation;

  /// Shape for each item's [Material] and pulse clip radius.
  final ShapeBorder? shape;

  /// Clip behavior for pulsed item content.
  final Clip itemClipBehavior;

  /// Ink overlay colors when splash is enabled on the wrapper layer.
  final WidgetStateProperty<Color?>? overlayColor;

  /// Whether the underlying view snaps to items.
  final bool itemSnapping;

  /// Whether collapsed weighted items may expand to the max weight size.
  final bool consumeMaxWeight;

  /// Minimum item extent during scroll transitions.
  final double shrinkExtent;

  /// Optional controller for the underlying [M3ECarouselView].
  final M3ECarouselController? controller;

  /// Scroll axis for the carousel.
  final Axis scrollDirection;

  /// Whether the list scrolls in the reverse reading direction.
  final bool reverse;

  /// Called when an item is tapped.
  final void Function(int)? onTap;

  /// Haptic intensity on item tap. Defaults to [M3EHapticFeedback.none].
  final M3EHapticFeedback haptic;

  /// Whether the wrapper ink layer reports splash feedback.
  final bool enableSplash;

  /// Whether the carousel loops infinitely.
  final bool infinite;

  /// Fixed main-axis extent for unweighted layouts.
  final double? itemExtent;

  /// Flex weights for weighted layouts.
  final List<int>? flexWeights;

  /// The child widgets for the carousel.
  final List<Widget> children;

  /// Called when the leading item index changes.
  final void Function(int)? onIndexChanged;

  /// Fixed logical pixels added or removed per animating edge at peak pulse.
  final double fixedPulseDelta;

  @override
  State<M3ECarouselWrapper> createState() => _M3ECarouselWrapperState();
}

class _M3ECarouselWrapperState extends State<M3ECarouselWrapper>
    with SingleTickerProviderStateMixin {
  int? _activeIndex;
  int? _leftVisibleNeighborIndex;
  int? _rightVisibleNeighborIndex;
  late M3ECarouselController _internalController;

  /// Per-index item boxes for pulse measuring.
  final Map<int, RenderBox> _itemBoxes = <int, RenderBox>{};

  /// Viewport box for neighbor visibility checks (no [GlobalKey] — those can
  /// reparent under [Theme] rebuilds and corrupt the weighted sliver).
  RenderBox? _viewportBox;

  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
    reverseDuration: const Duration(milliseconds: 220),
  );

  late final Animation<double> _bump = CurvedAnimation(
    parent: _pulseController,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  @override
  void initState() {
    super.initState();
    _internalController = widget.controller ?? M3ECarouselController();
  }

  @override
  void didUpdateWidget(M3ECarouselWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length) {
      _itemBoxes.removeWhere((int index, _) => index >= widget.children.length);
    }
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _internalController.dispose();
      }
      _internalController = widget.controller ?? M3ECarouselController();
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    _pulseController.dispose();
    super.dispose();
  }

  void _registerItemBox(int index, RenderBox box) {
    _itemBoxes[index] = box;
  }

  void _unregisterItemBox(int index, RenderBox box) {
    if (_itemBoxes[index] == box) {
      _itemBoxes.remove(index);
    }
  }

  void _unregisterViewportBox(RenderBox box) {
    if (_viewportBox == box) {
      _viewportBox = null;
    }
  }

  double _fallbackExtent() => widget.itemExtent ?? 100.0;

  bool get _vertical => widget.scrollDirection == Axis.vertical;

  EdgeInsets get _resolvedPadding {
    final EdgeInsetsGeometry padding =
        widget.padding ?? const EdgeInsets.all(4);
    return padding.resolve(Directionality.of(context));
  }

  double _mainAxisPadding(EdgeInsets padding) =>
      _vertical ? padding.vertical : padding.horizontal;

  /// Inner main-axis extent for the largest resting item slot.
  ///
  /// Content is laid out against this (plus pulse budget) so scroll size
  /// changes only move the clip window, and expanded pulse edges stay filled.
  double _stableInnerContentExtent(double viewportMain) {
    final double paddingMain = _mainAxisPadding(_resolvedPadding);
    if (widget.itemExtent != null) {
      return math.max(widget.itemExtent! - paddingMain, 0);
    }
    final List<int>? weights = widget.flexWeights;
    if (weights != null && weights.isNotEmpty && viewportMain > 0) {
      final int total = weights.fold<int>(0, (int a, int b) => a + b);
      if (total > 0) {
        final int maxWeight = weights.reduce(math.max);
        return math.max(viewportMain * maxWeight / total - paddingMain, 0);
      }
    }
    return _fallbackExtent();
  }

  (bool expandLeading, bool expandTrailing) _expandSidesForActiveIndex(
    int index,
  ) {
    final leadingVisible = _leftVisibleNeighborIndex != null;
    final trailingVisible = _rightVisibleNeighborIndex != null;
    final noVisibleNeighbors = !leadingVisible && !trailingVisible;
    final lastIndex = widget.children.length - 1;

    final expandLeading =
        leadingVisible ||
        (noVisibleNeighbors && index == lastIndex) ||
        (noVisibleNeighbors && index > 0 && index < lastIndex);
    final expandTrailing =
        trailingVisible ||
        (noVisibleNeighbors && index == 0) ||
        (noVisibleNeighbors && index > 0 && index < lastIndex);
    return (expandLeading, expandTrailing);
  }

  bool _isNeighborViewportVisible(int index, RenderBox carouselBox) {
    if (index < 0 || index >= widget.children.length) {
      return false;
    }

    final box = _itemBoxes[index];
    if (box == null || !box.hasSize || !box.attached) {
      return false;
    }

    final Offset carouselOrigin = carouselBox.localToGlobal(Offset.zero);
    final Offset itemOrigin = box.localToGlobal(Offset.zero);

    if (_vertical) {
      if (box.size.height <= 1.0) {
        return false;
      }
      final double carouselTop = carouselOrigin.dy;
      final double carouselBottom = carouselTop + carouselBox.size.height;
      final double itemTop = itemOrigin.dy;
      final double itemBottom = itemTop + box.size.height;
      return itemBottom > (carouselTop + 1.0) &&
          itemTop < (carouselBottom - 1.0);
    }

    if (box.size.width <= 1.0) {
      return false;
    }
    final double carouselLeft = carouselOrigin.dx;
    final double carouselRight = carouselLeft + carouselBox.size.width;
    final double itemLeft = itemOrigin.dx;
    final double itemRight = itemLeft + box.size.width;
    return itemRight > (carouselLeft + 1.0) && itemLeft < (carouselRight - 1.0);
  }

  /// Clip-window rect in resting-item coordinates for the current pulse.
  ({double left, double top, double width, double height}) _pulseFrameRect({
    required int index,
    required bool isActive,
    required bool isLeftNeighbor,
    required bool isRightNeighbor,
    required double edgeDelta,
    required double restWidth,
    required double restHeight,
  }) {
    if (_activeIndex == null || edgeDelta <= 0) {
      return (left: 0, top: 0, width: restWidth, height: restHeight);
    }

    if (isActive) {
      final (expandLeading, expandTrailing) = _expandSidesForActiveIndex(index);
      final double leading = expandLeading ? edgeDelta : 0;
      final double trailing = expandTrailing ? edgeDelta : 0;
      if (_vertical) {
        return (
          left: 0,
          top: -leading,
          width: restWidth,
          height: restHeight + leading + trailing,
        );
      }
      return (
        left: -leading,
        top: 0,
        width: restWidth + leading + trailing,
        height: restHeight,
      );
    }

    if (isLeftNeighbor) {
      // Squish the trailing edge shared with the active item.
      if (_vertical) {
        return (
          left: 0,
          top: 0,
          width: restWidth,
          height: math.max(restHeight - edgeDelta, 1),
        );
      }
      return (
        left: 0,
        top: 0,
        width: math.max(restWidth - edgeDelta, 1),
        height: restHeight,
      );
    }

    if (isRightNeighbor) {
      // Squish the leading edge shared with the active item.
      if (_vertical) {
        return (
          left: 0,
          top: edgeDelta,
          width: restWidth,
          height: math.max(restHeight - edgeDelta, 1),
        );
      }
      return (
        left: edgeDelta,
        top: 0,
        width: math.max(restWidth - edgeDelta, 1),
        height: restHeight,
      );
    }

    return (left: 0, top: 0, width: restWidth, height: restHeight);
  }

  void _snapshotVisibleNeighbors(int index, RenderBox? parentBox) {
    if (parentBox != null) {
      _leftVisibleNeighborIndex =
          _isNeighborViewportVisible(index - 1, parentBox) ? index - 1 : null;
      _rightVisibleNeighborIndex =
          _isNeighborViewportVisible(index + 1, parentBox) ? index + 1 : null;
      return;
    }

    _leftVisibleNeighborIndex = index > 0 ? index - 1 : null;
    _rightVisibleNeighborIndex = index < widget.children.length - 1
        ? index + 1
        : null;
  }

  Future<void> _handleTap(int index) async {
    if (widget.onTap != null) {
      M3EHaptics.trigger(widget.haptic);
    }
    widget.onTap?.call(index);
    if (_pulseController.isAnimating) {
      return;
    }

    setState(() {
      _activeIndex = index;
      _snapshotVisibleNeighbors(index, _viewportBox);
    });

    await _pulseController.forward();
    await _pulseController.reverse();

    if (mounted) {
      setState(() {
        _activeIndex = null;
        _leftVisibleNeighborIndex = null;
        _rightVisibleNeighborIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints viewportConstraints) {
        final double viewportMain = _vertical
            ? viewportConstraints.maxHeight
            : viewportConstraints.maxWidth;
        return AnimatedBuilder(
          animation: _bump,
          builder: (context, _) {
            final double edgeDelta = widget.fixedPulseDelta * _bump.value;
            final carouselChildren = List<Widget>.generate(
              widget.children.length,
              (int index) => _buildPulsedChild(
                index: index,
                edgeDelta: edgeDelta,
                viewportMain: viewportMain,
              ),
            );
            return _CarouselViewportAnchor(
              onRegister: (RenderBox box) => _viewportBox = box,
              onUnregister: _unregisterViewportBox,
              child: _buildCarouselView(carouselChildren),
            );
          },
        );
      },
    );
  }

  Widget _buildPulsedChild({
    required int index,
    required double edgeDelta,
    required double viewportMain,
  }) {
    final isActive = _activeIndex == index;
    final isLeftNeighbor = _leftVisibleNeighborIndex == index;
    final isRightNeighbor = _rightVisibleNeighborIndex == index;
    final BorderRadius finalRadius = widget.shape is RoundedRectangleBorder
        ? ((widget.shape! as RoundedRectangleBorder).borderRadius
              as BorderRadius)
        : BorderRadius.zero;
    final Clip clipBehavior = widget.itemClipBehavior != Clip.none
        ? widget.itemClipBehavior
        : Clip.antiAlias;
    final double stableInner = _stableInnerContentExtent(viewportMain);
    final double pulseBudget = widget.fixedPulseDelta * 2;

    return _CarouselItemAnchor(
      index: index,
      onRegister: _registerItemBox,
      onUnregister: _unregisterItemBox,
      child: RepaintBoundary(
        // Content is laid out once at (max slot + pulse overflow) and stays
        // pinned in resting coordinates. Only the clip rect animates.
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double restWidth = constraints.maxWidth;
            final double restHeight = constraints.maxHeight;
            final frame = _pulseFrameRect(
              index: index,
              isActive: isActive,
              isLeftNeighbor: isLeftNeighbor,
              isRightNeighbor: isRightNeighbor,
              edgeDelta: edgeDelta,
              restWidth: restWidth,
              restHeight: restHeight,
            );

            // Enough overflow at rest that a full pulse expand never reveals
            // content edges. Size is independent of the pulse animation so
            // nothing snaps when a tap starts.
            final double contentWidth = _vertical
                ? restWidth
                : math.max(stableInner, restWidth) + pulseBudget;
            final double contentHeight = _vertical
                ? math.max(stableInner, restHeight) + pulseBudget
                : restHeight;
            final double contentLeft = (restWidth - contentWidth) / 2;
            final double contentTop = (restHeight - contentHeight) / 2;

            return SizedBox(
              width: restWidth,
              height: restHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Positioned(
                    left: frame.left,
                    top: frame.top,
                    width: frame.width,
                    height: frame.height,
                    child: ClipRRect(
                      borderRadius: finalRadius,
                      clipBehavior: clipBehavior,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: contentLeft - frame.left,
                            top: contentTop - frame.top,
                            width: contentWidth,
                            height: contentHeight,
                            child: IgnorePointer(child: widget.children[index]),
                          ),
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                enableFeedback: false,
                                onTap: () => _handleTap(index),
                                overlayColor: widget.overlayColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCarouselView(List<Widget> carouselChildren) {
    final ScrollPhysics? physics = widget.freeScroll
        ? null
        : const NeverScrollableScrollPhysics().applyTo(
            const M3ECarouselScrollPhysics(),
          );
    if (widget.flexWeights != null) {
      return M3ECarouselView.weighted(
        physics: physics,
        padding: widget.padding,
        backgroundColor: widget.backgroundColor,
        elevation: widget.elevation,
        shape: widget.shape,
        itemClipBehavior: Clip.none,
        overlayColor: widget.overlayColor,
        itemSnapping: widget.itemSnapping,
        consumeMaxWeight: widget.consumeMaxWeight,
        shrinkExtent: widget.shrinkExtent,
        controller: _internalController,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        enableSplash: false,
        infinite: widget.infinite,
        flexWeights: widget.flexWeights!,
        onIndexChanged: widget.onIndexChanged,
        children: carouselChildren,
      );
    }
    return M3ECarouselView(
      physics: physics,
      padding: widget.padding,
      backgroundColor: widget.backgroundColor,
      elevation: widget.elevation,
      shape: widget.shape,
      itemClipBehavior: Clip.none,
      overlayColor: widget.overlayColor,
      itemSnapping: widget.itemSnapping,
      shrinkExtent: widget.shrinkExtent,
      controller: _internalController,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      enableSplash: false,
      infinite: widget.infinite,
      itemExtent: widget.itemExtent!,
      onIndexChanged: widget.onIndexChanged,
      children: carouselChildren,
    );
  }
}

/// Registers the carousel viewport [RenderBox] without a [GlobalKey].
class _CarouselViewportAnchor extends SingleChildRenderObjectWidget {
  const _CarouselViewportAnchor({
    required this.onRegister,
    required this.onUnregister,
    required Widget child,
  }) : super(child: child);

  final void Function(RenderBox box) onRegister;
  final void Function(RenderBox box) onUnregister;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCarouselViewportAnchor(
      onRegister: onRegister,
      onUnregister: onUnregister,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderCarouselViewportAnchor renderObject,
  ) {
    renderObject
      ..onRegister = onRegister
      ..onUnregister = onUnregister;
  }
}

class _RenderCarouselViewportAnchor extends RenderProxyBox {
  _RenderCarouselViewportAnchor({
    required this.onRegister,
    required this.onUnregister,
  });

  void Function(RenderBox box) onRegister;
  void Function(RenderBox box) onUnregister;

  void _registerIfReady() {
    if (hasSize && attached) {
      onRegister(this);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _registerIfReady();
  }

  @override
  void detach() {
    onUnregister(this);
    super.detach();
  }

  @override
  void performLayout() {
    super.performLayout();
    _registerIfReady();
  }
}

/// Registers its [RenderBox] for pulse measuring without a [GlobalKey].
class _CarouselItemAnchor extends SingleChildRenderObjectWidget {
  const _CarouselItemAnchor({
    required this.index,
    required this.onRegister,
    required this.onUnregister,
    required Widget child,
  }) : super(child: child);

  final int index;
  final void Function(int index, RenderBox box) onRegister;
  final void Function(int index, RenderBox box) onUnregister;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCarouselItemAnchor(
      index: index,
      onRegister: onRegister,
      onUnregister: onUnregister,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderCarouselItemAnchor renderObject,
  ) {
    renderObject
      ..index = index
      ..onRegister = onRegister
      ..onUnregister = onUnregister;
  }
}

class _RenderCarouselItemAnchor extends RenderProxyBox {
  _RenderCarouselItemAnchor({
    required this._index,
    required this.onRegister,
    required this.onUnregister,
  });

  int _index;
  void Function(int index, RenderBox box) onRegister;
  void Function(int index, RenderBox box) onUnregister;

  int get index => _index;

  set index(int value) {
    if (_index == value) {
      return;
    }
    onUnregister(_index, this);
    _index = value;
    _registerIfReady();
  }

  void _registerIfReady() {
    if (hasSize && attached) {
      onRegister(_index, this);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _registerIfReady();
  }

  @override
  void detach() {
    onUnregister(_index, this);
    super.detach();
  }

  @override
  void performLayout() {
    super.performLayout();
    _registerIfReady();
  }
}
