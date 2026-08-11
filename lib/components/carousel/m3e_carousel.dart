import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/carousel/components/m3e_carousel_wrapper.dart';
import 'package:material_3_expressive/foundations/foundations.dart';

import 'components/m3e_carousel_view.dart';
import 'enums/m3e_carousel_type.dart';
import 'models/m3e_carousel_change_details.dart';
import 'styles/m3e_carousel_theme.dart';
import 'utils/m3e_carousel_scroll_helper.dart';

export 'enums/m3e_carousel_type.dart';
export 'models/m3e_carousel_change_details.dart';
export 'styles/m3e_carousel_theme.dart';

/// Creates a Material Design carousel.
///
/// Material Design 3 introduces 3 carousel layouts:
///  * Multi-browse: shows at least one large, medium, and small item at a time.
///  * Uncontained (default): shows items that scroll to the edge of the
///    container.
///  * Hero: shows at least one large and one small item at a time.
///
/// Scrolls along [axis] (horizontal by default, or vertical).
///
/// For more info checkout the
/// [Official Docs](https://m3.material.io/components/carousel).
class M3ECarousel extends StatefulWidget {
  /// Creates a Material Design carousel.
  const M3ECarousel({
    super.key,
    this.width,
    this.height,
    this.axis = Axis.horizontal,
    this.type = M3ECarouselType.hero,
    this.isExtended = false,
    this.freeScroll = false,
    this.heroAlignment = M3ECarouselHeroAlignment.center,
    this.uncontainedItemExtent = M3ECarouselTheme.defaultUncontainedItemExtent,
    this.uncontainedShrinkExtent =
        M3ECarouselTheme.defaultUncontainedShrinkExtent,
    this.childElementBorderRadius = M3ECarouselTheme.defaultBorderRadiusValue,
    this.scrollAnimationDuration =
        M3ECarouselTheme.defaultScrollAnimationDuration,
    this.fixedPulseDelta = 4,
    this.singleSwipeGestureSensitivityRange =
        M3ECarouselTheme.defaultSingleSwipeGestureSensitivityRange,
    this.onTap,
    this.onChange,
    this.haptic = M3EHapticFeedback.none,
    required this.children,
  });

  /// The explicit bounded width allocation applied to the root carousel container wrapper.
  final double? width;

  /// The explicit bounded height allocation applied to the root carousel container wrapper.
  final double? height;

  /// Scroll and layout axis. Defaults to [Axis.horizontal].
  final Axis axis;

  /// Specifies the structural layout rule type determining element sizes and scaling constraints.
  final M3ECarouselType type;

  /// Flag indicating whether item bounding sizes shift into altered or expanded aspect footprints.
  final bool isExtended;

  /// True if item canvas movements can glide smoothly without forcing standard snap boundary stops.
  final bool freeScroll;

  /// Focal-item alignment for [M3ECarouselType.hero].
  ///
  /// Horizontal: left / center / right.
  /// Vertical: [M3ECarouselHeroAlignment.left] is top (start),
  /// [M3ECarouselHeroAlignment.right] is bottom (end).
  final M3ECarouselHeroAlignment heroAlignment;

  /// Baseline main-axis extent for items in uncontained layouts
  /// (width when horizontal, height when vertical).
  final double uncontainedItemExtent;

  /// The minimal compressed dimension boundary applied to items scaling down near container thresholds.
  final double uncontainedShrinkExtent;

  /// The curvature factor mapping circular corner clipping arcs over nested item view layouts.
  final double childElementBorderRadius;

  /// The total lifespan millisecond count allocated to complete layout transition slide curves.
  final int scrollAnimationDuration;

  /// The dimensional drag delta requirement needed to trigger single-item sweep navigation actions.
  final int singleSwipeGestureSensitivityRange;

  /// Fixed logical pixels added or removed per animating edge at peak pulse.
  ///
  /// A value of `4` expands or squishes each active edge by up to 4px.
  /// When both sides animate, each edge uses the full delta independently.
  final double fixedPulseDelta;

  /// Click event notification pipe exposing the zero-based list tracking index of the interacted element.
  final void Function(int selectedIndex)? onTap;

  /// Called when the leading or focal item index changes after scrolling.
  final ValueChanged<M3ECarouselChangeDetails>? onChange;

  /// Haptic intensity on item tap. Defaults to [M3EHapticFeedback.none].
  final M3EHapticFeedback haptic;

  /// The continuous structured sequence of elements rendered inside the carousel scroll track.
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

  bool get _horizontal => widget.axis == Axis.horizontal;

  /// Viewport extent along the scroll axis.
  double get _mainExtent => _horizontal ? frameWidth : frameHeight;

  void scrollFrame(int direction) {
    final step = M3ECarouselScrollHelper.nextStep(
      type: widget.type,
      heroAlignment: widget.heroAlignment,
      isExtended: widget.isExtended,
      uncontainedItemExtent: widget.uncontainedItemExtent,
      layoutWeight: layoutWeight,
      mainExtent: _mainExtent,
      childrenLength: widget.children.length,
      itemScrolled: itemScrolled,
      prevScrollPosition: controller.position.pixels,
      direction: direction,
    );
    if (step == null) {
      return;
    }
    itemScrolled = step.itemScrolled;
    controller.animateTo(
      step.nextScrollPosition,
      duration: Duration(milliseconds: widget.scrollAnimationDuration),
      curve: Curves.ease,
    );
  }

  void onDragEnd(DragEndDetails details) {
    final double? velocity = details.primaryVelocity;
    if (velocity == null) {
      return;
    }
    if (velocity > (kIsWeb ? 0 : widget.singleSwipeGestureSensitivityRange)) {
      scrollFrame(0);
    } else if (velocity <
        -(kIsWeb ? 0 : widget.singleSwipeGestureSensitivityRange)) {
      scrollFrame(1);
    }
  }

  Widget setGestureLayer(Widget child) {
    if (widget.freeScroll) {
      return child;
    }
    if (_horizontal) {
      return GestureDetector(onHorizontalDragEnd: onDragEnd, child: child);
    }
    return GestureDetector(onVerticalDragEnd: onDragEnd, child: child);
  }

  @override
  void initState() {
    // Weighted layouts use consumeMaxWeight: false and initialItem: 0 so
    // flexWeights map onto items 0..n at scroll offset 0. Using
    // consumeMaxWeight with a non-zero initialItem inserts a phantom leading
    // extent that theme rebuilds can leave offstage.
    controller = M3ECarouselController();
    _applyLayoutWeights();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant M3ECarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.type != widget.type ||
        oldWidget.heroAlignment != widget.heroAlignment ||
        oldWidget.isExtended != widget.isExtended) {
      _applyLayoutWeights();
      itemScrolled = 0;
      if (controller.hasClients) {
        controller.jumpTo(0);
      }
    }
  }

  void _applyLayoutWeights() {
    switch (widget.type) {
      case M3ECarouselType.hero:
        switch (widget.heroAlignment) {
          case M3ECarouselHeroAlignment.left:
            layoutWeight = [8, 2];
          case M3ECarouselHeroAlignment.center:
            layoutWeight = [2, 6, 2];
          case M3ECarouselHeroAlignment.right:
            layoutWeight = [2, 8];
        }
      case M3ECarouselType.contained:
        layoutWeight = widget.isExtended ? [4, 3, 2, 1] : [5, 4, 1];
      case M3ECarouselType.uncontained:
        layoutWeight = [];
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (context) => LayoutBuilder(
        builder: (ctx, dimens) {
          frameWidth = widget.width ?? dimens.maxWidth;
          frameHeight = widget.height ?? dimens.maxHeight;
          return setGestureLayer(
            SizedBox(
              width: frameWidth,
              height: frameHeight,
              child: M3ECarouselWrapper(
                controller: controller,
                freeScroll: widget.freeScroll,
                itemSnapping: widget.freeScroll,
                consumeMaxWeight: false,
                scrollDirection: widget.axis,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    widget.childElementBorderRadius,
                  ),
                ),
                onTap: widget.onTap,
                onChange: widget.onChange,
                haptic: widget.haptic,
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
