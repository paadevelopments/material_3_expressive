// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'dart:math' as math;
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../../foundations/foundations.dart';
import 'package:motor/motor.dart';

import '../buttons/enums/m3e_button_enums.dart';
import '../buttons/res/m3e_button_constants.dart';
import '../buttons/styles/m3e_button_decoration.dart';
import '../buttons/styles/m3e_button_motion.dart';
import '../buttons/styles/m3e_overflow_bottom_sheet_decoration.dart';
import '../buttons/styles/m3e_overflow_popup_decoration.dart';
import '../buttons/components/m3e_overflow_strategy.dart';
import '../menus/m3e_menus.dart';
import '../toggle_button/m3e_toggle_button.dart';
import 'controllers/m3e_button_group_overflow_controller.dart';
import 'enums/m3e_toggle_button_group_enums.dart';
import 'models/m3e_button_group_action.dart';
import 'models/m3e_button_group_overflow_paging_window.dart';
import 'components/m3e_toggle_button_group_item_scope.dart';
import 'components/m3e_toggle_button_group_provider.dart';
import 'components/m3e_toggle_button_group_scope.dart';
export 'enums/m3e_toggle_button_group_enums.dart';
export 'styles/m3e_toggle_button_group_theme.dart';
export 'components/m3e_toggle_button_group_scope.dart';

part 'components/m3e_button_group_align.dart';
part 'components/m3e_button_group_parent_data.dart';
part 'components/m3e_toggle_button_group_collaborators.dart';
part 'components/m3e_toggle_button_group_overflow_presenter.dart';
part 'components/m3e_toggle_button_group_render.dart';

// ---------------------------------------------------------------------------
// M3EButtonGroupAction
// ---------------------------------------------------------------------------

/// Intent for moving focus to the next button in the group.
class _MoveFocusIntent extends Intent {
  final int direction;
  const _MoveFocusIntent(this.direction);
}

// ---------------------------------------------------------------------------
// M3EButtonGroup
// ---------------------------------------------------------------------------

/// A horizontal (or vertical) row of [M3EToggleButton]s with optional
/// neighbor-squish animation and connected-group shape morphing.
class M3EButtonGroup extends StatefulWidget {
  const M3EButtonGroup({
    super.key,
    required this.actions,
    this.type = M3EButtonGroupType.standard,
    this.shape = M3EButtonShape.round,
    this.size = M3EButtonSize.sm,
    this.style = M3EButtonStyle.filled,
    this.density = M3EButtonGroupDensity.regular,
    this.spacing,
    this.direction = Axis.horizontal,
    this.selectedIndex,
    this.selectedIndices,
    this.onSelectedIndexChanged,
    this.onSelectedIndicesChanged,
    this.neighborSquish = true,
    this.expandedRatio = 0.15,
    this.haptic = M3EHapticFeedback.none,
    this.enableFeedback = true,
    this.decoration,
    this.semanticLabel,
    this.clipBehavior = Clip.none,
    this.overflow = M3EButtonGroupOverflow.scroll,
    this.overflowIcon,
    this.overflowPopupDecoration = const M3EOverflowPopupDecoration(),
    this.overflowBottomSheetDecoration =
    const M3EOverflowBottomSheetDecoration(),
    this.overflowMenuStyle = M3EButtonGroupOverflowMenuStyle.popup,
    this.overflowStrategy,
  });

  final List<M3EButtonGroupAction> actions;
  final M3EButtonGroupType type;
  final M3EButtonShape shape;
  final M3EButtonSize size;
  final M3EButtonStyle style;
  final M3EButtonGroupDensity density;
  final double? spacing;
  final Axis direction;
  final int? selectedIndex;
  final Set<int>? selectedIndices;
  final ValueChanged<int?>? onSelectedIndexChanged;
  final ValueChanged<Set<int>>? onSelectedIndicesChanged;
  final bool neighborSquish;
  final double expandedRatio;
  final M3EHapticFeedback haptic;
  final bool enableFeedback;
  final M3EToggleButtonDecoration? decoration;
  final String? semanticLabel;
  final Clip clipBehavior;
  final M3EButtonGroupOverflow overflow;
  final Widget? overflowIcon;
  final M3EOverflowPopupDecoration overflowPopupDecoration;
  final M3EOverflowBottomSheetDecoration overflowBottomSheetDecoration;
  final M3EButtonGroupOverflowMenuStyle overflowMenuStyle;
  final M3EOverflowStrategy? overflowStrategy;

  bool get _connected => type == M3EButtonGroupType.connected;

  @override
  State<M3EButtonGroup> createState() => _M3EButtonGroupState();
}

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class _M3EButtonGroupState extends State<M3EButtonGroup>
    with SingleTickerProviderStateMixin, _ToggleGroupOverflowPresenterMixin {
  late List<WidgetStatesController> _controllers;
  late List<FocusNode?> _focusNodes;
  late int _layoutSignature;
  late int _focusNodeSignature;
  late final M3EButtonGroupOverflowController _overflowController;
  late final _ToggleGroupPressCoordinator _pressCoordinator;
  late final _ToggleGroupMeasurementOrchestrator _measurement;
  int? _lastOverflowSelectionIndex;

  final ValueNotifier<int?> _focusedIndexNotifier = ValueNotifier<int?>(null);

  bool _isRtl = false;

  int get _measurementGeneration => _measurement.generation;
  set _measurementGeneration(int value) => _measurement.generation = value;

  int _focusedIndex = 0;

  List<GlobalKey> get _uncheckedKeys => _measurement.uncheckedKeys;
  List<GlobalKey> get _checkedKeys => _measurement.checkedKeys;

  List<double?> get _measuredUncheckedWidths =>
      _measurement.measuredUncheckedWidths;
  List<double?> get _measuredCheckedWidths =>
      _measurement.measuredCheckedWidths;

  bool get _hasAnyLabel => _measurement.hasAnyLabel;
  set _hasAnyLabel(bool value) => _measurement.hasAnyLabel = value;

  double _iconOnlyNaturalSizeCache = 40.0;

  bool get _supportsAnimatedSquish =>
      widget.direction == Axis.horizontal &&
          !widget._connected &&
          widget.neighborSquish;

  bool _computeHasAnyLabel() => widget.actions.any(
        (action) => action.label != null || action.checkedLabel != null,
  );

  bool _needsDistinctCheckedMeasurement(M3EButtonGroupAction action) {
    return action.checkedLabel != null || action.checkedIcon != null;
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

  late List<M3EToggleButtonDecoration> _cachedDecorations;

  @override
  void initState() {
    super.initState();
    _measurement = _ToggleGroupMeasurementOrchestrator();
    _pressCoordinator = _ToggleGroupPressCoordinator(isMounted: () => mounted);
    _overflowController = M3EButtonGroupOverflowController();
    _overflowController.stableAllOverflowMeasured.addListener(
      _handleOverflowChange,
    );
    assert(() {
      final hasControlledGroup =
          widget.onSelectedIndexChanged != null ||
              widget.onSelectedIndicesChanged != null;
      if (!hasControlledGroup) return true;
      for (final action in widget.actions) {
        if (action.checked != null) {
          throw FlutterError(
            'M3EButtonGroup: Do not set action.checked when the group uses '
                'onSelectedIndexChanged or onSelectedIndicesChanged.\n'
                'Use selectedIndex / selectedIndices on the group instead. '
                'Mixing per-action checked state with group-controlled selection '
                'produces undefined behavior.',
          );
        }
      }
      return true;
    }(), '');
    _layoutSignature = _computeLayoutSignature(widget);
    _focusNodeSignature = _computeFocusNodeSignature(widget.actions);
    _initControllers();
    _initFocusNodes();
    _hasAnyLabel = _computeHasAnyLabel();
    _updateDecorations();
    _initMeasurementState();
    _scheduleMeasurementIfNeeded();
  }

  void _handleOverflowChange() {
    if (mounted) setState(() {});
  }

  void _updateDecorations() {
    _cachedDecorations = List.generate(widget.actions.length, (i) {
      final action = widget.actions[i];
      return M3EToggleButtonDecoration(
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
        checkedRadius:
        action.decoration?.checkedRadius ??
            widget.decoration?.checkedRadius,
        uncheckedRadius:
        action.decoration?.uncheckedRadius ??
            widget.decoration?.uncheckedRadius,
        pressedRadius:
        action.decoration?.pressedRadius ??
            widget.decoration?.pressedRadius,
        hoveredRadius:
        action.decoration?.hoveredRadius ??
            widget.decoration?.hoveredRadius,
        connectedInnerRadius:
        action.decoration?.connectedInnerRadius ??
            widget.decoration?.connectedInnerRadius,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateIconOnlyNaturalSizeCache();
    _scheduleMeasurementIfNeeded();
  }

  void _updateIconOnlyNaturalSizeCache() {
    final buttonTheme = M3ETheme.of(context).buttonTheme;
    final m = buttonTheme.measurements(_mapSize(widget.size));
    _iconOnlyNaturalSizeCache = m.height;
  }

  @override
  void didUpdateWidget(covariant M3EButtonGroup old) {
    super.didUpdateWidget(old);
    assert(() {
      final hasControlledGroup =
          widget.onSelectedIndexChanged != null ||
              widget.onSelectedIndicesChanged != null;
      if (hasControlledGroup) {
        for (final action in widget.actions) {
          if (action.checked != null) {
            throw FlutterError(
              'M3EButtonGroup: Do not set action.checked when the group uses '
                  'onSelectedIndexChanged or onSelectedIndicesChanged.\n'
                  'Use selectedIndex / selectedIndices on the group instead. '
                  'Mixing per-action checked state with group-controlled selection '
                  'produces undefined behavior.',
            );
          }
        }
      }
      return true;
    }(), '');
    final bool actionsIdentityChanged = !identical(old.actions, widget.actions);
    final bool maybeScalarLayoutChanged = _didScalarLayoutFieldsChange(
      old,
      widget,
    );

    final nextLayoutSignature =
    (actionsIdentityChanged || maybeScalarLayoutChanged)
        ? _computeLayoutSignature(widget)
        : _layoutSignature;
    final nextFocusNodeSignature = actionsIdentityChanged
        ? _computeFocusNodeSignature(widget.actions)
        : _focusNodeSignature;
    final bool lengthChanged = old.actions.length != widget.actions.length;
    final bool layoutChanged = nextLayoutSignature != _layoutSignature;
    final bool focusNodesChanged =
        nextFocusNodeSignature != _focusNodeSignature;

    if (lengthChanged) {
      _disposeControllers();
      _initControllers();
      _pressCoordinator.clearPressedIndex();
    }
    if (lengthChanged || focusNodesChanged) {
      _disposeFocusNodes();
      _initFocusNodes();
    }
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
    if (_overflowController.windowStartIndex.value >= widget.actions.length) {
      _overflowController.windowStartIndex.value = 0;
    }
    if (widget.selectedIndex != _lastOverflowSelectionIndex) {
      _lastOverflowSelectionIndex = null;
    }
    _layoutSignature = nextLayoutSignature;
    _focusNodeSignature = nextFocusNodeSignature;
  }

  @override
  void dispose() {
    _overflowController.stableAllOverflowMeasured.removeListener(
      _handleOverflowChange,
    );
    _overflowController.dispose();
    _pressCoordinator.dispose();
    _focusedIndexNotifier.dispose();
    _disposeControllers();
    _disposeFocusNodes();
    _disposeMeasurerControllers();
    super.dispose();
  }

  void _measureButtonWidths(int generation) {
    if (!mounted || generation != _measurementGeneration) return;
    bool anyChanged = false;
    for (int i = 0; i < widget.actions.length; i++) {
      final action = widget.actions[i];
      if (action.label == null && action.checkedLabel == null) {
        continue;
      }

      final ctxU = _uncheckedKeys[i].currentContext;
      final renderU = ctxU?.findRenderObject() as RenderBox?;
      if (renderU != null && renderU.hasSize) {
        final measured = renderU.size.width;
        if (_measuredUncheckedWidths[i] != measured) {
          _measuredUncheckedWidths[i] = measured;
          anyChanged = true;
        }
      }

      if (!_needsDistinctCheckedMeasurement(action)) {
        final resolved =
            _measuredUncheckedWidths[i] ?? _iconOnlyNaturalSizeCache;
        if (_measuredCheckedWidths[i] != resolved) {
          _measuredCheckedWidths[i] = resolved;
          anyChanged = true;
        }
        continue;
      }

      final ctxC = _checkedKeys[i].currentContext;
      final renderC = ctxC?.findRenderObject() as RenderBox?;
      if (renderC != null && renderC.hasSize) {
        final measured = renderC.size.width;
        if (_measuredCheckedWidths[i] != measured) {
          _measuredCheckedWidths[i] = measured;
          anyChanged = true;
        }
      }
    }
    if (anyChanged && mounted && generation == _measurementGeneration) {
      setState(() {
        if (_allOverflowExtentsMeasured()) {
          _overflowController.stableAllOverflowMeasured.value = true;
        }
      });
    }
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

    if (!_needsDistinctCheckedMeasurement(action)) {
      return M3EToggleButton(
        key: _uncheckedKeys[index],
        style: widget.style,
        size: _mapSize(widget.size, actionWidth: action.width),
        decoration: widget.decoration,
        icon: action.icon,
        label: action.label,
        checked: false,
        checkedIcon: action.checkedIcon,
        checkedLabel: action.checkedLabel,
        enabled: action.enabled,
        enableFeedback: action.enableFeedback ?? widget.enableFeedback,
        onCheckedChange: (_) {},
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        M3EToggleButton(
          key: _uncheckedKeys[index],
          style: widget.style,
          size: _mapSize(widget.size, actionWidth: action.width),
          decoration: widget.decoration,
          icon: action.icon,
          label: action.label,
          checked: false,
          checkedIcon: action.checkedIcon,
          checkedLabel: action.checkedLabel,
          enabled: action.enabled,
          enableFeedback: action.enableFeedback ?? widget.enableFeedback,
          onCheckedChange: (_) {},
        ),
        M3EToggleButton(
          key: _checkedKeys[index],
          style: widget.style,
          size: _mapSize(widget.size, actionWidth: action.width),
          decoration: widget.decoration,
          icon: action.icon,
          label: action.checkedLabel ?? action.label,
          checked: true,
          checkedIcon: action.checkedIcon,
          checkedLabel: action.checkedLabel,
          enabled: action.enabled,
          enableFeedback: action.enableFeedback ?? widget.enableFeedback,
          onCheckedChange: (_) {},
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
    _focusNodes = _ToggleGroupFocusManager.buildInternalFocusNodes(
      widget.actions,
    );
  }

  void _disposeFocusNodes() {
    _ToggleGroupFocusManager.disposeInternalFocusNodes(_focusNodes);
  }

  int _computeFocusNodeSignature(List<M3EButtonGroupAction> actions) {
    return _ToggleGroupFocusManager.computeFocusNodeSignature(actions);
  }

  int _computeLayoutSignature(M3EButtonGroup group) {
    int actionsHash = 0;
    for (final action in group.actions) {
      actionsHash = Object.hash(actionsHash, _actionLayoutSignature(action));
    }

    final styleHash = Object.hash(
      group.type,
      group.shape,
      group.size,
      group.style,
      group.density,
      group.decoration,
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
    return Object.hash(
      _widgetContentHash(action.icon),
      _widgetContentHash(action.checkedIcon),
      _widgetContentHash(action.label),
      _widgetContentHash(action.checkedLabel),
      action.enabled,
      action.decoration,
    );
  }

  int _widgetContentHash(Widget? w) {
    if (w == null) return 0;
    if (w is Icon) return w.icon.hashCode;
    if (w is Text) return w.data.hashCode;
    return w.hashCode;
  }

  bool _didScalarLayoutFieldsChange(
      M3EButtonGroup old,
      M3EButtonGroup next,
      ) {
    return old.type != next.type ||
        old.shape != next.shape ||
        old.size != next.size ||
        old.style != next.style ||
        old.density != next.density ||
        old.direction != next.direction ||
        old.neighborSquish != next.neighborSquish ||
        old.expandedRatio != next.expandedRatio ||
        old.overflow != next.overflow ||
        old.overflowMenuStyle != next.overflowMenuStyle ||
        old.decoration != next.decoration;
  }

  void _focusNextButton(int currentIndex, int direction) {
    final nextIndex = _ToggleGroupFocusManager.nextEnabledIndex(
      widget.actions,
      currentIndex: currentIndex,
      direction: direction,
    );
    if (nextIndex == null) return;
    (widget.actions[nextIndex].focusNode ?? _focusNodes[nextIndex])
        ?.requestFocus();
  }

  void _onButtonStateChanged(int index, WidgetStatesController c) {
    if (!mounted) return;

    final isPressed = c.value.contains(WidgetState.pressed);
    _pressCoordinator.handlePressedStateChange(
      index: index,
      isPressed: isPressed,
    );

    final isFocused = c.value.contains(WidgetState.focused);
    if (isFocused && _focusedIndexNotifier.value != index) {
      if (SchedulerBinding.instance.schedulerPhase ==
          SchedulerPhase.persistentCallbacks) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) _focusedIndexNotifier.value = index;
        });
      } else {
        _focusedIndexNotifier.value = index;
      }
    } else if (!isFocused && _focusedIndexNotifier.value == index) {
      if (SchedulerBinding.instance.schedulerPhase ==
          SchedulerPhase.persistentCallbacks) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted && _focusedIndexNotifier.value == index) {
            _focusedIndexNotifier.value = null;
          }
        });
      } else {
        _focusedIndexNotifier.value = null;
      }
    }
  }

  Map<ShortcutActivator, Intent> get _arrowKeyShortcuts {
    return _ToggleGroupKeyboardConfig.arrowKeyShortcuts(
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

    if (index >= _measuredUncheckedWidths.length) {
      return _iconOnlyNaturalSizeCache;
    }

    final uncheckedWidth =
        _measuredUncheckedWidths[index] ?? _iconOnlyNaturalSizeCache;
    final checkedWidth = _measuredCheckedWidths[index] ?? uncheckedWidth;

    if (!widget._connected && _needsDistinctCheckedMeasurement(action)) {
      return math.max(uncheckedWidth, checkedWidth);
    }

    final bool checked = _isToggleActionSelected(index);

    return checked ? checkedWidth : uncheckedWidth;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<M3EButtonGroupType>('type', widget.type));
    properties.add(EnumProperty<M3EButtonShape>('shape', widget.shape));
    properties.add(DiagnosticsProperty<M3EButtonSize>('size', widget.size));
    properties.add(IntProperty('actionCount', widget.actions.length));
    properties.add(
      EnumProperty<M3EButtonGroupOverflow>('overflow', widget.overflow),
    );
    properties.add(
      FlagProperty(
        'neighborSquish',
        value: widget.neighborSquish,
        ifTrue: 'squish',
      ),
    );
    properties.add(
      FlagProperty('hasLabels', value: _hasAnyLabel, ifTrue: 'labeled'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildGroup);
  }

  Widget _buildGroup(BuildContext context) {
    final groupTheme = M3ETheme.of(context).toggleButtonGroupTheme;
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

  Widget _buildContent(BuildContext context, double spacing) {
    if (widget.actions.isEmpty) return const SizedBox.shrink();

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
        final maxMain = widget.direction == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;

        final strategy = widget.overflowStrategy!;
        int visibleCount = widget.actions.length;

        double triggerExtent = 0;

        if (maxMain.isFinite) {
          final hasMeasurements =
              _overflowController.stableAllOverflowMeasured.value ||
                  !_hasAnyLabel ||
                  _allOverflowExtentsMeasured();

          if (hasMeasurements) {
            final itemExtents = [
              for (int i = 0; i < widget.actions.length; i++)
                _itemMainExtentForOverflow(context, i),
            ];

            triggerExtent =
                M3EButtonGroupOverflowController.roundConsumed(
                  strategy.triggerExtent ?? _defaultOverflowTriggerExtent(),
                );

            visibleCount = _overflowController.computeVisibleCountForMenu(
              maxMain: maxMain,
              itemExtents: itemExtents,
              triggerExtent: triggerExtent,
              separatorExtent: () => _separatorMainExtent(spacing),
            );
          } else {
            return _linearScrollable(context, spacing);
          }
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
          buildButton: (index, isFirst, isLast) {
            return _repaintButton(
              KeyedSubtree(
                key: ValueKey('custom-item-$index'),
                child: M3EButtonGroupItemScope(
                  index: index,
                  count:
                  visibleCount +
                      (visibleCount < widget.actions.length ? 1 : 0),
                  child: _buildButton(context, index, isFirst, isLast),
                ),
              ),
            );
          },
        );

        final hiddenCount = widget.actions.length - visibleCount;

        if (hiddenCount > 0) {
          final trigger = strategy.buildOverflowTrigger(
            context: context,
            hiddenCount: hiddenCount,
            style: widget.style,
            size: widget.size,
            decoration: widget.decoration,
            connected: widget._connected,
            isFirst: visibleCount == 0,
            isLast: true,
            onPressed: () async {
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
            },
            checked:
            _selectedToggleActionInRange(
              visibleCount,
              widget.actions.length - 1,
            ) !=
                null,
          );

          if (trigger != null) {
            final children = <Widget>[
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
            ];

            return _axisFlex(children);
          }
        }

        return layout;
      },
    );
  }

  Widget _repaintButton(Widget child) => RepaintBoundary(child: child);

  Widget _buildAnimatedLinearLayout(
      BuildContext context,
      double spacing,
      double maxMain,
      ) {
    final count = widget.actions.length;
    final squishEnabled = _supportsAnimatedSquish;

    final children = <Widget>[];
    for (var i = 0; i < count; i++) {
      final button = _buildButton(context, i, i == 0, i == count - 1);
      final scoped = M3EButtonGroupItemScope(
        index: i,
        count: count,
        child: button,
      );

      children.add(
        _repaintButton(
          KeyedSubtree(key: ValueKey('toggle-item-$i'), child: scoped),
        ),
      );
    }

    if (!squishEnabled) {
      final flexChildren = <Widget>[];
      for (var i = 0; i < count; i++) {
        flexChildren.add(children[i]);
        if (i < count - 1) {
          flexChildren.add(_buildGap(context, i, spacing));
        }
      }
      return _axisFlex(flexChildren);
    }

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
        if (!isBounded) return core;
        return SingleChildScrollView(
          scrollDirection: widget.direction,
          primary: false,
          clipBehavior: Clip.hardEdge,
          child: core,
        );
      },
    );
  }

  Widget _linearWithOverflowMenu(BuildContext context, double spacing) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxMain = widget.direction == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        if (!maxMain.isFinite) {
          return _buildAnimatedLinearLayout(context, spacing, maxMain);
        }

        final hasMeasurements =
            _overflowController.stableAllOverflowMeasured.value ||
                !_hasAnyLabel ||
                _allOverflowExtentsMeasured();

        if (!hasMeasurements) {
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

        final visibleItems = <Widget>[];
        final visibleScopeCount = visibleCount + 1;
        for (int i = 0; i < visibleCount; i++) {
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
        return _axisFlex(visibleItems);
      },
    );
  }

  Widget _linearWithExperimentalPaging(BuildContext context, double spacing) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxMain = widget.direction == Axis.horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        if (!maxMain.isFinite) {
          return _buildAnimatedLinearLayout(context, spacing, maxMain);
        }

        final hasMeasurements =
            _overflowController.stableAllOverflowMeasured.value ||
                (!_hasAnyLabel) ||
                _allOverflowExtentsMeasured();

        if (!hasMeasurements) {
          return _linearScrollable(context, spacing);
        }

        final itemExtents = [
          for (int i = 0; i < widget.actions.length; i++)
            _itemMainExtentForOverflow(context, i),
        ];

        return ValueListenableBuilder<int>(
          valueListenable: _overflowController.windowStartIndex,
          builder: (context, windowStartIndex, _) {
            final pagingWindow = _overflowController.computePagingWindow(
              maxMain: maxMain,
              itemExtents: itemExtents,
              triggerExtent:
              M3EButtonGroupOverflowController.roundConsumed(
                _defaultOverflowTriggerExtent(),
              ),
              separatorBetweenItems: (_) => _separatorMainExtent(spacing),
              separatorBeforeOverflow: (isFirst) =>
              isFirst ? 0.0 : _separatorMainExtent(spacing),
            );

            final visibleItems = <Widget>[];
            int localIndex = 0;
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

            for (int i = pagingWindow.start; i <= pagingWindow.end; i++) {
              if (visibleItems.isNotEmpty) {
                visibleItems.add(_buildGap(context, i - 1, spacing));
              }
              final isLastVisible =
                  i == pagingWindow.end && !pagingWindow.needsForward;
              visibleItems.add(
                _repaintButton(
                  KeyedSubtree(
                    key: ValueKey('toggle-paging-item-$i'),
                    child: M3EButtonGroupItemScope(
                      index: localIndex++,
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
          },
        );
      },
    );
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
          connectedGap:
              M3ETheme.of(context).toggleButtonGroupTheme.connectedGap,
        );

        final double width = widget.direction == Axis.horizontal ? gap : 0;        final double height = widget.direction == Axis.vertical ? gap : 0;

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
    final connectedGap =
        M3ETheme.of(context).toggleButtonGroupTheme.connectedGap;
    return M3EButtonGroupOverflowController.roundConsumed(
      widget._connected ? connectedGap : spacing,
    );
  }

  bool _allOverflowExtentsMeasured() {
    for (int i = 0; i < widget.actions.length; i++) {
      final action = widget.actions[i];
      if (action.label != null || action.checkedLabel != null) {
        if (!_isMeasured(i)) return false;
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
    return M3EButtonGroupOverflowController.roundConsumed(
      measurements.height,
    );
  }

  double _defaultOverflowTriggerExtent() {
    if (widget.direction == Axis.vertical) return _iconOnlyNaturalSizeCache;
    return M3EButtonGroupOverflowController.roundConsumed(
      _iconOnlyNaturalSizeCache,
    );
  }

  int _pagingScopeCount(M3EButtonGroupOverflowPagingWindow window) {
    int count = window.end >= window.start
        ? (window.end - window.start + 1)
        : 0;
    if (window.needsBack) count++;
    if (window.needsForward) count++;
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

  @override
  void _handleOverflowActionSelection(int index) {
    final action = widget.actions[index];
    if (!action.enabled) return;

    final isCurrentlySelected = _isToggleActionSelected(index);

    if (widget.onSelectedIndicesChanged != null) {
      final current = widget.selectedIndices ?? <int>{};
      Set<int> next;
      if (isCurrentlySelected) {
        next = {...current};
        next.remove(index);
      } else {
        next = {...current, index};
      }
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

  @override
  bool _isToggleActionSelected(int index) {
    if (widget.selectedIndices != null) {
      return widget.selectedIndices!.contains(index);
    }
    if (widget.onSelectedIndexChanged != null || widget.selectedIndex != null) {
      return widget.selectedIndex == index;
    }
    return widget.actions[index].checked ?? false;
  }

  M3EButtonGroupAction? _selectedToggleActionInRange(int start, int end) {
    if (start < 0 || end >= widget.actions.length || start > end) return null;
    for (int i = start; i <= end; i++) {
      if (_isToggleActionSelected(i)) return widget.actions[i];
    }
    final selectedIndex = _lastOverflowSelectionIndex;
    if (selectedIndex == null) return null;
    if (selectedIndex < start || selectedIndex > end) return null;
    return widget.actions[selectedIndex];
  }

  Widget _buildButton(
      BuildContext context,
      int index,
      bool isFirst,
      bool isLast,
      ) {
    final action = widget.actions[index];
    final bool checked = _isToggleActionSelected(index);
    final isVisualFirst = _isRtl ? isLast : isFirst;
    final isVisualLast = _isRtl ? isFirst : isLast;

    Widget button = M3EToggleButton(
      icon: action.icon,
      checkedIcon: action.checkedIcon,
      label: action.label,
      checkedLabel: action.checkedLabel,
      checked: checked,
      enabled: action.enabled,
      style: widget.style,
      size: _mapSize(widget.size, actionWidth: action.width),
      isGroupConnected: widget._connected,
      isFirstInGroup: isVisualFirst,
      isLastInGroup: isVisualLast,
      decoration: _cachedDecorations[index],
      statesController: _controllers[index],
      focusNode: action.focusNode ?? _focusNodes[index],
      autofocus: action.autofocus,
      enableFeedback: action.enableFeedback ?? widget.enableFeedback,
      onFocusChange: (focused) {
        if (focused) _focusedIndex = index;
        action.onFocusChange?.call(focused);
      },
      semanticLabel: action.semanticLabel,
      tooltip: action.tooltip,
      onCheckedChange: (val) {
        if (widget.onSelectedIndicesChanged != null) {
          final current = widget.selectedIndices ?? <int>{};
          Set<int> next;
          if (val) {
            next = {...current, index};
          } else {
            next = {...current};
            next.remove(index);
          }
          widget.onSelectedIndicesChanged!.call(next);
          return;
        }
        if (widget.onSelectedIndexChanged != null) {
          widget.onSelectedIndexChanged!.call(val ? index : null);
        }
      },
    );

    if (!widget._connected &&
        action.width == null &&
        _needsDistinctCheckedMeasurement(action) &&
        index < _measuredUncheckedWidths.length) {
      final uncheckedWidth =
          _measuredUncheckedWidths[index] ?? _iconOnlyNaturalSizeCache;
      final checkedWidth = _measuredCheckedWidths[index] ?? uncheckedWidth;

      final motion =
      (action.decoration?.motion ??
          widget.decoration?.motion ??
          M3EButtonMotion.standard)
          .toMotion();

      return SingleMotionBuilder(
        motion: motion,
        value: checked ? 1.0 : 0.0,
        builder: (context, progress, child) {
          final isShrinkingCollapse = !checked && checkedWidth > uncheckedWidth;
          final p = isShrinkingCollapse
              ? progress.clamp(-0.45, 1.0)
              : progress.clamp(0.0, 1.0);
          final width = uncheckedWidth + ((checkedWidth - uncheckedWidth) * p);
          return SizedBox(width: width, child: child);
        },
        child: button,
      );
    }

    return button;
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
