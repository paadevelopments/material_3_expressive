part of '../m3e_sliders.dart';

/// Drag/tap callbacks for an [M3ESlider] gesture layer.
class _M3ESliderGestures {
  const _M3ESliderGestures({
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
  });

  final GestureDragStartCallback? onHorizontalDragStart;
  final GestureDragUpdateCallback? onHorizontalDragUpdate;
  final GestureDragEndCallback? onHorizontalDragEnd;
  final GestureDragCancelCallback? onHorizontalDragCancel;
  final GestureDragStartCallback? onVerticalDragStart;
  final GestureDragUpdateCallback? onVerticalDragUpdate;
  final GestureDragEndCallback? onVerticalDragEnd;
  final GestureDragCancelCallback? onVerticalDragCancel;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
}

/// Resolved theme values for [M3ESlider] layout.
class _M3ESliderResolved {
  const _M3ESliderResolved({
    required this.sliderTheme,
    required this.colors,
    required this.direction,
    required this.reverse,
    required this.handleThickness,
    required this.indicatorLabel,
    required this.wavelength,
    required this.waveSpeed,
    required this.amplitudeFactor,
    required this.trackThickness,
    required this.thumbLength,
    required this.dotSize,
    required this.dotSpacing,
    required this.useCustomDots,
  });

  final M3ESliderTheme sliderTheme;
  final M3ESliderColors colors;
  final TextDirection direction;
  final bool reverse;
  final double handleThickness;
  final String indicatorLabel;
  final double wavelength;
  final double waveSpeed;
  final double amplitudeFactor;
  final double trackThickness;
  final double thumbLength;
  final double dotSize;
  final double dotSpacing;
  final bool useCustomDots;
}

extension on _M3ESliderState {
  _M3ESliderResolved _resolve(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ESliderTheme sliderTheme = theme.sliderTheme;
    final M3ESliderColors colors = sliderTheme.colors(
      theme.colorScheme,
      enabled: _enabled,
    );
    final TextDirection direction = Directionality.of(context);
    final bool rtl = !_vertical && direction == TextDirection.rtl;
    final bool reverse = _vertical ? !widget.topToBottom : rtl;
    final double handleThickness = _pressed
        ? sliderTheme.pressedHandleWidth
        : (_vertical
              ? M3ESliderTokens.verticalHandleHeight
              : sliderTheme.handleWidth);
    final String indicatorLabel =
        widget.label ??
        (widget.divisions != null
            ? widget.value.round().toString()
            : widget.value.toStringAsFixed(2));
    final double wavelength = widget.wavelength ?? sliderTheme.wavelength;
    final double waveSpeed = widget.waveSpeed ?? wavelength;
    return _M3ESliderResolved(
      sliderTheme: sliderTheme,
      colors: colors,
      direction: direction,
      reverse: reverse,
      handleThickness: handleThickness,
      indicatorLabel: indicatorLabel,
      wavelength: wavelength,
      waveSpeed: waveSpeed,
      amplitudeFactor: _amplitudeFactor(sliderTheme),
      trackThickness: widget.trackThickness ?? sliderTheme.trackHeight,
      thumbLength: widget.thumbLength ?? sliderTheme.handleHeight,
      dotSize: widget.dotSize ?? sliderTheme.stopIndicatorSize,
      dotSpacing: widget.dotSpacing ?? sliderTheme.stopIndicatorTrailingSpace,
      useCustomDots: widget.dotBuilder != null,
    );
  }

  Widget _buildLayout(
    BuildContext context,
    BoxConstraints constraints,
    _M3ESliderResolved resolved,
  ) {
    final double extent = _vertical
        ? constraints.maxHeight
        : constraints.maxWidth;
    final double cross = _vertical
        ? (constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : math.max(resolved.sliderTheme.height, resolved.thumbLength))
        : math.max(resolved.sliderTheme.height, resolved.thumbLength);

    Widget trackLayer = _buildTrackLayer(context, resolved);
    if (_vertical && resolved.reverse) {
      trackLayer = Transform.flip(flipY: true, child: trackLayer);
    }

    final Widget thumb = _buildThumb(context, resolved);
    final double thumbPrimary = resolved.reverse
        ? (1.0 - _fraction) * extent
        : _fraction * extent;

    return _buildGestureStack(
      extent: extent,
      cross: cross,
      trackLayer: trackLayer,
      thumb: thumb,
      thumbPrimary: thumbPrimary,
      resolved: resolved,
    );
  }

  Widget _buildTrackLayer(BuildContext context, _M3ESliderResolved resolved) {
    Widget buildTrack({required double phase}) {
      return widget.trackBuilder?.call(
            context: context,
            colors: resolved.colors,
            theme: resolved.sliderTheme,
            fraction: _fraction,
            tickFractions: _ticks,
            handleThickness: resolved.handleThickness,
          ) ??
          _defaultTrack(resolved, phase: phase);
    }

    Widget track = widget.wavy
        ? AnimatedBuilder(
            animation: _waveController,
            builder: (BuildContext context, Widget? child) {
              return buildTrack(
                phase: _phase(resolved.wavelength, resolved.waveSpeed),
              );
            },
          )
        : buildTrack(phase: 0);

    if (widget.trackIcons != null && widget.trackIcons!.hasAny) {
      track = _TrackIconsOverlay(
        icons: widget.trackIcons!,
        fraction: _fraction,
        trackKind: widget.trackKind,
        axis: widget.axis,
        child: track,
      );
    }

    if (!resolved.useCustomDots) {
      return track;
    }
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        track,
        M3ESliderDotOverlay(
          builder: widget.dotBuilder!,
          mode: M3ESliderPaintMode.single,
          trackKind: widget.trackKind,
          activeStartFraction: 0,
          activeEndFraction: _fraction,
          tickFractions: _ticks,
          colors: resolved.colors,
          trackHeight: resolved.trackThickness,
          handleGap: resolved.sliderTheme.handleGap,
          handleThickness: resolved.handleThickness,
          stopIndicatorSize: resolved.dotSize,
          tickSize: resolved.dotSize,
          edgeInset: resolved.dotSpacing,
          axis: widget.axis,
          textDirection: resolved.direction,
        ),
      ],
    );
  }

  Widget _defaultTrack(_M3ESliderResolved resolved, {required double phase}) {
    if (widget.trackKind == M3ESliderTrackKind.centered) {
      return M3ESliderCenteredTrack(
        fraction: _fraction,
        tickFractions: _ticks,
        colors: resolved.colors,
        theme: resolved.sliderTheme,
        axis: widget.axis,
        textDirection: resolved.direction,
        handleThickness: resolved.handleThickness,
        trackHeight: resolved.trackThickness,
        stopIndicatorSize: resolved.dotSize,
        tickSize: resolved.dotSize,
        edgeInset: resolved.dotSpacing,
        drawDots: !resolved.useCustomDots,
        isWavy: widget.wavy,
        waveAmplitude: resolved.sliderTheme.waveAmplitude,
        wavelength: resolved.wavelength,
        phase: phase,
        amplitudeFactor: resolved.amplitudeFactor,
      );
    }
    return M3ESliderTrack(
      fraction: _fraction,
      tickFractions: _ticks,
      colors: resolved.colors,
      theme: resolved.sliderTheme,
      axis: widget.axis,
      textDirection: resolved.direction,
      handleThickness: resolved.handleThickness,
      trackHeight: resolved.trackThickness,
      stopIndicatorSize: resolved.dotSize,
      tickSize: resolved.dotSize,
      edgeInset: resolved.dotSpacing,
      drawDots: !resolved.useCustomDots,
      isWavy: widget.wavy,
      waveAmplitude: resolved.sliderTheme.waveAmplitude,
      wavelength: resolved.wavelength,
      phase: phase,
      amplitudeFactor: resolved.amplitudeFactor,
    );
  }

  Widget _buildThumb(BuildContext context, _M3ESliderResolved resolved) {
    return widget.thumbBuilder?.call(
          context: context,
          colors: resolved.colors,
          pressed: _pressed,
        ) ??
        M3ESliderThumb(
          color: resolved.colors.thumb,
          pressed: _pressed,
          axis: widget.axis,
          width: _vertical
              ? resolved.thumbLength
              : resolved.sliderTheme.handleWidth,
          height: _vertical
              ? M3ESliderTokens.verticalHandleHeight
              : resolved.thumbLength,
          pressedThickness: resolved.sliderTheme.pressedHandleWidth,
        );
  }

  Widget _buildGestureStack({
    required double extent,
    required double cross,
    required Widget trackLayer,
    required Widget thumb,
    required double thumbPrimary,
    required _M3ESliderResolved resolved,
  }) {
    final gestures = _gestureCallbacks(extent, resolved.reverse);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: gestures.onHorizontalDragStart,
      onHorizontalDragUpdate: gestures.onHorizontalDragUpdate,
      onHorizontalDragEnd: gestures.onHorizontalDragEnd,
      onHorizontalDragCancel: gestures.onHorizontalDragCancel,
      onVerticalDragStart: gestures.onVerticalDragStart,
      onVerticalDragUpdate: gestures.onVerticalDragUpdate,
      onVerticalDragEnd: gestures.onVerticalDragEnd,
      onVerticalDragCancel: gestures.onVerticalDragCancel,
      onTapDown: gestures.onTapDown,
      onTapUp: gestures.onTapUp,
      onTapCancel: gestures.onTapCancel,
      child: _buildStackBody(
        extent: extent,
        cross: cross,
        trackLayer: trackLayer,
        thumb: thumb,
        thumbPrimary: thumbPrimary,
        resolved: resolved,
      ),
    );
  }

  _M3ESliderGestures _gestureCallbacks(double extent, bool reverse) {
    if (!_enabled) {
      return const _M3ESliderGestures();
    }
    if (_vertical) {
      return _verticalGestures(extent, reverse);
    }
    return _horizontalGestures(extent, reverse);
  }

  _M3ESliderGestures _verticalGestures(double extent, bool reverse) {
    return _M3ESliderGestures(
      onVerticalDragStart: _pressStart,
      onVerticalDragUpdate: _verticalDragUpdate(extent, reverse),
      onVerticalDragEnd: _dragEnd,
      onVerticalDragCancel: _endInteraction,
      onTapDown: _tapDown(extent, reverse),
      onTapUp: _tapUp,
      onTapCancel: _endInteraction,
    );
  }

  _M3ESliderGestures _horizontalGestures(double extent, bool reverse) {
    return _M3ESliderGestures(
      onHorizontalDragStart: _pressStart,
      onHorizontalDragUpdate: _horizontalDragUpdate(extent, reverse),
      onHorizontalDragEnd: _dragEnd,
      onHorizontalDragCancel: _endInteraction,
      onTapDown: _tapDown(extent, reverse),
      onTapUp: _tapUp,
      onTapCancel: _endInteraction,
    );
  }

  void _pressStart(DragStartDetails details) {
    setState(() => _pressed = true);
  }

  void _dragEnd(DragEndDetails details) {
    _endInteraction();
  }

  void _tapUp(TapUpDetails details) {
    _endInteraction();
  }

  GestureDragUpdateCallback _verticalDragUpdate(double extent, bool reverse) {
    return (DragUpdateDetails d) {
      _update(d.localPosition.dy, extent, reverse);
    };
  }

  GestureDragUpdateCallback _horizontalDragUpdate(double extent, bool reverse) {
    return (DragUpdateDetails d) {
      _update(d.localPosition.dx, extent, reverse);
    };
  }

  GestureTapDownCallback _tapDown(double extent, bool reverse) {
    return (TapDownDetails d) {
      _onTapDown(d, extent, reverse);
    };
  }

  void _onTapDown(TapDownDetails d, double extent, bool reverse) {
    setState(() => _pressed = true);
    final double primary = _vertical ? d.localPosition.dy : d.localPosition.dx;
    _update(primary, extent, reverse);
  }

  Widget _buildStackBody({
    required double extent,
    required double cross,
    required Widget trackLayer,
    required Widget thumb,
    required double thumbPrimary,
    required _M3ESliderResolved resolved,
  }) {
    return SizedBox(
      width: _vertical ? cross : extent,
      height: _vertical ? extent : cross,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(child: trackLayer),
          Positioned(
            left: _vertical ? null : thumbPrimary - 12,
            top: _vertical ? thumbPrimary - 12 : null,
            width: _vertical ? cross : 24,
            height: _vertical ? 24 : cross,
            child: Center(child: thumb),
          ),
          if (_pressed)
            Positioned(
              left: _vertical ? cross + 8 : thumbPrimary - 24,
              top: _vertical
                  ? thumbPrimary - 12
                  : -resolved.sliderTheme.valueIndicatorBottomSpace - 24,
              child: M3ESliderValueIndicator(
                label: resolved.indicatorLabel,
                colors: resolved.colors,
              ),
            ),
        ],
      ),
    );
  }
}
