import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_3_expressive/components/carousel/components/m3e_carousel_wrapper.dart';
import 'components/m3e_carousel_view.dart';
import 'enums/m3e_carousel_type.dart';
import 'styles/m3e_carousel_theme.dart';
export 'enums/m3e_carousel_type.dart';
export 'styles/m3e_carousel_theme.dart';

/// Creates a Material Design carousel.
///
/// Material Design 3 introduces 3 carousel layouts:
///  * Multi-browse: shows at least one large, medium, and small item at a time.
///  * Uncontained (default): shows items that scroll to the edge of the
///    container.
///  * Hero: shows at least one large and one small item at a time.
///
/// For more info checkout the
/// [Official Docs](https://m3.material.io/components/carousel).
///
/// .
class M3ECarousel extends StatefulWidget {
  /// Creates a Material Design carousel.
  ///
  /// .
  const M3ECarousel({
    super.key,
    this.width,
    this.height,
    this.type = M3ECarouselType.hero,
    this.isExtended = false,
    this.freeScroll = false,
    this.heroAlignment = M3ECarouselHeroAlignment.center,
    this.uncontainedItemExtent =
        M3ECarouselTheme.defaultUncontainedItemExtent,
    this.uncontainedShrinkExtent =
        M3ECarouselTheme.defaultUncontainedShrinkExtent,
    this.childElementBorderRadius = M3ECarouselTheme.defaultBorderRadiusValue,
    this.scrollAnimationDuration =
        M3ECarouselTheme.defaultScrollAnimationDuration,
    this.fixedPulseDelta = 4,
    this.singleSwipeGestureSensitivityRange =
        M3ECarouselTheme.defaultSingleSwipeGestureSensitivityRange,
    this.onTap,
    required this.children,
  });

  /// The explicit bounded width allocation applied to the root carousel container wrapper.
  ///
  /// .
  final double? width;

  /// The explicit bounded height allocation applied to the root carousel container wrapper.
  ///
  /// .
  final double? height;

  /// Specifies the structural layout rule type determining element sizes and scaling constraints.
  ///
  /// .
  final M3ECarouselType type;

  /// Flag indicating whether item bounding sizes shift into altered or expanded aspect footprints.
  ///
  /// .
  final bool isExtended;

  /// True if item canvas movements can glide smoothly without forcing standard snap boundary stops.
  ///
  /// .
  final bool freeScroll;

  /// The alignment anchor profile positioning focal items when running inside hero layouts.
  ///
  /// .
  final M3ECarouselHeroAlignment heroAlignment;

  /// The baseline horizontal dimension assigned to items inside uncontained structural layouts.
  ///
  /// .
  final double uncontainedItemExtent;

  /// The minimal compressed dimension boundary applied to items scaling down near container thresholds.
  ///
  /// .
  final double uncontainedShrinkExtent;

  /// The curvature factor mapping circular corner clipping arcs over nested item view layouts.
  ///
  /// .
  final double childElementBorderRadius;

  /// The total lifespan millisecond count allocated to complete layout transition slide curves.
  ///
  /// .
  final int scrollAnimationDuration;

  /// The dimensional drag delta requirement needed to trigger single-item sweep navigation actions.
  ///
  /// .
  final int singleSwipeGestureSensitivityRange;

  /// A precise stepping constant utilized to offset position indexes inside elastic layout computations.
  ///
  /// .
  final double fixedPulseDelta;

  /// Click event notification pipe exposing the zero-based list tracking index of the interacted element.
  ///
  /// .
  final void Function(int selectedIndex)? onTap;

  /// The continuous structured row sequence of elements rendered inside the carousel container scroll track.
  ///
  /// .
  final List<Widget> children;

  @override
  State<M3ECarousel> createState() => _M3ECarouselState();
}

class _M3ECarouselState extends State<M3ECarousel> {
  double frameWidth = 0;
  double frameHeight = 0;
  List<int> layoutWeight = [];
  int itemScrolled = 0;
  late M3ECarouselController controller;

  void scrollFrame(int direction) {
    double prevScrollPosition = controller.position.pixels,
        nextScrollPosition = 0.0;
    if (widget.type == M3ECarouselType.hero) {
      double shouldAddOrSubtract =
          (((layoutWeight.reduce(
                    widget.heroAlignment == M3ECarouselHeroAlignment.left
                        ? max
                        : min,
                  ) *
                  10) /
              100) *
          frameWidth);
      int limit = 0;
      switch (widget.heroAlignment) {
        case M3ECarouselHeroAlignment.center:
          limit = direction == 0 ? 0 : 3;
        case M3ECarouselHeroAlignment.left:
          limit = direction == 0 ? 0 : 2;
        case M3ECarouselHeroAlignment.right:
          limit = direction == 0 ? 0 : 2;
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
    controller.animateTo(
      nextScrollPosition,
      duration: Duration(milliseconds: widget.scrollAnimationDuration),
      curve: Curves.ease,
    );
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
      : GestureDetector(onHorizontalDragEnd: onHorizontalDragEnd, child: child);

  @override
  void initState() {
    controller = M3ECarouselController();
    switch (widget.type) {
      case M3ECarouselType.hero:
        switch (widget.heroAlignment) {
          case M3ECarouselHeroAlignment.left:
            layoutWeight = [8, 2];
            controller = M3ECarouselController();
          case M3ECarouselHeroAlignment.center:
            layoutWeight = [2, 6, 2];
            controller = M3ECarouselController(initialItem: 1);
          case M3ECarouselHeroAlignment.right:
            layoutWeight = [2, 8];
            controller = M3ECarouselController(initialItem: 1);
        }
      case M3ECarouselType.contained:
        layoutWeight = widget.isExtended ? [4, 3, 2, 1] : [5, 4, 1];
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
    return M3EComponentTheme(
      child: LayoutBuilder(
        builder: (ctx, dimens) {
          frameWidth = widget.width ?? dimens.maxWidth;
          frameHeight = widget.height ?? dimens.maxHeight;
          return setGestureLayer(
            SizedBox(
              width: frameWidth,
              height: frameHeight,
              child: M3ECarouselWrapper(
                key: UniqueKey(),
                controller: controller,
                freeScroll: widget.freeScroll,
                itemSnapping: widget.freeScroll,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    widget.childElementBorderRadius,
                  ),
                ),
                onTap: widget.onTap,
                flexWeights: widget.type == M3ECarouselType.uncontained
                    ? null
                    : layoutWeight,
                itemExtent: widget.type == M3ECarouselType.uncontained
                    ? widget.uncontainedItemExtent
                    : null,
                fixedPulseDelta: widget.fixedPulseDelta,
                children: widget.children,
              ),
            ),
          );
        },
      ),
    );
  }
}
