// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/buttons/_vendor_exports.dart';

/// Callback type for building overflow menu content.
///
/// Used by [OverflowStrategy.buildOverflowMenu] to allow custom implementations
/// to define how overflow menu items are displayed.
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
///
/// Extend this class to provide custom overflow behavior for
/// [M3EButtonGroup] when the built-in overflow options are insufficient.
///
/// ## Example
/// ```dart
/// class CustomOverflowStrategy extends OverflowStrategy {
///   @override
///   String get id => 'custom';
///
///   @override
///   Widget buildLayout({
///     required BuildContext context,
///     required List<M3EButtonGroupAction> actions,
///     required int visibleCount,
///     required double spacing,
///     required Axis direction,
///     required M3EButtonStyle style,
///     required M3EButtonSize size,
///     required M3EToggleButtonDecoration? decoration,
///     required bool connected,
///     required Widget Function(int, bool, bool) buildButton,
///     required void Function(int) onOverflowAction,
///   }) {
///     // Return your custom layout
///   }
/// }
/// ```
///
/// Then use it with [M3EButtonGroup]:
/// ```dart
/// M3EButtonGroup(
///   actions: [...],
///   overflowStrategy: CustomOverflowStrategy(),
/// )
/// ```
abstract class OverflowStrategy {
  const OverflowStrategy();

  /// Unique identifier for this overflow strategy.
  ///
  /// Used for debugging and analytics. Should be a unique string
  /// that identifies the strategy implementation.
  String get id;

  /// Returns the estimated main-axis extent of the trigger built by [buildOverflowTrigger].
  ///
  /// If this returns [null], the group will fall back to a standard icon-only measurement.
  /// Provide this if your custom trigger is significantly wider than a standard
  /// icon button (for example, if it includes a text label) to prevent the
  /// group from overflowing and clipping the content.
  double? get triggerExtent => null;

  /// Builds the main layout of visible buttons.
  ///
  /// Override this to provide a custom visible layout when buttons overflow.
  /// Return a [Widget] that displays the visible portion of the button group.
  ///
  /// The [buildButton] callback creates a button at the given index with
  /// the appropriate [isFirstInGroup] and [isLastInGroup] flags.
  ///
  /// For example, a custom strategy might wrap buttons in a custom scrollable:
  /// ```dart
  /// Widget buildLayout({
  ///   required BuildContext context,
  ///   required List<M3EButtonGroupAction> actions,
  ///   required int visibleCount,
  ///   // ... other params
  /// }) {
  ///   return CustomScrollView(
  ///     slivers: [
  ///       for (int i = 0; i < visibleCount; i++)
  ///         SliverToBoxAdapter(
  ///           child: buildButton(i, i == 0, i == visibleCount - 1),
  ///         ),
  ///     ],
  ///   );
  /// }
  /// ```
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

  /// Builds the overflow trigger widget.
  ///
  /// This is the button that appears when there are hidden items,
  /// typically showing "..." or a menu icon.
  ///
  /// When [checked] is true, an overflow item is currently selected
  /// and the trigger should reflect the selected state (same colors/radius
  /// as other selected buttons in the group).
  ///
  /// Return [null] if no trigger should be shown.
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

  /// Opens the overflow menu when the trigger is pressed.
  ///
  /// Override this to provide custom menu behavior when the overflow
  /// trigger button is tapped.
  ///
  /// [selectedIndex] is the currently selected index (if any) in the overflow
  /// range, so the menu can highlight the selected item.
  ///
  /// Return the selected index from the menu, or [null] if cancelled.
  Future<int?> showOverflowMenu({
    required BuildContext context,
    required List<M3EButtonGroupAction> actions,
    required int firstHiddenIndex,
    required int? selectedIndex,
  });

  /// Called when an item is selected from the overflow menu.
  ///
  /// Override to handle the selection, typically by calling
  /// the group's selection callback.
  void onItemSelected(int index) {}
}

/// Strategy for no overflow (all buttons always visible).
///
/// Use with [M3EButtonGroup] to disable overflow handling:
/// ```dart
/// M3EButtonGroup(
///   overflowStrategy: const NoOverflowStrategy(),
/// )
/// ```
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

/// Strategy that scrolls overflowing buttons.
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
