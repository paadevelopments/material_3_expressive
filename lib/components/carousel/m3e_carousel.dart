import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:material_3_expressive/components/carousel/components/m3e_carousel_wrapper.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_ui/material_ui.dart';

import '../buttons/m3e_buttons.dart';
import '../cards/m3e_cards.dart';
import '../icon_buttons/m3e_icon_buttons.dart';
import 'components/m3e_carousel_item.dart';
import 'components/m3e_carousel_show_all.dart';
import 'components/m3e_carousel_view.dart';
import 'enums/m3e_carousel_type.dart';
import 'models/m3e_carousel_change_details.dart';
import 'styles/m3e_carousel_theme.dart';
import 'utils/m3e_carousel_layout.dart';
import 'utils/m3e_carousel_scroll_helper.dart';

export 'components/m3e_carousel_item.dart';
export 'components/m3e_carousel_show_all.dart';
export 'components/m3e_carousel_slot_scope.dart';
export 'components/m3e_carousel_view.dart';
export 'components/m3e_carousel_wrapper.dart';
export 'enums/m3e_carousel_type.dart';
export 'models/m3e_carousel_change_details.dart';
export 'models/m3e_carousel_scrim.dart';
export 'styles/m3e_carousel_theme.dart';
export 'utils/m3e_carousel_layout.dart';
export 'utils/m3e_carousel_scroll_helper.dart';

/// Creates a Material Design carousel.
///
/// Layouts:
///  * Multi-browse ([M3ECarouselType.contained]): large, medium, and small.
///  * Uncontained: one item size, scrolling to the container edge.
///  * Uncontained multi-aspect: widths from 9:16 to 16:9.
///  * Hero: one large item and a small peek.
///  * Full-screen: one edge-to-edge item, scrolled vertically.
///
/// Scrolls along [axis] (horizontal by default). Full-screen is always
/// vertical. A swipe advances one item unless [freeScroll] is on, which
/// drags and snaps to the nearest item.
class M3ECarousel extends StatefulWidget {
  /// Creates a Material Design carousel.
  const M3ECarousel({
    super.key,
    this.controller,
    this.width,
    this.height,
    this.axis = Axis.horizontal,
    this.type = M3ECarouselType.hero,
    this.isExtended,
    this.freeScroll,
    this.heroAlignment = M3ECarouselHeroAlignment.center,
    this.uncontainedItemExtent = M3ECarouselTheme.defaultUncontainedItemExtent,
    this.uncontainedShrinkExtent =
        M3ECarouselTheme.defaultUncontainedShrinkExtent,
    this.childElementBorderRadius,
    this.largeMaxWidth,
    this.itemPadding,
    this.scrollAnimationDuration =
        M3ECarouselTheme.defaultScrollAnimationDuration,
    this.fixedPulseDelta = 4,
    this.singleSwipeGestureSensitivityRange =
        M3ECarouselTheme.defaultSingleSwipeGestureSensitivityRange,
    this.onTap,
    this.onChange,
    this.haptic = M3EHapticFeedback.none,
    this.header,
    this.showAll = false,
    required this.children,
  });

  /// Scroll and action controller. The carousel creates one when this is omitted.
  ///
  /// Use [M3ECarouselController.next], [M3ECarouselController.previous],
  /// [M3ECarouselController.animateToItem], [M3ECarouselController.jumpToItem],
  /// and [M3ECarouselController.showAll].
  final M3ECarouselController? controller;

  /// The explicit bounded width allocation applied to the root carousel container wrapper.
  final double? width;

  /// The explicit bounded height allocation applied to the root carousel container wrapper.
  final double? height;

  /// Scroll and layout axis. Defaults to [Axis.horizontal].
  ///
  /// [M3ECarouselType.fullScreen] always scrolls vertically.
  final Axis axis;

  /// Specifies the structural layout rule type determining element sizes and scaling constraints.
  final M3ECarouselType type;

  /// Expanded slot pattern.
  ///
  /// When null, a wide contained carousel uses the extended pattern.
  ///
  /// Hero ignores this. Below the breakpoint, contained shows at most three
  /// slots.
  final bool? isExtended;

  /// When false, a swipe advances one item and the scroll view does not drag.
  /// When true, the scroll view drags and snaps to the nearest item.
  ///
  /// Defaults to false.
  final bool? freeScroll;

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

  /// Corner radius. Defaults to the theme value for the layout.
  final double? childElementBorderRadius;

  /// Largest large-item extent. Defaults to the theme value.
  final double? largeMaxWidth;

  /// Padding inside each item. Defaults to the layout gap.
  final EdgeInsetsGeometry? itemPadding;

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

  /// Title shown above the items, with an arrow that opens every item.
  final Widget? header;

  /// Trailing text button that opens every item. Ignored when [header] is set
  /// or the layout is full-screen.
  final bool showAll;

  /// Items rendered in the scroll track.
  final List<M3ECarouselItem> children;

  @override
  State<M3ECarousel> createState() => _M3ECarouselState();
}

class _M3ECarouselState extends State<M3ECarousel> {
  double frameWidth = 0;
  double frameHeight = 0;
  double _trackMain = 0;
  double _stepExtent = 0;
  List<int> layoutWeight = [];
  int itemScrolled = 0;
  List<double>? _aspectExtents;
  M3ECarouselController? _ownedController;
  final GlobalKey _trackKey = GlobalKey();

  M3ECarouselController get _controller =>
      widget.controller ?? _ownedController!;

  bool get _fullScreen => widget.type == M3ECarouselType.fullScreen;

  Axis get _axis => _fullScreen ? Axis.vertical : widget.axis;

  bool get _horizontal => _axis == Axis.horizontal;

  /// Viewport extent along the scroll axis.
  double get _mainExtent => _horizontal ? frameWidth : frameHeight;

  bool _freeScroll() => widget.freeScroll ?? false;

  Future<void> scrollFrame(int direction) async {
    if (!_controller.hasClients) {
      return;
    }
    final List<double>? varied = _aspectExtents;
    if (varied != null) {
      await _scrollVaried(direction, varied);
      return;
    }
    final M3ECarouselTheme theme = M3ETheme.of(context).carouselTheme;
    final bool weighted = layoutWeight.isNotEmpty;
    final step = M3ECarouselScrollHelper.nextStep(
      type: weighted ? widget.type : M3ECarouselType.uncontained,
      heroAlignment: widget.heroAlignment,
      isExtended: _extended(theme),
      uncontainedItemExtent: _stepExtent,
      leadingGap: _leadingGap(theme),
      layoutWeight: layoutWeight,
      mainExtent: _trackMain,
      childrenLength: widget.children.length,
      itemScrolled: itemScrolled,
      prevScrollPosition: _controller.position.pixels,
      direction: direction,
    );
    if (step == null) {
      return;
    }
    itemScrolled = step.itemScrolled;
    await _controller.animateTo(
      step.nextScrollPosition,
      duration: Duration(milliseconds: widget.scrollAnimationDuration),
      curve: Curves.ease,
    );
  }

  Future<void> _scrollVaried(int direction, List<double> extents) async {
    if (extents.isEmpty) {
      return;
    }
    if (direction == 0) {
      if (itemScrolled <= 0) {
        return;
      }
      itemScrolled -= 1;
    } else {
      if (itemScrolled >= extents.length - 1) {
        return;
      }
      itemScrolled += 1;
    }
    double offset = 0;
    for (var i = 0; i < itemScrolled; i++) {
      offset += extents[i];
    }
    await _controller.animateTo(
      offset,
      duration: Duration(milliseconds: widget.scrollAnimationDuration),
      curve: Curves.ease,
    );
  }

  Future<void> _moveTo(
    int index, {
    required bool jump,
    required Duration duration,
    required Curve curve,
  }) async {
    if (!mounted || !_controller.hasClients || widget.children.isEmpty) {
      return;
    }
    final int target = _clampIndex(index);
    itemScrolled = target;
    final double offset = _offsetFor(target);
    if (jump) {
      _controller.jumpTo(offset);
      return;
    }
    await _controller.animateTo(offset, duration: duration, curve: curve);
  }

  int _clampIndex(int index) {
    final List<double>? varied = _aspectExtents;
    if (varied != null && varied.isNotEmpty) {
      return index.clamp(0, varied.length - 1);
    }
    final int limit = M3ECarouselScrollHelper.maxIndex(
      type: layoutWeight.isEmpty ? M3ECarouselType.uncontained : widget.type,
      heroAlignment: widget.heroAlignment,
      isExtended: _extended(M3ETheme.of(context).carouselTheme),
      childrenLength: widget.children.length,
    );
    if (limit < 0) {
      return 0;
    }
    return index.clamp(0, limit);
  }

  double _offsetFor(int index) {
    final List<double>? varied = _aspectExtents;
    if (varied != null && varied.isNotEmpty) {
      double offset = 0;
      final int end = math.min(index, varied.length);
      for (int i = 0; i < end; i++) {
        offset += varied[i];
      }
      return offset;
    }
    final M3ECarouselTheme theme = M3ETheme.of(context).carouselTheme;
    return M3ECarouselScrollHelper.offsetForIndex(
      type: layoutWeight.isEmpty ? M3ECarouselType.uncontained : widget.type,
      heroAlignment: widget.heroAlignment,
      isExtended: _extended(theme),
      uncontainedItemExtent: _stepExtent,
      leadingGap: _leadingGap(theme),
      layoutWeight: layoutWeight,
      mainExtent: _trackMain,
      childrenLength: widget.children.length,
      index: index,
    );
  }

  void _bindController(M3ECarouselController controller) {
    controller.attachActions(
      currentItem: () => itemScrolled,
      step: scrollFrame,
      moveTo: _moveTo,
      showAll: () {
        if (!mounted) {
          return;
        }
        _openList(M3ETheme.of(context).carouselTheme);
      },
    );
  }

  void onDragEnd(DragEndDetails details) {
    final double? velocity = details.primaryVelocity;
    if (velocity == null) {
      return;
    }
    final int threshold = kIsWeb
        ? 0
        : widget.singleSwipeGestureSensitivityRange;
    if (velocity > threshold) {
      scrollFrame(0);
    } else if (velocity < -threshold) {
      scrollFrame(1);
    }
  }

  Widget _gestureLayer(Widget child) {
    if (_freeScroll()) {
      return child;
    }
    if (_horizontal) {
      return GestureDetector(onHorizontalDragEnd: onDragEnd, child: child);
    }
    return GestureDetector(onVerticalDragEnd: onDragEnd, child: child);
  }

  bool _extended(M3ECarouselTheme theme) {
    if (widget.type == M3ECarouselType.hero) {
      return false;
    }
    if (widget.isExtended != null) {
      return widget.isExtended!;
    }
    return frameWidth >= theme.expandedBreakpoint;
  }

  /// Gap before the first uncontained item. Later rests keep that gap too.
  double _leadingGap(M3ECarouselTheme theme) {
    final bool uncontained =
        widget.type == M3ECarouselType.uncontained ||
        widget.type == M3ECarouselType.uncontainedMultiAspect;
    if (!_horizontal || !uncontained || widget.itemPadding != null) {
      return 0;
    }
    return theme.itemGap;
  }

  @override
  void initState() {
    if (widget.controller == null) {
      _ownedController = M3ECarouselController();
    }
    _bindController(_controller);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant M3ECarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _ownedController)?.detachActions();
      if (oldWidget.controller == null) {
        _ownedController?.dispose();
        _ownedController = null;
      }
      if (widget.controller == null) {
        _ownedController = M3ECarouselController();
      }
      _bindController(_controller);
    }
    if (oldWidget.type != widget.type ||
        oldWidget.heroAlignment != widget.heroAlignment ||
        oldWidget.isExtended != widget.isExtended) {
      itemScrolled = 0;
      if (_controller.hasClients) {
        _controller.jumpTo(0);
      }
    }
  }

  @override
  void dispose() {
    _controller.detachActions();
    _ownedController?.dispose();
    super.dispose();
  }

  List<int> _pattern(bool extended) {
    switch (widget.type) {
      case M3ECarouselType.hero:
        switch (widget.heroAlignment) {
          case M3ECarouselHeroAlignment.left:
            return <int>[8, 2];
          case M3ECarouselHeroAlignment.center:
            return <int>[2, 6, 2];
          case M3ECarouselHeroAlignment.right:
            return <int>[2, 8];
        }
      case M3ECarouselType.contained:
        return extended ? <int>[4, 3, 2, 1] : <int>[5, 4, 1];
      case M3ECarouselType.uncontained:
      case M3ECarouselType.uncontainedMultiAspect:
      case M3ECarouselType.fullScreen:
        return const <int>[];
    }
  }

  void _openList(M3ECarouselTheme theme) {
    final RenderBox? box =
        _trackKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return;
    }
    final Rect origin = box.localToGlobal(Offset.zero) & box.size;
    final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
    M3ECardContainerTransform.show<void>(
      context: context,
      origin: origin,
      originRadius: theme.radiusFor(widget.type),
      originColor: scheme.surface,
      builder: (BuildContext context) {
        return M3ECarouselShowAll(
          header: widget.header,
          children: widget.children,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (BuildContext context) {
        final M3ECarouselTheme theme = M3ETheme.of(context).carouselTheme;
        final bool freeScroll = _freeScroll();
        final bool reduced = MediaQuery.disableAnimationsOf(context);
        return LayoutBuilder(
          builder: (BuildContext ctx, BoxConstraints dimens) {
            frameWidth = widget.width ?? dimens.maxWidth;
            frameHeight = widget.height ?? dimens.maxHeight;
            final bool extended = _extended(theme);
            final bool reducedMotion = reduced;
            final double main = _mainExtent;
            final EdgeInsets container = _containerPadding(
              theme,
              reducedMotion,
            );
            final double trackMain = math.max(
              0,
              main - (_horizontal ? container.horizontal : container.vertical),
            );
            _trackMain = trackMain;
            layoutWeight = _resolvedWeights(
              theme,
              extended,
              reducedMotion,
              trackMain,
            );
            final List<double>? varied = _aspectExtentsFor(theme, container);
            _aspectExtents = varied;
            final double? itemExtent = _fixedExtent(theme, reduced, trackMain);
            _stepExtent = itemExtent ?? widget.uncontainedItemExtent;
            final bool showHeader = widget.header != null && !_fullScreen;
            final bool showAllButton =
                widget.showAll && widget.header == null && !_fullScreen;
            final Widget track = _gestureLayer(
              KeyedSubtree(
                key: _trackKey,
                child: Padding(
                  padding: container,
                  child: M3ECarouselWrapper(
                    controller: _controller,
                    freeScroll: freeScroll,
                    itemSnapping: freeScroll,
                    consumeMaxWeight: false,
                    scrollDirection: _axis,
                    padding: _itemPadding(theme, reducedMotion),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        widget.childElementBorderRadius ??
                            theme.radiusFor(widget.type),
                      ),
                    ),
                    onTap: widget.onTap,
                    onChange: widget.onChange,
                    haptic: widget.haptic,
                    flexWeights: varied == null && itemExtent == null
                        ? layoutWeight
                        : null,
                    itemExtent: varied == null ? itemExtent : null,
                    itemExtents: varied,
                    leadingInset: _leadingGap(theme),
                    shrinkExtent:
                        widget.type == M3ECarouselType.uncontained ||
                            widget.type ==
                                M3ECarouselType.uncontainedMultiAspect
                        ? widget.uncontainedShrinkExtent
                        : 0,
                    scaleItems:
                        widget.type == M3ECarouselType.uncontained ||
                        widget.type == M3ECarouselType.uncontainedMultiAspect,
                    reducedMotion: reduced,
                    fixedPulseDelta: widget.fixedPulseDelta,
                    children: widget.children,
                  ),
                ),
              ),
            );
            return Semantics(
              container: true,
              child: FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: SizedBox(
                  width: frameWidth,
                  height: frameHeight,
                  child: !frameHeight.isFinite
                      ? track
                      : Column(
                          children: <Widget>[
                            if (showHeader)
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(2),
                                child: _header(theme),
                              ),
                            Expanded(
                              child: FocusTraversalOrder(
                                order: const NumericFocusOrder(1),
                                child: track,
                              ),
                            ),
                            if (showAllButton)
                              FocusTraversalOrder(
                                order: const NumericFocusOrder(2),
                                child: _showAll(theme),
                              ),
                          ],
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<int> _resolvedWeights(
    M3ECarouselTheme theme,
    bool extended,
    bool reduced,
    double trackMain,
  ) {
    if (reduced ||
        widget.type == M3ECarouselType.uncontained ||
        widget.type == M3ECarouselType.uncontainedMultiAspect ||
        _fullScreen) {
      return const <int>[];
    }
    return M3ECarouselLayout.clampWeights(
      pattern: _pattern(extended),
      viewport: trackMain,
      smallMin: theme.smallMinWidth,
      smallMax: theme.smallMaxWidth,
      largeMax: widget.largeMaxWidth ?? theme.largeMaxWidth,
    );
  }

  double? _fixedExtent(M3ECarouselTheme theme, bool reduced, double trackMain) {
    if (widget.type == M3ECarouselType.uncontainedMultiAspect) {
      return null;
    }
    if (_fullScreen) {
      // One item is the viewport. A gap here makes later pages land short.
      return trackMain;
    }
    if (widget.type == M3ECarouselType.uncontained) {
      return widget.uncontainedItemExtent;
    }
    if (!reduced) {
      return null;
    }
    if (widget.type == M3ECarouselType.hero) {
      return math.max(trackMain - theme.smallMaxWidth, trackMain * 0.5);
    }
    return trackMain;
  }

  List<double>? _aspectExtentsFor(
    M3ECarouselTheme theme,
    EdgeInsets container,
  ) {
    if (widget.type != M3ECarouselType.uncontainedMultiAspect) {
      return null;
    }
    final double cross = _horizontal
        ? math.max(0, frameHeight - container.vertical)
        : math.max(0, frameWidth - container.horizontal);
    final EdgeInsets itemPadding = _itemPadding(theme, false);
    final double gap = _horizontal
        ? itemPadding.horizontal
        : itemPadding.vertical;
    return <double>[
      for (int i = 0; i < widget.children.length; i++)
        cross *
                widget.children[i].aspectRatio.clamp(
                  theme.minAspect,
                  theme.maxAspect,
                ) +
            gap,
    ];
  }

  EdgeInsets _containerPadding(M3ECarouselTheme theme, bool reduced) {
    if (reduced && widget.type == M3ECarouselType.contained) {
      return EdgeInsets.zero;
    }
    return theme.containerPaddingFor(widget.type);
  }

  EdgeInsets _itemPadding(M3ECarouselTheme theme, bool reduced) {
    if (widget.itemPadding != null) {
      return widget.itemPadding!.resolve(Directionality.of(context));
    }
    final EdgeInsets themed = theme.itemPadding.resolve(
      Directionality.of(context),
    );
    const EdgeInsets fallback = EdgeInsets.symmetric(horizontal: 4);
    if (themed != fallback) {
      return themed;
    }
    if (_fullScreen || (reduced && widget.type == M3ECarouselType.contained)) {
      return EdgeInsets.zero;
    }
    final bool bleed =
        widget.type == M3ECarouselType.uncontained ||
        widget.type == M3ECarouselType.uncontainedMultiAspect;
    if (bleed) {
      // The gap is on the trailing side so the leading edge matches the flush
      // trailing edge of the track.
      if (_horizontal) {
        return EdgeInsetsDirectional.only(end: theme.itemGap)
            .resolve(Directionality.of(context));
      }
      return EdgeInsets.only(top: theme.itemGap);
    }
    return _horizontal
        ? EdgeInsets.symmetric(horizontal: theme.itemGap / 2)
        : EdgeInsets.symmetric(vertical: theme.itemGap / 2);
  }

  Widget _header(M3ECarouselTheme theme) {
    return SizedBox(
      height: theme.arrowSize,
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: theme.headerInset)
            .resolve(Directionality.of(context)),
        child: Row(
          children: <Widget>[
            Expanded(child: widget.header!),
            M3EIconButton(
              variant: M3EIconButtonVariant.standard,
              icon: const Icon(M3EIcons.arrow_forward),
              tooltip: 'Show all',
              onPressed: () => _openList(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showAll(M3ECarouselTheme theme) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Padding(
        padding: EdgeInsets.only(top: theme.showAllGap),
        child: Padding(
          padding: EdgeInsets.all(theme.showAllPadding),
          child: M3EButton(
            style: M3EButtonStyle.text,
            onPressed: () => _openList(theme),
            child: const Text('Show all'),
          ),
        ),
      ),
    );
  }
}
