// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

/// Describes the visible window of items in a paged overflow layout.
class M3EButtonGroupOverflowPagingWindow {
  /// M3EButtonGroupOverflowPagingWindow.
  const M3EButtonGroupOverflowPagingWindow({
    required this.start,
    required this.end,
    required this.needsBack,
    required this.needsForward,
  });

  /// start.

  final int start;

  /// end.
  final int end;

  /// needsBack.
  final bool needsBack;

  /// needsForward.
  final bool needsForward;
}
