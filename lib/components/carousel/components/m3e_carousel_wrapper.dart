import 'dart:math' as math;

import 'package:flutter/material.dart';

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
  late List<GlobalKey> _itemKeys;
  final GlobalKey _carouselKey = GlobalKey();

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
    _generateKeys();
  }

  @override
  void didUpdateWidget(M3ECarouselWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.children.length != oldWidget.children.length) {
      _generateKeys();
    }
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _internalController.dispose();
      }
      _internalController = widget.controller ?? M3ECarouselController();
    }
  }

  void _generateKeys() {
    _itemKeys = List.generate(widget.children.length, (_) => GlobalKey());
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    _pulseController.dispose();
    super.dispose();
  }

  bool _isNeighborViewportVisible(int index, RenderBox carouselBox) {
    if (index < 0 || index >= widget.children.length) {
      return false;
    }

    final context = _itemKeys[index].currentContext;
    final box = context?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.width <= 1.0) {
      return false;
    }

    final double carouselLeft = carouselBox.localToGlobal(Offset.zero).dx;
    final double carouselRight = carouselLeft + carouselBox.size.width;

    final double itemLeft = box.localToGlobal(Offset.zero).dx;
    final double itemRight = itemLeft + box.size.width;

    return itemRight > (carouselLeft + 1.0) && itemLeft < (carouselRight - 1.0);
  }

  Alignment _expandAlignmentForActiveIndex(int index) {
    final leftVisible = _leftVisibleNeighborIndex != null;
    final rightVisible = _rightVisibleNeighborIndex != null;
    final noVisibleNeighbors = !leftVisible && !rightVisible;
    final lastIndex = widget.children.length - 1;

    final expandLeft = leftVisible ||
        (noVisibleNeighbors && index == lastIndex) ||
        (noVisibleNeighbors && index > 0 && index < lastIndex);
    final expandRight = rightVisible ||
        (noVisibleNeighbors && index == 0) ||
        (noVisibleNeighbors && index > 0 && index < lastIndex);

    if (expandLeft && expandRight) {
      return Alignment.center;
    }
    if (expandLeft) {
      return Alignment.centerRight;
    }
    if (expandRight) {
      return Alignment.centerLeft;
    }
    return Alignment.center;
  }

  Alignment _squishAlignmentForNeighborIndex(int index) {
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

    final parentContext = _carouselKey.currentContext;
    final parentBox = parentContext?.findRenderObject() as RenderBox?;
    final context = _itemKeys[index].currentContext;
    final renderBox = context?.findRenderObject() as RenderBox?;

    final double fallbackBasis = widget.itemExtent ?? 100.0;
    final double accurateWidth = renderBox?.size.width ?? fallbackBasis;

    setState(() {
      _activeIndex = index;
      _currentGrowBaseWidth = accurateWidth;
      _snapshotVisibleNeighbors(index, parentBox);
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
        final int squishCount = (_leftVisibleNeighborIndex != null ? 1 : 0) +
            (_rightVisibleNeighborIndex != null ? 1 : 0);

        final carouselChildren = List<Widget>.generate(widget.children.length, (
          int index,
        ) {
          final isActive = _activeIndex == index;
          final isLeftNeighbor = _leftVisibleNeighborIndex == index;
          final isRightNeighbor = _rightVisibleNeighborIndex == index;

          var scaleX = 1.0;
          EdgeInsets dynamicPadding = EdgeInsets.zero;

          Alignment individualAlignment = Alignment.center;
          if (isActive) {
            individualAlignment = _expandAlignmentForActiveIndex(index);
          } else if (isLeftNeighbor || isRightNeighbor) {
            individualAlignment = _squishAlignmentForNeighborIndex(index);
          }

          if (_activeIndex != null) {
            final double currentGrowDelta =
                widget.fixedPulseDelta * _bump.value;

            if (isActive) {
              scaleX =
                  (_currentGrowBaseWidth + currentGrowDelta) /
                  _currentGrowBaseWidth;
            } else if ((isLeftNeighbor || isRightNeighbor) &&
                squishCount > 0) {
              final double shrinkEach = currentGrowDelta / squishCount;

              final neighborContext = _itemKeys[index].currentContext;
              final neighborBox =
                  neighborContext?.findRenderObject() as RenderBox?;
              final double neighborWidth =
                  neighborBox?.size.width ?? widget.itemExtent ?? 100.0;

              final targetWidth = math.max(
                neighborWidth - shrinkEach,
                1,
              );
              scaleX = targetWidth / neighborWidth;

              if (isLeftNeighbor) {
                dynamicPadding = EdgeInsets.only(right: shrinkEach);
              } else if (isRightNeighbor) {
                dynamicPadding = EdgeInsets.only(left: shrinkEach);
              }
            }
          }

          final BorderRadius finalRadius =
              widget.shape is RoundedRectangleBorder
              ? ((widget.shape! as RoundedRectangleBorder).borderRadius
                    as BorderRadius)
              : BorderRadius.zero;

          return Container(
            key: _itemKeys[index],
            child: Transform(
              transform: Matrix4.identity()..scaleByDouble(scaleX, 1, 1, 1),
              alignment: individualAlignment,
              child: Padding(
                padding: dynamicPadding,
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

        if (widget.flexWeights != null) {
          return M3ECarouselView.weighted(
            key: _carouselKey,
            physics: widget.freeScroll
                ? null
                : const NeverScrollableScrollPhysics()
                .applyTo(const M3ECarouselScrollPhysics()),
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
            flexWeights: widget.flexWeights!,
            onIndexChanged: widget.onIndexChanged,
            children: carouselChildren,
          );
        } else {
          return M3ECarouselView(
            key: _carouselKey,
            physics: widget.freeScroll
                ? null
                : const NeverScrollableScrollPhysics()
                .applyTo(const M3ECarouselScrollPhysics()),
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
      },
    );
  }
}
