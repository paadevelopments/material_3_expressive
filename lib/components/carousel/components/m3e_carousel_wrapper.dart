import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../foundations/foundations.dart';
import '../../cards/m3e_cards.dart';
import '../models/m3e_carousel_change_details.dart';
import '../models/m3e_carousel_scrim.dart';
import '../styles/m3e_carousel_theme.dart';
import 'm3e_carousel_item.dart';
import 'm3e_carousel_step_physics.dart';
import 'm3e_carousel_track_clip.dart';
import 'm3e_carousel_view.dart';

part 'm3e_carousel_wrapper_anchors.dart';
part 'm3e_carousel_wrapper_pulse.dart';

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
    this.scaleItems = true,
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
    this.onChange,
    this.onFocusedIndex,
    this.reducedMotion = false,
    this.itemExtents,
    this.leadingInset = 0,
    this.trailingGap = 0,

    /// Fixed logical pixels added or removed per animating edge at peak pulse.
    ///
    /// A value of `4` expands or squishes each active edge by up to 4px.
    /// When both sides animate, each edge uses the full delta independently.
    this.fixedPulseDelta = 4,
  }) : assert(
         (flexWeights != null && itemExtent == null && itemExtents == null) ||
             (flexWeights == null &&
                 itemExtent != null &&
                 itemExtents == null) ||
             (flexWeights == null && itemExtent == null && itemExtents != null),
         'Provide itemExtent, flexWeights, or itemExtents.',
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

  /// Whether fixed-extent items shrink as they scroll.
  ///
  /// Full-screen pages stay one size and slide.
  final bool scaleItems;

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

  /// Items in the carousel.
  final List<M3ECarouselItem> children;

  /// Empty space before the first item on uncontained tracks.
  final double leadingInset;

  /// Called when the leading item index changes.
  final void Function(int)? onIndexChanged;

  /// Called when the leading or focal item index changes.
  final ValueChanged<M3ECarouselChangeDetails>? onChange;

  /// Called when keyboard focus moves to an item.
  final ValueChanged<int>? onFocusedIndex;

  /// Turns off parallax and size morphing.
  final bool reducedMotion;

  /// Resting main-axis size of each item.
  ///
  /// The track shrinks these the same way an uncontained carousel does.
  final List<double>? itemExtents;

  /// Empty space after each item, inside a fixed extent.
  final double trailingGap;

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
  final List<FocusNode> _itemFocus = <FocusNode>[];
  final List<WidgetStatesController> _itemStates = <WidgetStatesController>[];
  final List<LayerLink> _itemLinks = <LayerLink>[];
  final List<Size> _itemRest = <Size>[];
  bool _restRebuildScheduled = false;

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
    _syncFocusNodes();
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
    _syncFocusNodes();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _internalController.dispose();
    }
    for (final FocusNode node in _itemFocus) {
      node.dispose();
    }
    for (final WidgetStatesController states in _itemStates) {
      states.dispose();
    }
    _pulseController.dispose();
    super.dispose();
  }

  void _syncFocusNodes() {
    while (_itemFocus.length < widget.children.length) {
      _itemFocus.add(
        FocusNode(debugLabel: 'carousel item ${_itemFocus.length}'),
      );
      final WidgetStatesController states = WidgetStatesController();
      states.addListener(_onItemStates);
      _itemStates.add(states);
      _itemLinks.add(LayerLink());
      _itemRest.add(Size.zero);
    }
    while (_itemFocus.length > widget.children.length) {
      _itemFocus.removeLast().dispose();
      _itemStates.removeLast().dispose();
      _itemLinks.removeLast();
      _itemRest.removeLast();
    }
  }

  void _rememberRest(int index, Size rest) {
    if (index >= _itemRest.length || _itemRest[index] == rest) {
      return;
    }
    _itemRest[index] = rest;
    if (index >= _itemFocus.length || !_itemFocus[index].hasPrimaryFocus) {
      return;
    }
    if (_restRebuildScheduled) {
      return;
    }
    _restRebuildScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restRebuildScheduled = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _clearItemFocus(int index) {
    M3EFocusInteraction.instance.notePointerInteraction();
    if (index < _itemFocus.length && _itemFocus[index].hasFocus) {
      _itemFocus[index].unfocus();
    }
  }

  void _onItemStates() {
    if (mounted) {
      setState(() {});
    }
  }

  void _moveFocus(int index) {
    if (index < 0 || index >= widget.children.length) {
      return;
    }
    widget.onFocusedIndex?.call(index);
    _internalController.animateToItem(index).whenComplete(() {
      if (mounted) {
        _itemFocus[index].requestFocus();
      }
    });
  }

  KeyEventResult _onItemKey(int index, KeyEvent event) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final LogicalKeyboardKey key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp ||
        key == LogicalKeyboardKey.arrowDown) {
      return KeyEventResult.ignored;
    }
    final bool rtl = Directionality.of(context) == TextDirection.rtl;
    final bool next =
        key ==
        (rtl ? LogicalKeyboardKey.arrowLeft : LogicalKeyboardKey.arrowRight);
    final bool previous =
        key ==
        (rtl ? LogicalKeyboardKey.arrowRight : LogicalKeyboardKey.arrowLeft);
    if (next || previous) {
      _moveFocus(index + (next ? 1 : -1));
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.tab) {
      final bool shift = HardwareKeyboard.instance.isShiftPressed;
      final int target = index + (shift ? -1 : 1);
      if (target < 0 || target >= widget.children.length) {
        return KeyEventResult.ignored;
      }
      _moveFocus(target);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.space || key == LogicalKeyboardKey.enter) {
      final M3ECarouselItem item = _itemAt(index);
      if (!item.enabled) {
        return KeyEventResult.handled;
      }
      item.onTap?.call();
      _handleTap(index);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  M3ECarouselItem _itemAt(int index) => widget.children[index];

  /// Full-screen pages keep one size, so the image shifts as the page moves.
  bool get _fullscreenParallax =>
      !widget.reducedMotion &&
      !widget.scaleItems &&
      widget.flexWeights == null &&
      widget.itemExtents == null &&
      widget.itemExtent != null;

  /// Image shift for a full-screen page, in the scroll direction.
  ///
  /// The image is taller or wider than the page and moves slower than the
  /// page, matching the centered clip on the weighted layouts.
  double _fullscreenParallaxShift(
    int index,
    double restMain,
    ScrollPosition position,
  ) {
    final double viewport = position.hasViewportDimension
        ? position.viewportDimension
        : restMain;
    if (viewport == 0) {
      return 0;
    }
    final double extent = widget.itemExtent ?? restMain;
    final double origin = index * extent + widget.leadingInset;
    final double delta =
        (origin + restMain / 2) - (position.pixels + viewport / 2);
    final double extra = restMain * 0.5;
    final double t = (delta / viewport).clamp(-1.0, 1.0);
    return -t * extra / 2;
  }

  /// Full card size on the scroll axis, so a peek clips a stable image.
  double _pinnedContentMain(int index, double restMain) {
    final double paddingMain = _mainAxisPadding(_resolvedPadding);
    if (widget.itemExtents != null && index < widget.itemExtents!.length) {
      return math.max(widget.itemExtents![index] - paddingMain, restMain);
    }
    if (widget.itemExtent != null) {
      return math.max(widget.itemExtent! - paddingMain, restMain);
    }
    return math.max(restMain, 0);
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
    final M3ECarouselItem item = _itemAt(index);
    final Widget? destination = item.transform;
    if (destination != null && item.enabled && mounted) {
      _openItemTransform(index, destination);
    }
  }

  void _openItemTransform(int index, Widget destination) {
    RenderBox? box = _itemBoxes[index];
    if (box == null || !box.hasSize || !box.attached) {
      final RenderObject? object = _itemFocus[index].context
          ?.findRenderObject();
      if (object is RenderBox && object.hasSize && object.attached) {
        box = object;
      }
    }
    if (box == null) {
      return;
    }
    final Rect origin = box.localToGlobal(Offset.zero) & box.size;
    final theme = M3ETheme.of(context);
    final radius = widget.shape is RoundedRectangleBorder
        ? (widget.shape! as RoundedRectangleBorder).borderRadius as BorderRadius
        : BorderRadius.zero;
    M3ECardContainerTransform.show<void>(
      context: context,
      origin: origin,
      originRadius: radius.topLeft.x,
      originColor: theme.colorScheme.surface,
      builder: (BuildContext context) => destination,
    );
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
            final M3EThemeData theme = M3ETheme.of(context);
            return Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                _CarouselViewportAnchor(
                  onRegister: (RenderBox box) => _viewportBox = box,
                  onUnregister: _unregisterViewportBox,
                  child: ClipRect(
                    clipper: M3ECarouselTrackClipper(
                      axis: widget.scrollDirection,
                    ),
                    child: _buildCarouselView(carouselChildren),
                  ),
                ),
                Positioned.fill(
                  child: ClipRect(
                    clipper: M3ECarouselTrackClipper(
                      axis: widget.scrollDirection,
                      mainAxisBleed: _focusRingBleed,
                      crossAxisBleed: _focusRingBleed,
                    ),
                    child: Stack(children: _focusRings(edgeDelta, theme)),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static const double _focusRingBleed = 8;

  List<Widget> _focusRings(double edgeDelta, M3EThemeData theme) {
    final BorderRadius radius = widget.shape is RoundedRectangleBorder
        ? ((widget.shape! as RoundedRectangleBorder).borderRadius
              as BorderRadius)
        : BorderRadius.zero;
    final M3ECarouselTheme carousel = theme.carouselTheme;
    final List<Widget> rings = <Widget>[];
    for (int index = 0; index < widget.children.length; index++) {
      if (index >= _itemFocus.length || !_itemFocus[index].hasPrimaryFocus) {
        continue;
      }
      if (index >= _itemRest.length || _itemRest[index].isEmpty) {
        continue;
      }
      final Size rest = _itemRest[index];
      final frame = _pulseFrameRect(
        index: index,
        isActive: _activeIndex == index,
        isLeftNeighbor: _leftVisibleNeighborIndex == index,
        isRightNeighbor: _rightVisibleNeighborIndex == index,
        edgeDelta: edgeDelta,
        restWidth: rest.width,
        restHeight: rest.height,
      );
      rings.add(
        CompositedTransformFollower(
          link: _itemLinks[index],
          showWhenUnlinked: false,
          child: IgnorePointer(
            child: SizedBox(
              width: frame.width,
              height: frame.height,
              child: M3EFocusRing(
                focused: theme.keyboardFocusIndicators,
                radius: radius,
                width: carousel.focusThickness,
                gap: carousel.focusOffset,
                color: theme.colorScheme.secondary,
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      );
    }
    return rings;
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
    // Resolve inherited values before the sliver lays the item out. Looking
    // them up while the scroll view is in layout drops the leading child.
    final M3EThemeData theme = M3ETheme.of(context);
    final bool compact = MediaQuery.sizeOf(context).width < 600;

    return _CarouselItemAnchor(
      index: index,
      onRegister: _registerItemBox,
      onUnregister: _unregisterItemBox,
      child: RepaintBoundary(
        // Content is laid out once at (max slot + pulse overflow) and stays
        // pinned in resting coordinates. Only the clip rect animates.
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double gap = widget.trailingGap;
            final double restWidth = math.max(
              0,
              constraints.maxWidth - (_vertical ? 0 : gap),
            );
            final double restHeight = math.max(
              0,
              constraints.maxHeight - (_vertical ? gap : 0),
            );
            _rememberRest(index, Size(restWidth, restHeight));
            final ScrollPosition position = Scrollable.of(context).position;
            return Padding(
              padding: EdgeInsets.only(
                right: _vertical ? 0 : gap,
                bottom: _vertical ? gap : 0,
              ),
              child: _buildPulsedChildFrame(
                index: index,
                isActive: isActive,
                isLeftNeighbor: isLeftNeighbor,
                isRightNeighbor: isRightNeighbor,
                edgeDelta: edgeDelta,
                restWidth: restWidth,
                restHeight: restHeight,
                stableInner: stableInner,
                pulseBudget: pulseBudget,
                finalRadius: finalRadius,
                clipBehavior: clipBehavior,
                theme: theme,
                compact: compact,
                position: position,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPulsedChildFrame({
    required int index,
    required bool isActive,
    required bool isLeftNeighbor,
    required bool isRightNeighbor,
    required double edgeDelta,
    required double restWidth,
    required double restHeight,
    required double stableInner,
    required double pulseBudget,
    required BorderRadius finalRadius,
    required Clip clipBehavior,
    required M3EThemeData theme,
    required bool compact,
    required ScrollPosition position,
  }) {
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
    // Weighted layouts center a stable image so the clip can parallax.
    // Full-screen pages are one size, so the image shifts with scroll instead.
    // Other fixed layouts pin the image so a settle does not slide it.
    final bool fullscreenParallax = _fullscreenParallax;
    final bool pinImage = widget.flexWeights == null && !fullscreenParallax;
    final double pinnedMain = _pinnedContentMain(
      index,
      _vertical ? restHeight : restWidth,
    );
    final double contentWidth = pinImage
        ? (_vertical ? restWidth : pinnedMain + pulseBudget * 2)
        : _vertical
        ? restWidth
        : widget.reducedMotion
        ? restWidth + pulseBudget
        : math.max(stableInner, restWidth) + pulseBudget;
    final double contentHeight = pinImage
        ? (_vertical ? pinnedMain + pulseBudget * 2 : restHeight)
        : _vertical
        ? widget.reducedMotion
              ? restHeight + pulseBudget
              : math.max(stableInner, restHeight) + pulseBudget
        : restHeight;
    final double contentLeft = pinImage
        ? (_vertical ? 0 : -pulseBudget)
        : (restWidth - contentWidth) / 2;
    final double contentTop = pinImage
        ? (_vertical ? -pulseBudget : 0)
        : (restHeight - contentHeight) / 2;

    final M3ECarouselTheme carousel = theme.carouselTheme;
    final M3EColorScheme scheme = theme.colorScheme;
    final M3ECarouselItem item = _itemAt(index);
    final bool enabled = item.enabled;
    final Set<WidgetState> states = index < _itemStates.length
        ? _itemStates[index].value
        : const <WidgetState>{};
    final bool hovered = states.contains(WidgetState.hovered);
    final String positionLabel =
        'List item, ${index + 1} of ${widget.children.length}';
    final String? spoken = item.semanticLabel;
    final double slotMain = _vertical ? restHeight : restWidth;
    final Widget picture = item.image;
    final Widget labels =
        item.textOverlay(slotMain: slotMain) ?? const SizedBox.shrink();
    final M3ECarouselScrim? scrim = item.showScrim;

    return SizedBox(
      width: restWidth,
      height: restHeight,
      child: TapRegion(
        onTapOutside: (_) => _clearItemFocus(index),
        child: Semantics(
          label: spoken == null ? positionLabel : '$spoken, $positionLabel',
          button: enabled,
          child: Focus(
            focusNode: index < _itemFocus.length ? _itemFocus[index] : null,
            onKeyEvent: (FocusNode node, KeyEvent event) =>
                _onItemKey(index, event),
            onFocusChange: (bool hasFocus) {
              if (index < _itemStates.length) {
                _itemStates[index].update(WidgetState.focused, hasFocus);
              }
              _onItemStates();
            },
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Positioned(
                  left: frame.left,
                  top: frame.top,
                  width: frame.width,
                  height: frame.height,
                  child: CompositedTransformTarget(
                    link: _itemLinks[index],
                    child: Material(
                      color: scheme.surface,
                      elevation: hovered && enabled
                          ? carousel.hoverElevation
                          : 0,
                      shadowColor: scheme.shadow,
                      surfaceTintColor: Colors.transparent,
                      clipBehavior: clipBehavior,
                      shape: RoundedRectangleBorder(borderRadius: finalRadius),
                      child: Stack(
                        children: <Widget>[
                          if (fullscreenParallax)
                            Positioned.fill(
                              child: ListenableBuilder(
                                listenable: position,
                                builder: (BuildContext context, Widget? child) {
                                  final double restMain = _vertical
                                      ? restHeight
                                      : restWidth;
                                  final double extra = restMain * 0.5;
                                  final double shift = _fullscreenParallaxShift(
                                    index,
                                    restMain,
                                    position,
                                  );
                                  final double main =
                                      restMain + extra + pulseBudget * 2;
                                  final double cross =
                                      (_vertical ? restWidth : restHeight) +
                                      pulseBudget * 2;
                                  final double mainOffset =
                                      (restMain - main) / 2 + shift;
                                  return Stack(
                                    children: <Widget>[
                                      Positioned(
                                        left: _vertical
                                            ? -pulseBudget
                                            : mainOffset,
                                        top: _vertical
                                            ? mainOffset
                                            : -pulseBudget,
                                        width: _vertical ? cross : main,
                                        height: _vertical ? main : cross,
                                        child: child!,
                                      ),
                                    ],
                                  );
                                },
                                child: IgnorePointer(
                                  child: Opacity(
                                    opacity: enabled
                                        ? 1
                                        : carousel.disabledOpacity,
                                    child: picture,
                                  ),
                                ),
                              ),
                            )
                          else
                            Positioned(
                              left: contentLeft - frame.left,
                              top: contentTop - frame.top,
                              width: math.max(
                                contentWidth,
                                frame.width - (contentLeft - frame.left),
                              ),
                              height: math.max(
                                contentHeight,
                                frame.height - (contentTop - frame.top),
                              ),
                              child: IgnorePointer(
                                child: Opacity(
                                  opacity: enabled
                                      ? 1
                                      : carousel.disabledOpacity,
                                  child: picture,
                                ),
                              ),
                            ),
                          if (scrim != null)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: ColoredBox(color: scrim.paintColor),
                              ),
                            ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Opacity(
                                opacity: enabled ? 1 : carousel.disabledOpacity,
                                child: labels,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                statesController: index < _itemStates.length
                                    ? _itemStates[index]
                                    : null,
                                enableFeedback: false,
                                splashFactory: InkSparkle.splashFactory,
                                mouseCursor: enabled
                                    ? SystemMouseCursors.click
                                    : SystemMouseCursors.basic,
                                canRequestFocus: false,
                                onTap: enabled
                                    ? () {
                                        item.onTap?.call();
                                        if (index < _itemFocus.length) {
                                          _itemFocus[index].requestFocus();
                                        }
                                        _handleTap(index);
                                      }
                                    : null,
                                overlayColor: widget.overlayColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselView(List<Widget> carouselChildren) {
    // Free scroll drags and snaps. Otherwise a swipe steps one item and the
    // scroll view does not drag or fling on after the step.
    final ScrollPhysics? physics = widget.freeScroll
        ? null
        : const M3ECarouselStepPhysics();
    final List<double>? extents = widget.itemExtents;
    if (extents != null) {
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
        scaleItems: widget.scaleItems,
        controller: _internalController,
        scrollDirection: widget.scrollDirection,
        reverse: widget.reverse,
        enableSplash: false,
        infinite: widget.infinite,
        leadingInset: widget.leadingInset,
        itemExtent: extents.isEmpty ? 1 : extents.first,
        restingExtents: extents,
        onIndexChanged: widget.onIndexChanged,
        onChange: widget.onChange,
        children: carouselChildren,
      );
    }
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
        onChange: widget.onChange,
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
      scaleItems: widget.scaleItems,
      controller: _internalController,
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      enableSplash: false,
      infinite: widget.infinite,
      leadingInset: widget.leadingInset,
      itemExtent: widget.itemExtent!,
      onIndexChanged: widget.onIndexChanged,
      onChange: widget.onChange,
      children: carouselChildren,
    );
  }
}
