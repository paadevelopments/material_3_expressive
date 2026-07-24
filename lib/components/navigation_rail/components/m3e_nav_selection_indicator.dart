import 'dart:math' as math;

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

/// Liquid selection indicator: lead/trail springs elongate into a bridge
/// between destinations, then settle to a stadium pill (spatial springs spec).
///
/// [targetKeys] must match destination order (one key per selectable item).
/// Place each key on the widget the pill should cover (icon chip / row).
class M3ENavSelectionIndicator extends StatefulWidget {
  const M3ENavSelectionIndicator({
    required this.selectedIndex,
    required this.targetKeys,
    required this.axis,
    required this.color,
    required this.child,
    this.enabled = true,
    this.layoutToken,
    this.layoutSettleDuration = Duration.zero,
    this.onTravelingChanged,
    super.key,
  });

  final int selectedIndex;
  final List<GlobalKey> targetKeys;
  final Axis axis;
  final Color color;
  final Widget child;
  final bool enabled;

  /// When this value changes (e.g. rail expanded ↔ collapsed), the pill
  /// remeasures and snaps to the new destination geometry.
  final Object? layoutToken;

  /// How long to keep remeasuring after [layoutToken] changes (e.g. width
  /// animation). The pill tracks the selected item without a travel morph.
  final Duration layoutSettleDuration;

  /// Called when the liquid bridge starts or finishes traveling.
  ///
  /// Hosts can hide their resting local pill while this is true so only the
  /// morph overlay is visible.
  final ValueChanged<bool>? onTravelingChanged;

  @override
  State<M3ENavSelectionIndicator> createState() =>
      _M3ENavSelectionIndicatorState();
}

class _M3ENavSelectionIndicatorState extends State<M3ENavSelectionIndicator>
    with TickerProviderStateMixin {
  final GlobalKey _stackKey = GlobalKey();

  /// Main-axis centers of the lead and trailing edges of the pill.
  late SingleMotionController _lead;
  late SingleMotionController _trail;

  /// Cross-axis center and resting main-axis size / cross size.
  double _crossCenter = 0;
  double _baseMain = 0;
  double _crossSize = 0;
  bool _ready = false;
  bool _traveling = false;
  int _layoutTrackId = 0;
  int _measureAttempts = 0;
  bool _measureScheduled = false;
  bool _pendingForceJump = false;
  bool _layoutTracking = false;
  EdgeInsets? _viewPadding;

  /// Cached geometries so selection changes can animate without waiting a frame.
  final Map<int, ({double main, double cross, double mainSize, double crossSize})>
      _geoCache =
      <int, ({double main, double cross, double mainSize, double crossSize})>{};

  /// Lead moves with snappier shape spring; trail follows with position spring.
  SpringMotion get _leadMotion =>
      const MaterialSpringMotion.expressiveSpatialDefault()
          .copyWith(damping: 0.45);

  SpringMotion get _trailMotion =>
      const MaterialSpringMotion.expressiveSpatialDefault()
          .copyWith(damping: 0.55);

  bool get _animating => _lead.isAnimating || _trail.isAnimating;

  @override
  void initState() {
    super.initState();
    _lead = SingleMotionController(motion: _leadMotion, vsync: this);
    _trail = SingleMotionController(motion: _trailMotion, vsync: this);
    _lead.addStatusListener(_onMotionStatus);
    _trail.addStatusListener(_onMotionStatus);
    _scheduleMeasure(forceJump: true);
  }

  void _onMotionStatus(AnimationStatus status) {
    _updateTraveling();
  }

  void _updateTraveling() {
    _setTraveling(_animating);
  }

  /// Updates traveling without calling [setState] during build.
  ///
  /// [animateTo] from [didUpdateWidget] can fire status listeners while the
  /// tree is still building; hosts must not be notified until after the frame.
  void _setTraveling(bool traveling) {
    if (traveling == _traveling) {
      return;
    }
    _traveling = traveling;

    void notify() {
      if (!mounted) {
        return;
      }
      setState(() {});
      widget.onTravelingChanged?.call(_traveling);
    }

    final SchedulerPhase phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks) {
      notify();
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) => notify());
    }
  }

  @override
  void didUpdateWidget(covariant M3ENavSelectionIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      // Item slots don't move on selection — start the morph immediately.
      _sync();
    } else if (oldWidget.layoutToken != widget.layoutToken) {
      _trackLayoutChange();
    } else if (oldWidget.targetKeys.length != widget.targetKeys.length ||
        oldWidget.enabled != widget.enabled) {
      _geoCache.clear();
      _scheduleMeasure(forceJump: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safe-area often settles after first paint. Other MediaQuery churn
    // (keyboard viewInsets from fullscreen search) must not force-jump the
    // pill — that snaps to transitional / bogus geometry.
    final EdgeInsets padding = MediaQuery.viewPaddingOf(context);
    final bool first = _viewPadding == null;
    final bool paddingChanged = !first && _viewPadding != padding;
    _viewPadding = padding;
    if (!_ready || first || paddingChanged) {
      _scheduleMeasure(forceJump: !_ready || first);
      return;
    }
    _scheduleMeasure(forceJump: false);
  }

  /// Remeasure through a layout transition (expand/collapse) so the pill
  /// matches the new item size/position without a selection morph.
  void _trackLayoutChange() {
    final int track = ++_layoutTrackId;
    _layoutTracking = true;
    _geoCache.clear();
    void tick() {
      if (!mounted || track != _layoutTrackId) {
        return;
      }
      _sync(forceJump: true);
    }

    void finish() {
      if (!mounted || track != _layoutTrackId) {
        return;
      }
      _layoutTracking = false;
      _sync(forceJump: true);
    }

    _scheduleMeasure(forceJump: true);

    final Duration settle = widget.layoutSettleDuration;
    if (settle <= Duration.zero) {
      // Single post-frame snap; tracking ends after that measure.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && track == _layoutTrackId) {
          _layoutTracking = false;
        }
      });
      return;
    }
    final int frames = (settle.inMilliseconds / 16).ceil().clamp(1, 60);
    for (int i = 1; i <= frames; i++) {
      Future<void>.delayed(Duration(milliseconds: 16 * i), tick);
    }
    Future<void>.delayed(Duration(milliseconds: 16 * frames), finish);
  }

  /// Post-frame measure, and [scheduleFrame] so release builds retry when idle.
  void _scheduleMeasure({required bool forceJump}) {
    _pendingForceJump = _pendingForceJump || forceJump;
    if (_measureScheduled) {
      return;
    }
    _measureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureScheduled = false;
      final bool jump = _pendingForceJump;
      _pendingForceJump = false;
      if (!mounted) {
        return;
      }
      _sync(forceJump: jump);
    });
    SchedulerBinding.instance.scheduleFrame();
  }

  @override
  void dispose() {
    _layoutTrackId++;
    if (_traveling) {
      widget.onTravelingChanged?.call(false);
    }
    _lead.removeStatusListener(_onMotionStatus);
    _trail.removeStatusListener(_onMotionStatus);
    _lead.dispose();
    _trail.dispose();
    super.dispose();
  }

  RenderBox? _boxOf(GlobalKey key) {
    final BuildContext? ctx = key.currentContext;
    if (ctx == null) {
      return null;
    }
    final RenderObject? renderObject = ctx.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize || !renderObject.attached) {
      return null;
    }
    return renderObject;
  }

  RenderBox? get _stackBox {
    final RenderObject? renderObject =
        _stackKey.currentContext?.findRenderObject();
    if (renderObject is! RenderBox ||
        !renderObject.hasSize ||
        !renderObject.attached) {
      return null;
    }
    return renderObject;
  }

  /// True when [item] is under [stack] in the render tree.
  bool _isDescendant(RenderBox item, RenderBox stack) {
    RenderObject? node = item.parent;
    while (node != null) {
      if (node == stack) {
        return true;
      }
      node = node.parent;
    }
    return false;
  }

  ({double main, double cross, double mainSize, double crossSize})? _readGeometry(
    int index,
  ) {
    if (index < 0 || index >= widget.targetKeys.length) {
      return null;
    }
    final RenderBox? item = _boxOf(widget.targetKeys[index]);
    final RenderBox? stack = _stackBox;
    if (item == null || stack == null || !_isDescendant(item, stack)) {
      return null;
    }
    // global → stack-local is more reliable than localToGlobal(ancestor:) when
    // transforms are still settling (common on cold start / MediaQuery updates).
    final Offset itemGlobal = item.localToGlobal(Offset.zero);
    final Offset stackGlobal = stack.localToGlobal(Offset.zero);
    final Rect itemGlobalRect = itemGlobal & item.size;
    final Rect stackGlobalRect = stackGlobal & stack.size;
    // Reject frames where transforms report the item far from the stack
    // (route / keyboard settle often yields a bogus top-of-bar snap).
    if (!itemGlobalRect.overlaps(
      stackGlobalRect.inflate(item.size.longestSide),
    )) {
      return null;
    }
    final Offset topLeft = stack.globalToLocal(itemGlobal);
    final Rect rect = topLeft & item.size;
    if (rect.width <= 0 || rect.height <= 0) {
      return null;
    }
    if (widget.axis == Axis.vertical) {
      return (
        main: rect.center.dy,
        cross: rect.center.dx,
        mainSize: rect.height,
        crossSize: rect.width,
      );
    }
    return (
      main: rect.center.dx,
      cross: rect.center.dy,
      mainSize: rect.width,
      crossSize: rect.height,
    );
  }

  void _refreshCache() {
    for (int i = 0; i < widget.targetKeys.length; i++) {
      final geo = _readGeometry(i);
      if (geo != null) {
        _geoCache[i] = geo;
      }
    }
  }

  bool _isSuspiciousJump({
    required ({double main, double cross, double mainSize, double crossSize})
        live,
    required ({double main, double cross, double mainSize, double crossSize})
        cached,
  }) {
    if (_layoutTracking) {
      return false;
    }
    final double threshold = math.max(cached.mainSize * 2.5, 64);
    return (live.main - cached.main).abs() > threshold;
  }

  ({double main, double cross, double mainSize, double crossSize})? _geometryOf(
    int index,
  ) {
    final live = _readGeometry(index);
    final cached = _geoCache[index];
    if (live != null) {
      if (cached != null &&
          _ready &&
          _isSuspiciousJump(live: live, cached: cached)) {
        // Keep last good geometry; retry once the tree settles.
        _scheduleMeasure(forceJump: false);
        return cached;
      }
      _geoCache[index] = live;
      return live;
    }
    return cached;
  }

  void _sync({bool forceJump = false}) {
    if (!mounted || !widget.enabled) {
      if (_ready) {
        setState(() => _ready = false);
      }
      return;
    }
    final geo = _geometryOf(widget.selectedIndex);
    if (geo == null) {
      // First layout can miss RenderBox sizes; retry on a real next frame.
      if (_measureAttempts++ < 120) {
        _scheduleMeasure(forceJump: forceJump);
      }
      return;
    }
    _measureAttempts = 0;

    final bool geometryChanged = !_ready ||
        (_crossCenter - geo.cross).abs() > 0.5 ||
        (_baseMain - geo.mainSize).abs() > 0.5 ||
        (_crossSize - geo.crossSize).abs() > 0.5 ||
        (!_animating && (_lead.value - geo.main).abs() > 0.5);

    _crossCenter = geo.cross;
    _baseMain = geo.mainSize;
    _crossSize = geo.crossSize;

    if (!_ready || forceJump) {
      _lead.value = geo.main;
      _trail.value = geo.main;
      if (!_ready) {
        setState(() => _ready = true);
      } else if (geometryChanged) {
        setState(() {});
      }
      _refreshCache();
      return;
    }

    if ((_lead.value - geo.main).abs() < 0.5 &&
        (_trail.value - geo.main).abs() < 0.5) {
      if (geometryChanged) {
        setState(() {});
      }
      return;
    }

    _lead
      ..motion = _leadMotion
      ..animateTo(geo.main);
    _trail
      ..motion = _trailMotion
      ..animateTo(geo.main);
    // Ensure host hides resting pills for this travel even if the ticker
    // reports inactive for a beat before the first spring tick.
    _setTraveling(true);
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild/remeasure when safe-area insets change after first paint.
    MediaQuery.viewPaddingOf(context);

    if (widget.enabled && !_ready) {
      _scheduleMeasure(forceJump: true);
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        // Scroll notifications fire before the viewport lays out children at
        // the new offset — remeasure on the following frame.
        _geoCache.clear();
        _scheduleMeasure(forceJump: true);
        return false;
      },
      child: NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (SizeChangedLayoutNotification notification) {
          // Soft remasure keeps last-good geometry if this frame is transitional
          // (keyboard / route MediaQuery), instead of snapping to a bad top.
          _scheduleMeasure(forceJump: !_ready);
          return false;
        },
        child: Stack(
          key: _stackKey,
          clipBehavior: Clip.none,
          children: <Widget>[
            // When [onTravelingChanged] is set, resting fill is owned by the host
            // (cold-start safe). Overlay only paints while traveling.
            if (widget.enabled &&
                _ready &&
                (widget.onTravelingChanged == null || _traveling))
              AnimatedBuilder(
                animation: Listenable.merge(<Listenable>[_lead, _trail]),
                builder: (BuildContext context, Widget? child) {
                  return _buildPill();
                },
              ),
            SizeChangedLayoutNotifier(child: widget.child),
          ],
        ),
      ),
    );
  }

  Widget _buildPill() {
    final double lead = _lead.value;
    final double trail = _trail.value;
    final double minMain = math.min(lead, trail);
    final double maxMain = math.max(lead, trail);
    final double mainExtent = (maxMain - minMain) + _baseMain;
    final double mainStart = minMain - _baseMain / 2;
    final double radius = math.min(_crossSize, _baseMain) / 2;

    if (widget.axis == Axis.vertical) {
      return Positioned(
        left: _crossCenter - _crossSize / 2,
        top: mainStart,
        width: _crossSize,
        height: mainExtent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );
    }
    return Positioned(
      top: _crossCenter - _crossSize / 2,
      left: mainStart,
      height: _crossSize,
      width: mainExtent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
