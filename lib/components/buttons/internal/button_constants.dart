// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/services.dart';

import 'package:material_3_expressive/components/buttons/style/m3e_button_enums.dart';

/// Shared numeric constants used throughout the button package.
///
/// All magic numbers that appear in more than one place, or that map to a
/// named concept, should be defined here rather than inlined.
abstract final class ButtonConstants {
  // ── Screen / layout ──────────────────────────────────────────────────────

  /// Minimum distance between any popup / dropdown and the screen edge (dp).
  static const double kScreenEdgePadding = 12.0;

  // ── Animation ───────────────────────────────────────────────────────────

  /// Spring progress threshold at which a pending press-release is committed.
  /// When the animated width returns to >= 75 % of its natural size the
  /// neighbor-squish is considered done.
  static const double kPressReleaseThreshold = 0.75;

  /// How long to wait for a press-release threshold before forcing a reset.
  static const Duration kReleaseTimeout = Duration(seconds: 1);

  // ── Measurement ──────────────────────────────────────────────────────────

  /// Default natural-width fallback for icon-only buttons before the first
  /// measurement completes. Equals the `sm` token height (40 dp).
  static const double kIconOnlyNaturalSizeFallback = 40.0;

  // ── Overflow / scope ─────────────────────────────────────────────────────

  /// Sentinel `index` passed to [M3EButtonGroupItemScope] for the overflow
  /// trigger button. Must be a value that is never a real action index.
  /// The scope's `isLast` getter uses `_visualIsLast` directly; the index
  /// value itself is never used for corner-radius logic.
  static const int kOverflowTriggerScopeIndex = 999;

  // ── Focus ring ───────────────────────────────────────────────────────────

  /// Gap between the component edge and the focus ring outline (dp).
  /// Keep in sync with [M3EButtonTokensAdapter.focusRingGap].
  static const double kFocusRingGap = 2.0;

  /// Stroke width of the focus ring outline (dp).
  /// Keep in sync with [M3EButtonTokensAdapter.focusRingWidth].
  static const double kFocusRingWidth = 2.0;

  // ── Colors / opacity ─────────────────────────────────────────────────────

  /// Alpha value for disabled foreground color (text/icons).
  /// Reduces opacity to 38% for disabled state.
  static const double kDisabledForegroundAlpha = 0.38;

  /// Alpha value for disabled background color.
  /// Reduces opacity to 12% for disabled state.
  static const double kDisabledBackgroundAlpha = 0.12;

  /// Alpha value for disabled outline/border color.
  /// Reduces opacity to 12% for disabled state.
  static const double kDisabledOutlineAlpha = 0.12;

  // ── Radius ───────────────────────────────────────────────────────────────

  /// Ratio used to calculate pressed corner radius from square radius.
  /// Pressed radius = squareRadius * kPressedRadiusRatio, clamped to [6, 18].
  static const double kPressedRadiusRatio = 0.6;

  /// Minimum pressed corner radius in dp.
  static const double kMinPressedRadius = 6.0;

  /// Maximum pressed corner radius in dp.
  static const double kMaxPressedRadius = 18.0;

  // ── Animation thresholds ─────────────────────────────────────────────────

  /// Minimum delta threshold for triggering animation progress update.
  /// Prevents floating-point noise from triggering micro-updates.
  static const double kAnimationDeltaThreshold = 0.5;

  /// Triggers haptic feedback for the selected [M3EHapticFeedback] level.
  static void triggerHapticFeedback(M3EHapticFeedback haptic) {
    switch (haptic) {
      case M3EHapticFeedback.light:
        HapticFeedback.lightImpact();
      case M3EHapticFeedback.medium:
        HapticFeedback.mediumImpact();
      case M3EHapticFeedback.heavy:
        HapticFeedback.heavyImpact();
      case M3EHapticFeedback.none:
        break;
    }
  }
}
