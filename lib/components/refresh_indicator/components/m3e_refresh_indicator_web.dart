part of '../m3e_refresh_indicator.dart';

/// Web-only helpers. Host (non-web) code paths must not call these.
extension _M3ERefreshIndicatorWeb on M3ERefreshIndicatorState {
  /// Same pad/position math as the host checkDragOffset. Skips the host's
  /// empty setState at the visual cap (that freezes CanvasKit).
  void _checkDragOffsetWeb() {
    assert(
      _status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed,
      'assertion failed',
    );
    final double maxPad = _resolvedContentDragOffset(context);
    _contentPadController.value = math.min(
      math.max(0, _dragOffset ?? 0),
      maxPad,
    );

    final double reveal = _revealProgress(context);
    final double limit = M3ERefreshIndicatorTheme.kDragSizeFactorLimit;
    final double target = reveal / limit;
    if (target != _positionController.value) {
      _positionController.value = clampDouble(target, 0, 1);
    }

    if (_status == M3ERefreshStatus.drag && reveal >= 1.0) {
      _status = M3ERefreshStatus.armed;
      widget.onStatusChange?.call(_status);
    } else if (_status == M3ERefreshStatus.armed && reveal < 1.0) {
      _status = M3ERefreshStatus.drag;
      widget.onStatusChange?.call(_status);
    }
  }

  /// Desktop browsers exclude mouse from [ScrollBehavior.dragDevices], so
  /// click-drag never produces drag details and pull never starts.
  ///
  /// While pulling, block leading underscroll so the only list gap is our
  /// capped pad (matches host). Physics only rejects new underscroll from a
  /// valid position — never when already past min (avoids ballistic assert).
  Widget _wrapWebScrollBehavior(Widget child) {
    final ScrollBehavior behavior = ScrollConfiguration.of(context);
    return ScrollConfiguration(
      behavior: behavior.copyWith(
        dragDevices: <PointerDeviceKind>{
          ...behavior.dragDevices,
          PointerDeviceKind.mouse,
        },
        physics: _M3EWebRefreshScrollPhysics(
          shouldClampLeading: _webShouldClampLeadingOverscroll,
          parent: behavior.getScrollPhysics(context),
        ),
      ),
      child: child,
    );
  }

  bool _webShouldClampLeadingOverscroll() {
    return _status == M3ERefreshStatus.drag ||
        _status == M3ERefreshStatus.armed;
  }

  /// Split list pad vs indicator listenables so the pad spring during refresh
  /// does not rebuild the morph spinner every frame (CanvasKit freeze).
  Widget _buildWebTree(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        AnimatedBuilder(
          animation: _contentPadController,
          builder: (BuildContext context, Widget? _) {
            // Pad is only ever written capped in checkDragOffsetWeb / springs.
            final double maxPad = _resolvedContentDragOffset(context);
            final double pad = math.min(
              math.max(0, _contentPadController.value),
              maxPad,
            );
            return NotificationListener<ScrollNotification>(
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
          },
        ),
        // Do not listen to [_contentPadController] here — its spring during
        // [onRefresh] rebuilds the indicator every frame and freezes CanvasKit.
        AnimatedBuilder(
          animation: Listenable.merge(<Listenable>[
            _positionController,
            _scaleController,
            _bubbleController,
          ]),
          builder: (BuildContext context, Widget? _) {
            if (_status == null) {
              return const SizedBox.shrink();
            }
            return _buildPositionedIndicatorWeb(context);
          },
        ),
      ],
    );
  }

  /// Snap pad spring to 0 once visually settled so list layout stops thrashing.
  Future<void> _springContentPadToZeroWeb() async {
    void stopper() {
      if (_contentPadController.value > 0.5) {
        return;
      }
      _contentPadController.removeListener(stopper);
      if (_contentPadController.isAnimating) {
        _contentPadController.stop(canceled: false);
      }
      _contentPadController.value = 0;
    }

    _contentPadController.addListener(stopper);
    try {
      await _springTo(_contentPadController, target: 0);
    } finally {
      _contentPadController.removeListener(stopper);
      if (_contentPadController.value != 0) {
        _contentPadController.value = 0;
      }
    }
  }

  /// Done dismiss: snap scale once nearly hidden so morph stops painting.
  Future<void> _animateDismissWeb() async {
    switch (_status!) {
      case M3ERefreshStatus.done:
        void stopper() {
          if (_scaleController.value < 0.97) {
            return;
          }
          _scaleController.removeListener(stopper);
          if (_scaleController.isAnimating) {
            _scaleController.stop(canceled: false);
          }
          _scaleController.value = 1;
          if (_contentPadController.isAnimating) {
            _contentPadController.stop(canceled: false);
          }
          _contentPadController.value = 0;
        }

        _scaleController.addListener(stopper);
        try {
          await Future.wait(<Future<void>>[
            _springTo(_scaleController, target: 1),
            _springTo(_contentPadController, target: 0),
          ]);
        } finally {
          _scaleController.removeListener(stopper);
        }
      case M3ERefreshStatus.canceled:
        await Future.wait(<Future<void>>[
          _springTo(_contentPadController, target: 0),
          _springTo(_positionController, target: 0),
        ]);
      case M3ERefreshStatus.armed:
      case M3ERefreshStatus.drag:
      case M3ERefreshStatus.refresh:
      case M3ERefreshStatus.snap:
        assert(false, 'assertion failed');
    }
  }

  /// Web indicator: host Opacity + scale reveal; morph elevation stays 0
  /// (path drawShadow freezes CanvasKit). Spinner is cached in RepaintBoundary.
  Widget _buildPositionedIndicatorWeb(BuildContext context) {
    final bool atTop = _isIndicatorAtTop!;
    final bool showIndeterminate =
        _status == M3ERefreshStatus.refresh || _status == M3ERefreshStatus.done;
    final double reveal = _revealProgress(context);
    final double inset = _indicatorInset(context);
    final double bubble = switch (_status) {
      M3ERefreshStatus.refresh ||
      M3ERefreshStatus.snap => _bubbleController.value,
      _ => 1.0,
    };
    final bool dragDriven = switch (_status) {
      M3ERefreshStatus.drag ||
      M3ERefreshStatus.armed ||
      M3ERefreshStatus.canceled => true,
      _ => false,
    };

    final Widget indicatorChild;
    if (_usesMorphLoadingIndicator) {
      final _WebSpinnerPhase phase = dragDriven
          ? _WebSpinnerPhase.drag
          : _WebSpinnerPhase.refresh;
      final Widget cached;
      final Widget? existing = _webSpinnerCache;
      if (existing == null ||
          _webSpinnerPhase != phase ||
          _webSpinnerType != widget._indicatorType) {
        _webSpinnerPhase = phase;
        _webSpinnerType = widget._indicatorType;
        cached = _buildWebMorphSpinner(dragDriven: dragDriven);
        _webSpinnerCache = cached;
      } else {
        cached = existing;
      }
      if (dragDriven) {
        final double turns = math.max(0, _dragOffset ?? 0) / 80;
        indicatorChild = Transform.rotate(
          angle: turns * 2 * math.pi,
          child: cached,
        );
      } else {
        indicatorChild = cached;
      }
    } else {
      _clearWebSpinnerCache();
      indicatorChild = _buildIndicator(context, showIndeterminate);
    }

    return Positioned(
      top: atTop ? widget.edgeOffset + inset : null,
      bottom: atTop ? null : widget.edgeOffset + inset,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Align(
          alignment: atTop ? Alignment.topCenter : Alignment.bottomCenter,
          child: Opacity(
            opacity: reveal.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: reveal * bubble,
              alignment: atTop ? Alignment.topCenter : Alignment.bottomCenter,
              child: indicatorChild,
            ),
          ),
        ),
      ),
    );
  }

  bool get _usesMorphLoadingIndicator => switch (widget._indicatorType) {
    _IndicatorType.expressive || _IndicatorType.contained => true,
    _ => false,
  };

  void _clearWebSpinnerCache() {
    _webSpinnerCache = null;
    _webSpinnerPhase = _WebSpinnerPhase.none;
    _webSpinnerType = null;
  }

  /// Elevation 0 on web — morph drawShadow under drag transforms freezes
  /// CanvasKit. [RepaintBoundary] keeps scale/rotate from re-painting morph.
  Widget _buildWebMorphSpinner({required bool dragDriven}) {
    final M3ELoadingIndicatorVariant variant =
        widget._indicatorType == _IndicatorType.contained
        ? M3ELoadingIndicatorVariant.contained
        : M3ELoadingIndicatorVariant.defaultStyle;
    return RepaintBoundary(
      child: M3ELoadingIndicator(
        key: ValueKey<String>(
          dragDriven
              ? 'm3e_refresh_web_drag_spinner'
              : 'm3e_refresh_web_refresh_spinner',
        ),
        variant: variant,
        color: _effectiveValueColor,
        containerColor: _effectiveContainerColor,
        polygons: widget.polygons,
        constraints: widget.indicatorConstraints,
        semanticLabel: widget.semanticsLabel,
        semanticValue: widget.semanticsValue,
        // Drag: frozen morph, outer Transform.rotate. Refresh: internal spin.
        rotationTurns: dragDriven ? 0 : null,
        elevation: 0,
      ),
    );
  }
}

/// Blocks new leading underscroll while pulling so list gap is only our pad.
///
/// Only rejects movement from a valid position into underscroll. Does not run
/// when pixels are already past min (that caused AlwaysScrollable ballistic
/// "invalid overscroll" asserts).
class _M3EWebRefreshScrollPhysics extends ScrollPhysics {
  const _M3EWebRefreshScrollPhysics({
    required this.shouldClampLeading,
    super.parent,
  });

  final bool Function() shouldClampLeading;

  @override
  _M3EWebRefreshScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _M3EWebRefreshScrollPhysics(
      shouldClampLeading: shouldClampLeading,
      parent: buildParent(ancestor),
    );
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    if (shouldClampLeading() &&
        position.pixels >= position.minScrollExtent &&
        value < position.minScrollExtent) {
      return value - position.minScrollExtent;
    }
    return super.applyBoundaryConditions(position, value);
  }
}
