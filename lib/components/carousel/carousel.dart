// Vendored verbatim from `package:m3_carousel/m3_carousel.dart`. The logic is
// kept identical to the reference `M3Carousel`; only the public names are
// prefixed with `M3E` and the underlying view/controller/physics come from the
// vendored `m3e_carousel_view.dart`.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, number_of_parameters

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'components/m3e_carousel_view.dart';
import 'enums/m3e_carousel_type.dart';

export 'enums/m3e_carousel_type.dart';

/// Creates a Material Design carousel.
///
/// Material Design 3 introduces 4 carousel layouts:
///  * Multi-browse: shows at least one large, medium, and small item at a time.
///  * Uncontained (default): shows items that scroll to the edge of the
///    container.
///  * Hero: shows at least one large and one small item at a time.
///  * Full-screen: shows one edge-to-edge large item at a time and scrolls
///    vertically.
///
/// For more info checkout the
/// [Official Docs](https://m3.material.io/components/carousel).
class M3ECarousel extends StatefulWidget {
  /// Creates a Material Design carousel.
  const M3ECarousel({
    super.key,
    this.width,
    this.height,
    this.type = M3ECarouselType.hero,
    this.isExtended = false,
    this.freeScroll = false,
    this.heroAlignment = M3ECarouselHeroAlignment.center,
    this.uncontainedItemExtent = 270.0,
    this.uncontainedShrinkExtent = 150.0,
    this.childElementBorderRadius = 28.0,
    this.scrollAnimationDuration = 500,
    this.singleSwipeGestureSensitivityRange = 300,
    this.onTap,
    required this.children,
  });

  /// Width of the carousel view.
  ///
  /// Defaults to using a calculated maxWidth value provided by an internally
  /// wrapped [LayoutBuilder].
  final double? width;

  /// Height of the carousel view.
  ///
  /// Defaults to using a calculated maxHeight value provided by an internally
  /// wrapped [LayoutBuilder].
  final double? height;

  /// The type of carousel.
  ///
  /// Defaults to [M3ECarouselType.hero].
  final M3ECarouselType type;

  /// Determines whether or not to display an extended carousel.
  ///
  /// This applies to "contained" type carousels ONLY. If value is set to true,
  /// the visible items of the carousel will be extended to 4.
  ///
  /// Defaults to false.
  final bool isExtended;

  /// Determines whether to enable/disable manual scrolling of carousel items.
  ///
  /// If set to false, scrolling will be actionable via a horizontal single-swipe
  /// gesture and item snapping will be automatic. If true, scrolling and item
  /// snapping will be manual.
  ///
  /// Defaults to false.
  final bool freeScroll;

  /// Sets alignment for "hero" type carousel.
  ///
  /// This applies to "hero" type carousel ONLY.
  ///
  /// Defaults to [M3ECarouselHeroAlignment.center] alignment.
  final M3ECarouselHeroAlignment heroAlignment;

  /// The extent the children are forced to have in the main axis.
  ///
  /// This applies to "uncontained" carousel ONLY.
  ///
  /// Defaults to 270.0.
  final double uncontainedItemExtent;

  /// The minimum allowable extent (size) in the main axis for carousel items
  /// during scrolling transitions.
  ///
  /// This applies to "uncontained" carousel ONLY.
  ///
  /// Defaults to 150.0.
  final double uncontainedShrinkExtent;

  /// Border radius value for carousel items.
  ///
  /// Defaults to 28.0.
  final double childElementBorderRadius;

  /// Animation duration for automatic scroll.
  ///
  /// This works if [freeScroll] value is set to false (enables automatic
  /// scroll).
  ///
  /// Defaults to 500. Value unit is in milliseconds.
  final int scrollAnimationDuration;

  /// Swipe scroll sensitivity for single-swipe gesture (automatic) scrolling.
  ///
  /// A higher value will imply a longer horizontal swipe to trigger scroll
  /// action on carousel. Hence, reducing swipe sensitivity. This works if
  /// [freeScroll] value is set to false (enables automatic scroll). And on all
  /// platforms except Web.
  ///
  /// Defaults to 300.
  final int singleSwipeGestureSensitivityRange;

  /// Sets listener for clicks/taps on carousel items.
  ///
  /// Clicked / Tapped item's index is return as selectedIndex value.
  ///
  /// If null, no click/tap event is registered.
  final void Function(int selectedIndex)? onTap;

  /// The child widgets for the carousel.
  final List<Widget> children;

  @override
  State<M3ECarousel> createState() => _M3ECarouselState();
}

class _M3ECarouselState extends State<M3ECarousel> {
  double frameWidth = 0.0;
  double frameHeight = 0.0;
  List<int> layoutWeight = [];
  int itemScrolled = 0;
  late M3ECarouselController controller;

  void scrollFrame(int direction) {
    double prevScrollPosition = controller.position.pixels,
        nextScrollPosition = 0.0;
    if (widget.type == M3ECarouselType.hero) {
      double shouldAddOrSubtract = (((layoutWeight.reduce(
                      widget.heroAlignment == M3ECarouselHeroAlignment.left
                          ? max
                          : min) *
                  10) /
              100) *
          frameWidth);
      int limit = 0;
      switch (widget.heroAlignment) {
        case M3ECarouselHeroAlignment.center:
          limit = direction == 0 ? 0 : 3;
          break;
        case M3ECarouselHeroAlignment.left:
          limit = direction == 0 ? 0 : 2;
          break;
        case M3ECarouselHeroAlignment.right:
          limit = direction == 0 ? 0 : 2;
          break;
      }
      if (direction == 0) {
        if (itemScrolled <= limit) return;
        nextScrollPosition = prevScrollPosition - shouldAddOrSubtract;
        itemScrolled -= 1;
      } else {
        if (itemScrolled >= (widget.children.length - limit)) return;
        nextScrollPosition = prevScrollPosition + shouldAddOrSubtract;
        itemScrolled += 1;
      }
    } else if (widget.type == M3ECarouselType.contained) {
      double shouldAddOrSubtract =
          (((layoutWeight.reduce(max) * 10) / 100) * frameWidth);
      if (direction == 0) {
        if (itemScrolled <= 0) return;
        nextScrollPosition = prevScrollPosition - shouldAddOrSubtract;
        itemScrolled -= 1;
      } else {
        if (itemScrolled >=
            (widget.children.length - (widget.isExtended ? 4 : 3))) {
          return;
        }
        nextScrollPosition = prevScrollPosition + shouldAddOrSubtract;
        itemScrolled += 1;
      }
    } else {
      if (direction == 0) {
        if (itemScrolled <= 0) return;
        nextScrollPosition = prevScrollPosition - widget.uncontainedItemExtent;
        itemScrolled -= 1;
      } else {
        if (itemScrolled >= (widget.children.length - 1)) return;
        nextScrollPosition = prevScrollPosition + widget.uncontainedItemExtent;
        itemScrolled += 1;
      }
    }
    controller.animateTo(nextScrollPosition,
        duration: Duration(milliseconds: widget.scrollAnimationDuration),
        curve: Curves.ease);
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    if (details.primaryVelocity! >
        (kIsWeb ? 0 : widget.singleSwipeGestureSensitivityRange)) {
      scrollFrame(0);
    } else if (details.primaryVelocity! <
        -(kIsWeb ? 0 : widget.singleSwipeGestureSensitivityRange)) {
      scrollFrame(1);
    }
  }

  Widget setGestureLayer(Widget child) => widget.freeScroll
      ? child
      : GestureDetector(
          onHorizontalDragEnd: onHorizontalDragEnd,
          child: child,
        );

  @override
  void initState() {
    controller = M3ECarouselController();
    switch (widget.type) {
      case M3ECarouselType.hero:
        switch (widget.heroAlignment) {
          case M3ECarouselHeroAlignment.left:
            layoutWeight = [8, 2];
            controller = M3ECarouselController(initialItem: 0);
            break;
          case M3ECarouselHeroAlignment.center:
            layoutWeight = [2, 6, 2];
            controller = M3ECarouselController(initialItem: 1);
            break;
          case M3ECarouselHeroAlignment.right:
            layoutWeight = [2, 8];
            controller = M3ECarouselController(initialItem: 1);
            break;
        }
        break;
      case M3ECarouselType.contained:
        layoutWeight = widget.isExtended ? [4, 3, 2, 1] : [5, 4, 1];
        break;
      case M3ECarouselType.uncontained:
        // No layout weights needed for uncontained type
        break;
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, dimens) {
      frameWidth = widget.width ?? dimens.maxWidth;
      frameHeight = widget.height ?? dimens.maxHeight;
      return setGestureLayer(SizedBox(
        width: frameWidth,
        height: frameHeight,
        child: widget.type == M3ECarouselType.uncontained
            ? M3ECarouselView(
                key: UniqueKey(),
                controller: controller,
                physics: widget.freeScroll
                    ? null
                    : const NeverScrollableScrollPhysics()
                        .applyTo(const M3ECarouselScrollPhysics()),
                itemExtent: widget.uncontainedItemExtent,
                shrinkExtent: widget.uncontainedShrinkExtent,
                itemSnapping: widget.freeScroll,
                children: widget.children
                    .asMap()
                    .entries
                    .map((listItem) => ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(widget.childElementBorderRadius)),
                          child: Stack(
                            children: [
                              listItem.value,
                              widget.onTap == null
                                  ? const SizedBox(
                                      width: 0,
                                      height: 0,
                                    )
                                  : Material(
                                      color: Colors.transparent,
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              widget.childElementBorderRadius)),
                                      child: InkWell(
                                        splashFactory: InkSparkle.splashFactory,
                                        onTap: () =>
                                            widget.onTap!(listItem.key),
                                      ),
                                    ),
                            ],
                          ),
                        ))
                    .toList(),
              )
            : M3ECarouselView.weighted(
                key: UniqueKey(),
                controller: controller,
                flexWeights: layoutWeight,
                physics: widget.freeScroll
                    ? null
                    : const NeverScrollableScrollPhysics()
                        .applyTo(const M3ECarouselScrollPhysics()),
                itemSnapping: widget.freeScroll,
                children: widget.children
                    .asMap()
                    .entries
                    .map((listItem) => ClipRRect(
                          borderRadius: BorderRadius.all(
                              Radius.circular(widget.childElementBorderRadius)),
                          child: Stack(
                            children: [
                              listItem.value,
                              widget.onTap == null
                                  ? const SizedBox(
                                      width: 0,
                                      height: 0,
                                    )
                                  : Material(
                                      color: Colors.transparent,
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              widget.childElementBorderRadius)),
                                      child: InkWell(
                                        onTap: () =>
                                            widget.onTap!(listItem.key),
                                      ),
                                    ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
      ));
    });
  }
}
