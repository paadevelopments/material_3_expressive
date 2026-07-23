import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'm3e_carousel_view.dart';

class M3ECarouselWrapper extends StatefulWidget {
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

  final bool freeScroll;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip itemClipBehavior;
  final WidgetStateProperty<Color?>? overlayColor;
  final bool itemSnapping;
  final bool consumeMaxWeight;
  final double shrinkExtent;
  final M3ECarouselController? controller;
  final Axis scrollDirection;
  final bool reverse;
  final void Function(int)? onTap;
  final bool enableSplash;
  final bool infinite;
  final double? itemExtent;
  final List<int>? flexWeights;
  final List<Widget> children;
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

  double _currentGrowBaseWidth = 0;

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
      _itemBoxes.removeWhere(
        (int index, _) => index >= widget.children.length,
      );
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

  void _registerViewportBox(RenderBox box) {
    _viewportBox = box;
  }

  void _unregisterViewportBox(RenderBox box) {
    if (_viewportBox == box) {
      _viewportBox = null;
    }
  }

  double _fallbackExtent() => widget.itemExtent ?? 100.0;

  bool get _vertical => widget.scrollDirection == Axis.vertical;

  double _contentExtentFor(int index) {
    final box = _itemBoxes[index];
    if (box == null || !box.hasSize) {
      return _fallbackExtent();
    }
    final double extent = _vertical ? box.size.height : box.size.width;
    if (extent <= 0) {
      return _fallbackExtent();
    }
    return extent;
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

  Alignment _expandAlignmentForActiveIndex(int index) {
    final (expandLeading, expandTrailing) = _expandSidesForActiveIndex(index);

    if (expandLeading && expandTrailing) {
      return Alignment.center;
    }
    if (_vertical) {
      if (expandLeading) {
        return Alignment.bottomCenter;
      }
      if (expandTrailing) {
        return Alignment.topCenter;
      }
      return Alignment.center;
    }
    if (expandLeading) {
      return Alignment.centerRight;
    }
    if (expandTrailing) {
      return Alignment.centerLeft;
    }
    return Alignment.center;
  }

  Alignment _squishAlignmentForNeighborIndex(int index) {
    if (_vertical) {
      if (index == _leftVisibleNeighborIndex) {
        return Alignment.topCenter;
      }
      if (index == _rightVisibleNeighborIndex) {
        return Alignment.bottomCenter;
      }
      return Alignment.center;
    }
    if (index == _leftVisibleNeighborIndex) {
      return Alignment.centerLeft;
    }
    if (index == _rightVisibleNeighborIndex) {
      return Alignment.centerRight;
    }
    return Alignment.center;
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
    _rightVisibleNeighborIndex =
        index < widget.children.length - 1 ? index + 1 : null;
  }

  Future<void> _handleTap(int index) async {
    widget.onTap?.call(index);
    if (_pulseController.isAnimating) {
      return;
    }

    setState(() {
      _activeIndex = index;
      _currentGrowBaseWidth = _contentExtentFor(index);
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
    return AnimatedBuilder(
      animation: _bump,
      builder: (context, _) {
        final int squishCount =
            (_leftVisibleNeighborIndex != null ? 1 : 0) +
            (_rightVisibleNeighborIndex != null ? 1 : 0);
        final double edgeDelta = widget.fixedPulseDelta * _bump.value;

        final carouselChildren = List<Widget>.generate(widget.children.length, (
          int index,
        ) {
          final isActive = _activeIndex == index;
          final isLeftNeighbor = _leftVisibleNeighborIndex == index;
          final isRightNeighbor = _rightVisibleNeighborIndex == index;

          var scaleMain = 1.0;

          Alignment individualAlignment = Alignment.center;
          if (isActive) {
            individualAlignment = _expandAlignmentForActiveIndex(index);
          } else if (isLeftNeighbor || isRightNeighbor) {
            individualAlignment = _squishAlignmentForNeighborIndex(index);
          }

          if (_activeIndex != null) {
            if (isActive) {
              final double extent = _currentGrowBaseWidth > 0
                  ? _currentGrowBaseWidth
                  : _fallbackExtent();
              final (expandLeading, expandTrailing) =
                  _expandSidesForActiveIndex(index);
              final growTotal = (expandLeading ? edgeDelta : 0) +
                  (expandTrailing ? edgeDelta : 0);
              scaleMain = (extent + growTotal) / extent;
            } else if ((isLeftNeighbor || isRightNeighbor) && squishCount > 0) {
              final double neighborExtent = _contentExtentFor(index);
              final shrinkPixels = edgeDelta;
              final double targetExtent = math.max(
                neighborExtent - shrinkPixels,
                1,
              );
              scaleMain = targetExtent / neighborExtent;
            }
          }

          final BorderRadius finalRadius =
              widget.shape is RoundedRectangleBorder
              ? ((widget.shape! as RoundedRectangleBorder).borderRadius
                    as BorderRadius)
              : BorderRadius.zero;

          return _CarouselItemAnchor(
            index: index,
            onRegister: _registerItemBox,
            onUnregister: _unregisterItemBox,
            child: RepaintBoundary(
              child: Transform(
                transform: _vertical
                    ? (Matrix4.identity()..scaleByDouble(1, scaleMain, 1, 1))
                    : (Matrix4.identity()..scaleByDouble(scaleMain, 1, 1, 1)),
                alignment: individualAlignment,
                child: ClipRRect(
                  borderRadius: finalRadius,
                  clipBehavior: widget.itemClipBehavior != Clip.none
                      ? widget.itemClipBehavior
                      : Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      IgnorePointer(child: widget.children[index]),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          enableFeedback: widget.enableSplash,
                          onTap: () => _handleTap(index),
                          overlayColor: widget.overlayColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });

        final Widget view = widget.flexWeights != null
            ? M3ECarouselView.weighted(
                physics: widget.freeScroll
                    ? null
                    : const NeverScrollableScrollPhysics().applyTo(
                        const M3ECarouselScrollPhysics(),
                      ),
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
              )
            : M3ECarouselView(
                physics: widget.freeScroll
                    ? null
                    : const NeverScrollableScrollPhysics().applyTo(
                        const M3ECarouselScrollPhysics(),
                      ),
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

        return _CarouselViewportAnchor(
          onRegister: _registerViewportBox,
          onUnregister: _unregisterViewportBox,
          child: view,
        );
      },
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
