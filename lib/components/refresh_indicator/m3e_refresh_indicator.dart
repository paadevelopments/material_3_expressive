import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';

import '../../foundations/foundations.dart';
import '../loading_indicator/m3e_loading_indicator.dart';
import 'enums/m3e_refresh_status.dart';
import 'styles/m3e_refresh_indicator_theme.dart';

export 'enums/m3e_refresh_status.dart';
export 'styles/m3e_refresh_indicator_theme.dart';

enum _IndicatorType { material, expressive, contained, adaptive, noSpinner }

/// A Material Design 3 expressive refresh indicator.
///
/// Expressive and contained variants use [M3ELoadingIndicator] for the spinner.
class M3ERefreshIndicator extends StatefulWidget {
  const M3ERefreshIndicator({
    super.key,
    required this.child,
    this.displacement = M3ERefreshIndicatorTheme.kDefaultDisplacement,
    this.edgeOffset = M3ERefreshIndicatorTheme.kDefaultEdgeOffset,
    required this.onRefresh,
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
  })  : _indicatorType = _IndicatorType.expressive,
        strokeWidth = 0.0,
        assert(elevation >= 0.0),
        assert(polygons != null ? polygons.length > 1 : true);

  const M3ERefreshIndicator.contained({
    super.key,
    required this.child,
    this.displacement = M3ERefreshIndicatorTheme.kDefaultDisplacement,
    this.edgeOffset = M3ERefreshIndicatorTheme.kDefaultEdgeOffset,
    required this.onRefresh,
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
  })  : _indicatorType = _IndicatorType.contained,
        strokeWidth = 0.0,
        assert(elevation >= 0.0),
        assert(polygons != null ? polygons.length > 1 : true);

  const M3ERefreshIndicator.material({
    super.key,
    required this.child,
    this.displacement = M3ERefreshIndicatorTheme.kDefaultDisplacement,
    this.edgeOffset = M3ERefreshIndicatorTheme.kDefaultEdgeOffset,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    this.triggerMode = M3ERefreshTriggerMode.onEdge,
    this.elevation = M3ERefreshIndicatorTheme.kDefaultElevation,
    this.onStatusChange,
  })  : _indicatorType = _IndicatorType.material,
        polygons = null,
        indicatorConstraints = null,
        assert(elevation >= 0.0);

  const M3ERefreshIndicator.adaptive({
    super.key,
    required this.child,
    this.displacement = M3ERefreshIndicatorTheme.kDefaultDisplacement,
    this.edgeOffset = M3ERefreshIndicatorTheme.kDefaultEdgeOffset,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = RefreshProgressIndicator.defaultStrokeWidth,
    this.triggerMode = M3ERefreshTriggerMode.onEdge,
    this.elevation = M3ERefreshIndicatorTheme.kDefaultElevation,
    this.onStatusChange,
  })  : _indicatorType = _IndicatorType.adaptive,
        polygons = null,
        indicatorConstraints = null,
        assert(elevation >= 0.0);

  const M3ERefreshIndicator.noSpinner({
    super.key,
    required this.child,
    required this.onRefresh,
    this.onStatusChange,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.triggerMode = M3ERefreshTriggerMode.onEdge,
    this.elevation = M3ERefreshIndicatorTheme.kDefaultElevation,
  })  : _indicatorType = _IndicatorType.noSpinner,
        displacement = 0.0,
        edgeOffset = 0.0,
        color = null,
        backgroundColor = null,
        strokeWidth = 0.0,
        polygons = null,
        indicatorConstraints = null,
        assert(elevation >= 0.0);

  final Widget child;
  final double displacement;
  final double edgeOffset;
  final M3ERefreshCallback onRefresh;
  final ValueChanged<M3ERefreshStatus?>? onStatusChange;
  final Color? color;
  final Color? backgroundColor;
  final ScrollNotificationPredicate notificationPredicate;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double strokeWidth;
  final M3ERefreshTriggerMode triggerMode;
  final double elevation;
  final _IndicatorType _indicatorType;
  final List<RoundedPolygon>? polygons;
  final BoxConstraints? indicatorConstraints;

  @override
  M3ERefreshIndicatorState createState() => M3ERefreshIndicatorState();
}

class M3ERefreshIndicatorState extends State<M3ERefreshIndicator>
    with TickerProviderStateMixin<M3ERefreshIndicator> {
  late AnimationController _positionController;
  late AnimationController _scaleController;
  late Animation<double> _positionFactor;
  late Animation<double> _scaleFactor;
  late Animation<double> _value;
  late Animation<Color?> _valueColor;

  M3ERefreshStatus? _status;
  late Future<void> _pendingRefreshFuture;
  bool? _isIndicatorAtTop;
  double? _dragOffset;
  late Color _effectiveValueColor;
  late Color _effectiveContainerColor;

  static final Animatable<double> _threeQuarterTween =
      Tween<double>(begin: 0.0, end: 0.75);
  static final Animatable<double> _kDragSizeFactorLimitTween = Tween<double>(
    begin: 0.0,
    end: M3ERefreshIndicatorTheme.kDragSizeFactorLimit,
  );
  static final Animatable<double> _oneToZeroTween =
      Tween<double>(begin: 1.0, end: 0.0);

  @override
  void initState() {
    super.initState();
    _positionController = AnimationController(vsync: this);
    _positionFactor = _positionController.drive(_kDragSizeFactorLimitTween);
    _value = _positionController.drive(_threeQuarterTween);
    _scaleController = AnimationController(vsync: this);
    _scaleFactor = _scaleController.drive(_oneToZeroTween);
  }

  @override
  void didChangeDependencies() {
    _setupColorTween();
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant M3ERefreshIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      _setupColorTween();
    }
  }

  @override
  void dispose() {
    _positionController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _setupColorTween() {
    final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
    final M3ERefreshIndicatorTheme refreshTheme =
        M3ETheme.of(context).refreshIndicatorTheme;

    if (widget._indicatorType == _IndicatorType.contained) {
      _effectiveValueColor = widget.color ?? refreshTheme.activeColor(scheme);
      _effectiveContainerColor = widget.backgroundColor ?? refreshTheme.containerColorDefault();
    } else {
      _effectiveValueColor = widget.color ?? refreshTheme.containedActiveColor(scheme);
      _effectiveContainerColor = widget.backgroundColor ?? refreshTheme.containedContainerColor(scheme);
    }

    final Color color = _effectiveValueColor;
    if (color.a == 0.0) {
      _valueColor = AlwaysStoppedAnimation<Color>(color);
    } else {
      _valueColor = _positionController.drive(
        ColorTween(begin: color, end: color).chain(
          CurveTween(
            curve: const Interval(
              0.0,
              1.0 / M3ERefreshIndicatorTheme.kDragSizeFactorLimit,
            ),
          ),
        ),
      );
    }
  }

  bool _shouldStart(ScrollNotification notification) {
    return ((notification is ScrollStartNotification &&
                notification.dragDetails != null) ||
            (notification is ScrollUpdateNotification &&
                notification.dragDetails != null &&
                widget.triggerMode == M3ERefreshTriggerMode.anywhere)) &&
        ((notification.metrics.axisDirection == AxisDirection.up &&
                notification.metrics.extentAfter == 0.0) ||
            (notification.metrics.axisDirection == AxisDirection.down &&
                notification.metrics.extentBefore == 0.0)) &&
        _status == null &&
        _start(notification.metrics.axisDirection);
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) {
      return false;
    }
    if (_shouldStart(notification)) {
      setState(() {
        _status = M3ERefreshStatus.drag;
        widget.onStatusChange?.call(_status);
      });
      return false;
    }
    final bool? indicatorAtTopNow = switch (notification.metrics.axisDirection) {
      AxisDirection.down || AxisDirection.up => true,
      AxisDirection.left || AxisDirection.right => null,
    };
    if (indicatorAtTopNow != _isIndicatorAtTop) {
      if (_status == M3ERefreshStatus.drag ||
          _status == M3ERefreshStatus.armed) {
        _dismiss(M3ERefreshStatus.canceled);
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_status == M3ERefreshStatus.drag ||
          _status == M3ERefreshStatus.armed) {
        if (notification.metrics.axisDirection == AxisDirection.down) {
          _dragOffset = _dragOffset! - notification.scrollDelta!;
        } else if (notification.metrics.axisDirection == AxisDirection.up) {
          _dragOffset = _dragOffset! + notification.scrollDelta!;
        }
        _checkDragOffset(notification.metrics.viewportDimension);
      }
      if (_status == M3ERefreshStatus.armed &&
          notification.dragDetails == null) {
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_status == M3ERefreshStatus.drag ||
          _status == M3ERefreshStatus.armed) {
        if (notification.metrics.axisDirection == AxisDirection.down) {
          _dragOffset = _dragOffset! - notification.overscroll;
        } else if (notification.metrics.axisDirection == AxisDirection.up) {
          _dragOffset = _dragOffset! + notification.overscroll;
        }
        _checkDragOffset(notification.metrics.viewportDimension);
      }
    } else if (notification is ScrollEndNotification) {
      switch (_status) {
        case M3ERefreshStatus.armed:
          if (_positionController.value < 1.0) {
            _dismiss(M3ERefreshStatus.canceled);
          } else {
            _show();
          }
        case M3ERefreshStatus.drag:
          _dismiss(M3ERefreshStatus.canceled);
        case M3ERefreshStatus.canceled:
        case M3ERefreshStatus.done:
        case M3ERefreshStatus.refresh:
        case M3ERefreshStatus.snap:
        case null:
          break;
      }
    }
    return false;
  }

  bool _handleIndicatorNotification(
    OverscrollIndicatorNotification notification,
  ) {
    if (notification.depth != 0 || !notification.leading) {
      return false;
    }
    if (_status == M3ERefreshStatus.drag) {
      notification.disallowIndicator();
      return true;
    }
    return false;
  }

  bool _start(AxisDirection direction) {
    assert(_status == null);
    assert(_isIndicatorAtTop == null);
    assert(_dragOffset == null);
    switch (direction) {
      case AxisDirection.down:
      case AxisDirection.up:
        _isIndicatorAtTop = true;
      case AxisDirection.left:
      case AxisDirection.right:
        _isIndicatorAtTop = null;
        return false;
    }
    _dragOffset = 0.0;
    _scaleController.value = 0.0;
    _positionController.value = 0.0;
    return true;
  }

  void _checkDragOffset(double containerExtent) {
    assert(
      _status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed,
    );
    double newValue = _dragOffset! /
        (containerExtent *
            M3ERefreshIndicatorTheme.kDragContainerExtentPercentage);
    if (_status == M3ERefreshStatus.armed) {
      newValue = math.max(
        newValue,
        1.0 / M3ERefreshIndicatorTheme.kDragSizeFactorLimit,
      );
    }
    _positionController.value = clampDouble(newValue, 0.0, 1.0);
    if (_status == M3ERefreshStatus.drag &&
        _valueColor.value!.a == _effectiveValueColor.a) {
      _status = M3ERefreshStatus.armed;
      widget.onStatusChange?.call(_status);
    }
  }

  Future<void> _dismiss(M3ERefreshStatus newMode) async {
    await Future<void>.value();
    assert(
      newMode == M3ERefreshStatus.canceled || newMode == M3ERefreshStatus.done,
    );
    setState(() {
      _status = newMode;
      widget.onStatusChange?.call(_status);
    });
    switch (_status!) {
      case M3ERefreshStatus.done:
        await _scaleController.animateTo(
          1.0,
          duration:
              M3ERefreshIndicatorTheme.defaults.indicatorScaleDuration,
        );
      case M3ERefreshStatus.canceled:
        await _positionController.animateTo(
          0.0,
          duration:
              M3ERefreshIndicatorTheme.defaults.indicatorScaleDuration,
        );
      case M3ERefreshStatus.armed:
      case M3ERefreshStatus.drag:
      case M3ERefreshStatus.refresh:
      case M3ERefreshStatus.snap:
        assert(false);
    }
    if (mounted && _status == newMode) {
      _dragOffset = null;
      _isIndicatorAtTop = null;
      setState(() {
        _status = null;
      });
    }
  }

  void _show() {
    assert(_status != M3ERefreshStatus.refresh);
    assert(_status != M3ERefreshStatus.snap);
    final Completer<void> completer = Completer<void>();
    _pendingRefreshFuture = completer.future;
    _status = M3ERefreshStatus.snap;
    widget.onStatusChange?.call(_status);
    _positionController
        .animateTo(
          1.0 / M3ERefreshIndicatorTheme.kDragSizeFactorLimit,
          duration: M3ERefreshIndicatorTheme.defaults.indicatorSnapDuration,
        )
        .then<void>((void value) {
      if (mounted && _status == M3ERefreshStatus.snap) {
        setState(() {
          _status = M3ERefreshStatus.refresh;
          widget.onStatusChange?.call(_status);
        });

        final Future<void> refreshResult = widget.onRefresh();
        refreshResult.whenComplete(() {
          if (mounted && _status == M3ERefreshStatus.refresh) {
            completer.complete();
            _dismiss(M3ERefreshStatus.done);
          }
        });
      }
    });
  }

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
    final Widget child = NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: _handleIndicatorNotification,
        child: widget.child,
      ),
    );

    return M3EComponentTheme(
      builder: (BuildContext context) => Stack(
        clipBehavior: Clip.hardEdge,
        children: <Widget>[
          child,
          if (_status != null)
            AnimatedBuilder(
              animation: Listenable.merge(
                <Listenable>[_positionController, _scaleController],
              ),
              builder: (BuildContext context, Widget? _) {
                return _buildPositionedIndicator(context);
              },
            ),
        ],
      ),
    );
  }

  /// Pull distance from the list edge. Starts at 0 (top edge) and grows with
  /// drag — no padded SizeTransition reveal, so the indicator does not jump in.
  double get _edgePullOffset =>
      _positionFactor.value * widget.displacement;

  Widget _buildPositionedIndicator(BuildContext context) {
    final bool atTop = _isIndicatorAtTop!;
    final bool showIndeterminate = _status == M3ERefreshStatus.refresh ||
        _status == M3ERefreshStatus.done;
    final double pull = _edgePullOffset;
    // Fade in over the first ~15% of drag so touch-down at the edge doesn't
    // flash a full indicator before the pull begins.
    final double reveal =
        (_positionController.value / 0.15).clamp(0.0, 1.0);

    return Positioned(
      top: atTop ? widget.edgeOffset + pull : null,
      bottom: atTop ? null : widget.edgeOffset + pull,
      left: 0.0,
      right: 0.0,
      child: IgnorePointer(
        child: Opacity(
          opacity: reveal,
          child: Align(
            alignment: atTop ? Alignment.topCenter : Alignment.bottomCenter,
            child: ScaleTransition(
              scale: _scaleFactor,
              child: _buildIndicator(context, showIndeterminate),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, bool showIndeterminate) {
    switch (widget._indicatorType) {
      case _IndicatorType.expressive:
        return _buildLoadingIndicator(
          showIndeterminate: showIndeterminate,
          variant: M3ELoadingIndicatorVariant.defaultStyle,
        );
      case _IndicatorType.contained:
        return _buildLoadingIndicator(
          showIndeterminate: showIndeterminate,
          variant: M3ELoadingIndicatorVariant.contained,
        );
      case _IndicatorType.material:
        return _buildMaterialIndicator(context, showIndeterminate);
      case _IndicatorType.adaptive:
        return _buildAdaptiveIndicator(context, showIndeterminate);
      case _IndicatorType.noSpinner:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLoadingIndicator({
    required bool showIndeterminate,
    required M3ELoadingIndicatorVariant variant,
  }) {
    final Color color = showIndeterminate
        ? _effectiveValueColor
        : (_valueColor.value ?? _effectiveValueColor);
    final Widget indicator = M3ELoadingIndicator(
      variant: variant,
      color: color,
      containerColor: _effectiveContainerColor,
      polygons: widget.polygons,
      constraints: widget.indicatorConstraints,
      semanticLabel: widget.semanticsLabel,
      semanticValue: widget.semanticsValue,
    );

    if (showIndeterminate) {
      return indicator;
    }

    // During drag, grow the loading indicator with pull progress.
    final double t = (_value.value / 0.75).clamp(0.0, 1.0);
    return Transform.scale(
      scale: 0.55 + 0.45 * Curves.easeOut.transform(t),
      child: indicator,
    );
  }

  Widget _buildMaterialIndicator(
    BuildContext context,
    bool showIndeterminate,
  ) {
    return RefreshProgressIndicator(
      semanticsLabel: widget.semanticsLabel ??
          MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
      semanticsValue: widget.semanticsValue,
      value: showIndeterminate ? null : _value.value,
      valueColor: _valueColor,
      backgroundColor: widget.backgroundColor,
      strokeWidth: widget.strokeWidth,
      elevation: widget.elevation,
    );
  }

  Widget _buildAdaptiveIndicator(
    BuildContext context,
    bool showIndeterminate,
  ) {
    switch (M3ETheme.platformOf(context)) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return _buildMaterialIndicator(context, showIndeterminate);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoActivityIndicator(color: widget.color);
    }
  }
}
