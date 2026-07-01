// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

/// How buttons in the group are visually connected.
///
/// Used by [M3EButtonGroup] to control whether buttons have gaps
/// ([standard]) or share edges ([connected]).
///
/// See also:
/// - [M3EButtonGroup] for the connected toggle button group
enum M3EButtonGroupType {
  /// Independent buttons with gaps between them. Spacing is controlled by
  /// [density] parameter.
  standard,

  /// Buttons share edges with no gap. Inner corners animate on press;
  /// outer corners of the first and last button are locked at the full-round
  /// radius, matching the Compose `ConnectedButtonGroup` spec.
  connected,
}

/// Spacing compactness between adjacent buttons.
///
/// Used by [M3EButtonGroup] to control the spacing between buttons.
///
/// See also:
/// - [M3EButtonGroup] for the connected toggle button group
enum M3EButtonGroupDensity {
  /// Full token spacing.
  regular,

  /// 75 % of token spacing, floored to the nearest dp.
  compact,
}

/// Controls how button groups handle overflow when wrap=false.
///
/// Used by [M3EButtonGroup] to control overflow behavior.
///
/// See also:
/// - [M3EButtonGroup] for the connected toggle button group
enum M3EButtonGroupOverflow {
  /// Do not handle overflow specially.
  none,

  /// Allow scrolling along the main axis when constraints are bounded.
  scroll,

  /// Replace overflow with a functional overflow menu trigger.
  menu,

  /// Shift the visible window in-place using back/forward overflow triggers.
  experimentalPaging,
}

/// Style for the overflow menu.
///
/// Used by [M3EButtonGroup] when [M3EButtonGroupOverflow.menu] is active.
///
/// See also:
/// - [M3EButtonGroup] for the connected toggle button group
enum M3EButtonGroupOverflowMenuStyle { popup, bottomSheet }
