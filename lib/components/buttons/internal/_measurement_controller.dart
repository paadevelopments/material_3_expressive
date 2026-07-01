// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/buttons/_vendor_exports.dart';

class ButtonMeasurementController {
  ButtonMeasurementController({required int actionCount}) {
    _initialize(actionCount);
  }

  late List<GlobalKey> _uncheckedKeys;
  late List<GlobalKey> _checkedKeys;
  late List<double?> _measuredUncheckedWidths;
  late List<double?> _measuredCheckedWidths;
  late List<WidgetStatesController> _measurerUncheckedControllers;
  late List<WidgetStatesController> _measurerCheckedControllers;
  bool _stableAllOverflowMeasured = false;
  int _generation = 0;

  List<GlobalKey> get uncheckedKeys => _uncheckedKeys;
  List<GlobalKey> get checkedKeys => _checkedKeys;
  List<double?> get measuredUncheckedWidths => _measuredUncheckedWidths;
  List<double?> get measuredCheckedWidths => _measuredCheckedWidths;
  bool get stableAllOverflowMeasured => _stableAllOverflowMeasured;
  int get generation => _generation;

  void _initialize(int actionCount) {
    _uncheckedKeys = List.generate(actionCount, (_) => GlobalKey());
    _checkedKeys = List.generate(actionCount, (_) => GlobalKey());
    _measuredUncheckedWidths = List.filled(actionCount, null);
    _measuredCheckedWidths = List.filled(actionCount, null);
    _measurerUncheckedControllers = List.generate(
      actionCount,
      (_) => WidgetStatesController(),
    );
    _measurerCheckedControllers = List.generate(
      actionCount,
      (_) => WidgetStatesController(),
    );
    _stableAllOverflowMeasured = false;
    _generation = 0;
  }

  bool isMeasured(int index) {
    return _measuredUncheckedWidths[index] != null &&
        _measuredCheckedWidths[index] != null;
  }

  bool needsDistinctCheckedMeasurement(M3EButtonGroupAction action) {
    return action.checkedLabel != null || action.checkedIcon != null;
  }

  void reset(int actionCount) {
    dispose();
    _initialize(actionCount);
  }

  void incrementGeneration() {
    _generation++;
    _stableAllOverflowMeasured = false;
  }

  void updateMeasurements(
    List<M3EButtonGroupAction> actions,
    double iconOnlyFallback,
    bool Function(M3EButtonGroupAction) needsDistinctChecked,
  ) {
    bool anyChanged = false;
    for (int i = 0; i < actions.length; i++) {
      final action = actions[i];
      if (action.label == null && action.checkedLabel == null) {
        continue;
      }

      // Measure Unchecked
      final ctxU = _uncheckedKeys[i].currentContext;
      final renderU = ctxU?.findRenderObject() as RenderBox?;
      if (renderU != null && renderU.hasSize) {
        final measured = renderU.size.width;
        if (_measuredUncheckedWidths[i] != measured) {
          _measuredUncheckedWidths[i] = measured;
          anyChanged = true;
        }
      }

      if (!needsDistinctChecked(action)) {
        final resolved = _measuredUncheckedWidths[i] ?? iconOnlyFallback;
        if (_measuredCheckedWidths[i] != resolved) {
          _measuredCheckedWidths[i] = resolved;
          anyChanged = true;
        }
        continue;
      }

      // Measure Checked
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

    if (anyChanged && allOverflowExtentsMeasured(actions)) {
      _stableAllOverflowMeasured = true;
    }
  }

  bool allOverflowExtentsMeasured(List<M3EButtonGroupAction> actions) {
    for (int i = 0; i < actions.length; i++) {
      final action = actions[i];
      if (action.label != null || action.checkedLabel != null) {
        if (!isMeasured(i)) return false;
      }
    }
    return true;
  }

  double naturalSizeForButton(
    int index,
    bool checked,
    double iconOnlyFallback,
  ) {
    if (index < 0 || index >= _measuredUncheckedWidths.length) {
      return iconOnlyFallback;
    }
    final widths = checked ? _measuredCheckedWidths : _measuredUncheckedWidths;
    return widths[index] ?? iconOnlyFallback;
  }

  void dispose() {
    for (final c in _measurerUncheckedControllers) {
      c.dispose();
    }
    for (final c in _measurerCheckedControllers) {
      c.dispose();
    }
    _measurerUncheckedControllers = [];
    _measurerCheckedControllers = [];
  }
}
