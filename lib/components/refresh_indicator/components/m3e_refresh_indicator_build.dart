part of '../m3e_refresh_indicator.dart';

/// Indicator geometry and spinner builders for [M3ERefreshIndicatorState].
extension _M3ERefreshIndicatorBuild on M3ERefreshIndicatorState {
  double _indicatorHeight(BuildContext context) {
    final double? maxHeight = widget.indicatorConstraints?.maxHeight;
    if (maxHeight != null && maxHeight.isFinite) {
      return maxHeight;
    }
    return M3ETheme.of(context).loadingIndicatorTheme.containerHeight;
  }

  /// Max visual travel during drag: resting refresh position
  /// (`top == displacement`).
  double _maxVisualPull(BuildContext context) =>
      widget.displacement + _indicatorHeight(context);

  /// Finger pull clamped to the snap cap.
  double _visualPull(BuildContext context) {
    return math.min(math.max(0, _dragOffset ?? 0.0), _maxVisualPull(context));
  }

  /// Pull distance in pixels used for positioning.
  ///
  /// Drag/armed follow the finger via [_dragOffset] until the snap cap.
  /// Animated phases derive pull from [_positionFactor] so the resting refresh
  /// position is [M3ERefreshIndicator.displacement] below the edge.
  double _pullDistance(BuildContext context) {
    final double height = _indicatorHeight(context);
    switch (_status) {
      case M3ERefreshStatus.drag:
      case M3ERefreshStatus.armed:
        return _visualPull(context);
      case M3ERefreshStatus.snap:
      case M3ERefreshStatus.refresh:
      case M3ERefreshStatus.done:
      case M3ERefreshStatus.canceled:
        // positionFactor 1.0 → pull = displacement + height → top = displacement.
        return _positionFactor.value * (widget.displacement + height);
      case null:
        return 0;
    }
  }

  Widget _buildPositionedIndicator(BuildContext context) {
    final bool atTop = _isIndicatorAtTop!;
    final bool showIndeterminate =
        _status == M3ERefreshStatus.refresh || _status == M3ERefreshStatus.done;
    final double height = _indicatorHeight(context);
    final double pull = _pullDistance(context);
    // pull 0 → fully above the clip; as the user drags, the indicator slides
    // out of the top edge and continues downward with the finger.
    final double inset = pull - height;

    return Positioned(
      top: atTop ? widget.edgeOffset + inset : null,
      bottom: atTop ? null : widget.edgeOffset + inset,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Align(
          alignment: atTop ? Alignment.topCenter : Alignment.bottomCenter,
          child: ScaleTransition(
            scale: _scaleFactor,
            alignment: atTop ? Alignment.topCenter : Alignment.bottomCenter,
            child: _buildIndicator(context, showIndeterminate),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, bool showIndeterminate) {
    switch (widget._indicatorType) {
      case _IndicatorType.expressive:
        return _buildLoadingIndicator(
          variant: M3ELoadingIndicatorVariant.defaultStyle,
        );
      case _IndicatorType.contained:
        return _buildLoadingIndicator(
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

  Widget _buildLoadingIndicator({required M3ELoadingIndicatorVariant variant}) {
    // Keep loading indicators fully opaque; reveal is the edge slide-in.
    return M3ELoadingIndicator(
      variant: variant,
      color: _effectiveValueColor,
      containerColor: _effectiveContainerColor,
      polygons: widget.polygons,
      constraints: widget.indicatorConstraints,
      semanticLabel: widget.semanticsLabel,
      semanticValue: widget.semanticsValue,
    );
  }

  Widget _buildMaterialIndicator(BuildContext context, bool showIndeterminate) {
    return RefreshProgressIndicator(
      semanticsLabel:
          widget.semanticsLabel ??
          MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
      semanticsValue: widget.semanticsValue,
      value: showIndeterminate ? null : _value.value,
      valueColor: _valueColor,
      backgroundColor: widget.backgroundColor,
      strokeWidth: widget.strokeWidth,
      elevation: widget.elevation,
    );
  }

  Widget _buildAdaptiveIndicator(BuildContext context, bool showIndeterminate) {
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
