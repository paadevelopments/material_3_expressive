part of '../m3e_button_group.dart';

/// Build and selection helpers for [_M3EButtonGroupState].
extension _M3EButtonGroupBuild on _M3EButtonGroupState {
  Widget _buildGroup(BuildContext context) {
    final groupTheme = M3ETheme.of(context).buttonGroupTheme;
    final metrics = groupTheme.metricsFor(
      widget.size,
      widget.density,
      isConnected: widget._connected,
    );
    final spacing =
        widget.spacing ?? (widget._connected ? 0.0 : metrics.spacing);
    _isRtl = Directionality.of(context) == TextDirection.rtl;

    Widget group = M3EButtonGroupProvider(
      controller: _overflowController,
      child: M3EButtonGroupScope(
        type: widget.type,
        shape: widget.shape,
        size: widget.size,
        density: widget.density,
        direction: widget.direction,
        child: _buildContent(context, spacing),
      ),
    );

    if (_hasAnyLabel) {
      group = Stack(
        children: [
          group,
          Positioned.fill(
            child: Opacity(opacity: 0, child: _buildOffstageMeasurer(context)),
          ),
        ],
      );
    }

    Widget result = Shortcuts(
      shortcuts: _arrowKeyShortcuts,
      child: Actions(
        actions: <Type, Action<Intent>>{
          _MoveFocusIntent: _MoveFocusAction(_focusNextButtonFromFocused),
        },
        child: FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: Semantics(
            container: true,
            label: widget.semanticLabel,
            child: group,
          ),
        ),
      ),
    );

    if (widget.clipBehavior != Clip.none) {
      result = ClipRRect(
        clipBehavior: widget.clipBehavior,
        borderRadius: groupTheme.groupRadiusFor(widget.shape, widget.size),
        child: result,
      );
    }

    return result;
  }

  void _applyOverflowActionSelection(int index) {
    final action = widget.actions[index];
    if (!action.enabled) {
      return;
    }

    final isCurrentlySelected = _isActionSelected(index);

    if (widget.onSelectedIndicesChanged != null) {
      final current = widget.selectedIndices ?? <int>{};
      final next = isCurrentlySelected
          ? ({...current}..remove(index))
          : {...current, index};
      _lastOverflowSelectionIndex = index;
      widget.onSelectedIndicesChanged!.call(next);
      return;
    }

    final nextSelectedIndex = isCurrentlySelected ? null : index;
    final isNowSelected = nextSelectedIndex == index;

    _lastOverflowSelectionIndex = index;
    widget.onSelectedIndexChanged?.call(nextSelectedIndex);

    if (!isNowSelected) {
      _lastOverflowSelectionIndex = null;
    }
  }

  bool _resolveActionSelected(int index) {
    if (widget.selectedIndices != null) {
      return widget.selectedIndices!.contains(index);
    }
    if (widget.onSelectedIndexChanged != null || widget.selectedIndex != null) {
      return widget.selectedIndex == index;
    }
    return widget.actions[index].isSelected ?? false;
  }

  M3EButtonGroupAction? _selectedActionInRange(int start, int end) {
    if (start < 0 || end >= widget.actions.length || start > end) {
      return null;
    }
    for (var i = start; i <= end; i++) {
      if (_isActionSelected(i)) {
        return widget.actions[i];
      }
    }
    final selectedIndex = _lastOverflowSelectionIndex;
    if (selectedIndex == null) {
      return null;
    }
    if (selectedIndex < start || selectedIndex > end) {
      return null;
    }
    return widget.actions[selectedIndex];
  }

  Widget _buildButton(
    BuildContext context,
    int index,
    bool isFirst,
    bool isLast,
  ) {
    final action = widget.actions[index];
    final bool selected = _isActionSelected(index);
    final button = _buildButtonWidget(
      action: action,
      index: index,
      selected: selected,
      isVisualFirst: _isRtl ? isLast : isFirst,
      isVisualLast: _isRtl ? isFirst : isLast,
    );
    return _maybeWrapButtonWidthMotion(
      action: action,
      index: index,
      selected: selected,
      button: button,
    );
  }

  Widget _buildButtonWidget({
    required M3EButtonGroupAction action,
    required int index,
    required bool selected,
    required bool isVisualFirst,
    required bool isVisualLast,
  }) {
    return M3EButton(
      icon: action.icon,
      selectedIcon: action.selectedIcon,
      label: action.label,
      selectedLabel: action.selectedLabel,
      isSelected: selected,
      onPressed: action.enabled
          ? () => _onSelectionChange(index, !selected)
          : null,
      enabled: action.enabled,
      style: widget.style,
      size: _mapSize(widget.size, actionWidth: action.width),
      shape: widget.shape,
      isGroupConnected: widget._connected,
      isFirstInGroup: isVisualFirst,
      isLastInGroup: isVisualLast,
      decoration: _cachedDecorations[index],
      statesController: _controllers[index],
      focusNode: action.focusNode ?? _focusNodes[index],
      autofocus: action.autofocus,
      enableFeedback: action.enableFeedback ?? widget.enableFeedback,
      onFocusChange: (focused) {
        if (focused) {
          _focusedIndex = index;
        }
        action.onFocusChange?.call(focused);
      },
      semanticLabel: action.semanticLabel,
      tooltip: action.tooltip,
    );
  }

  void _onSelectionChange(int index, bool selected) {
    if (widget.onSelectedIndicesChanged != null) {
      final current = widget.selectedIndices ?? <int>{};
      final next = selected
          ? {...current, index}
          : ({...current}..remove(index));
      widget.onSelectedIndicesChanged!.call(next);
      return;
    }
    if (widget.onSelectedIndexChanged != null) {
      widget.onSelectedIndexChanged!.call(selected ? index : null);
    }
  }

  Widget _maybeWrapButtonWidthMotion({
    required M3EButtonGroupAction action,
    required int index,
    required bool selected,
    required Widget button,
  }) {
    if (widget._connected ||
        action.width != null ||
        !_needsDistinctSelectedMeasurement(action) ||
        index >= _measuredUnselectedWidths.length) {
      return button;
    }

    final unselectedWidth =
        _measuredUnselectedWidths[index] ?? _iconOnlyNaturalSizeCache;
    final selectedWidth = _measuredSelectedWidths[index] ?? unselectedWidth;
    final motion =
        (action.decoration?.motion ??
                widget.decoration?.motion ??
                M3EButtonMotion.standard)
            .toMotion();

    return SingleMotionBuilder(
      motion: motion,
      value: selected ? 1.0 : 0.0,
      builder: (context, progress, child) {
        final isShrinkingCollapse =
            !selected && selectedWidth > unselectedWidth;
        final p = isShrinkingCollapse
            ? progress.clamp(-0.45, 1.0)
            : progress.clamp(0.0, 1.0);
        final width = unselectedWidth + ((selectedWidth - unselectedWidth) * p);
        return SizedBox(width: width, child: child);
      },
      child: button,
    );
  }

  M3EButtonSize _mapSize(M3EButtonSize s, {double? actionWidth}) {
    final base = switch (s.name) {
      'xs' => M3EButtonSize.xs,
      'sm' => M3EButtonSize.sm,
      'md' => M3EButtonSize.md,
      'lg' => M3EButtonSize.lg,
      'xl' => M3EButtonSize.xl,
      _ => M3EButtonSize.md,
    };
    if (actionWidth != null || s.name == 'custom') {
      return M3EButtonSize.custom(
        height: s.height ?? base.height,
        hPadding: s.hPadding ?? base.hPadding,
        iconSize: s.iconSize ?? base.iconSize,
        iconGap: s.iconGap ?? base.iconGap,
        width: actionWidth ?? s.width ?? base.width,
      );
    }
    return base;
  }
}
