part of '../m3e_toggle_button.dart';

/// Icon / label content builders for [_M3EToggleButtonState].
extension _M3EToggleButtonContent on _M3EToggleButtonState {
  bool get _animateIconToCheckedLabel =>
      widget.icon != null &&
      widget.checkedLabel != null &&
      widget.label == null &&
      widget.checkedIcon == null;

  bool get _animateLabelToCheckedIcon =>
      widget.checkedIcon != null &&
      widget.label != null &&
      widget.icon == null &&
      widget.checkedLabel == null;

  bool get _hasDistinctLabelStates =>
      _animateIconToCheckedLabel || _animateLabelToCheckedIcon;

  Widget _buildContent(M3EButtonMeasurements m, bool checked) {
    final effectiveIcon = _effectiveIcon;
    final uncheckedLabel = widget.label;
    final checkedLabel = widget.checkedLabel ?? widget.label;

    if (_isEmptyContent(effectiveIcon, uncheckedLabel, checkedLabel)) {
      return const SizedBox.shrink();
    }

    final iconWidget = _buildIconWidget(effectiveIcon, m);
    final naturalRow = _buildNaturalContentRow(
      measurements: m,
      checked: checked,
      iconWidget: iconWidget,
      uncheckedLabel: uncheckedLabel,
      checkedLabel: checkedLabel,
    );
    return _wrapContentForConstraints(m, naturalRow);
  }

  bool _isEmptyContent(
    Widget? effectiveIcon,
    Widget? uncheckedLabel,
    Widget? checkedLabel,
  ) {
    return effectiveIcon == null &&
        uncheckedLabel == null &&
        checkedLabel == null;
  }

  Widget _buildNaturalContentRow({
    required M3EButtonMeasurements measurements,
    required bool checked,
    required Widget? iconWidget,
    required Widget? uncheckedLabel,
    required Widget? checkedLabel,
  }) {
    final hasDistinct = _hasDistinctLabelStates;
    if (!hasDistinct) {
      return _buildContentRow(
        measurements: measurements,
        progress: checked ? 1.0 : 0.0,
        iconWidget: iconWidget,
        uncheckedLabel: uncheckedLabel,
        checkedLabel: checkedLabel,
        hasDistinctLabelStates: false,
        checked: checked,
      );
    }
    return SingleMotionBuilder(
      motion: _labelTransitionMotion(),
      value: checked ? 1.0 : 0.0,
      builder: (context, progress, _) => _buildContentRow(
        measurements: measurements,
        progress: progress,
        iconWidget: iconWidget,
        uncheckedLabel: uncheckedLabel,
        checkedLabel: checkedLabel,
        hasDistinctLabelStates: true,
        checked: checked,
      ),
    );
  }

  Widget _wrapContentForConstraints(
    M3EButtonMeasurements m,
    Widget naturalRow,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _fitContentToConstraints(m, naturalRow, constraints);
      },
    );
  }

  Widget _fitContentToConstraints(
    M3EButtonMeasurements m,
    Widget naturalRow,
    BoxConstraints constraints,
  ) {
    if (!constraints.hasBoundedWidth) {
      return naturalRow;
    }
    return SizedBox(
      height: m.height,
      child: FittedBox(
        fit: BoxFit.none,
        clipBehavior: Clip.hardEdge,
        child: naturalRow,
      ),
    );
  }

  Widget? _buildIconWidget(Widget? effectiveIcon, M3EButtonMeasurements m) {
    if (effectiveIcon == null) {
      return null;
    }
    return RepaintBoundary(
      child: DefaultTextStyle.merge(
        style: TextStyle(
          fontSize: m.height / 3,
          overflow: TextOverflow.ellipsis,
        ),
        maxLines: 1,
        softWrap: false,
        child: IconTheme.merge(
          data: IconThemeData(size: m.iconSize),
          child: effectiveIcon,
        ),
      ),
    );
  }

  Widget _buildContentRow({
    required M3EButtonMeasurements measurements,
    required double progress,
    required Widget? iconWidget,
    required Widget? uncheckedLabel,
    required Widget? checkedLabel,
    required bool hasDistinctLabelStates,
    required bool checked,
  }) {
    final p = _boundedProgress(progress);
    final hasUncheckedLabel = uncheckedLabel != null;
    final hasCheckedLabel = checkedLabel != null;
    final activeLabelProgress = _lerp(
      hasUncheckedLabel ? 1.0 : 0.0,
      hasCheckedLabel ? 1.0 : 0.0,
      p,
    );

    final labelWidget = _resolveLabelWidget(
      hasDistinctLabelStates: hasDistinctLabelStates,
      uncheckedLabel: uncheckedLabel,
      checkedLabel: checkedLabel,
      progress: p,
      checked: checked,
    );

    final gapWidget = (iconWidget != null && labelWidget != null)
        ? SizedBox(width: measurements.iconGap * activeLabelProgress)
        : null;

    if (iconWidget != null && labelWidget != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [iconWidget, gapWidget!, labelWidget],
      );
    }

    return iconWidget ?? labelWidget ?? const SizedBox.shrink();
  }

  Widget? _resolveLabelWidget({
    required bool hasDistinctLabelStates,
    required Widget? uncheckedLabel,
    required Widget? checkedLabel,
    required double progress,
    required bool checked,
  }) {
    if (hasDistinctLabelStates) {
      return _buildAnimatedLabelSlot(
        uncheckedLabel: uncheckedLabel,
        checkedLabel: checkedLabel,
        progress: progress,
      );
    }
    if (_effectiveLabel != null) {
      return _buildLabelText(_effectiveLabel!, checked: checked);
    }
    return null;
  }

  Widget _buildLabelText(Widget child, {required bool checked}) {
    return KeyedSubtree(
      key: ValueKey('toggle-label-$checked-${child.hashCode}'),
      child: DefaultTextStyle.merge(maxLines: 1, softWrap: false, child: child),
    );
  }

  Widget _buildAnimatedLabelSlot({
    required Widget? uncheckedLabel,
    required Widget? checkedLabel,
    required double progress,
  }) {
    final unchecked = uncheckedLabel != null
        ? _buildLabelText(uncheckedLabel, checked: false)
        : null;
    final checked = checkedLabel != null
        ? _buildLabelText(checkedLabel, checked: true)
        : null;

    final p = _boundedProgress(progress);
    final hasBothLabels = unchecked != null && checked != null;
    final shouldSlideOneSidedCheckedAppear =
        widget.icon != null &&
        widget.checkedLabel != null &&
        widget.label == null &&
        widget.checkedIcon == null;

    final outgoingSlide = hasBothLabels
        ? _toggleTheme.labelSlideDistance * p
        : 0.0;
    final incomingSlide =
        (hasBothLabels ||
            (shouldSlideOneSidedCheckedAppear &&
                unchecked == null &&
                checked != null))
        ? _toggleTheme.labelSlideDistance * (1.0 - p)
        : 0.0;

    final outgoingOpacity = hasBothLabels ? (1.0 - p) : _lingerOpacity(1.0 - p);
    final incomingOpacity = hasBothLabels ? p : _lingerOpacity(p);

    return ClipRect(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (unchecked != null)
            Align(
              widthFactor: 1.0 - p,
              alignment: Alignment.centerLeft,
              child: Opacity(
                opacity: outgoingOpacity,
                child: Transform.translate(
                  offset: Offset(-outgoingSlide, 0),
                  child: unchecked,
                ),
              ),
            ),
          if (checked != null)
            Align(
              widthFactor: p,
              alignment: Alignment.centerLeft,
              child: Opacity(
                opacity: incomingOpacity,
                child: Transform.translate(
                  offset: Offset(incomingSlide, 0),
                  child: checked,
                ),
              ),
            ),
        ],
      ),
    );
  }

  SpringMotion _labelTransitionMotion() {
    final base = effectiveMotion ?? M3EButtonMotion.standard;
    final damping = base.damping < 1.05 ? 1.05 : base.damping;
    final stiffness = base.stiffness * 0.5;
    return M3EButtonMotion.custom(stiffness, damping).toMotion();
  }

  double _boundedProgress(double t) => t.clamp(0.0, 1.0);

  double _lingerOpacity(double t) {
    final p = _boundedProgress(t);
    if (p >= 0.45) {
      return 1;
    }
    return p / 0.45;
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}
