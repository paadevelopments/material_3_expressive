// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';

import 'package:material_3_expressive/components/buttons/style/m3e_button_motion.dart';

/// Styling configuration for the overflow popup menu in [M3EButtonGroup].
///
/// Use with [M3EButtonGroup.overflowPopupDecoration] to customize the
/// appearance of the overflow menu when [M3EButtonGroupOverflow.menu] is used.
///
/// ## Card List Style
///
/// By default, items use the M3E card list style with outer/inner radius treatment.
/// Set [useCardList] to `false` to use a traditional ListTile-style menu instead.
///
/// ## Example
/// ```dart
/// M3EButtonGroup(
///   overflow: M3EButtonGroupOverflow.menu,
///   overflowPopupDecoration: M3EOverflowPopupDecoration(
///     backgroundColor: Colors.surface,
///     elevation: 8,
///     useCardList: true,
///     outerRadius: 16,
///     innerRadius: 4,
///     trailing: const Icon(Icons.check_rounded),
///   ),
///   // ...
/// )
/// ```
///
/// See also:
/// - [M3EOverflowBottomSheetDecoration] for bottom sheet styling
/// - [M3EButtonGroup] for the overflow menu source
class M3EOverflowPopupDecoration {
  /// Background color of the popup menu.
  final Color? backgroundColor;

  /// Elevation of the popup menu.
  final double elevation;

  /// Border radius of the popup menu container.
  final BorderRadius? borderRadius;

  /// Border of the popup menu.
  final BorderSide? border;

  /// Minimum width of the popup menu.
  final double minWidth;

  /// Maximum width of the popup menu.
  final double maxWidth;

  /// Maximum height of the popup menu.
  final double maxHeight;

  /// Padding of the popup menu list.
  final EdgeInsetsGeometry padding;

  /// Offset from the trigger button.
  final Offset offset;

  /// Whether to use the M3E card list style for popup items.
  /// When true, items have rounded corners with outer/inner radius treatment.
  /// When false, uses standard ListTile style with selectedColor and selectedBorderRadius.
  /// Defaults to `true`.
  final bool useCardList;

  /// Outer radius applied to the first and last popup item cards
  /// (the "cap" corners), mirroring the M3E card list treatment.
  /// Only used when [useCardList] is true.
  /// Defaults to `12.0`.
  final double outerRadius;

  /// Inner radius applied to middle popup item cards.
  /// Only used when [useCardList] is true.
  /// Defaults to `4.0`.
  final double innerRadius;

  /// Border radius applied to a selected item.
  /// When null, falls back to [outerRadius].
  final double? selectedBorderRadius;

  /// Background color for selected items.
  final Color? selectedBackgroundColor;

  /// Background color for items (non-selected).
  final Color? itemBackgroundColor;

  /// Gap between items.
  /// Defaults to `3.0`.
  final double itemGap;

  /// Custom trailing widget shown for selected items.
  ///
  /// When an item is selected, this widget appears at the trailing edge
  /// of the item row. Set to `null` to hide the trailing indicator.
  /// Defaults to [Icons.check_rounded].
  final Widget? trailing;

  /// Inner padding applied to each popup item.
  final EdgeInsetsGeometry itemPadding;

  /// Spring animation configuration for the popup menu.
  ///
  /// Controls the spring physics for the menu open/close animation.
  /// Defaults to a snappy spring (stiffness: 1600, damping: 0.85).
  final M3EButtonMotion motion;

  const M3EOverflowPopupDecoration({
    this.backgroundColor,
    this.elevation = 10.0,
    this.borderRadius,
    this.border,
    this.minWidth = 220.0,
    this.maxWidth = 280.0,
    this.maxHeight = 320.0,
    this.padding = const EdgeInsets.all(8),
    this.offset = const Offset(0, 6.0),
    this.useCardList = true,
    this.outerRadius = 12.0,
    this.innerRadius = 4.0,
    this.selectedBorderRadius,
    this.selectedBackgroundColor,
    this.itemBackgroundColor,
    this.itemGap = 3.0,
    this.trailing,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.motion = M3EButtonMotion.standardOverflow,
  });
}

/// Styling configuration for the overflow bottom sheet in [M3EButtonGroup].
///
/// Use with [M3EButtonGroup.overflowBottomSheetDecoration] to customize
/// the appearance of the bottom sheet when [M3EButtonGroupOverflowMenuStyle.bottomSheet]
/// is used.
///
/// ## Card List Style
///
/// By default, items use the M3E card list style with outer/inner radius treatment.
/// Set [useCardList] to `false` to use a traditional ListTile-style menu instead.
///
/// ## Example
/// ```dart
/// M3EButtonGroup(
///   overflow: M3EButtonGroupOverflow.menu,
///   overflowMenuStyle: M3EButtonGroupOverflowMenuStyle.bottomSheet,
///   overflowBottomSheetDecoration: M3EOverflowBottomSheetDecoration(
///     title: const Text('More Options'),
///     showDragHandle: true,
///     useCardList: true,
///     trailing: const Icon(Icons.check_rounded),
///   ),
///   // ...
/// )
/// ```
///
/// See also:
/// - [M3EOverflowPopupDecoration] for popup menu styling
/// - [M3EButtonGroup] for the overflow menu source
class M3EOverflowBottomSheetDecoration {
  /// Title shown at the top of the overflow sheet.
  final Widget? title;

  /// Background color of the bottom sheet.
  final Color? backgroundColor;

  /// Elevation of the bottom sheet.
  final double? elevation;

  /// Shape of the bottom sheet.
  final ShapeBorder? shape;

  /// Whether to show a drag handle at the top of the bottom sheet.
  final bool showDragHandle;

  /// Padding of the title.
  final EdgeInsetsGeometry titlePadding;

  /// Whether to use the M3E card list style for popup items.
  /// When true, items have rounded corners with outer/inner radius treatment.
  /// When false, uses standard ListTile style with selectedColor and selectedBorderRadius.
  /// Defaults to `true`.
  final bool useCardList;

  /// Outer radius applied to the first and last popup item cards
  /// (the "cap" corners), mirroring the M3E card list treatment.
  /// Only used when [useCardList] is true.
  /// Defaults to `12.0`.
  final double outerRadius;

  /// Inner radius applied to middle popup item cards.
  /// Only used when [useCardList] is true.
  /// Defaults to `4.0`.
  final double innerRadius;

  /// Border radius applied to a selected item.
  /// When null, falls back to [outerRadius].
  final double? selectedBorderRadius;

  /// Background color for selected items.
  final Color? selectedBackgroundColor;

  /// Background color for items (non-selected).
  final Color? itemBackgroundColor;

  /// Gap between items.
  /// Defaults to `3.0`.
  final double itemGap;

  /// Custom trailing widget shown for selected items.
  ///
  /// When an item is selected, this widget appears at the trailing edge
  /// of the item row. Set to `null` to hide the trailing indicator.
  /// Defaults to [Icons.check_rounded].
  final Widget? trailing;

  /// Inner padding applied to each popup item.
  final EdgeInsetsGeometry itemPadding;

  /// Spring animation configuration for the bottom sheet.
  ///
  /// Controls the spring physics for the sheet open/close animation.
  /// Defaults to a snappy spring (stiffness: 1600, damping: 0.85).
  final M3EButtonMotion motion;

  const M3EOverflowBottomSheetDecoration({
    this.title,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.showDragHandle = true,
    this.titlePadding = const EdgeInsets.fromLTRB(20, 8, 20, 12),
    this.useCardList = true,
    this.outerRadius = 12.0,
    this.innerRadius = 4.0,
    this.selectedBorderRadius,
    this.selectedBackgroundColor,
    this.itemBackgroundColor,
    this.itemGap = 3.0,
    this.trailing,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.motion = M3EButtonMotion.standardOverflow,
  });
}
