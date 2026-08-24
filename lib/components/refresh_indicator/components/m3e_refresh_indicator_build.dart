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

  /// Max visual travel during drag used for arming / material progress.
  double _maxVisualPull(BuildContext context) =>
      widget.displacement + _indicatorHeight(context);

  /// Finger pull clamped to the snap cap.
  double _visualPull(BuildContext context) {
    return math.min(math.max(0, _dragOffset ?? 0.0), _maxVisualPull(context));
  }

  /// List top/bottom padding while dragging (capped) or while springing back.
  double _contentPad(BuildContext context) {
    switch (_status) {
      case M3ERefreshStatus.drag:
      case M3ERefreshStatus.armed:
        return math.min(_visualPull(context), _resolvedContentDragOffset);
      case M3ERefreshStatus.snap:
      case M3ERefreshStatus.refresh:
      case M3ERefreshStatus.done:
      case M3ERefreshStatus.canceled:
        return math.max(0, _contentPadController.value);
      case null:
        return 0;
    }
  }

  /// Scale / opacity progress for the parked indicator (0 → 1 with pull).
  double _revealProgress(BuildContext context) {
    final double target = widget.displacement > 0
        ? widget.displacement
        : _resolvedContentDragOffset;
    if (target <= 0) {
      return 1;
    }
    final double restingPosition =
        1.0 / M3ERefreshIndicatorTheme.kDragSizeFactorLimit;
    switch (_status) {
      case M3ERefreshStatus.drag:
      case M3ERefreshStatus.armed:
        return (_visualPull(context) / target).clamp(0.0, 1.0);
      case M3ERefreshStatus.snap:
        // Allow slight overshoot past 1 while the spatial spring settles.
        return (_positionController.value / restingPosition).clamp(0.0, 1.2);
      case M3ERefreshStatus.refresh:
        return 1;
      case M3ERefreshStatus.done:
        return _scaleFactor.value.clamp(0.0, 1.2);
      case M3ERefreshStatus.canceled:
        return (_positionController.value / restingPosition).clamp(0.0, 1.2);
      case null:
        return 0;
    }
  }

  Widget _buildPositionedIndicator(BuildContext context) {
    final bool atTop = _isIndicatorAtTop!;
    final bool showIndeterminate =
        _status == M3ERefreshStatus.refresh || _status == M3ERefreshStatus.done;
    final double reveal = _revealProgress(context);
    // Park at displacement; reveal via scale + fade (no slide-down).
    final double restingInset = widget.displacement;

    return Positioned(
      top: atTop ? widget.edgeOffset + restingInset : null,
      bottom: atTop ? null : widget.edgeOffset + restingInset,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Align(
          alignment: atTop ? Alignment.topCenter : Alignment.bottomCenter,
          child: Opacity(
            opacity: reveal.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: reveal,
              alignment: atTop ? Alignment.topCenter : Alignment.bottomCenter,
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
