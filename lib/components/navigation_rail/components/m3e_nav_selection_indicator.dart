import 'dart:math' as math;

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
  int _layoutTrackId = 0;

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

  @override
  void initState() {
    super.initState();
    _lead = SingleMotionController(motion: _leadMotion, vsync: this);
    _trail = SingleMotionController(motion: _trailMotion, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync(forceJump: true));
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
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _sync(forceJump: true));
    }
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

    WidgetsBinding.instance.addPostFrameCallback((_) => tick());

    final Duration settle = widget.layoutSettleDuration;
    if (settle <= Duration.zero) {
      return;
    }
    final int frames = (settle.inMilliseconds / 16).ceil().clamp(1, 60);
    for (int i = 1; i <= frames; i++) {
      Future<void>.delayed(Duration(milliseconds: 16 * i), tick);
    }
  }

  @override
  void dispose() {
    _layoutTrackId++;
    _lead.dispose();
    _trail.dispose();
    super.dispose();
  }

  RenderBox? _boxOf(GlobalKey key) {
    final BuildContext? ctx = key.currentContext;
    if (ctx == null) {
      return null;
    }
    return ctx.findRenderObject() as RenderBox?;
  }

  RenderBox? get _stackBox =>
      _stackKey.currentContext?.findRenderObject() as RenderBox?;

  ({double main, double cross, double mainSize, double crossSize})? _readGeometry(
    int index,
  ) {
    if (index < 0 || index >= widget.targetKeys.length) {
      return null;
    }
    final RenderBox? item = _boxOf(widget.targetKeys[index]);
    final RenderBox? stack = _stackBox;
    if (item == null || stack == null || !item.hasSize || !stack.hasSize) {
      return null;
    }
    final Offset topLeft = item.localToGlobal(Offset.zero, ancestor: stack);
    final Rect rect = topLeft & item.size;
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
      // First layout: try again next frame.
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _sync(forceJump: forceJump));
      return;
    }

    _crossCenter = geo.cross;
    _baseMain = geo.mainSize;
    _crossSize = geo.crossSize;

    if (!_ready || forceJump) {
      _lead.value = geo.main;
      _trail.value = geo.main;
      if (!_ready) {
        setState(() => _ready = true);
      } else {
        // Geometry-only snap (expand/collapse).
        setState(() {});
      }
      _refreshCache();
      return;
    }

    _lead
      ..motion = _leadMotion
      ..animateTo(geo.main);
    _trail
      ..motion = _trailMotion
      ..animateTo(geo.main);
    // No setState — AnimatedBuilder rebuilds the pill; avoid rebuilding
    // the destination list (that felt like tap latency).
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification n) {
        _refreshCache();
        _sync(forceJump: true);
        return false;
      },
      child: Stack(
        key: _stackKey,
        clipBehavior: Clip.none,
        children: <Widget>[
          if (widget.enabled && _ready)
            AnimatedBuilder(
              animation: Listenable.merge(<Listenable>[_lead, _trail]),
              builder: (BuildContext context, Widget? child) {
                return _buildPill();
              },
            ),
          widget.child,
        ],
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
