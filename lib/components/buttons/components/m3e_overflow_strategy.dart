// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.
import 'package:material_ui/material_ui.dart';

import '../../toggle_button_group/models/m3e_button_group_action.dart';
import '../enums/m3e_button_enums.dart';
import '../styles/m3e_button_decoration.dart';

/// Abstract base class for custom overflow implementations.
abstract class M3EOverflowStrategy {
  /// M3EOverflowStrategy.
  const M3EOverflowStrategy();

  /// id.

  String get id;

  /// triggerExtent.
  double? get triggerExtent => null;

  /// buildLayout.

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
    required Widget Function(
      int index, {
      required bool isFirst,
      required bool isLast,
    })
    buildButton,
  });

  /// buildOverflowTrigger.

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

  /// showOverflowMenu.

  Future<int?> showOverflowMenu({
    required BuildContext context,
    required List<M3EButtonGroupAction> actions,
    required int firstHiddenIndex,
    required int? selectedIndex,
  });

  /// onItemSelected.

  void onItemSelected(int index) {}

  /// Builds the ordered list of visible buttons, honouring RTL direction.
  @protected
  static List<Widget> buildVisibleButtons({
    required int count,
    required bool isRtl,
    required Widget Function(
      int index, {
      required bool isFirst,
      required bool isLast,
    })
    buildButton,
  }) {
    final children = <Widget>[];
    for (var i = 0; i < count; i++) {
      final isFirst = isRtl ? (i == count - 1) : (i == 0);
      final isLast = isRtl ? (i == 0) : (i == count - 1);
      children.add(buildButton(i, isFirst: isFirst, isLast: isLast));
    }
    return children;
  }

  /// Lays out [children] as a row or column for the given [direction].
  @protected
  static Widget axisFlex(List<Widget> children, Axis direction) {
    return direction == Axis.horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: children)
        : Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}
