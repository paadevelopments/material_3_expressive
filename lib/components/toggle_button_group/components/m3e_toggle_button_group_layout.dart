part of '../m3e_toggle_button_group.dart';

/// Overflow and linear layout helpers for [_M3EButtonGroupState].
extension _M3EButtonGroupLayout on _M3EButtonGroupState {
  Widget _buildContent(BuildContext context, double spacing) {
    if (widget.actions.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.overflowStrategy != null) {
      return _buildWithCustomStrategy(context, spacing);
    }

    switch (widget.overflow) {
      case M3EButtonGroupOverflow.none:
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxMain = widget.direction == Axis.horizontal
                ? constraints.maxWidth
                : constraints.maxHeight;
            return _buildAnimatedLinearLayout(context, spacing, maxMain);
          },
        );
      case M3EButtonGroupOverflow.scroll:
        return _linearScrollable(context, spacing);
      case M3EButtonGroupOverflow.menu:
        return _linearWithOverflowMenu(context, spacing);
      case M3EButtonGroupOverflow.experimentalPaging:
        return _linearWithExperimentalPaging(context, spacing);
    }
  }

  Widget _buildWithCustomStrategy(BuildContext context, double spacing) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _buildCustomStrategyChild(context, constraints, spacing);
      },
    );
  }

  Widget _buildCustomStrategyChild(
    BuildContext context,
    BoxConstraints constraints,
    double spacing,
  ) {
    final maxMain = widget.direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;

    final strategy = widget.overflowStrategy!;
    var visibleCount = widget.actions.length;

    if (maxMain.isFinite) {
      final resolved = _resolveCustomStrategyVisibleCount(
        context,
        maxMain: maxMain,
        spacing: spacing,
        strategy: strategy,
      );
      if (resolved == null) {
        return _linearScrollable(context, spacing);
      }
      visibleCount = resolved;
    }

    final layout = strategy.buildLayout(
      context: context,
      actions: widget.actions,
      visibleCount: visibleCount,
      spacing: spacing,
      direction: widget.direction,
      style: widget.style,
      size: widget.size,
      decoration: widget.decoration,
      connected: widget._connected,
      isRtl: _isRtl,
      buildButton: (index, {required isFirst, required isLast}) {
        return _repaintButton(
          KeyedSubtree(
            key: ValueKey('custom-item-$index'),
            child: M3EButtonGroupItemScope(
              index: index,
              count:
                  visibleCount + (visibleCount < widget.actions.length ? 1 : 0),
              child: _buildButton(context, index, isFirst, isLast),
            ),
          ),
        );
      },
    );

    return _wrapCustomStrategyWithTrigger(
      context,
      spacing: spacing,
      strategy: strategy,
      visibleCount: visibleCount,
      layout: layout,
    );
  }

  int? _resolveCustomStrategyVisibleCount(
    BuildContext context, {
    required double maxMain,
    required double spacing,
    required M3EOverflowStrategy strategy,
  }) {
    final hasMeasurements =
        _overflowController.stableAllOverflowMeasured.value ||
        !_hasAnyLabel ||
        _allOverflowExtentsMeasured();
    if (!hasMeasurements) {
      return null;
    }

    final itemExtents = [
      for (int i = 0; i < widget.actions.length; i++)
        _itemMainExtentForOverflow(context, i),
    ];
    final triggerExtent = M3EButtonGroupOverflowController.roundConsumed(
      strategy.triggerExtent ?? _defaultOverflowTriggerExtent(),
    );
    return _overflowController.computeVisibleCountForMenu(
      maxMain: maxMain,
      itemExtents: itemExtents,
      triggerExtent: triggerExtent,
      separatorExtent: () => _separatorMainExtent(spacing),
    );
  }

  Widget _wrapCustomStrategyWithTrigger(
    BuildContext context, {
    required double spacing,
    required M3EOverflowStrategy strategy,
    required int visibleCount,
    required Widget layout,
  }) {
    final hiddenCount = widget.actions.length - visibleCount;
    if (hiddenCount <= 0) {
      return layout;
    }

    final trigger = strategy.buildOverflowTrigger(
      context: context,
      hiddenCount: hiddenCount,
      style: widget.style,
      size: widget.size,
      decoration: widget.decoration,
      connected: widget._connected,
      isFirst: visibleCount == 0,
      isLast: true,
      onPressed: () =>
          _onCustomOverflowPressed(context, strategy, visibleCount),
      checked:
          _selectedToggleActionInRange(
            visibleCount,
            widget.actions.length - 1,
          ) !=
          null,
    );

    if (trigger == null) {
      return layout;
    }

    return _axisFlex([
      layout,
      _buildGap(context, visibleCount - 1, spacing),
      _repaintButton(
        KeyedSubtree(
          key: const ValueKey('custom-overflow-trigger'),
          child: M3EButtonGroupItemScope(
            index: M3EButtonConstants.kOverflowTriggerScopeIndex,
            count: 1,
            child: trigger,
          ),
        ),
      ),
    ]);
  }

  Future<void> _onCustomOverflowPressed(
    BuildContext context,
    M3EOverflowStrategy strategy,
    int visibleCount,
  ) async {
    final selectedAction = _selectedToggleActionInRange(
      visibleCount,
      widget.actions.length - 1,
    );
    final selectedIndex = selectedAction != null
        ? widget.actions.indexOf(selectedAction)
        : null;
    final result = await strategy.showOverflowMenu(
      context: context,
      actions: widget.actions,
      firstHiddenIndex: visibleCount,
      selectedIndex: selectedIndex,
    );
    if (result != null && mounted) {
      strategy.onItemSelected(result);
      _handleOverflowActionSelection(result);
    }
  }

  Widget _repaintButton(Widget child) => RepaintBoundary(child: child);

  Widget _buildAnimatedLinearLayout(
    BuildContext context,
    double spacing,
    double maxMain,
  ) {
    final count = widget.actions.length;
    final children = <Widget>[
      for (var i = 0; i < count; i++)
        _repaintButton(
          KeyedSubtree(
            key: ValueKey('toggle-item-$i'),
            child: M3EButtonGroupItemScope(
              index: i,
              count: count,
              child: _buildButton(context, i, i == 0, i == count - 1),
            ),
          ),
        ),
    ];

    if (!_supportsAnimatedSquish) {
      return _axisFlex(_interleaveWithGaps(context, children, spacing));
    }
    return _buildSquishAnimatedLayout(children, spacing);
  }

  List<Widget> _interleaveWithGaps(
    BuildContext context,
    List<Widget> children,
    double spacing,
  ) {
    final flexChildren = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      flexChildren.add(children[i]);
      if (i < children.length - 1) {
        flexChildren.add(_buildGap(context, i, spacing));
      }
    }
    return flexChildren;
  }

  Widget _buildSquishAnimatedLayout(List<Widget> children, double spacing) {
    return ValueListenableBuilder<int?>(
      valueListenable: _pressCoordinator.pressedIndexNotifier,
      builder: (context, pressedIndex, _) {
        return SingleMotionBuilder(
          motion:
              widget.decoration?.motion?.toMotion() ??
              M3EButtonMotion.standard.toMotion(),
          value: pressedIndex != null ? 1.0 : 0.0,
          builder: (context, animValue, _) {
            _pressCoordinator.onAnimationProgress(animValue);
            return _ButtonGroupRenderObjectWidget(
              direction: widget.direction,
              spacing: spacing,
              pressedIndex: _pressCoordinator.lastPressedIndex,
              animValue: animValue,
              expandedRatio: widget.expandedRatio,
              children: children,
            );
          },
        );
      },
    );
  }

  Widget _linearScrollable(BuildContext context, double spacing) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isBounded = widget.direction == Axis.horizontal
            ? constraints.hasBoundedWidth
            : constraints.hasBoundedHeight;
        final maxMain = widget.direction == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        final core = _buildAnimatedLinearLayout(context, spacing, maxMain);
        if (!isBounded) {
          return core;
        }
        final contentFits = _scrollContentFits(maxMain, spacing);
        return SingleChildScrollView(
          key: PageStorageKey<Object>(_scrollOverflowController),
          controller: _scrollOverflowController,
          scrollDirection: widget.direction,
          primary: false,
          physics: contentFits ? const NeverScrollableScrollPhysics() : null,
          clipBehavior: contentFits ? Clip.none : Clip.hardEdge,
          child: core,
        );
      },
    );
  }

  bool _scrollContentFits(double maxMain, double spacing) {
    if (!maxMain.isFinite || !_allOverflowExtentsMeasured()) {
      return false;
    }
    return _scrollContentMainExtent(spacing) <= maxMain;
  }

  double _scrollContentMainExtent(double spacing) {
    final separator = _separatorMainExtent(spacing);
    var total = 0.0;
    for (var i = 0; i < widget.actions.length; i++) {
      if (i > 0) {
        total += separator;
      }
      total += _itemMainExtentForScrollFit(context, i);
    }
    return total;
  }

  double _itemMainExtentForScrollFit(BuildContext context, int index) {
    if (widget.direction == Axis.vertical) {
      return _itemMainExtentForOverflow(context, index);
    }
    if (index < 0 || index >= widget.actions.length) {
      return M3EButtonGroupOverflowController.roundConsumed(
        _iconOnlyNaturalSizeCache,
      );
    }
    final action = widget.actions[index];
    if (action.width != null) {
      return M3EButtonGroupOverflowController.roundConsumed(action.width!);
    }
    if (index >= _measuredUncheckedWidths.length) {
      return M3EButtonGroupOverflowController.roundConsumed(
        _iconOnlyNaturalSizeCache,
      );
    }
    final uncheckedWidth =
        _measuredUncheckedWidths[index] ?? _iconOnlyNaturalSizeCache;
    final checkedWidth = _measuredCheckedWidths[index] ?? uncheckedWidth;
    return M3EButtonGroupOverflowController.roundConsumed(
      math.max(uncheckedWidth, checkedWidth),
    );
  }

  Widget _linearWithOverflowMenu(BuildContext context, double spacing) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _buildOverflowMenuChild(context, constraints, spacing);
      },
    );
  }

  Widget _buildOverflowMenuChild(
    BuildContext context,
    BoxConstraints constraints,
    double spacing,
  ) {
    final maxMain = widget.direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;
    if (!maxMain.isFinite) {
      return _buildAnimatedLinearLayout(context, spacing, maxMain);
    }

    if (!_hasStableOverflowMeasurements()) {
      return _linearScrollable(context, spacing);
    }

    final itemExtents = [
      for (int i = 0; i < widget.actions.length; i++)
        _itemMainExtentForOverflow(context, i),
    ];
    final visibleCount = _overflowController.computeVisibleCountForMenu(
      maxMain: maxMain,
      itemExtents: itemExtents,
      triggerExtent: M3EButtonGroupOverflowController.roundConsumed(
        _defaultOverflowTriggerExtent(),
      ),
      separatorExtent: () => _separatorMainExtent(spacing),
    );

    if (visibleCount >= widget.actions.length) {
      return _buildAnimatedLinearLayout(context, spacing, maxMain);
    }

    return _axisFlex(
      _buildOverflowMenuVisibleItems(context, spacing, visibleCount),
    );
  }

  bool _hasStableOverflowMeasurements() {
    return _overflowController.stableAllOverflowMeasured.value ||
        !_hasAnyLabel ||
        _allOverflowExtentsMeasured();
  }

  List<Widget> _buildOverflowMenuVisibleItems(
    BuildContext context,
    double spacing,
    int visibleCount,
  ) {
    final visibleItems = <Widget>[];
    final visibleScopeCount = visibleCount + 1;
    for (var i = 0; i < visibleCount; i++) {
      if (visibleItems.isNotEmpty) {
        visibleItems.add(_buildGap(context, i - 1, spacing));
      }
      visibleItems.add(
        _repaintButton(
          KeyedSubtree(
            key: ValueKey('toggle-menu-item-$i'),
            child: M3EButtonGroupItemScope(
              index: i,
              count: visibleScopeCount,
              child: _buildButton(context, i, i == 0, false),
            ),
          ),
        ),
      );
    }

    if (visibleItems.isNotEmpty) {
      visibleItems.add(_buildGap(context, visibleCount - 1, spacing));
    }
    visibleItems.add(
      _repaintButton(
        _buildOverflowMenuTrigger(
          context,
          firstHiddenIndex: visibleCount,
          isFirst: visibleCount == 0,
          isLast: true,
        ),
      ),
    );
    return visibleItems;
  }

  Widget _linearWithExperimentalPaging(BuildContext context, double spacing) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _buildExperimentalPagingChild(context, constraints, spacing);
      },
    );
  }

  Widget _buildExperimentalPagingChild(
    BuildContext context,
    BoxConstraints constraints,
    double spacing,
  ) {
    final maxMain = widget.direction == Axis.horizontal
        ? constraints.maxWidth
        : constraints.maxHeight;
    if (!maxMain.isFinite) {
      return _buildAnimatedLinearLayout(context, spacing, maxMain);
    }

    if (!_hasStableOverflowMeasurements()) {
      return _linearScrollable(context, spacing);
    }

    final itemExtents = [
      for (int i = 0; i < widget.actions.length; i++)
        _itemMainExtentForOverflow(context, i),
    ];

    return ValueListenableBuilder<int>(
      valueListenable: _overflowController.windowStartIndex,
      builder: (context, windowStartIndex, _) {
        return _buildPagingWindowItems(
          context,
          spacing: spacing,
          maxMain: maxMain,
          itemExtents: itemExtents,
        );
      },
    );
  }

  Widget _buildPagingWindowItems(
    BuildContext context, {
    required double spacing,
    required double maxMain,
    required List<double> itemExtents,
  }) {
    final pagingWindow = _overflowController.computePagingWindow(
      maxMain: maxMain,
      itemExtents: itemExtents,
      triggerExtent: M3EButtonGroupOverflowController.roundConsumed(
        _defaultOverflowTriggerExtent(),
      ),
      separatorBetweenItems: (_) => _separatorMainExtent(spacing),
      separatorBeforeOverflow: ({required isFirst}) =>
          isFirst ? 0.0 : _separatorMainExtent(spacing),
    );

    final visibleItems = <Widget>[];
    var localIndex = 0;
    if (pagingWindow.needsBack) {
      visibleItems.add(
        _repaintButton(
          KeyedSubtree(
            key: const ValueKey('toggle-paging-back'),
            child: _buildOverflowTrigger(
              context,
              targetIndex: 0,
              isBack: true,
              isFirst: true,
              isLast: false,
            ),
          ),
        ),
      );
      localIndex++;
    }

    localIndex = _appendPagingWindowButtons(
      context,
      spacing: spacing,
      pagingWindow: pagingWindow,
      visibleItems: visibleItems,
      localIndex: localIndex,
    );

    if (pagingWindow.needsForward) {
      if (visibleItems.isNotEmpty) {
        visibleItems.add(_buildGap(context, pagingWindow.end, spacing));
      }
      visibleItems.add(
        _repaintButton(
          KeyedSubtree(
            key: const ValueKey('toggle-paging-forward'),
            child: _buildOverflowTrigger(
              context,
              targetIndex: pagingWindow.end + 1,
              isBack: false,
              isFirst: false,
              isLast: true,
            ),
          ),
        ),
      );
    }

    return _axisFlex(visibleItems);
  }

  int _appendPagingWindowButtons(
    BuildContext context, {
    required double spacing,
    required M3EButtonGroupOverflowPagingWindow pagingWindow,
    required List<Widget> visibleItems,
    required int localIndex,
  }) {
    var index = localIndex;
    for (int i = pagingWindow.start; i <= pagingWindow.end; i++) {
      if (visibleItems.isNotEmpty) {
        visibleItems.add(_buildGap(context, i - 1, spacing));
      }
      final isLastVisible = i == pagingWindow.end && !pagingWindow.needsForward;
      visibleItems.add(
        _repaintButton(
          KeyedSubtree(
            key: ValueKey('toggle-paging-item-$i'),
            child: M3EButtonGroupItemScope(
              index: index++,
              count: _pagingScopeCount(pagingWindow),
              child: _buildButton(
                context,
                i,
                !pagingWindow.needsBack && i == pagingWindow.start,
                isLastVisible,
              ),
            ),
          ),
        ),
      );
    }
    return index;
  }

  Widget _axisFlex(List<Widget> children) => widget.direction == Axis.horizontal
      ? Row(mainAxisSize: MainAxisSize.min, children: children)
      : Column(mainAxisSize: MainAxisSize.min, children: children);

  Widget _buildGap(BuildContext context, int beforeIndex, double spacing) {
    return ValueListenableBuilder<int?>(
      valueListenable: _focusedIndexNotifier,
      builder: (context, focusedIndex, _) {
        final gap = _FocusRingGapRenderer.resolveGap(
          connected: widget._connected,
          focusedIndex: focusedIndex,
          beforeIndex: beforeIndex,
          spacing: spacing,
          connectedGap: M3ETheme.of(
            context,
          ).toggleButtonGroupTheme.connectedGap,
        );

        final double width = widget.direction == Axis.horizontal ? gap : 0;
        final double height = widget.direction == Axis.vertical ? gap : 0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOutCubic,
          width: widget.direction == Axis.horizontal ? null : width,
          height: widget.direction == Axis.vertical ? null : height,
          constraints: BoxConstraints(minWidth: width, minHeight: height),
        );
      },
    );
  }

  double _separatorMainExtent(double spacing) {
    final connectedGap = M3ETheme.of(
      context,
    ).toggleButtonGroupTheme.connectedGap;
    return M3EButtonGroupOverflowController.roundConsumed(
      widget._connected ? connectedGap : spacing,
    );
  }

  bool _allOverflowExtentsMeasured() {
    for (var i = 0; i < widget.actions.length; i++) {
      final action = widget.actions[i];
      if (action.label != null || action.checkedLabel != null) {
        if (!_isMeasured(i)) {
          return false;
        }
      }
    }
    return true;
  }

  double _itemMainExtentForOverflow(BuildContext context, int index) {
    if (widget.direction == Axis.horizontal) {
      return M3EButtonGroupOverflowController.roundConsumed(
        _naturalSizeForButton(context, index),
      );
    }
    final buttonTheme = M3ETheme.of(context).buttonTheme;
    final measurements = buttonTheme.measurements(
      _mapSize(widget.size, actionWidth: widget.actions[index].width),
    );
    return M3EButtonGroupOverflowController.roundConsumed(measurements.height);
  }

  double _defaultOverflowTriggerExtent() {
    if (widget.direction == Axis.vertical) {
      return _iconOnlyNaturalSizeCache;
    }
    return M3EButtonGroupOverflowController.roundConsumed(
      _iconOnlyNaturalSizeCache,
    );
  }

  int _pagingScopeCount(M3EButtonGroupOverflowPagingWindow window) {
    int count = window.end >= window.start
        ? (window.end - window.start + 1)
        : 0;
    if (window.needsBack) {
      count++;
    }
    if (window.needsForward) {
      count++;
    }
    return count;
  }

  Widget _buildOverflowTrigger(
    BuildContext context, {
    required int targetIndex,
    required bool isBack,
    required bool isFirst,
    required bool isLast,
  }) {
    return _buildOverflowIndicatorButton(
      context,
      start: isBack ? 0 : targetIndex,
      end: isBack
          ? _overflowController.windowStartIndex.value - 1
          : widget.actions.length - 1,
      icon: isBack
          ? const Icon(M3EIcons.arrow_back_rounded)
          : (widget.overflowIcon ?? const Icon(M3EIcons.more_horiz)),
      semanticLabel: isBack
          ? MaterialLocalizations.of(context).previousPageTooltip
          : 'More options',
      isFirst: isFirst,
      isLast: isLast,
      onPressed: () {
        _overflowController.windowStartIndex.value = targetIndex;
      },
    );
  }

  Widget _buildOverflowMenuTrigger(
    BuildContext context, {
    required int firstHiddenIndex,
    required bool isFirst,
    required bool isLast,
  }) {
    return _buildOverflowIndicatorButton(
      context,
      start: firstHiddenIndex,
      end: widget.actions.length - 1,
      icon: widget.overflowIcon ?? const Icon(M3EIcons.more_horiz),
      semanticLabel: MaterialLocalizations.of(context).showMenuTooltip,
      isFirst: isFirst,
      isLast: isLast,
      onPressed: () => _openOverflowMenu(context, firstHiddenIndex),
    );
  }

  Widget _buildOverflowIndicatorButton(
    BuildContext context, {
    required int start,
    required int end,
    required Widget icon,
    required String semanticLabel,
    required bool isFirst,
    required bool isLast,
    required VoidCallback onPressed,
  }) {
    return KeyedSubtree(
      key: ValueKey('toggle-overflow-$start-$end-$isFirst-$isLast'),
      child: M3EButtonGroupItemScope(
        index: isLast ? M3EButtonConstants.kOverflowTriggerScopeIndex : 0,
        count: 1,
        child: M3EToggleButton(
          icon: icon,
          checked: _selectedToggleActionInRange(start, end) != null,
          onCheckedChange: (_) => onPressed(),
          style: widget.style,
          size: _mapSize(widget.size),
          decoration: widget.decoration,
          isGroupConnected: widget._connected,
          isFirstInGroup: isFirst,
          isLastInGroup: isLast,
          semanticLabel: semanticLabel,
          enableFeedback: widget.enableFeedback,
        ),
      ),
    );
  }
}
