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
    final bool traveling = _animating;
    if (traveling == _traveling) {
      return;
    }
    setState(() => _traveling = traveling);
    widget.onTravelingChanged?.call(traveling);
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
    // Safe-area / MediaQuery often settles after the first frame in release.
    _scheduleMeasure(forceJump: true);
  }

  /// Remeasure through a layout transition (expand/collapse) so the pill
  /// matches the new item size/position without a selection morph.
  void _trackLayoutChange() {
    final int track = ++_layoutTrackId;
    _geoCache.clear();
    void tick() {
      if (!mounted || track != _layoutTrackId) {
        return;
      }
      _sync(forceJump: true);
    }

    _scheduleMeasure(forceJump: true);

    final Duration settle = widget.layoutSettleDuration;
    if (settle <= Duration.zero) {
      return;
    }
    final int frames = (settle.inMilliseconds / 16).ceil().clamp(1, 60);
    for (int i = 1; i <= frames; i++) {
      Future<void>.delayed(Duration(milliseconds: 16 * i), tick);
    }
  }

  /// Post-frame measure, and [scheduleFrame] so release builds retry when idle.
  void _scheduleMeasure({required bool forceJump}) {
    if (_measureScheduled) {
      return;
    }
    _measureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureScheduled = false;
      if (!mounted) {
        return;
      }
      _sync(forceJump: forceJump);
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
    final Offset topLeft = stack.globalToLocal(item.localToGlobal(Offset.zero));
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

  ({double main, double cross, double mainSize, double crossSize})? _geometryOf(
    int index,
  ) {
    final live = _readGeometry(index);
    if (live != null) {
      _geoCache[index] = live;
      return live;
    }
    return _geoCache[index];
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
    if (!_traveling) {
      setState(() => _traveling = true);
      widget.onTravelingChanged?.call(true);
    }
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
          _geoCache.clear();
          _scheduleMeasure(forceJump: !_animating);
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
