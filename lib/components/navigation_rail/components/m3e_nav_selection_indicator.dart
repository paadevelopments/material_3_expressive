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
    super.key,
  });

  final int selectedIndex;
  final List<GlobalKey> targetKeys;
  final Axis axis;
  final Color color;
  final Widget child;
  final bool enabled;

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
      WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
    } else if (oldWidget.targetKeys.length != widget.targetKeys.length ||
        oldWidget.enabled != widget.enabled) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _sync(forceJump: true));
    }
  }

  @override
  void dispose() {
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

  /// Target center along the main axis + geometry, in stack-local coords.
  ({double main, double cross, double mainSize, double crossSize})? _geometryOf(
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

  void _sync({bool forceJump = false}) {
    if (!mounted || !widget.enabled) {
      if (_ready) {
        setState(() => _ready = false);
      }
      return;
    }
    final geo = _geometryOf(widget.selectedIndex);
    if (geo == null) {
      return;
    }

    _crossCenter = geo.cross;
    _baseMain = geo.mainSize;
    _crossSize = geo.crossSize;

    if (!_ready || forceJump) {
      _lead.value = geo.main;
      _trail.value = geo.main;
      setState(() => _ready = true);
      return;
    }

    _lead
      ..motion = _leadMotion
      ..animateTo(geo.main);
    _trail
      ..motion = _trailMotion
      ..animateTo(geo.main);
    // Cross-axis / size may change (expand/collapse); refresh layout.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification n) {
        _sync();
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
    final double radius = _crossSize / 2;

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
