part of '../m3e_refresh_indicator.dart';

/// Web-only helpers. Host (non-web) code paths must not call these.
extension _M3ERefreshIndicatorWeb on M3ERefreshIndicatorState {
  /// Diagnostic console logs. Enabled when [debugTraceRefresh] is true
  /// (any platform). Uses [print] so Flutter web does not throttle them away.
  ///
  /// Filter for `[M3ERefresh#` in the terminal running `flutter run` / Chrome
  /// DevTools console.
  void _webLog(String step, [String? detail]) {
    if (!M3ERefreshIndicatorState.debugTraceRefresh) {
      return;
    }
    final extra = detail == null ? '' : ' | $detail';
    // Diagnostic tracing for the web freeze investigation; print is intentional.
    // ignore: avoid_print
    print('[M3ERefresh#${++_webLogSeq} kIsWeb=$kIsWeb] $step$extra');
  }

  /// Flutter web (CanvasKit) freezes when [_checkDragOffset] does an empty
  /// [setState] on every overscroll after the pad/position are already at cap:
  /// each rebuild relayouts the scrollable and repaints the morphing spinner.
  ///
  /// This path updates animation controllers only when values change and never
  /// calls empty [setState].
  void _checkDragOffsetWeb() {
    _webLog(
      'checkDragOffsetWeb:enter',
      'status=$_status dragOffset=$_dragOffset '
          'padCtrl=${_contentPadController.value.toStringAsFixed(2)} '
          'posCtrl=${_positionController.value.toStringAsFixed(4)}',
    );
    assert(
      _status == M3ERefreshStatus.drag || _status == M3ERefreshStatus.armed,
      'assertion failed',
    );
    final double maxPad = _resolvedContentDragOffset(context);
    final double nextPad = math.min(math.max(0, _dragOffset ?? 0), maxPad);
    final bool padChanged =
        (nextPad - _contentPadController.value).abs() > 1e-6;
    if (padChanged) {
      _webLog(
        'checkDragOffsetWeb:pad',
        '${nextPad.toStringAsFixed(2)} '
            '(was ${_contentPadController.value.toStringAsFixed(2)})',
      );
      _contentPadController.value = nextPad;
      _webLog('checkDragOffsetWeb:padApplied');
    }

    final double reveal = _revealProgress(context);
    final double limit = M3ERefreshIndicatorTheme.kDragSizeFactorLimit;
    final double target = clampDouble(reveal / limit, 0, 1);
    final bool posChanged = (target - _positionController.value).abs() > 1e-6;
    if (posChanged) {
      _webLog(
        'checkDragOffsetWeb:position',
        'target=${target.toStringAsFixed(4)} '
            'reveal=${reveal.toStringAsFixed(3)}',
      );
      _positionController.value = target;
      _webLog('checkDragOffsetWeb:positionApplied');
    } else {
      _webLog(
        'checkDragOffsetWeb:skipSetStateAtCap',
        'target=${target.toStringAsFixed(4)} '
            'reveal=${reveal.toStringAsFixed(3)} '
            '(host would setState here)',
      );
    }

    if (_status == M3ERefreshStatus.drag && reveal >= 1.0) {
      _webLog('checkDragOffsetWeb:arm');
      _status = M3ERefreshStatus.armed;
      widget.onStatusChange?.call(_status);
    } else if (_status == M3ERefreshStatus.armed && reveal < 1.0) {
      _webLog('checkDragOffsetWeb:disarm');
      _status = M3ERefreshStatus.drag;
      widget.onStatusChange?.call(_status);
    }
    _webLog('checkDragOffsetWeb:exit', 'status=$_status');
  }

  /// Desktop browsers exclude mouse from [ScrollBehavior.dragDevices], so
  /// click-drag never produces drag details and pull never starts.
  Widget _wrapWebScrollBehavior(Widget child) {
    _webLog('wrapWebScrollBehavior');
    final ScrollBehavior behavior = ScrollConfiguration.of(context);
    return ScrollConfiguration(
      behavior: behavior.copyWith(
        dragDevices: <PointerDeviceKind>{
          ...behavior.dragDevices,
          PointerDeviceKind.mouse,
        },
      ),
      child: child,
    );
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
            final double pad = _contentPad(context);
            _webLog(
              'build:webPad',
              'pad=$pad status=$_status dragOffset=$_dragOffset',
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
        // Reveal/inset during drag track [_positionController]; dismiss uses
        // [_scaleController]. Do not listen to [_contentPadController] here —
        // its spring keeps ticking near 0 for the whole [onRefresh] wait.
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
      // canceled: false so animateWith's future completes (not TickerCanceled).
      if (_contentPadController.isAnimating) {
        _contentPadController.stop(canceled: false);
      }
      _contentPadController.value = 0;
      _webLog('webPad:snapZero');
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
          // canceled: false — default stop() aborts dismiss and leaves status=done.
          if (_scaleController.isAnimating) {
            _scaleController.stop(canceled: false);
          }
          _scaleController.value = 1;
          if (_contentPadController.isAnimating) {
            _contentPadController.stop(canceled: false);
          }
          _contentPadController.value = 0;
          _webLog('webDismiss:snapDone');
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

  /// Web indicator: cached flat morph spinner + transforms only (no per-tick
  /// rotationTurns updates, elevation shadows, or Opacity saveLayer).
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

    _webLog(
      'indicatorWeb:build',
      'reveal=${reveal.toStringAsFixed(3)} dragDriven=$dragDriven '
          'status=$_status',
    );

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
        _webLog('indicatorWeb:cacheSpinner', 'phase=$phase');
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

    // Scale-only reveal (no Opacity saveLayer) for all web phases.
    return Positioned(
      top: atTop ? widget.edgeOffset + inset : null,
      bottom: atTop ? null : widget.edgeOffset + inset,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Align(
          alignment: atTop ? Alignment.topCenter : Alignment.bottomCenter,
          child: Transform.scale(
            scale: reveal * bubble,
            alignment: atTop ? Alignment.topCenter : Alignment.bottomCenter,
            child: indicatorChild,
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

  Widget _buildWebMorphSpinner({required bool dragDriven}) {
    final M3ELoadingIndicatorVariant variant =
        widget._indicatorType == _IndicatorType.contained
        ? M3ELoadingIndicatorVariant.contained
        : M3ELoadingIndicatorVariant.defaultStyle;
    return M3ELoadingIndicator(
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
    );
  }
}
