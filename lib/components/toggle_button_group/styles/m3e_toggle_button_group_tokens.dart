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

import '../../buttons/enums/m3e_button_enums.dart';
import '../enums/m3e_toggle_button_group_enums.dart';

/// Resolved layout measurements for a button group.
@immutable
class M3EButtonGroupMetrics {
  const M3EButtonGroupMetrics({
    required this.spacing,
    required this.runSpacing,
    required this.dividerThickness,
  });

  final double spacing;
  final double runSpacing;
  final double dividerThickness;
}

/// Static helpers that map button group properties to concrete dp values.
abstract final class M3EButtonGroupTokens {
  static const double _kStandardSpacing = 8.0;
  static final Map<int, BorderRadius> _connectedRadiusCache = {};
  static const double kConnectedGap = 2.0;
  static const double _kDividerThickness = 1.0;
  static const double kConnectedInnerRadius = 6.0;
  static const double kConnectedPressedInnerRadius = 2.0;
  static const double kExpandedRatio = 0.15;
  static const double kFullRoundRadius = 9999.0;

  static double squareRadiusFor(M3EButtonSize size) => switch (size.name) {
    'xs' => 8.0,
    'sm' => 12.0,
    'md' => 16.0,
    'lg' => 24.0,
    'xl' => 32.0,
    _ => 16.0,
  };

  static M3EButtonGroupMetrics metricsFor(
    M3EButtonSize size,
    M3EButtonGroupDensity density, {
    bool isConnected = false,
  }) {
    final raw = isConnected ? kConnectedGap : _kStandardSpacing;
    final spacing = density == M3EButtonGroupDensity.compact
        ? (raw * 0.75).floorToDouble()
        : raw;

    return M3EButtonGroupMetrics(
      spacing: spacing,
      runSpacing: spacing,
      dividerThickness: _kDividerThickness,
    );
  }

  static BorderRadius groupRadiusFor(
    M3EButtonShape shape,
    M3EButtonSize size,
  ) => shape == M3EButtonShape.round
      ? BorderRadius.circular(kFullRoundRadius)
      : BorderRadius.circular(squareRadiusFor(size));

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

  static BorderRadius standardRadiusFor(
    M3EButtonShape shape,
    M3EButtonSize size,
  ) => shape == M3EButtonShape.round
      ? BorderRadius.circular(kFullRoundRadius)
      : BorderRadius.circular(squareRadiusFor(size));

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
      deltas[i] = growth;
      deltas[i + 1] = -growth;
    } else if (i == n - 1) {
      deltas[i] = growth;
      deltas[i - 1] = -growth;
    } else {
      final half = growth / 2.0;
      deltas[i] = growth;
      deltas[i - 1] = -half;
      deltas[i + 1] = -half;
    }

    return deltas;
  }

  static double overflowTriggerExtent(M3EButtonSize size) =>
      clampDouble(containerHeightFor(size), 40.0, 56.0);

  static double containerHeightFor(M3EButtonSize size) => switch (size.name) {
    'xs' => 32.0,
    'sm' => 40.0,
    'md' => 56.0,
    'lg' => 96.0,
    'xl' => 136.0,
    _ => size.height ?? 56.0,
  };

  static double fallbackChildWidth(M3EButtonSize size) => switch (size.name) {
    'xs' => 56.0,
    'sm' => 80.0,
    'md' => 100.0,
    'lg' => 120.0,
    'xl' => 140.0,
    _ => size.width ?? 100.0,
  };
}
