// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
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
import 'package:motor/motor.dart';

import '../../foundations/foundations.dart';
import '../buttons/components/m3e_overflow_strategy.dart';
import '../buttons/enums/m3e_button_enums.dart';
import '../buttons/res/m3e_button_constants.dart';
import '../buttons/styles/m3e_button_decoration.dart';
import '../buttons/styles/m3e_button_motion.dart';
import '../buttons/styles/m3e_overflow_bottom_sheet_decoration.dart';
import '../buttons/styles/m3e_overflow_popup_decoration.dart';
import '../menus/m3e_menus.dart';
import '../toggle_button/m3e_toggle_button.dart';
import 'components/m3e_toggle_button_group_item_scope.dart';
import 'components/m3e_toggle_button_group_provider.dart';
import 'components/m3e_toggle_button_group_scope.dart';
import 'controllers/m3e_button_group_overflow_controller.dart';
import 'enums/m3e_toggle_button_group_enums.dart';
import 'models/m3e_button_group_action.dart';
import 'models/m3e_button_group_overflow_paging_window.dart';

export 'components/m3e_toggle_button_group_scope.dart';
export 'enums/m3e_toggle_button_group_enums.dart';
export 'styles/m3e_toggle_button_group_theme.dart';

part 'components/m3e_button_group_align.dart';
part 'components/m3e_button_group_parent_data.dart';
part 'components/m3e_toggle_button_group_collaborators.dart';
part 'components/m3e_toggle_button_group_overflow_presenter.dart';
part 'components/m3e_toggle_button_group_render.dart';
part 'components/m3e_toggle_button_group_measurement.dart';
part 'components/m3e_toggle_button_group_layout.dart';
part 'components/m3e_toggle_button_group_build.dart';

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
  /// const.
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

  /// final.

  final List<M3EButtonGroupAction> actions;

  /// final.
  final M3EButtonGroupType type;

  /// final.
  final M3EButtonShape shape;

  /// final.
  final M3EButtonSize size;

  /// final.
  final M3EButtonStyle style;

  /// final.
  final M3EButtonGroupDensity density;

  /// final.
  final double? spacing;

  /// final.
  final Axis direction;

  /// final.
  final int? selectedIndex;

  /// final.
  final Set<int>? selectedIndices;

  /// final.
  final ValueChanged<int?>? onSelectedIndexChanged;

  /// final.
  final ValueChanged<Set<int>>? onSelectedIndicesChanged;

  /// final.
  final bool neighborSquish;

  /// final.
  final double expandedRatio;

  /// final.
  final M3EHapticFeedback haptic;

  /// final.
  final bool enableFeedback;

  /// final.
  final M3EToggleButtonDecoration? decoration;

  /// final.
  final String? semanticLabel;

  /// final.
  final Clip clipBehavior;

  /// final.
  final M3EButtonGroupOverflow overflow;

  /// final.
  final Widget? overflowIcon;

  /// final.
  final M3EOverflowPopupDecoration overflowPopupDecoration;

  /// final.
  final M3EOverflowBottomSheetDecoration overflowBottomSheetDecoration;

  /// final.
  final M3EButtonGroupOverflowMenuStyle overflowMenuStyle;

  /// final.
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

  double _iconOnlyNaturalSizeCache = 40;

  bool get _supportsAnimatedSquish =>
      widget.direction == Axis.horizontal &&
      !widget._connected &&
      widget.neighborSquish;

  late List<M3EToggleButtonDecoration> _cachedDecorations;

  @override
  void initState() {
    super.initState();
    _assertControlledSelection();
    _bootstrapState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateIconOnlyNaturalSizeCache();
    _scheduleMeasurementIfNeeded();
  }

  @override
  void didUpdateWidget(covariant M3EButtonGroup old) {
    super.didUpdateWidget(old);
    _assertControlledSelection();
    _applyWidgetUpdate(old);
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<M3EButtonGroupType>('type', widget.type))
      ..add(EnumProperty<M3EButtonShape>('shape', widget.shape))
      ..add(DiagnosticsProperty<M3EButtonSize>('size', widget.size))
      ..add(IntProperty('actionCount', widget.actions.length))
      ..add(EnumProperty<M3EButtonGroupOverflow>('overflow', widget.overflow))
      ..add(
        FlagProperty(
          'neighborSquish',
          value: widget.neighborSquish,
          ifTrue: 'squish',
        ),
      )
      ..add(FlagProperty('hasLabels', value: _hasAnyLabel, ifTrue: 'labeled'));
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildGroup);
  }

  @override
  void _handleOverflowActionSelection(int index) {
    _applyOverflowActionSelection(index);
  }

  @override
  bool _isToggleActionSelected(int index) {
    return _resolveToggleActionSelected(index);
  }
}
