part of '../m3e_button_group.dart';

/// Measurement, focus, and signature helpers for [_M3EButtonGroupState].
extension _M3EButtonGroupMeasurement on _M3EButtonGroupState {
  void _assertControlledSelection() {
    assert(_controlledSelectionIsValid(), '');
  }

  bool _controlledSelectionIsValid() {
    final hasControlledGroup =
        widget.onSelectedIndexChanged != null ||
        widget.onSelectedIndicesChanged != null;
    if (!hasControlledGroup) {
      return true;
    }
    for (final action in widget.actions) {
      if (action.isSelected != null) {
        throw FlutterError(
          'M3EButtonGroup: Do not set action.isSelected when the group uses '
          'onSelectedIndexChanged or onSelectedIndicesChanged.\n'
          'Use selectedIndex / selectedIndices on the group instead. '
          'Mixing per-action selection with group-controlled selection '
          'produces undefined behavior.',
        );
      }
    }
    return true;
  }

  void _bootstrapState() {
    _measurement = _ButtonGroupMeasurementOrchestrator();
    _pressCoordinator = _ButtonGroupPressCoordinator(isMounted: () => mounted);
    _overflowController = M3EButtonGroupOverflowController();
    _scrollOverflowController = ScrollController();
    _overflowController.stableAllOverflowMeasured.addListener(
      _handleOverflowChange,
    );
    _layoutSignature = _computeLayoutSignature(widget);
    _focusNodeSignature = _computeFocusNodeSignature(widget.actions);
    _initControllers();
    _initFocusNodes();
    _hasAnyLabel = _computeHasAnyLabel();
    _updateDecorations();
    _initMeasurementState();
    _scheduleMeasurementIfNeeded();
  }

  void _applyWidgetUpdate(M3EButtonGroup old) {
    final actionsIdentityChanged = !identical(old.actions, widget.actions);
    final maybeScalarLayoutChanged = _didScalarLayoutFieldsChange(old, widget);
    final nextLayoutSignature =
        (actionsIdentityChanged || maybeScalarLayoutChanged)
        ? _computeLayoutSignature(widget)
        : _layoutSignature;
    final nextFocusNodeSignature = actionsIdentityChanged
        ? _computeFocusNodeSignature(widget.actions)
        : _focusNodeSignature;

    _syncControllersAndFocusNodes(
      old,
      nextFocusNodeSignature: nextFocusNodeSignature,
    );
    _updateDecorations();
    _syncLayoutMeasurement(old, nextLayoutSignature: nextLayoutSignature);
    _syncOverflowWindowOnUpdate();
    _layoutSignature = nextLayoutSignature;
    _focusNodeSignature = nextFocusNodeSignature;
  }

  void _syncControllersAndFocusNodes(
    M3EButtonGroup old, {
    required int nextFocusNodeSignature,
  }) {
    final lengthChanged = old.actions.length != widget.actions.length;
    final focusNodesChanged = nextFocusNodeSignature != _focusNodeSignature;
    if (lengthChanged) {
      _disposeControllers();
      _initControllers();
      _pressCoordinator.clearPressedIndex();
    }
    if (lengthChanged || focusNodesChanged) {
      _disposeFocusNodes();
      _initFocusNodes();
    }
  }

  void _syncLayoutMeasurement(
    M3EButtonGroup old, {
    required int nextLayoutSignature,
  }) {
    final lengthChanged = old.actions.length != widget.actions.length;
    final layoutChanged = nextLayoutSignature != _layoutSignature;
    if (lengthChanged || layoutChanged) {
      _measurementGeneration++;
      _hasAnyLabel = _computeHasAnyLabel();
      _updateDecorations();
      _initMeasurementState();
      _scheduleMeasurementIfNeeded();
    }
    if (old.size != widget.size) {
      _updateIconOnlyNaturalSizeCache();
    }
  }

  void _syncOverflowWindowOnUpdate() {
    if (_overflowController.windowStartIndex.value >= widget.actions.length) {
      _overflowController.windowStartIndex.value = 0;
    }
    if (widget.selectedIndex != _lastOverflowSelectionIndex) {
      _lastOverflowSelectionIndex = null;
    }
  }

  bool _computeHasAnyLabel() => widget.actions.any(
    (action) => action.label != null || action.selectedLabel != null,
  );

  bool _needsDistinctSelectedMeasurement(M3EButtonGroupAction action) {
    return action.selectedLabel != null || action.selectedIcon != null;
  }

  void _initMeasurementState() {
    _measurement.initMeasurementState(
      actionCount: widget.actions.length,
      overflowController: _overflowController,
    );
  }

  void _disposeMeasurerControllers() {
    _measurement.disposeMeasurerControllers();
  }

  bool _isMeasured(int index) {
    return _measurement.isMeasured(index);
  }

  void _handleOverflowChange() {
    if (mounted) {
      setState(() {});
    }
  }

  void _updateDecorations() {
    _cachedDecorations = List.generate(widget.actions.length, (i) {
      final action = widget.actions[i];
      return M3EButtonDecoration(
        backgroundColor:
            action.decoration?.backgroundColor ??
            widget.decoration?.backgroundColor,
        foregroundColor:
            action.decoration?.foregroundColor ??
            widget.decoration?.foregroundColor,
        side: action.decoration?.side ?? widget.decoration?.side,
        overlayColor:
            action.decoration?.overlayColor ?? widget.decoration?.overlayColor,
        surfaceTintColor:
            action.decoration?.surfaceTintColor ??
            widget.decoration?.surfaceTintColor,
        mouseCursor:
            action.decoration?.mouseCursor ?? widget.decoration?.mouseCursor,
        motion: action.decoration?.motion ?? widget.decoration?.motion,
        haptic:
            action.decoration?.haptic ??
            widget.decoration?.haptic ??
            widget.haptic,
        selectedRadius:
            action.decoration?.selectedRadius ??
            widget.decoration?.selectedRadius,
        unselectedRadius:
            action.decoration?.unselectedRadius ??
            widget.decoration?.unselectedRadius,
        pressedRadius:
            action.decoration?.pressedRadius ??
            widget.decoration?.pressedRadius,
        hoveredRadius:
            action.decoration?.hoveredRadius ??
            widget.decoration?.hoveredRadius,
        connectedInnerRadius:
            action.decoration?.connectedInnerRadius ??
            widget.decoration?.connectedInnerRadius,
        backgroundGradient:
            action.decoration?.backgroundGradient ??
            widget.decoration?.backgroundGradient,
        foregroundGradient:
            action.decoration?.foregroundGradient ??
            widget.decoration?.foregroundGradient,
        overlayGradient:
            action.decoration?.overlayGradient ??
            widget.decoration?.overlayGradient,
        outlineGradient:
            action.decoration?.outlineGradient ??
            widget.decoration?.outlineGradient,
        backgroundBuilder:
            action.decoration?.backgroundBuilder ??
            widget.decoration?.backgroundBuilder,
        foregroundBuilder:
            action.decoration?.foregroundBuilder ??
            widget.decoration?.foregroundBuilder,
      );
    });
  }

  void _updateIconOnlyNaturalSizeCache() {
    final buttonTheme = M3ETheme.of(context).buttonTheme;
    final m = buttonTheme.measurements(_mapSize(widget.size));
    _iconOnlyNaturalSizeCache = m.height;
  }

  void _measureButtonWidths(int generation) {
    if (!mounted || generation != _measurementGeneration) {
      return;
    }
    var anyChanged = false;
    for (var i = 0; i < widget.actions.length; i++) {
      if (_measureLabeledButtonWidth(i)) {
        anyChanged = true;
      }
    }
    if (!anyChanged || !mounted || generation != _measurementGeneration) {
      return;
    }
    setState(() {
      if (_allOverflowExtentsMeasured()) {
        _overflowController.stableAllOverflowMeasured.value = true;
      }
    });
  }

  bool _measureLabeledButtonWidth(int index) {
    final action = widget.actions[index];
    if (action.label == null && action.selectedLabel == null) {
      return false;
    }

    var changed = _captureMeasuredWidth(
      key: _unselectedKeys[index],
      into: _measuredUnselectedWidths,
      index: index,
    );

    if (!_needsDistinctSelectedMeasurement(action)) {
      final resolved =
          _measuredUnselectedWidths[index] ?? _iconOnlyNaturalSizeCache;
      if (_measuredSelectedWidths[index] != resolved) {
        _measuredSelectedWidths[index] = resolved;
        changed = true;
      }
      return changed;
    }

    return _captureMeasuredWidth(
          key: _selectedKeys[index],
          into: _measuredSelectedWidths,
          index: index,
        ) ||
        changed;
  }

  bool _captureMeasuredWidth({
    required GlobalKey key,
    required List<double?> into,
    required int index,
  }) {
    final render = key.currentContext?.findRenderObject() as RenderBox?;
    if (render == null || !render.hasSize) {
      return false;
    }
    final measured = render.size.width;
    if (into[index] == measured) {
      return false;
    }
    into[index] = measured;
    return true;
  }

  void _scheduleMeasurementIfNeeded() {
    if (_hasAnyLabel) {
      final gen = _measurementGeneration;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _measureButtonWidths(gen),
      );
    }
  }

  void _initControllers() {
    _controllers = List.generate(widget.actions.length, (i) {
      final c = WidgetStatesController();
      c.addListener(() => _onButtonStateChanged(i, c));
      return c;
    });
  }

  Widget _buildOffstageMeasurer(BuildContext context) {
    return IgnorePointer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < widget.actions.length; i++)
            _buildOffstageMeasurerItem(i),
        ],
      ),
    );
  }

  Widget _buildOffstageMeasurerItem(int index) {
    final action = widget.actions[index];

    if (!_needsDistinctSelectedMeasurement(action)) {
      return M3EButton(
        key: _unselectedKeys[index],
        onPressed: () {},
        style: widget.style,
        size: _mapSize(widget.size, actionWidth: action.width),
        decoration: widget.decoration,
        icon: action.icon,
        label: action.label,
        isSelected: false,
        selectedIcon: action.selectedIcon,
        selectedLabel: action.selectedLabel,
        enabled: action.enabled,
        enableFeedback: action.enableFeedback ?? widget.enableFeedback,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        M3EButton(
          key: _unselectedKeys[index],
          onPressed: () {},
          style: widget.style,
          size: _mapSize(widget.size, actionWidth: action.width),
          decoration: widget.decoration,
          icon: action.icon,
          label: action.label,
          isSelected: false,
          selectedIcon: action.selectedIcon,
          selectedLabel: action.selectedLabel,
          enabled: action.enabled,
          enableFeedback: action.enableFeedback ?? widget.enableFeedback,
        ),
        M3EButton(
          key: _selectedKeys[index],
          onPressed: () {},
          style: widget.style,
          size: _mapSize(widget.size, actionWidth: action.width),
          decoration: widget.decoration,
          icon: action.icon,
          label: action.selectedLabel ?? action.label,
          isSelected: true,
          selectedIcon: action.selectedIcon,
          selectedLabel: action.selectedLabel,
          enabled: action.enabled,
          enableFeedback: action.enableFeedback ?? widget.enableFeedback,
        ),
      ],
    );
  }

  void _disposeControllers() {
    for (final c in _controllers) {
      c.dispose();
    }
    _controllers.clear();
  }

  void _initFocusNodes() {
    _focusNodes = _ButtonGroupFocusManager.buildInternalFocusNodes(
      widget.actions,
    );
  }

  void _disposeFocusNodes() {
    _ButtonGroupFocusManager.disposeInternalFocusNodes(_focusNodes);
  }

  int _computeFocusNodeSignature(List<M3EButtonGroupAction> actions) {
    return _ButtonGroupFocusManager.computeFocusNodeSignature(actions);
  }

  int _computeLayoutSignature(M3EButtonGroup group) {
    var actionsHash = 0;
    for (final action in group.actions) {
      actionsHash = Object.hash(actionsHash, _actionLayoutSignature(action));
    }

    // Decoration is excluded: colors / sides do not change intrinsic size.
    final styleHash = Object.hash(
      group.type,
      group.shape,
      group.size,
      group.style,
      group.density,
    );

    return Object.hash(
      group.direction,
      group.neighborSquish,
      group.expandedRatio,
      group.overflow,
      group.overflowMenuStyle,
      styleHash,
      actionsHash,
    );
  }

  int _actionLayoutSignature(M3EButtonGroupAction action) {
    // Decoration is excluded: selection-dependent colors must not wipe
    // measured widths. Size comes from content / explicit width.
    return Object.hash(
      _widgetContentHash(action.icon),
      _widgetContentHash(action.selectedIcon),
      _widgetContentHash(action.label),
      _widgetContentHash(action.selectedLabel),
      action.enabled,
      action.width,
    );
  }

  int _widgetContentHash(Widget? w) {
    if (w == null) {
      return 0;
    }
    if (w is Icon) {
      return Object.hash(w.icon, w.size);
    }
    if (w is Text) {
      return Object.hash(w.data, w.style?.fontSize, w.style?.fontWeight);
    }
    if (w is Flex) {
      return Object.hash(
        w.runtimeType,
        w.mainAxisSize,
        w.direction,
        Object.hashAll(w.children.map(_widgetContentHash)),
      );
    }
    if (w is Padding) {
      return Object.hash(w.padding, _widgetContentHash(w.child));
    }
    if (w is SizedBox) {
      return Object.hash(w.width, w.height, _widgetContentHash(w.child));
    }
    if (w is Center) {
      return Object.hash(
        w.widthFactor,
        w.heightFactor,
        _widgetContentHash(w.child),
      );
    }
    if (w is Align) {
      return Object.hash(
        w.alignment,
        w.widthFactor,
        w.heightFactor,
        _widgetContentHash(w.child),
      );
    }
    // Unknown custom widgets: identity is the safest size-signal fallback.
    return w.hashCode;
  }

  bool _didScalarLayoutFieldsChange(M3EButtonGroup old, M3EButtonGroup next) {
    return old.type != next.type ||
        old.shape != next.shape ||
        old.size != next.size ||
        old.style != next.style ||
        old.density != next.density ||
        old.direction != next.direction ||
        old.neighborSquish != next.neighborSquish ||
        old.expandedRatio != next.expandedRatio ||
        old.overflow != next.overflow ||
        old.overflowMenuStyle != next.overflowMenuStyle;
  }

  void _focusNextButton(int currentIndex, int direction) {
    final nextIndex = _ButtonGroupFocusManager.nextEnabledIndex(
      widget.actions,
      currentIndex: currentIndex,
      direction: direction,
    );
    if (nextIndex == null) {
      return;
    }
    (widget.actions[nextIndex].focusNode ?? _focusNodes[nextIndex])
        ?.requestFocus();
  }

  void _onButtonStateChanged(int index, WidgetStatesController c) {
    if (!mounted) {
      return;
    }

    final isPressed = c.value.contains(WidgetState.pressed);
    _pressCoordinator.handlePressedStateChange(
      index: index,
      isPressed: isPressed,
    );
    _syncFocusedIndexFromStates(
      index,
      isFocused: c.value.contains(WidgetState.focused),
    );
  }

  void _syncFocusedIndexFromStates(int index, {required bool isFocused}) {
    if (isFocused && _focusedIndexNotifier.value != index) {
      _runFocusNotifierUpdate(() => _focusedIndexNotifier.value = index);
      return;
    }
    if (!isFocused && _focusedIndexNotifier.value == index) {
      _runFocusNotifierUpdate(() {
        if (_focusedIndexNotifier.value == index) {
          _focusedIndexNotifier.value = null;
        }
      });
    }
  }

  void _runFocusNotifierUpdate(VoidCallback update) {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          update();
        }
      });
      return;
    }
    update();
  }

  Map<ShortcutActivator, Intent> get _arrowKeyShortcuts {
    return _ButtonGroupKeyboardConfig.arrowKeyShortcuts(
      direction: widget.direction,
      isRtl: _isRtl,
    );
  }

  void _focusNextButtonFromFocused(int direction) {
    _focusNextButton(_focusedIndex, direction);
  }

  double _naturalSizeForButton(BuildContext context, int index) {
    if (index < 0 || index >= widget.actions.length) {
      return _iconOnlyNaturalSizeCache;
    }

    final action = widget.actions[index];
    if (action.width != null) {
      return action.width!;
    }

    if (index >= _measuredUnselectedWidths.length) {
      return _iconOnlyNaturalSizeCache;
    }

    final unselectedWidth =
        _measuredUnselectedWidths[index] ?? _iconOnlyNaturalSizeCache;
    final selectedWidth = _measuredSelectedWidths[index] ?? unselectedWidth;

    if (!widget._connected && _needsDistinctSelectedMeasurement(action)) {
      return math.max(unselectedWidth, selectedWidth);
    }

    final bool selected = _isActionSelected(index);

    return selected ? selectedWidth : unselectedWidth;
  }
}
