part of '../m3e_refresh_indicator.dart';

/// Scroll, drag, and refresh lifecycle helpers for [M3ERefreshIndicatorState].
extension _M3ERefreshIndicatorScroll on M3ERefreshIndicatorState {
  void _setupColorTween() {
    final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
    final M3ERefreshIndicatorTheme refreshTheme = M3ETheme.of(
      context,
    ).refreshIndicatorTheme;

    if (widget._indicatorType == _IndicatorType.contained) {
      _effectiveValueColor =
          widget.color ?? refreshTheme.containedActiveColor(scheme);
      _effectiveContainerColor =
          widget.backgroundColor ??
          refreshTheme.containedContainerColor(scheme);
    } else {
      _effectiveValueColor = widget.color ?? refreshTheme.activeColor(scheme);
      _effectiveContainerColor =
          widget.backgroundColor ?? refreshTheme.containerColorDefault();
    }

    final Color color = _effectiveValueColor;
    if (color.a == 0.0) {
      _valueColor = AlwaysStoppedAnimation<Color>(color);
    } else {
      _valueColor = _positionController.drive(
        ColorTween(
          begin: color.withValues(alpha: 0),
          end: color.withValues(alpha: color.a),
        ).chain(
          CurveTween(
            curve: const Interval(
              0,
              1.0 / M3ERefreshIndicatorTheme.kDragSizeFactorLimit,
            ),
          ),
        ),
      );
    }
  }

  bool _isAtLeadingEdge(ScrollMetrics metrics) {
    return switch (metrics.axisDirection) {
      AxisDirection.down => metrics.extentBefore == 0.0,
      AxisDirection.up => metrics.extentAfter == 0.0,
      AxisDirection.left || AxisDirection.right => false,
    };
  }

  bool _isPullingPastLeadingEdge(OverscrollNotification notification) {
    return switch (notification.metrics.axisDirection) {
      // Dragging down past the top (or up past the bottom).
      AxisDirection.down => notification.overscroll < 0.0,
      AxisDirection.up => notification.overscroll > 0.0,
      AxisDirection.left || AxisDirection.right => false,
    };
  }

  bool _shouldStart(ScrollNotification notification) {
    if (_status != null || !_isAtLeadingEdge(notification.metrics)) {
      return false;
    }
    if (!_isStartGesture(notification)) {
      return false;
    }
    return _start(notification.metrics.axisDirection);
  }

  bool _isStartGesture(ScrollNotification notification) {
    final bool startedFromEdgeDrag =
        notification is ScrollStartNotification &&
        notification.dragDetails != null &&
        widget.triggerMode == M3ERefreshTriggerMode.onEdge;
    final bool startedFromAnywhereDrag =
        notification is ScrollUpdateNotification &&
        notification.dragDetails != null &&
        widget.triggerMode == M3ERefreshTriggerMode.anywhere;
    // Also start on a real leading-edge overscroll so a drag-down at the top
    // still works when ScrollStart was consumed by a parent scrollable.
    final bool startedFromOverscroll =
        notification is OverscrollNotification &&
        notification.dragDetails != null &&
        _isPullingPastLeadingEdge(notification);
    return startedFromEdgeDrag ||
        startedFromAnywhereDrag ||
        startedFromOverscroll;
  }

  void _applyDragDelta(ScrollNotification notification) {
    final double? delta = _dragDeltaFrom(notification);
    if (delta != null) {
      _dragOffset = _dragOffset! + delta;
    }
    _checkDragOffset(notification.metrics.viewportDimension);
  }

  double? _dragDeltaFrom(ScrollNotification notification) {
    final AxisDirection direction = notification.metrics.axisDirection;
    if (notification is ScrollUpdateNotification &&
        notification.scrollDelta != null) {
      return _signedDragDelta(direction, notification.scrollDelta!);
    }
    if (notification is OverscrollNotification) {
      return _signedDragDelta(direction, notification.overscroll);
    }
    return null;
  }

  double? _signedDragDelta(AxisDirection direction, double amount) {
    return switch (direction) {
      AxisDirection.down => -amount,
      AxisDirection.up => amount,
      AxisDirection.left || AxisDirection.right => null,
    };
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (!widget.notificationPredicate(notification)) {
      return false;
    }
    if (_tryBeginDrag(notification)) {
      return false;
    }
    if (_abortIfAxisChanged(notification) ||
        _abortIfLeftLeadingEdge(notification)) {
      return false;
    }
    _continueActiveDrag(notification);
    return false;
  }

  bool _tryBeginDrag(ScrollNotification notification) {
    if (!_shouldStart(notification)) {
      return false;
    }
    setState(() {
      _status = M3ERefreshStatus.drag;
      widget.onStatusChange?.call(_status);
    });
    // Apply this notification's delta so the first overscroll is not lost.
    _applyDragDelta(notification);
    return true;
  }

  bool _abortIfAxisChanged(ScrollNotification notification) {
    final bool? indicatorAtTopNow =
        switch (notification.metrics.axisDirection) {
          AxisDirection.down || AxisDirection.up => true,
          AxisDirection.left || AxisDirection.right => null,
        };
    if (indicatorAtTopNow == _isIndicatorAtTop) {
      return false;
    }
    if (_status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed) {
      _dismiss(M3ERefreshStatus.canceled);
    }
    return true;
  }

  bool _abortIfLeftLeadingEdge(ScrollNotification notification) {
    // Scrolled away from the top into content — abandon the pull.
    final bool pulling =
        _status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed;
    if (!pulling || _isAtLeadingEdge(notification.metrics)) {
      return false;
    }
    _dismiss(M3ERefreshStatus.canceled);
    return true;
  }

  void _continueActiveDrag(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      _handleScrollUpdate(notification);
    } else if (notification is OverscrollNotification) {
      _handleOverscroll(notification);
    } else if (notification is ScrollEndNotification) {
      _handleScrollEnd();
    }
  }

  void _handleScrollUpdate(ScrollUpdateNotification notification) {
    if (_status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed) {
      _applyDragDelta(notification);
    }
    if (_status == M3ERefreshStatus.armed && notification.dragDetails == null) {
      _show();
    }
  }

  void _handleOverscroll(OverscrollNotification notification) {
    if (_status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed) {
      _applyDragDelta(notification);
    }
  }

  void _handleScrollEnd() {
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
    assert(_status == null, 'assertion failed');
    assert(_isIndicatorAtTop == null, 'assertion failed');
    assert(_dragOffset == null, 'assertion failed');
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
    _contentPadController.value = 0.0;
    return true;
  }

  void _checkDragOffset(double containerExtent) {
    assert(
      _status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed,
      'assertion failed',
    );
    double newValue =
        _dragOffset! /
        (containerExtent *
            M3ERefreshIndicatorTheme.kDragContainerExtentPercentage);
    if (_status == M3ERefreshStatus.armed) {
      newValue = math.max(
        newValue,
        1.0 / M3ERefreshIndicatorTheme.kDragSizeFactorLimit,
      );
    }
    final double clamped = clampDouble(newValue, 0, 1);
    // Keep content pad in sync (capped) while dragging.
    _contentPadController.value = math.min(
      math.max(0, _dragOffset ?? 0),
      _resolvedContentDragOffset,
    );
    // Rebuild even when the controller is saturated so the indicator can still
    // settle at its snap cap while the finger keeps moving.
    if (clamped == _positionController.value) {
      setState(() {});
    } else {
      _positionController.value = clamped;
    }
    // Arm once the drag passes Material's armed threshold (same point where
    // the value-color fade completes).
    if (_status == M3ERefreshStatus.drag &&
        _positionController.value >=
            1.0 / M3ERefreshIndicatorTheme.kDragSizeFactorLimit) {
      _status = M3ERefreshStatus.armed;
      widget.onStatusChange?.call(_status);
    }
  }

  Future<void> _dismiss(M3ERefreshStatus newMode) async {
    await Future<void>.value();
    assert(
      newMode == M3ERefreshStatus.canceled || newMode == M3ERefreshStatus.done,
      'assertion failed',
    );

    if (newMode == M3ERefreshStatus.canceled && _dragOffset != null) {
      // Continuity: start the retract animation from the current visual pull.
      if (!mounted) {
        return;
      }
      _syncPositionToVisualPull();
      _contentPadController.value = math.min(
        _visualPull(context),
        _resolvedContentDragOffset,
      );
    }

    setState(() {
      _status = newMode;
      widget.onStatusChange?.call(_status);
    });
    await _animateDismiss();
    if (mounted && _status == newMode) {
      _dragOffset = null;
      _isIndicatorAtTop = null;
      setState(() {
        _status = null;
      });
    }
  }

  void _syncPositionToVisualPull() {
    final double height = _indicatorHeight(context);
    final double limit = M3ERefreshIndicatorTheme.kDragSizeFactorLimit;
    final double currentPull = _visualPull(context);
    _positionController.value =
        (currentPull / (limit * (widget.displacement + height))).clamp(
          0.0,
          1.0,
        );
  }

  Future<void> _springTo(
    AnimationController controller, {
    required double target,
  }) {
    return controller.animateWith(
      SpringSimulation(
        M3EMotion.expressiveSpatialDefault.toDescription(),
        controller.value,
        target,
        controller.velocity,
      ),
    );
  }

  Future<void> _animateDismiss() async {
    switch (_status!) {
      case M3ERefreshStatus.done:
        await Future.wait(<Future<void>>[
          _springTo(_scaleController, target: 1),
          _springTo(_contentPadController, target: 0),
        ]);
      case M3ERefreshStatus.canceled:
        await Future.wait(<Future<void>>[
          _springTo(_positionController, target: 0),
          _springTo(_contentPadController, target: 0),
        ]);
      case M3ERefreshStatus.armed:
      case M3ERefreshStatus.drag:
      case M3ERefreshStatus.refresh:
      case M3ERefreshStatus.snap:
        assert(false, 'assertion failed');
    }
  }

  void _show() {
    assert(_status != M3ERefreshStatus.refresh, 'assertion failed');
    assert(_status != M3ERefreshStatus.snap, 'assertion failed');
    final completer = Completer<void>();
    _pendingRefreshFuture = completer.future;

    // Keep the indicator where it visually is, then animate to the resting
    // refresh offset (displacement below the edge).
    _syncPositionToVisualPull();
    _contentPadController.value = math.min(
      _visualPull(context),
      _resolvedContentDragOffset,
    );

    _status = M3ERefreshStatus.snap;
    widget.onStatusChange?.call(_status);

    final double limit = M3ERefreshIndicatorTheme.kDragSizeFactorLimit;
    Future.wait(<Future<void>>[
      _springTo(_positionController, target: 1.0 / limit),
      _springTo(_contentPadController, target: 0),
    ]).then<void>((_) {
      _onSnapComplete(completer);
    });
  }

  void _onSnapComplete(Completer<void> completer) {
    if (!mounted || _status != M3ERefreshStatus.snap) {
      return;
    }
    setState(() {
      _status = M3ERefreshStatus.refresh;
      widget.onStatusChange?.call(_status);
    });

    widget.onRefresh().whenComplete(() {
      if (mounted && _status == M3ERefreshStatus.refresh) {
        completer.complete();
        _dismiss(M3ERefreshStatus.done);
      }
    });
  }
}
