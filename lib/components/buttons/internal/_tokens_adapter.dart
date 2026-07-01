// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

// ignore_for_file: constant_identifier_names

import 'dart:ui' show clampDouble;

import 'package:flutter/widgets.dart';

import 'package:material_3_expressive/components/buttons/style/m3e_button_enums.dart';
import 'package:material_3_expressive/components/button_groups/style/m3e_button_group_enums.dart';

// ---------------------------------------------------------------------------
// M3EButtonGroupMetrics
// ---------------------------------------------------------------------------

/// Resolved layout measurements for a button group.
///
/// Produced by [ButtonGroupTokens.metricsFor] and consumed by the group's
/// layout logic to set gap sizes and divider widths.
@immutable
class M3EButtonGroupMetrics {
  const M3EButtonGroupMetrics({
    required this.spacing,
    required this.runSpacing,
    required this.dividerThickness,
  });

  /// Gap between adjacent buttons along the main axis (dp).
  final double spacing;

  /// Gap between button rows in a [Wrap] layout (dp).
  final double runSpacing;

  /// Width / height of dividers when `showDividers` is enabled (dp).
  final double dividerThickness;
}

// ── Public API ────────────────────────────────────────────────────────────

/// Resolves layout [M3EButtonGroupMetrics] for a given [size] and [density].
///
/// [isConnected] switches between the standard gap and the tighter
/// connected-group gap.
///
/// The [context] parameter is accepted for API forward-compatibility (future
/// token implementations may read theme extensions) but is not currently used —
/// all values are resolved from static token tables.
// ignore: avoid_unused_parameters
M3EButtonGroupMetrics metricsFor(
  BuildContext context,
  M3EButtonSize size,
  M3EButtonGroupDensity density, {
  bool isConnected = false,
}) => ButtonGroupTokens.metricsFor(size, density, isConnected: isConnected);

/// Returns a [BorderRadius] appropriate for the group's outer clip shape.
///
/// The [context] parameter is accepted for API forward-compatibility but is
/// not currently used — see [metricsFor].
// ignore: avoid_unused_parameters
BorderRadius radiusFor(
  BuildContext context,
  M3EButtonShape shape,
  M3EButtonSize size,
) => ButtonGroupTokens.groupRadiusFor(shape, size);

// ---------------------------------------------------------------------------
// ButtonGroupTokens  (namespace for all token helpers — no instance needed)
// ---------------------------------------------------------------------------

/// Static helpers that map [M3EButtonGroupSize] / [M3EButtonGroupShape] /
/// [M3EButtonGroupDensity] to concrete dp values.
///
/// These values are taken directly from the Material 3 Expressive token files
/// (`ButtonGroupSmallTokens`, `ConnectedButtonGroupSmallTokens`, etc.).
/// When those tokens ship in Flutter's material library the switch tables
/// below can be replaced with `ButtonGroupSmallTokens.BetweenSpace.value`.
abstract final class ButtonGroupTokens {
  // ── Standard group between-space (dp) ─────────────────────────────────────
  //
  // Compose: ButtonGroupSmallTokens.BetweenSpace  → 8dp for all sizes.
  // We intentionally keep a unified 8dp here; the per-size variant used
  // previously was not spec-based.
  static const double _kStandardSpacing = 8.0;

  // ── BorderRadius cache for connected group corners ─────────────────────────
  //
  // Cache key: (isFirst, isLast, isPressed, isSelected, sizeOrdinal, isSquare)
  // Size ordinal: 0=xs, 1=sm, 2=md, 3=lg, 4=xl
  // isSquare: 0=round, 1=square
  static final Map<int, BorderRadius> _connectedRadiusCache = {};

  // ── Connected group inner gap (dp) ────────────────────────────────────────
  //
  // Compose: ConnectedButtonGroupSmallTokens.BetweenSpace → 2dp
  /// Gap between adjacent buttons in a connected group (dp).
  /// Matches Compose: ConnectedButtonGroupSmallTokens.BetweenSpace.
  static const double kConnectedGap = 2.0;

  // ── Divider thickness (dp) ────────────────────────────────────────────────
  static const double _kDividerThickness = 1.0;

  // ── Connected group inner corner radii (dp) ───────────────────────────────
  //
  // Resting inner corner:  ConnectedButtonGroupSmallTokens.InnerCornerCornerSize
  // Pressed inner corner:  ConnectedButtonGroupSmallTokens.PressedInnerCornerCornerSize

  /// Inner corner radius for a resting connected button (non-edge side).
  static const double kConnectedInnerRadius = 6.0;

  /// Inner corner radius when the button (or its neighbor) is pressed.
  static const double kConnectedPressedInnerRadius = 2.0;

  // ── expandedRatio ─────────────────────────────────────────────────────────
  //
  // Compose: ButtonGroupDefaults.ExpandedRatio = 0.15f
  // The pressed button grows by expandedRatio × its own width.

  /// Default ratio by which the pressed button expands its own width.
  static const double kExpandedRatio = 0.15;

  // ── Shape radii (dp) ──────────────────────────────────────────────────────

  /// Very large radius used to produce a fully-round pill shape.
  static const double kFullRoundRadius = 9999.0;

  /// Per-size square-shape radii for [M3EButtonShape.square].
  static double squareRadiusFor(M3EButtonSize size) => switch (size.name) {
    'xs' => 8.0,
    'sm' => 12.0,
    'md' => 16.0,
    'lg' => 24.0,
    'xl' => 32.0,
    _ => 16.0,
  };

  // ── Public API ────────────────────────────────────────────────────────────

  /// Resolves layout [M3EButtonGroupMetrics] for a given [size] and [density].
  ///
  /// [isConnected] switches between the standard gap and the tighter
  /// connected-group gap.
  static M3EButtonGroupMetrics metricsFor(
    M3EButtonSize size,
    M3EButtonGroupDensity density, {
    bool isConnected = false,
  }) {
    final raw = isConnected ? kConnectedGap : _kStandardSpacing;
    final spacing = density == M3EButtonGroupDensity.compact
        ? (raw * 0.75).floorToDouble()
        : raw;

    // Run-spacing follows the same compact scaling; connected groups never
    // wrap so the value is not meaningful in that case but we still provide it.
    return M3EButtonGroupMetrics(
      spacing: spacing,
      runSpacing: spacing,
      dividerThickness: _kDividerThickness,
    );
  }

  /// Returns a [BorderRadius] appropriate for the group's outer clip shape.
  ///
  /// This is used to clip the entire group container (e.g. in a [ClipRRect]).
  /// Individual button corners are computed separately in [connectedRadiusFor].
  static BorderRadius groupRadiusFor(
    M3EButtonShape shape,
    M3EButtonSize size,
  ) => shape == M3EButtonShape.round
      ? BorderRadius.circular(kFullRoundRadius)
      : BorderRadius.circular(squareRadiusFor(size));

  // ── Connected-group per-button corner helpers ─────────────────────────────

  /// Resolves the [BorderRadius] for a single button inside a connected group.
  ///
  /// Rules (identical to Compose's `ButtonGroupDefaults`):
  /// - Outer corners (the edge facing away from the group) → `∞` (full round)
  ///   unless [shape] is [M3EButtonShape.square], in which case they use
  ///   [squareRadiusFor].
  /// - Resting inner corners → [kConnectedInnerRadius]
  /// - Pressed inner corners → [kConnectedPressedInnerRadius]
  /// - A "checked/selected" button → all corners become fully round.
  ///
  /// [isFirst] / [isLast] refer to position along the main axis.
  /// For LTR horizontal groups: isFirst = left, isLast = right.
  static BorderRadius connectedRadiusFor({
    required M3EButtonShape shape,
    required M3EButtonSize size,
    required bool isFirst,
    required bool isLast,
    required bool isPressed,
    required bool isSelected,
  }) {
    if (isSelected) {
      return BorderRadius.circular(kFullRoundRadius);
    }

    final int cacheKey = _computeRadiusCacheKey(
      isFirst: isFirst,
      isLast: isLast,
      isPressed: isPressed,
      isSelected: isSelected,
      size: size,
      shape: shape,
    );

    if (_connectedRadiusCache.containsKey(cacheKey)) {
      return _connectedRadiusCache[cacheKey]!;
    }

    final outerRad = shape == M3EButtonShape.round
        ? kFullRoundRadius
        : squareRadiusFor(size);

    final innerRad = isPressed
        ? kConnectedPressedInnerRadius
        : kConnectedInnerRadius;

    final double tl = isFirst ? outerRad : innerRad;
    final double tr = isLast ? outerRad : innerRad;
    final double bl = isFirst ? outerRad : innerRad;
    final double br = isLast ? outerRad : innerRad;

    final result = BorderRadius.only(
      topLeft: Radius.circular(tl),
      topRight: Radius.circular(tr),
      bottomLeft: Radius.circular(bl),
      bottomRight: Radius.circular(br),
    );

    _connectedRadiusCache[cacheKey] = result;
    return result;
  }

  static int _computeRadiusCacheKey({
    required bool isFirst,
    required bool isLast,
    required bool isPressed,
    required bool isSelected,
    required M3EButtonSize size,
    required M3EButtonShape shape,
  }) {
    final sizeOrdinal = switch (size.name) {
      'xs' => 0,
      'sm' => 1,
      'md' => 2,
      'lg' => 3,
      'xl' => 4,
      _ => 2,
    };
    final isSquare = shape == M3EButtonShape.square ? 1 : 0;
    return (isFirst ? 1 : 0) |
        ((isLast ? 1 : 0) << 1) |
        ((isPressed ? 1 : 0) << 2) |
        ((isSelected ? 1 : 0) << 3) |
        (sizeOrdinal << 4) |
        (isSquare << 7);
  }

  // ── Standard group per-button corner helpers ──────────────────────────────

  /// Resolves the resting [BorderRadius] for a standalone / standard-group button.
  static BorderRadius standardRadiusFor(
    M3EButtonShape shape,
    M3EButtonSize size,
  ) => shape == M3EButtonShape.round
      ? BorderRadius.circular(kFullRoundRadius)
      : BorderRadius.circular(squareRadiusFor(size));

  // ── Width expansion math ─────────────────────────────────────────────────

  /// Computes the delta-width adjustments for every button given which index
  /// is currently pressed.
  ///
  /// Returns a list of [widthDelta] values (positive = wider, negative =
  /// narrower) in the same order as the input [naturalWidths].
  ///
  /// Matches Compose's `NonAdaptiveButtonGroupMeasurePolicy` expand / compress
  /// logic exactly:
  /// - Edge buttons (first / last): grow by `expandedRatio × width`;
  ///   their single neighbor shrinks by the full growth.
  /// - Middle buttons: grow by `expandedRatio × width / 2` per side;
  ///   each of the two neighbors shrinks by half the growth.
  static List<double> widthDeltas({
    required List<double> naturalWidths,
    required int? pressedIndex,
    required double expandedRatio,
  }) {
    final n = naturalWidths.length;
    final deltas = List<double>.filled(n, 0.0);
    if (pressedIndex == null || n < 2) return deltas;

    final i = pressedIndex;
    final growth = expandedRatio * naturalWidths[i];

    if (i == 0) {
      // First button: grow self, shrink right neighbor.
      deltas[i] = growth;
      deltas[i + 1] = -growth;
    } else if (i == n - 1) {
      // Last button: grow self, shrink left neighbor.
      deltas[i] = growth;
      deltas[i - 1] = -growth;
    } else {
      // Middle button: half-growth to each neighbor.
      final half = growth / 2.0;
      deltas[i] = growth;
      deltas[i - 1] = -half;
      deltas[i + 1] = -half;
    }

    return deltas;
  }

  // ── Overflow trigger default size ─────────────────────────────────────────

  /// Approximate size of the overflow icon-button for the given [size].
  /// Used as a conservative pre-measurement fallback.
  static double overflowTriggerExtent(M3EButtonSize size) =>
      clampDouble(containerHeightFor(size), 40.0, 56.0);

  /// Container height in dp for [size]. Mirrors the Compose token values.
  static double containerHeightFor(M3EButtonSize size) => switch (size.name) {
    'xs' => 32.0,
    'sm' => 40.0,
    'md' => 56.0,
    'lg' => 96.0,
    'xl' => 136.0,
    _ => size.height ?? 56.0,
  };

  /// Fallback natural width for an unmeasured button.
  static double fallbackChildWidth(M3EButtonSize size) => switch (size.name) {
    'xs' => 56.0,
    'sm' => 80.0,
    'md' => 100.0,
    'lg' => 120.0,
    'xl' => 140.0,
    _ => size.width ?? 100.0,
  };
}
