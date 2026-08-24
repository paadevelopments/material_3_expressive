import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/physics.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundations/foundations.dart';
import '../loading_indicator/m3e_loading_indicator.dart';
import 'controllers/m3e_refresh_indicator_controller.dart';
import 'enums/m3e_refresh_status.dart';
import 'styles/m3e_refresh_indicator_theme.dart';

export 'controllers/m3e_refresh_indicator_controller.dart';
export 'enums/m3e_refresh_status.dart';
export 'styles/m3e_refresh_indicator_theme.dart';

part 'components/m3e_refresh_indicator_scroll.dart';
part 'components/m3e_refresh_indicator_build.dart';

enum _IndicatorType { material, expressive, contained, adaptive, noSpinner }

/// A Material Design 3 expressive refresh indicator.
///
/// Expressive and contained variants use [M3ELoadingIndicator] for the spinner.
///
/// Call [M3ERefreshIndicatorState.show] via a [GlobalKey], or pass a
/// [M3ERefreshIndicatorController] to trigger refresh programmatically.
class M3ERefreshIndicator extends StatefulWidget {
  /// const.
  const M3ERefreshIndicator({
    super.key,
    required this.child,
    this.displacement = M3ERefreshIndicatorTheme.kDefaultDisplacement,
    this.contentDragOffset,
    this.edgeOffset = M3ERefreshIndicatorTheme.kDefaultEdgeOffset,
    required this.onRefresh,
    this.controller,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.triggerMode = M3ERefreshTriggerMode.onEdge,
    this.elevation = M3ERefreshIndicatorTheme.kDefaultElevation,
    this.polygons,
    this.indicatorConstraints,
    this.onStatusChange,
  }) : _indicatorType = _IndicatorType.expressive,
       strokeWidth = 0.0,
       assert(elevation >= 0.0, 'assertion failed'),
       assert(!(polygons != null) || polygons.length > 1, 'assertion failed');

  /// const.

  const M3ERefreshIndicator.contained({
    super.key,
    required this.child,
    this.displacement = M3ERefreshIndicatorTheme.kDefaultDisplacement,
    this.contentDragOffset,
    this.edgeOffset = M3ERefreshIndicatorTheme.kDefaultEdgeOffset,
    required this.onRefresh,
    this.controller,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.triggerMode = M3ERefreshTriggerMode.onEdge,
    this.elevation = M3ERefreshIndicatorTheme.kDefaultElevation,
    this.polygons,
    this.indicatorConstraints,
    this.onStatusChange,
  }) : _indicatorType = _IndicatorType.contained,
       strokeWidth = 0.0,
       assert(elevation >= 0.0, 'assertion failed'),
       assert(!(polygons != null) || polygons.length > 1, 'assertion failed');

  /// const.

  const M3ERefreshIndicator.material({
    super.key,
    required this.child,
    this.displacement = M3ERefreshIndicatorTheme.kDefaultDisplacement,
    this.contentDragOffset,
    this.edgeOffset = M3ERefreshIndicatorTheme.kDefaultEdgeOffset,
    required this.onRefresh,
    this.controller,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    this.triggerMode = M3ERefreshTriggerMode.onEdge,
    this.elevation = M3ERefreshIndicatorTheme.kDefaultElevation,
    this.onStatusChange,
  }) : _indicatorType = _IndicatorType.material,
       polygons = null,
       indicatorConstraints = null,
       assert(elevation >= 0.0, 'assertion failed');

  /// const.

  const M3ERefreshIndicator.adaptive({
    super.key,
    required this.child,
    this.displacement = M3ERefreshIndicatorTheme.kDefaultDisplacement,
    this.contentDragOffset,
    this.edgeOffset = M3ERefreshIndicatorTheme.kDefaultEdgeOffset,
    required this.onRefresh,
    this.controller,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    this.triggerMode = M3ERefreshTriggerMode.onEdge,
    this.elevation = M3ERefreshIndicatorTheme.kDefaultElevation,
    this.onStatusChange,
  }) : _indicatorType = _IndicatorType.adaptive,
       polygons = null,
       indicatorConstraints = null,
       assert(elevation >= 0.0, 'assertion failed');

  /// const.

  const M3ERefreshIndicator.noSpinner({
    super.key,
    required this.child,
    required this.onRefresh,
    this.controller,
    this.onStatusChange,
    this.contentDragOffset,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.triggerMode = M3ERefreshTriggerMode.onEdge,
    this.elevation = M3ERefreshIndicatorTheme.kDefaultElevation,
  }) : _indicatorType = _IndicatorType.noSpinner,
       displacement = 0.0,
       edgeOffset = 0.0,
       color = null,
       backgroundColor = null,
       strokeWidth = 0.0,
       polygons = null,
       indicatorConstraints = null,
       assert(elevation >= 0.0, 'assertion failed');

  /// final.

  final Widget child;

  /// Resting offset of the indicator below the scroll edge.
  final double displacement;

  /// Max list top padding while dragging. Defaults to [displacement]
  /// (or [M3ERefreshIndicatorTheme.kDefaultDisplacement] when displacement is 0).
  /// Does not move the indicator's drop edge.
  final double? contentDragOffset;

  /// final.
  final double edgeOffset;

  /// final.
  final M3ERefreshCallback onRefresh;

  /// Optional controller to call [M3ERefreshIndicatorController.show].
  final M3ERefreshIndicatorController? controller;

  /// final.
  final ValueChanged<M3ERefreshStatus?>? onStatusChange;

  /// final.
  final Color? color;

  /// final.
  final Color? backgroundColor;

  /// final.
  final ScrollNotificationPredicate notificationPredicate;

  /// final.
  final String? semanticsLabel;

  /// final.
  final String? semanticsValue;

  /// final.
  final double strokeWidth;

  /// final.
  final M3ERefreshTriggerMode triggerMode;

  /// final.
  final double elevation;
  final _IndicatorType _indicatorType;

  /// final.
  final List<RoundedPolygon>? polygons;

  /// final.
  final BoxConstraints? indicatorConstraints;

  @override
  M3ERefreshIndicatorState createState() => M3ERefreshIndicatorState();
}

/// class.

class M3ERefreshIndicatorState extends State<M3ERefreshIndicator>
    with TickerProviderStateMixin<M3ERefreshIndicator> {
  late AnimationController _positionController;
  late AnimationController _scaleController;
  late AnimationController _contentPadController;
  late Animation<double> _scaleFactor;
  late Animation<double> _value;
  late Animation<Color?> _valueColor;

  M3ERefreshStatus? _status;
  late Future<void> _pendingRefreshFuture;
  bool? _isIndicatorAtTop;
  double? _dragOffset;
  late Color _effectiveValueColor;
  late Color _effectiveContainerColor;

  static final Animatable<double> _threeQuarterTween = Tween<double>(
    begin: 0,
    end: 0.75,
  );
  static final Animatable<double> _oneToZeroTween = Tween<double>(
    begin: 1,
    end: 0,
  );

  double get _resolvedContentDragOffset {
    if (widget.contentDragOffset != null) {
      return widget.contentDragOffset!;
    }
    if (widget.displacement > 0) {
      return widget.displacement;
    }
    return M3ERefreshIndicatorTheme.kDefaultDisplacement;
  }

  @override
  void initState() {
    super.initState();
    // Unbounded so expressive spatial springs can overshoot settle targets.
    _positionController = AnimationController.unbounded(vsync: this);
    _value = _positionController.drive(_threeQuarterTween);
    _scaleController = AnimationController.unbounded(vsync: this);
    _scaleFactor = _scaleController.drive(_oneToZeroTween);
    _contentPadController = AnimationController.unbounded(vsync: this);
    _pendingRefreshFuture = Future<void>.value();
    widget.controller?.attach(show);
  }

  @override
  void didChangeDependencies() {
    _setupColorTween();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant M3ERefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach();
      widget.controller?.attach(show);
    }
    if (oldWidget.color != widget.color) {
      _setupColorTween();
    }
  }

  @override
  void dispose() {
    widget.controller?.detach();
    _positionController.dispose();
    _scaleController.dispose();
    _contentPadController.dispose();
    super.dispose();
  }

  /// Shows the refresh indicator and runs [M3ERefreshIndicator.onRefresh].
  ///
  /// Same entry point used by [M3ERefreshIndicatorController.show] and a
  /// [GlobalKey] for [M3ERefreshIndicatorState].
  Future<void> show({bool atTop = true}) {
    if (_status != M3ERefreshStatus.refresh &&
        _status != M3ERefreshStatus.snap) {
      if (_status == null) {
        _start(atTop ? AxisDirection.down : AxisDirection.up);
      }
      _show();
    }
    return _pendingRefreshFuture;
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge(<Listenable>[
          _positionController,
          _scaleController,
          _contentPadController,
        ]),
        builder: (BuildContext context, Widget? _) {
          final double pad = _contentPad(context);
          final Widget child = NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification n) =>
                _handleScrollNotification(n),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification n) =>
                  _handleIndicatorNotification(n),
              child: Padding(
                padding: EdgeInsets.only(
                  top: (_isIndicatorAtTop ?? false) ? pad : 0,
                  bottom: _isIndicatorAtTop == false ? pad : 0,
                ),
                child: widget.child,
              ),
            ),
          );

          return Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              child,
              if (_status != null) _buildPositionedIndicator(context),
            ],
          );
        },
      ),
    );
  }
}
