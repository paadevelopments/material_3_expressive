// Vendored verbatim from the `expressive_refresh` package
// (https://github.com/alvaronp/expressive-refresh/blob/main/lib/expressive_refresh.dart).
// The logic is kept identical to the reference `ExpressiveRefreshIndicator`;
// only the public names are prefixed with `M3E` and the shared refresh enums
// live in `enums/m3e_refresh_status.dart`.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint, deprecated_member_use
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method
// ignore_for_file: avoid_positional_boolean_parameters, comment_references

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show clampDouble;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/semantics.dart';

import '../../../foundations/foundations.dart';
import 'enums/m3e_refresh_status.dart';
import 'styles/m3e_refresh_indicator_theme.dart';

enum _IndicatorType { material, expressive, contained, adaptive, noSpinner }

/// A Material Design 3 expressive refresh indicator that supports morphing shapes.
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
  }) : _indicatorType = _IndicatorType.expressive,
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
  }) : _indicatorType = _IndicatorType.contained,
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
  }) : _indicatorType = _IndicatorType.material,
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
  }) : _indicatorType = _IndicatorType.adaptive,
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
  }) : _indicatorType = _IndicatorType.noSpinner,
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

  static final Animatable<double> _threeQuarterTween = Tween<double>(begin: 0.0, end: 0.75);
  static final Animatable<double> _kDragSizeFactorLimitTween = Tween<double>(
    begin: 0.0,
    end: M3ERefreshIndicatorTheme.kDragSizeFactorLimit,
  );
  static final Animatable<double> _oneToZeroTween = Tween<double>(begin: 1.0, end: 0.0);

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
    final scheme = M3ETheme.of(context).colorScheme;
    final refreshTheme = M3ETheme.of(context).refreshIndicatorTheme;
    _effectiveValueColor = widget.color ?? refreshTheme.color(scheme);
    final Color color = _effectiveValueColor;
    if (color.alpha == 0x00) {
      _valueColor = AlwaysStoppedAnimation<Color>(color);
    } else {
      _valueColor = _positionController.drive(
        ColorTween(
          begin: color,
          end: color,
        ).chain(CurveTween(curve: const Interval(0.0, 1.0 / M3ERefreshIndicatorTheme.kDragSizeFactorLimit))),
      );
    }
  }

  bool _shouldStart(ScrollNotification notification) {
    return ((notification is ScrollStartNotification && notification.dragDetails != null) ||
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
      if (_status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed) {
        _dismiss(M3ERefreshStatus.canceled);
      }
    } else if (notification is ScrollUpdateNotification) {
      if (_status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed) {
        if (notification.metrics.axisDirection == AxisDirection.down) {
          _dragOffset = _dragOffset! - notification.scrollDelta!;
        } else if (notification.metrics.axisDirection == AxisDirection.up) {
          _dragOffset = _dragOffset! + notification.scrollDelta!;
        }
        _checkDragOffset(notification.metrics.viewportDimension);
      }
      if (_status == M3ERefreshStatus.armed && notification.dragDetails == null) {
        _show();
      }
    } else if (notification is OverscrollNotification) {
      if (_status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed) {
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

  bool _handleIndicatorNotification(OverscrollIndicatorNotification notification) {
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
    assert(_status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed);
    double newValue = _dragOffset! / (containerExtent * M3ERefreshIndicatorTheme.kDragContainerExtentPercentage);
    if (_status == M3ERefreshStatus.armed) {
      newValue = math.max(newValue, 1.0 / M3ERefreshIndicatorTheme.kDragSizeFactorLimit);
    }
    _positionController.value = clampDouble(newValue, 0.0, 1.0);
    if (_status == M3ERefreshStatus.drag &&
        _valueColor.value!.alpha == _effectiveValueColor.alpha) {
      _status = M3ERefreshStatus.armed;
      widget.onStatusChange?.call(_status);
    }
  }

  Future<void> _dismiss(M3ERefreshStatus newMode) async {
    await Future<void>.value();
    assert(newMode == M3ERefreshStatus.canceled || newMode == M3ERefreshStatus.done);
    setState(() {
      _status = newMode;
      widget.onStatusChange?.call(_status);
    });
    switch (_status!) {
      case M3ERefreshStatus.done:
        await _scaleController.animateTo(1.0, duration: M3ERefreshIndicatorTheme.defaults.indicatorScaleDuration);
      case M3ERefreshStatus.canceled:
        await _positionController.animateTo(0.0, duration: M3ERefreshIndicatorTheme.defaults.indicatorScaleDuration);
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
        .animateTo(1.0 / M3ERefreshIndicatorTheme.kDragSizeFactorLimit, duration: M3ERefreshIndicatorTheme.defaults.indicatorSnapDuration)
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
    if (_status != M3ERefreshStatus.refresh && _status != M3ERefreshStatus.snap) {
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

    final bool showIndeterminateIndicator =
        _status == M3ERefreshStatus.refresh || _status == M3ERefreshStatus.done;

    return Stack(
      children: <Widget>[
        child,
        if (_status != null)
          Positioned(
            top: _isIndicatorAtTop! ? widget.edgeOffset : null,
            bottom: !_isIndicatorAtTop! ? widget.edgeOffset : null,
            left: 0.0,
            right: 0.0,
            child: SizeTransition(
              axisAlignment: _isIndicatorAtTop! ? 1.0 : -1.0,
              sizeFactor: _positionFactor,
              child: Padding(
                padding: _isIndicatorAtTop!
                    ? EdgeInsets.only(top: widget.displacement)
                    : EdgeInsets.only(bottom: widget.displacement),
                child: Align(
                  alignment: _isIndicatorAtTop! ? Alignment.topCenter : Alignment.bottomCenter,
                  child: ScaleTransition(
                    scale: _scaleFactor,
                    child: _buildIndicator(context, showIndeterminateIndicator),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIndicator(BuildContext context, bool showIndeterminateIndicator) {
    return AnimatedBuilder(
      animation: _positionController,
      builder: (BuildContext context, Widget? child) {
        switch (widget._indicatorType) {
          case _IndicatorType.expressive:
            return _buildExpressiveIndicator(showIndeterminateIndicator);

          case _IndicatorType.contained:
            return _buildContainedExpressiveIndicator(showIndeterminateIndicator);

          case _IndicatorType.material:
            return _buildMaterialIndicator(context, showIndeterminateIndicator);

          case _IndicatorType.adaptive:
            return _buildAdaptiveIndicator(context, showIndeterminateIndicator);

          case _IndicatorType.noSpinner:
            return Container();
        }
      },
    );
  }

  Widget _buildExpressiveIndicator(bool showIndeterminateIndicator) {
    if (showIndeterminateIndicator) {
      return _ExpressiveLoadingIndicatorImpl(
        color: _effectiveValueColor,
        polygons: widget.polygons,
        constraints: widget.indicatorConstraints,
        semanticsLabel: widget.semanticsLabel,
        semanticsValue: widget.semanticsValue,
      );
    } else {
      return _DragExpressiveIndicator(
        color: _valueColor.value ?? _effectiveValueColor,
        progress: _value.value,
        polygons: widget.polygons,
        constraints: widget.indicatorConstraints,
        semanticsLabel: widget.semanticsLabel,
        semanticsValue: widget.semanticsValue,
      );
    }
  }

  Widget _buildContainedExpressiveIndicator(bool showIndeterminateIndicator) {
    if (showIndeterminateIndicator) {
      return _ContainedExpressiveLoadingIndicator(
        color: _effectiveValueColor,
        backgroundColor: widget.backgroundColor ??
            M3ETheme.of(context)
                .refreshIndicatorTheme
                .containedBackgroundColor(M3ETheme.of(context).colorScheme),
        polygons: widget.polygons,
        constraints: widget.indicatorConstraints,
        semanticsLabel: widget.semanticsLabel,
        semanticsValue: widget.semanticsValue,
      );
    } else {
      return _ContainedDragExpressiveIndicator(
        color: _effectiveValueColor,
        backgroundColor: widget.backgroundColor ??
            M3ETheme.of(context)
                .refreshIndicatorTheme
                .containedBackgroundColor(M3ETheme.of(context).colorScheme),
        progress: _value.value,
        polygons: widget.polygons,
        constraints: widget.indicatorConstraints,
        semanticsLabel: widget.semanticsLabel,
        semanticsValue: widget.semanticsValue,
      );
    }
  }

  Widget _buildMaterialIndicator(BuildContext context, bool showIndeterminateIndicator) {
    return RefreshProgressIndicator(
      semanticsLabel: widget.semanticsLabel ??
          MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
      semanticsValue: widget.semanticsValue,
      value: showIndeterminateIndicator ? null : _value.value,
      valueColor: _valueColor,
      backgroundColor: widget.backgroundColor,
      strokeWidth: widget.strokeWidth,
      elevation: widget.elevation,
    );
  }

  Widget _buildAdaptiveIndicator(BuildContext context, bool showIndeterminateIndicator) {
    switch (M3ETheme.platformOf(context)) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return _buildMaterialIndicator(context, showIndeterminateIndicator);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoActivityIndicator(
          color: widget.color,
        );
    }
  }
}

class _ExpressiveLoadingIndicatorImpl extends StatefulWidget {
  const _ExpressiveLoadingIndicatorImpl({
    required this.color,
    this.polygons,
    this.constraints,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final Color color;
  final List<RoundedPolygon>? polygons;
  final BoxConstraints? constraints;
  final String? semanticsLabel;
  final String? semanticsValue;

  @override
  State<_ExpressiveLoadingIndicatorImpl> createState() => _ExpressiveLoadingIndicatorImplState();
}

class _ExpressiveLoadingIndicatorImplState extends State<_ExpressiveLoadingIndicatorImpl>
    with TickerProviderStateMixin {

  static final List<RoundedPolygon> _defaultPolygons = [
    M3EMaterialNewShapes.softBurst,
    M3EMaterialNewShapes.cookie9Sided,
    M3EMaterialNewShapes.gem,
    M3EMaterialNewShapes.flower,
    M3EMaterialNewShapes.sunny,
    M3EMaterialNewShapes.cookie4Sided,
    M3EMaterialNewShapes.oval,
    M3EMaterialNewShapes.cookie12Sided
  ];

  static final BoxConstraints _defaultConstraints = BoxConstraints(
    minWidth: 48.0,
    minHeight: 48.0,
    maxWidth: 48.0,
    maxHeight: 48.0,
  );

  static const int _globalRotationDurationMs = 4666;
  static const int _morphIntervalMs = 650;
  static const double _fullRotation = 360.0;
  static const double _quarterRotation = _fullRotation / 4;

  late final List<RoundedPolygon> _polygons;
  late final List<Morph> _morphSequence;
  late final AnimationController _morphController;
  late final AnimationController _globalRotationController;

  int _currentMorphIndex = 0;
  double _morphRotationTargetAngle = _quarterRotation;
  Timer? _morphTimer;

  final _morphAnimationSpec = SpringSimulation(
    SpringDescription.withDampingRatio(ratio: 0.6, stiffness: 200.0, mass: 1.0),
    0.0,
    1.0,
    5.0,
    tolerance: const Tolerance(velocity: 0.1, distance: 0.1),
  );

  @override
  void initState() {
    super.initState();

    _polygons = widget.polygons ?? _defaultPolygons;
    _morphSequence = _createMorphSequence(_polygons, circularSequence: true);

    _morphController = AnimationController.unbounded(vsync: this);
    _globalRotationController = AnimationController(
      duration: const Duration(milliseconds: _globalRotationDurationMs),
      vsync: this,
    );

    _startAnimations();
  }

  @override
  void dispose() {
    _morphTimer?.cancel();
    _morphController.dispose();
    _globalRotationController.dispose();
    super.dispose();
  }

  List<Morph> _createMorphSequence(List<RoundedPolygon> polygons, {required bool circularSequence}) {
    final morphs = <Morph>[];
    for (int i = 0; i < polygons.length; i++) {
      if (i + 1 < polygons.length) {
        morphs.add(Morph(polygons[i], polygons[i + 1]));
      } else if (circularSequence) {
        morphs.add(Morph(polygons[i], polygons[0]));
      }
    }
    return morphs;
  }

  void _startAnimations() {
    _globalRotationController.repeat();
    _morphTimer = Timer.periodic(
      const Duration(milliseconds: _morphIntervalMs),
          (_) => _startMorphCycle(),
    );
    _startMorphCycle();
  }

  void _startMorphCycle() {
    if (!mounted) return;

    _currentMorphIndex = (_currentMorphIndex + 1) % _morphSequence.length;
    _morphRotationTargetAngle = (_morphRotationTargetAngle + _quarterRotation) % _fullRotation;

    _morphController.reset();
    _morphController.animateWith(_morphAnimationSpec).then((_) {
      if (mounted && _morphController.value != 1.0) {
        _morphController.value = 1.0;
      }
    });
  }

  double _calculateScaleFactor(List<RoundedPolygon> polygons) {
    var scaleFactor = 1.0;
    for (final polygon in polygons) {
      final bounds = polygon.calculateBounds();
      final maxBounds = polygon.calculateMaxBounds();

      final boundsWidth = bounds[2] - bounds[0];
      final boundsHeight = bounds[3] - bounds[1];
      final maxBoundsWidth = maxBounds[2] - maxBounds[0];
      final maxBoundsHeight = maxBounds[3] - maxBounds[1];

      final scaleX = boundsWidth / maxBoundsWidth;
      final scaleY = boundsHeight / maxBoundsHeight;

      scaleFactor = math.min(scaleFactor, math.max(scaleX, scaleY));
    }
    return scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    final constraints = widget.constraints ?? _defaultConstraints;
    final activeIndicatorScale = 38.0 / math.min(constraints.maxWidth, constraints.maxHeight);
    final shapesScaleFactor = _calculateScaleFactor(_polygons) * activeIndicatorScale;

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: widget.semanticsLabel,
        value: widget.semanticsValue,
      ),
      child: RepaintBoundary(
        child: ConstrainedBox(
          constraints: constraints,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: AnimatedBuilder(
              animation: Listenable.merge([_morphController, _globalRotationController]),
              builder: (context, child) {
                final morphProgress = _morphController.value.clamp(0.0, 1.0);
                final globalRotationDegrees = _globalRotationController.value * _fullRotation;

                final totalRotationDegrees = morphProgress * 90 +
                    _morphRotationTargetAngle + globalRotationDegrees;
                final totalRotationRadians = totalRotationDegrees * (math.pi / 180.0);

                return Transform.rotate(
                  angle: totalRotationRadians,
                  child: CustomPaint(
                    painter: _MorphPainter(
                      morph: _morphSequence[_currentMorphIndex],
                      progress: morphProgress,
                      color: widget.color,
                      scaleFactor: shapesScaleFactor,
                      morphIndex: _currentMorphIndex,
                    ),
                    child: const SizedBox.expand(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DragExpressiveIndicator extends StatelessWidget {
  const _DragExpressiveIndicator({
    required this.color,
    required this.progress,
    this.polygons,
    this.constraints,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final Color color;
  final double progress;
  final List<RoundedPolygon>? polygons;
  final BoxConstraints? constraints;
  final String? semanticsLabel;
  final String? semanticsValue;

  static final List<RoundedPolygon> _defaultPolygons = [
    M3EMaterialNewShapes.circle,
    M3EMaterialNewShapes.softBurst,
  ];

  static final BoxConstraints _defaultConstraints = BoxConstraints(
    minWidth: 48.0,
    minHeight: 48.0,
    maxWidth: 48.0,
    maxHeight: 48.0,
  );

  @override
  Widget build(BuildContext context) {
    final shapes = polygons ?? _defaultPolygons;
    final finalConstraints = constraints ?? _defaultConstraints;

    if (shapes.length < 2) return Container();

    final morphSequence = <Morph>[];
    for (int i = 0; i < shapes.length - 1; i++) {
      morphSequence.add(Morph(shapes[i], shapes[i + 1]));
    }

    final activeMorphIndex = (morphSequence.length * progress).floor().clamp(0, morphSequence.length - 1);
    final adjustedProgress = progress == 1.0 && activeMorphIndex == morphSequence.length - 1
        ? 1.0
        : (progress * morphSequence.length) % 1.0;

    final rotation = -progress * 180 * (math.pi / 180.0);

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: semanticsLabel,
        value: semanticsValue,
      ),
      child: RepaintBoundary(
        child: ConstrainedBox(
          constraints: finalConstraints,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Transform.rotate(
              angle: rotation,
              child: CustomPaint(
                painter: _MorphPainter(
                  morph: morphSequence[activeMorphIndex],
                  progress: adjustedProgress,
                  color: color,
                  scaleFactor: 0.8,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MorphPainter extends CustomPainter {
  final Morph morph;
  final double progress;
  final Color color;
  final double scaleFactor;
  final int morphIndex;

  _MorphPainter({
    required this.morph,
    required this.progress,
    required this.color,
    this.scaleFactor = 1.0,
    this.morphIndex = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.0 || color.alpha == 0) return;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final path = morph.toPath(progress: clampedProgress);
    final processedPath = _processPath(path, size);
    canvas.drawPath(
      processedPath,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(_MorphPainter oldDelegate) {
    return oldDelegate.morph != morph ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.scaleFactor != scaleFactor ||
        oldDelegate.morphIndex != morphIndex;
  }

  Path _processPath(Path path, Size size) {
    final Matrix4 scaleMatrix = Matrix4.diagonal3Values(
      size.width * scaleFactor,
      size.height * scaleFactor,
      1,
    );
    final Path scaledPath = path.transform(scaleMatrix.storage);
    final Rect bounds = scaledPath.getBounds();
    final Offset translation = Offset(size.width / 2, size.height / 2) - bounds.center;
    final Path finalPath = scaledPath.shift(translation);
    return finalPath;
  }
}

class _ContainedExpressiveLoadingIndicator extends StatefulWidget {
  const _ContainedExpressiveLoadingIndicator({
    required this.color,
    required this.backgroundColor,
    this.polygons,
    this.constraints,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final Color color;
  final Color backgroundColor;
  final List<RoundedPolygon>? polygons;
  final BoxConstraints? constraints;
  final String? semanticsLabel;
  final String? semanticsValue;

  @override
  State<_ContainedExpressiveLoadingIndicator> createState() => _ContainedExpressiveLoadingIndicatorState();
}

class _ContainedExpressiveLoadingIndicatorState extends State<_ContainedExpressiveLoadingIndicator>
    with TickerProviderStateMixin {

  static final List<RoundedPolygon> _defaultPolygons = [
    M3EMaterialNewShapes.softBurst,
    M3EMaterialNewShapes.cookie9Sided,
    M3EMaterialNewShapes.gem,
    M3EMaterialNewShapes.flower,
    M3EMaterialNewShapes.sunny,
    M3EMaterialNewShapes.cookie4Sided,
    M3EMaterialNewShapes.oval,
    M3EMaterialNewShapes.cookie12Sided
  ];

  static final BoxConstraints _defaultConstraints = BoxConstraints(
    minWidth: 48.0,
    minHeight: 48.0,
    maxWidth: 48.0,
    maxHeight: 48.0,
  );

  static const int _globalRotationDurationMs = 4666;
  static const int _morphIntervalMs = 650;
  static const double _fullRotation = 360.0;
  static const double _quarterRotation = _fullRotation / 4;

  late final List<RoundedPolygon> _polygons;
  late final List<Morph> _morphSequence;
  late final AnimationController _morphController;
  late final AnimationController _globalRotationController;

  int _currentMorphIndex = 0;
  double _morphRotationTargetAngle = _quarterRotation;
  Timer? _morphTimer;

  final _morphAnimationSpec = SpringSimulation(
    SpringDescription.withDampingRatio(ratio: 0.6, stiffness: 200.0, mass: 1.0),
    0.0,
    1.0,
    5.0,
    tolerance: const Tolerance(velocity: 0.1, distance: 0.1),
  );

  @override
  void initState() {
    super.initState();

    _polygons = widget.polygons ?? _defaultPolygons;
    _morphSequence = _createMorphSequence(_polygons, circularSequence: true);

    _morphController = AnimationController.unbounded(vsync: this);
    _globalRotationController = AnimationController(
      duration: const Duration(milliseconds: _globalRotationDurationMs),
      vsync: this,
    );

    _startAnimations();
  }

  @override
  void dispose() {
    _morphTimer?.cancel();
    _morphController.dispose();
    _globalRotationController.dispose();
    super.dispose();
  }

  List<Morph> _createMorphSequence(List<RoundedPolygon> polygons, {required bool circularSequence}) {
    final morphs = <Morph>[];
    for (int i = 0; i < polygons.length; i++) {
      if (i + 1 < polygons.length) {
        morphs.add(Morph(polygons[i], polygons[i + 1]));
      } else if (circularSequence) {
        morphs.add(Morph(polygons[i], polygons[0]));
      }
    }
    return morphs;
  }

  void _startAnimations() {
    _globalRotationController.repeat();
    _morphTimer = Timer.periodic(
      const Duration(milliseconds: _morphIntervalMs),
          (_) => _startMorphCycle(),
    );
    _startMorphCycle();
  }

  void _startMorphCycle() {
    if (!mounted) return;

    _currentMorphIndex = (_currentMorphIndex + 1) % _morphSequence.length;
    _morphRotationTargetAngle = (_morphRotationTargetAngle + _quarterRotation) % _fullRotation;

    _morphController.reset();
    _morphController.animateWith(_morphAnimationSpec).then((_) {
      if (mounted && _morphController.value != 1.0) {
        _morphController.value = 1.0;
      }
    });
  }

  double _calculateScaleFactor(List<RoundedPolygon> polygons) {
    var scaleFactor = 1.0;
    for (final polygon in polygons) {
      final bounds = polygon.calculateBounds();
      final maxBounds = polygon.calculateMaxBounds();

      final boundsWidth = bounds[2] - bounds[0];
      final boundsHeight = bounds[3] - bounds[1];
      final maxBoundsWidth = maxBounds[2] - maxBounds[0];
      final maxBoundsHeight = maxBounds[3] - maxBounds[1];

      final scaleX = boundsWidth / maxBoundsWidth;
      final scaleY = boundsHeight / maxBoundsHeight;

      scaleFactor = math.min(scaleFactor, math.max(scaleX, scaleY));
    }
    return scaleFactor;
  }

  @override
  Widget build(BuildContext context) {
    final constraints = widget.constraints ?? _defaultConstraints;
    final activeIndicatorScale = 38.0 / math.min(constraints.maxWidth, constraints.maxHeight);
    final shapesScaleFactor = _calculateScaleFactor(_polygons) * activeIndicatorScale;

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: widget.semanticsLabel,
        value: widget.semanticsValue,
      ),
      child: RepaintBoundary(
        child: ConstrainedBox(
          constraints: constraints,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: AnimatedBuilder(
                animation: Listenable.merge([_morphController, _globalRotationController]),
                builder: (context, child) {
                  final morphProgress = _morphController.value.clamp(0.0, 1.0);
                  final globalRotationDegrees = _globalRotationController.value * _fullRotation;

                  final totalRotationDegrees = morphProgress * 90 +
                      _morphRotationTargetAngle + globalRotationDegrees;
                  final totalRotationRadians = totalRotationDegrees * (math.pi / 180.0);

                  return Transform.rotate(
                    angle: totalRotationRadians,
                    child: CustomPaint(
                      painter: _MorphPainter(
                        morph: _morphSequence[_currentMorphIndex],
                        progress: morphProgress,
                        color: widget.color,
                        scaleFactor: shapesScaleFactor,
                        morphIndex: _currentMorphIndex,
                      ),
                      child: const SizedBox.expand(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContainedDragExpressiveIndicator extends StatelessWidget {
  const _ContainedDragExpressiveIndicator({
    required this.color,
    required this.backgroundColor,
    required this.progress,
    this.polygons,
    this.constraints,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final Color color;
  final Color backgroundColor;
  final double progress;
  final List<RoundedPolygon>? polygons;
  final BoxConstraints? constraints;
  final String? semanticsLabel;
  final String? semanticsValue;

  static final List<RoundedPolygon> _defaultPolygons = [
    M3EMaterialNewShapes.circle,
    M3EMaterialNewShapes.softBurst,
  ];

  static final BoxConstraints _defaultConstraints = BoxConstraints(
    minWidth: 48.0,
    minHeight: 48.0,
    maxWidth: 48.0,
    maxHeight: 48.0,
  );

  @override
  Widget build(BuildContext context) {
    final shapes = polygons ?? _defaultPolygons;
    final finalConstraints = constraints ?? _defaultConstraints;

    if (shapes.length < 2) return Container();

    final morphSequence = <Morph>[];
    for (int i = 0; i < shapes.length - 1; i++) {
      morphSequence.add(Morph(shapes[i], shapes[i + 1]));
    }

    final activeMorphIndex = (morphSequence.length * progress).floor().clamp(0, morphSequence.length - 1);
    final adjustedProgress = progress == 1.0 && activeMorphIndex == morphSequence.length - 1
        ? 1.0
        : (progress * morphSequence.length) % 1.0;

    final rotation = -progress * 180 * (math.pi / 180.0);

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: semanticsLabel,
        value: semanticsValue,
      ),
      child: RepaintBoundary(
        child: ConstrainedBox(
          constraints: finalConstraints,
          child: AspectRatio(
            aspectRatio: 1.0,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Transform.rotate(
                angle: rotation,
                child: CustomPaint(
                  painter: _MorphPainter(
                    morph: morphSequence[activeMorphIndex],
                    progress: adjustedProgress.clamp(0.0, 1.0),
                    color: color,
                    scaleFactor: 0.8,
                    morphIndex: activeMorphIndex,
                  ),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
