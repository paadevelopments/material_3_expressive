part of 'm3e_expandable_item.dart';

/// Body measurement / viewport helpers for [_M3EExpandableItemState].
extension _M3EExpandableItemBody on _M3EExpandableItemState {
  Widget _buildExpandableBody(
    M3EExpandableStyle d,
    double progress, {
    required bool isEntirelyTappable,
  }) {
    final expandableTheme = M3ETheme.of(context).listTheme.expandable;
    final effectivePadding = d.bodyPadding ?? expandableTheme.bodyPadding;
    final resolvedPadding = effectivePadding.resolve(
      Directionality.of(context),
    );
    final contentShift = math.min<double>(
      12,
      resolvedPadding.bottom * 0.6 + 4.0,
    );
    final bodyHeight = _computeBodyHeight(effectivePadding, progress);
    final translationY = -(1.0 - progress.clamp(0.0, 1.0)) * contentShift;
    final needsMeasurement =
        _collapsedHeight == null || _expandedHeight == null;

    return Stack(
      children: [
        if (needsMeasurement) _buildMeasurementOverlay(effectivePadding),
        if (bodyHeight > 0)
          _buildBodyViewport(
            d,
            progress,
            effectivePadding: effectivePadding,
            bodyHeight: bodyHeight,
            translationY: translationY,
            isEntirelyTappable: isEntirelyTappable,
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  double _computeBodyHeight(
    EdgeInsetsGeometry effectivePadding,
    double progress,
  ) {
    final contentCollapsed = _collapsedHeight ?? 0.0;
    final contentExpanded = _expandedHeight ?? 200.0;
    final paddingVertical = effectivePadding.vertical;
    final totalCollapsed = contentCollapsed > 0
        ? contentCollapsed + paddingVertical
        : 0.0;
    final totalExpanded = contentExpanded > 0
        ? contentExpanded + paddingVertical
        : 0.0;
    return math.max<double>(
      0,
      totalCollapsed + (totalExpanded - totalCollapsed) * progress,
    );
  }

  Widget _buildMeasurementOverlay(EdgeInsetsGeometry effectivePadding) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Offstage(
        child: Padding(
          padding: effectivePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_collapsedHeight == null)
                M3EMeasureSize(
                  onChange: (size) =>
                      setState(() => _collapsedHeight = size.height),
                  child: widget.bodyBuilder(context, widget.index, 0),
                ),
              if (_expandedHeight == null)
                M3EMeasureSize(
                  onChange: (size) =>
                      setState(() => _expandedHeight = size.height),
                  child: widget.bodyBuilder(context, widget.index, 1),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyViewport(
    M3EExpandableStyle d,
    double progress, {
    required EdgeInsetsGeometry effectivePadding,
    required double bodyHeight,
    required double translationY,
    required bool isEntirelyTappable,
  }) {
    return SizedBox(
      height: bodyHeight,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: effectivePadding,
        child: SizedBox(
          width: double.infinity,
          child: Builder(
            builder: (context) => _buildBodyInteractiveContent(
              d,
              progress,
              translationY: translationY,
              isEntirelyTappable: isEntirelyTappable,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyInteractiveContent(
    M3EExpandableStyle d,
    double progress, {
    required double translationY,
    required bool isEntirelyTappable,
  }) {
    final isExpanded = progress > 0.5;
    final canTapBody =
        (isExpanded && d.tapBodyToCollapse) ||
        (!isExpanded && d.tapBodyToExpand);
    final tapCallback =
        (!isEntirelyTappable && canTapBody && !d.tapIconToToggle)
        ? widget.onToggle
        : null;
    final bodyTooltip = tapCallback != null
        ? (isExpanded ? d.collapseTooltip : d.expandTooltip)
        : null;

    return _buildInteractionWrapper(
      d,
      onTap: tapCallback,
      tooltip: bodyTooltip,
      child: Align(
        alignment: d.bodyAlignment,
        child: Transform.translate(
          offset: Offset(0, translationY),
          child: widget.bodyBuilder(context, widget.index, progress),
        ),
      ),
    );
  }
}

/// Interaction wrapper helpers for [_M3EExpandableItemState].
extension _M3EExpandableItemInteraction on _M3EExpandableItemState {
  Widget _buildInteractionWrapper(
    M3EExpandableStyle d, {
    required Widget child,
    required VoidCallback? onTap,
    bool isHeader = false,
    bool isIcon = false,
    String? semanticLabel,
    String? semanticHint,
    bool? isExpanded,
    String? tooltip,
  }) {
    var result = child;
    if (tooltip != null) {
      result = Tooltip(message: tooltip, child: result);
    }
    if (onTap == null) {
      return Semantics(
        label: semanticLabel,
        expanded: isExpanded,
        child: result,
      );
    }
    final semantics = Semantics(
      label: semanticLabel,
      hint: semanticHint,
      expanded: isExpanded,
      button: true,
      onTap: onTap,
      child: result,
    );
    if (!d.useInkWell) {
      return _wrapWithGestureDetector(
        isHeader: isHeader,
        onTap: onTap,
        child: semantics,
      );
    }
    return _wrapWithInkWell(
      d,
      isHeader: isHeader,
      isIcon: isIcon,
      onTap: onTap,
      child: semantics,
    );
  }

  Widget _wrapWithGestureDetector({
    required bool isHeader,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      onTapDown: isHeader ? (_) => _handleTapDown() : null,
      onTapUp: isHeader ? (_) => _handleTapUp() : null,
      onTapCancel: isHeader ? () => _handleTapCancel() : null,
      child: child,
    );
  }

  Widget _wrapWithInkWell(
    M3EExpandableStyle d, {
    required bool isHeader,
    required bool isIcon,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return InkWell(
      customBorder: isIcon ? const CircleBorder() : null,
      splashColor: d.splashColor,
      highlightColor: d.highlightColor,
      splashFactory: d.splashFactory,
      enableFeedback: d.enableFeedback,
      onTap: onTap,
      onHover: isHeader ? _handleHoverChanged : null,
      onTapDown: isHeader ? (_) => _handleTapDown() : null,
      onTapUp: isHeader ? (_) => _handleTapUp() : null,
      onTapCancel: isHeader ? () => _handleTapCancel() : null,
      child: child,
    );
  }
}
