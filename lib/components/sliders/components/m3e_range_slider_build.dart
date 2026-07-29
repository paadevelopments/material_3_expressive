part of '../m3e_range_slider.dart';

/// Resolved theme values for [M3ERangeSlider] layout.
class _M3ERangeSliderResolved {
  const _M3ERangeSliderResolved({
    required this.sliderTheme,
    required this.colors,
    required this.direction,
    required this.rtl,
    required this.handleThickness,
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
  final bool rtl;
  final double handleThickness;
  final double wavelength;
  final double waveSpeed;
  final double amplitudeFactor;
  final double trackThickness;
  final double thumbLength;
  final double dotSize;
  final double dotSpacing;
  final bool useCustomDots;
}

extension on _M3ERangeSliderState {
  _M3ERangeSliderResolved _resolve(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ESliderTheme baseSliderTheme = theme.sliderTheme;
    final M3ESliderTheme sliderTheme = _showFocusOutline
        ? baseSliderTheme.copyWith(handleGap: baseSliderTheme.handleGap + 4)
        : baseSliderTheme;
    final M3ESliderColors colors = sliderTheme.colors(
      theme.colorScheme,
      enabled: _enabled,
    );
    final TextDirection direction = Directionality.of(context);
    final double wavelength = widget.wavelength ?? sliderTheme.wavelength;
    return _M3ERangeSliderResolved(
      sliderTheme: sliderTheme,
      colors: colors,
      direction: direction,
      rtl: direction == TextDirection.rtl,
      handleThickness: _pressed
          ? sliderTheme.pressedHandleWidth
          : sliderTheme.handleWidth,
      wavelength: wavelength,
      waveSpeed: widget.waveSpeed ?? wavelength,
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
    _M3ERangeSliderResolved resolved,
  ) {
    final double width = constraints.maxWidth;
    final double height = math.max(
      resolved.sliderTheme.height,
      resolved.thumbLength,
    );
    final Widget track = _buildTrackLayer(resolved);
    final double startX = _thumbX(_startFraction, width, resolved.rtl);
    final double endX = _thumbX(_endFraction, width, resolved.rtl);

    final Widget gestureDetector = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: !_enabled
          ? null
          : (DragStartDetails d) =>
                _selectThumb(d.localPosition.dx, startX, endX),
      onHorizontalDragUpdate: !_enabled
          ? null
          : (DragUpdateDetails d) =>
                _update(d.localPosition.dx, width, resolved.rtl),
      onHorizontalDragEnd: !_enabled ? null : (_) => _endInteraction(),
      onHorizontalDragCancel: !_enabled ? null : _endInteraction,
      onTapDown: !_enabled
          ? null
          : (TapDownDetails d) {
              _selectThumb(d.localPosition.dx, startX, endX);
              _update(d.localPosition.dx, width, resolved.rtl);
            },
      onTapUp: !_enabled ? null : (_) => _endInteraction(),
      onTapCancel: !_enabled ? null : _endInteraction,
      child: _buildStackBody(
        width: width,
        height: height,
        track: track,
        startX: startX,
        endX: endX,
        resolved: resolved,
      ),
    );
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      canRequestFocus: _enabled,
      onKeyEvent: _handleKeyEvent,
      child: MouseRegion(
        cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        child: gestureDetector,
      ),
    );
  }

  void _selectThumb(double dx, double startX, double endX) {
    _isFocusedFromPointer = true;
    _focusNode.requestFocus();
    _dragging = true;
    final double distStart = (dx - startX).abs();
    final double distEnd = (dx - endX).abs();
    setState(() {
      _activeThumb = distStart <= distEnd
          ? _M3ERangeThumb.start
          : _M3ERangeThumb.end;
    });
  }

  double _thumbX(double fraction, double width, bool rtl) {
    final double f = rtl ? 1.0 - fraction : fraction;
    return f * width;
  }

  Widget _buildTrackLayer(_M3ERangeSliderResolved resolved) {
    Widget buildTrack({required double phase}) {
      return M3ERangeSliderTrack(
        startFraction: _startFraction,
        endFraction: _endFraction,
        tickFractions: _ticks,
        colors: resolved.colors,
        theme: resolved.sliderTheme,
        axis: Axis.horizontal,
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

    final Widget track = widget.wavy
        ? AnimatedBuilder(
            animation: _waveController,
            builder: (BuildContext context, Widget? child) {
              return buildTrack(
                phase: _phase(resolved.wavelength, resolved.waveSpeed),
              );
            },
          )
        : buildTrack(phase: 0);

    if (!resolved.useCustomDots) {
      return track;
    }
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        track,
        M3ESliderDotOverlay(
          builder: widget.dotBuilder!,
          mode: M3ESliderPaintMode.range,
          trackKind: M3ESliderTrackKind.standard,
          activeStartFraction: _startFraction,
          activeEndFraction: _endFraction,
          tickFractions: _ticks,
          colors: resolved.colors,
          trackHeight: resolved.trackThickness,
          handleGap: resolved.sliderTheme.handleGap,
          handleThickness: resolved.handleThickness,
          stopIndicatorSize: resolved.dotSize,
          tickSize: resolved.dotSize,
          edgeInset: resolved.dotSpacing,
          axis: Axis.horizontal,
          textDirection: resolved.direction,
        ),
      ],
    );
  }

  Widget _buildThumb({
    required bool pressed,
    required bool focused,
    required _M3ERangeSliderResolved resolved,
  }) {
    return M3ESliderThumb(
      color: resolved.colors.thumb,
      pressed: pressed,
      focused: focused,
      width: resolved.sliderTheme.handleWidth,
      height: resolved.thumbLength,
      pressedThickness: resolved.sliderTheme.pressedHandleWidth,
    );
  }

  Widget _buildStackBody({
    required double width,
    required double height,
    required Widget track,
    required double startX,
    required double endX,
    required _M3ERangeSliderResolved resolved,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(child: track),
          Positioned(
            left: startX - 12,
            width: 24,
            height: height,
            child: Center(
              child: _buildThumb(
                pressed: _activeThumb == _M3ERangeThumb.start,
                focused:
                    _showFocusOutline && _keyboardThumb == _M3ERangeThumb.start,
                resolved: resolved,
              ),
            ),
          ),
          Positioned(
            left: endX - 12,
            width: 24,
            height: height,
            child: Center(
              child: _buildThumb(
                pressed: _activeThumb == _M3ERangeThumb.end,
                focused:
                    _showFocusOutline && _keyboardThumb == _M3ERangeThumb.end,
                resolved: resolved,
              ),
            ),
          ),
          if (_pressed)
            Positioned(
              left: (_activeThumb == _M3ERangeThumb.start ? startX : endX) - 24,
              top: -resolved.sliderTheme.valueIndicatorBottomSpace - 24,
              child: M3ESliderValueIndicator(
                label: _indicatorLabel(),
                colors: resolved.colors,
              ),
            ),
        ],
      ),
    );
  }
}
