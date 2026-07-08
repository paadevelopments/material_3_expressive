// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';

import '../models/m3e_button_group_overflow_paging_window.dart';

/// Reactive controller for managing the overflow state of a button group.
///
/// This controller holds the state of the overflow window and measurement
/// stability, allowing descendants to react to changes in the overflow
/// layout.
class M3EButtonGroupOverflowController {
  /// Creates a reactive overflow controller.
  M3EButtonGroupOverflowController({
    int windowStartIndex = 0,
    bool stableAllOverflowMeasured = false,
  }) : windowStartIndex = ValueNotifier<int>(windowStartIndex),
       stableAllOverflowMeasured = ValueNotifier<bool>(
         stableAllOverflowMeasured,
       );

  /// The start index of the current paging window.
  ///
  /// When this value changes, the layout pass will recompute which items are
  /// visible in the main group vs. the overflow menu.
  final ValueNotifier<int> windowStartIndex;

  /// Whether all overflow items have been measured and the state is stable.
  ///
  /// This is used to prevent layout jitters or "ghost" frames while the
  /// overflow strategy is still determining the final visible counts.
  final ValueNotifier<bool> stableAllOverflowMeasured;

  /// Disposes the notifiers.
  void dispose() {
    windowStartIndex.dispose();
    stableAllOverflowMeasured.dispose();
  }

  static double roundConsumed(double extent) => extent.ceilToDouble();

  static double roundAvailable(double extent) => extent.floorToDouble();

  static bool hasMainExtentChanged(double? last, double current) {
    return last == null || (last - current).abs() > 0.5;
  }

  /// Computes the number of items that can fit in the main group before the
  /// overflow menu trigger.
  int computeVisibleCountForMenu({
    required double maxMain,
    required List<double> itemExtents,
    required double triggerExtent,
    required double Function() separatorExtent,
  }) {
    final availableMain = roundAvailable(maxMain);
    double currentExtent = 0.0;
    int visibleCount = 0;

    for (int i = 0; i < itemExtents.length; i++) {
      final gapBefore = i == 0 ? 0.0 : separatorExtent();
      final remainingAfter = itemExtents.length - i - 1;
      final reservedForTrigger = remainingAfter > 0
          ? separatorExtent() + triggerExtent
          : 0.0;
      final nextExtent = currentExtent + gapBefore + itemExtents[i];
      if (nextExtent + reservedForTrigger < availableMain) {
        currentExtent = nextExtent;
        visibleCount = i + 1;
      } else {
        break;
      }
    }

    return visibleCount;
  }

  /// Computes the paging window based on the current [windowStartIndex] and
  /// available space.
  M3EButtonGroupOverflowPagingWindow computePagingWindow({
    required double maxMain,
    required List<double> itemExtents,
    required double triggerExtent,
    required double Function(int indexBefore) separatorBetweenItems,
    required double Function(bool isFirst) separatorBeforeOverflow,
  }) {
    final effectiveMaxMain = roundAvailable(maxMain);
    int windowStart = windowStartIndex.value.clamp(0, itemExtents.length);
    bool needsBack = windowStart > 0;
    bool needsForward = false;

    double currentWidth = 0.0;
    if (needsBack) {
      currentWidth += triggerExtent + separatorBeforeOverflow(true);
    }

    int windowEnd = windowStart;
    for (int i = windowStart; i < itemExtents.length; i++) {
      final itemExtent = itemExtents[i];
      final gap = separatorBeforeOverflow(i == windowStart && !needsBack);
      if (currentWidth + gap + itemExtent < effectiveMaxMain) {
        currentWidth += gap + itemExtent;
        windowEnd = i;
      } else {
        needsForward = true;
        break;
      }
    }

    if (needsForward) {
      while (windowEnd >= windowStart) {
        final gapBeforeForward = separatorBeforeOverflow(false);
        if (currentWidth + gapBeforeForward + triggerExtent <
            effectiveMaxMain) {
          break;
        }
        final gapBeforeItem = separatorBeforeOverflow(
          windowEnd == windowStart && !needsBack,
        );
        currentWidth -= gapBeforeItem + itemExtents[windowEnd];
        windowEnd--;
      }
    }

    final window = M3EButtonGroupOverflowPagingWindow(
      start: windowStart,
      end: windowEnd,
      needsBack: needsBack,
      needsForward: needsForward,
    );

    // Sync: Ensure the reactive state matches the computed window start.
    if (window.start != windowStartIndex.value) {
      windowStartIndex.value = window.start;
    }

    return window;
  }
}
