// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';

import '../../toggle_button_group/models/m3e_button_group_action.dart';
import '../enums/m3e_button_enums.dart';
import '../styles/m3e_button_decoration.dart';
import 'm3e_overflow_strategy.dart';

/// Overflow strategy that scrolls the actions inline in a single axis.
class M3EScrollOverflowStrategy extends M3EOverflowStrategy {
  const M3EScrollOverflowStrategy();

  @override
  String get id => 'scroll';

  @override
  Widget buildLayout({
    required BuildContext context,
    required List<M3EButtonGroupAction> actions,
    required int visibleCount,
    required double spacing,
    required Axis direction,
    required M3EButtonStyle style,
    required M3EButtonSize size,
    required M3EToggleButtonDecoration? decoration,
    required bool connected,
    required bool isRtl,
    required Widget Function(int index, bool isFirst, bool isLast) buildButton,
  }) {
    final children = M3EOverflowStrategy.buildVisibleButtons(
      count: actions.length,
      isRtl: isRtl,
      buildButton: buildButton,
    );

    return SingleChildScrollView(
      scrollDirection: direction,
      primary: false,
      clipBehavior: Clip.hardEdge,
      child: M3EOverflowStrategy.axisFlex(children, direction),
    );
  }

  @override
  Widget? buildOverflowTrigger({
    required BuildContext context,
    required int hiddenCount,
    required M3EButtonStyle style,
    required M3EButtonSize size,
    required M3EToggleButtonDecoration? decoration,
    required bool connected,
    required bool isFirst,
    required bool isLast,
    required VoidCallback onPressed,
    required bool checked,
  }) => null;

  @override
  Future<int?> showOverflowMenu({
    required BuildContext context,
    required List<M3EButtonGroupAction> actions,
    required int firstHiddenIndex,
    required int? selectedIndex,
  }) async => null;
}
