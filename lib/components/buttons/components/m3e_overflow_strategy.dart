// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import '../../toggle_button/toggle_button.dart';
import '../../toggle_button_group/toggle_button_group.dart';
import '../enums/m3e_button_enums.dart';
import '../styles/m3e_button_decoration.dart';

/// Callback type for building overflow menu content.
typedef OverflowMenuItemBuilder =
    Widget Function(
      BuildContext context,
      M3EButtonGroupAction action,
      bool isSelected,
    );

List<Widget> _buildVisibleButtons({
  required int count,
  required bool isRtl,
  required Widget Function(int index, bool isFirst, bool isLast) buildButton,
}) {
  final children = <Widget>[];
  for (int i = 0; i < count; i++) {
    final isFirst = isRtl ? (i == count - 1) : (i == 0);
    final isLast = isRtl ? (i == 0) : (i == count - 1);
    children.add(buildButton(i, isFirst, isLast));
  }
  return children;
}

Widget _axisFlex(List<Widget> children, Axis direction) {
  return direction == Axis.horizontal
      ? Row(mainAxisSize: MainAxisSize.min, children: children)
      : Column(mainAxisSize: MainAxisSize.min, children: children);
}

/// Abstract base class for custom overflow implementations.
abstract class OverflowStrategy {
  const OverflowStrategy();

  String get id;
  double? get triggerExtent => null;

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
  });

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
  });

  Future<int?> showOverflowMenu({
    required BuildContext context,
    required List<M3EButtonGroupAction> actions,
    required int firstHiddenIndex,
    required int? selectedIndex,
  });

  void onItemSelected(int index) {}
}

class NoOverflowStrategy extends OverflowStrategy {
  const NoOverflowStrategy();

  @override
  String get id => 'none';

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
    final children = _buildVisibleButtons(
      count: actions.length,
      isRtl: isRtl,
      buildButton: buildButton,
    );
    return _axisFlex(children, direction);
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

class ScrollOverflowStrategy extends OverflowStrategy {
  const ScrollOverflowStrategy();

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
    final children = _buildVisibleButtons(
      count: actions.length,
      isRtl: isRtl,
      buildButton: buildButton,
    );

    return SingleChildScrollView(
      scrollDirection: direction,
      primary: false,
      clipBehavior: Clip.hardEdge,
      child: _axisFlex(children, direction),
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
