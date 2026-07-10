import 'dart:ui' show clampDouble;

import 'package:flutter/widgets.dart';

import '../../../foundations/m3e_theme_extension.dart';
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

/// Theme values for `M3EButtonGroup`.
@immutable
class M3EToggleButtonGroupTheme
    extends M3EThemeExtension<M3EToggleButtonGroupTheme> {
  const M3EToggleButtonGroupTheme({
    this.standardSpacing = 8,
    this.connectedGap = 2,
    this.dividerThickness = 1,
    this.connectedInnerRadius = 6,
    this.connectedPressedInnerRadius = 2,
    this.expandedRatio = 0.15,
    this.fullRoundRadius = 9999,
  });

  static const M3EToggleButtonGroupTheme defaults =
      M3EToggleButtonGroupTheme();

  final double standardSpacing;
  final double connectedGap;
  final double dividerThickness;
  final double connectedInnerRadius;
  final double connectedPressedInnerRadius;
  final double expandedRatio;
  final double fullRoundRadius;

  static final Map<int, BorderRadius> _connectedRadiusCache = {};

  double squareRadiusFor(M3EButtonSize size) => switch (size.name) {
    'xs' => 8.0,
    'sm' => 12.0,
    'md' => 16.0,
    'lg' => 24.0,
    'xl' => 32.0,
    _ => 16.0,
  };

  M3EButtonGroupMetrics metricsFor(
    M3EButtonSize size,
    M3EButtonGroupDensity density, {
    bool isConnected = false,
  }) {
    final raw = isConnected ? connectedGap : standardSpacing;
    final spacing = density == M3EButtonGroupDensity.compact
        ? (raw * 0.75).floorToDouble()
        : raw;

    return M3EButtonGroupMetrics(
      spacing: spacing,
      runSpacing: spacing,
      dividerThickness: dividerThickness,
    );
  }

  BorderRadius groupRadiusFor(M3EButtonShape shape, M3EButtonSize size) =>
      shape == M3EButtonShape.round
      ? BorderRadius.circular(fullRoundRadius)
      : BorderRadius.circular(squareRadiusFor(size));

  BorderRadius connectedRadiusFor({
    required M3EButtonShape shape,
    required M3EButtonSize size,
    required bool isFirst,
    required bool isLast,
    required bool isPressed,
    required bool isSelected,
  }) {
    if (isSelected) {
      return BorderRadius.circular(fullRoundRadius);
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
        ? fullRoundRadius
        : squareRadiusFor(size);

    final innerRad = isPressed
        ? connectedPressedInnerRadius
        : connectedInnerRadius;

    final tl = isFirst ? outerRad : innerRad;
    final tr = isLast ? outerRad : innerRad;
    final bl = isFirst ? outerRad : innerRad;
    final br = isLast ? outerRad : innerRad;

    final result = BorderRadius.only(
      topLeft: Radius.circular(tl),
      topRight: Radius.circular(tr),
      bottomLeft: Radius.circular(bl),
      bottomRight: Radius.circular(br),
    );

    _connectedRadiusCache[cacheKey] = result;
    return result;
  }

  int _computeRadiusCacheKey({
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

  BorderRadius standardRadiusFor(M3EButtonShape shape, M3EButtonSize size) =>
      shape == M3EButtonShape.round
      ? BorderRadius.circular(fullRoundRadius)
      : BorderRadius.circular(squareRadiusFor(size));

  List<double> widthDeltas({
    required List<double> naturalWidths,
    required int? pressedIndex,
    double? expandedRatio,
  }) {
    final ratio = expandedRatio ?? this.expandedRatio;
    final n = naturalWidths.length;
    final deltas = List<double>.filled(n, 0);
    if (pressedIndex == null || n < 2) {
      return deltas;
    }

    final i = pressedIndex;
    final growth = ratio * naturalWidths[i];

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

  double overflowTriggerExtent(M3EButtonSize size) =>
      clampDouble(containerHeightFor(size), 40, 56);

  double containerHeightFor(M3EButtonSize size) => switch (size.name) {
    'xs' => 32.0,
    'sm' => 40.0,
    'md' => 56.0,
    'lg' => 96.0,
    'xl' => 136.0,
    _ => size.height ?? 56.0,
  };

  double fallbackChildWidth(M3EButtonSize size) => switch (size.name) {
    'xs' => 56.0,
    'sm' => 80.0,
    'md' => 100.0,
    'lg' => 120.0,
    'xl' => 140.0,
    _ => size.width ?? 100.0,
  };

  @override
  M3EToggleButtonGroupTheme copyWith({
    double? standardSpacing,
    double? connectedGap,
    double? dividerThickness,
    double? connectedInnerRadius,
    double? connectedPressedInnerRadius,
    double? expandedRatio,
    double? fullRoundRadius,
  }) {
    return M3EToggleButtonGroupTheme(
      standardSpacing: standardSpacing ?? this.standardSpacing,
      connectedGap: connectedGap ?? this.connectedGap,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      connectedInnerRadius: connectedInnerRadius ?? this.connectedInnerRadius,
      connectedPressedInnerRadius:
          connectedPressedInnerRadius ?? this.connectedPressedInnerRadius,
      expandedRatio: expandedRatio ?? this.expandedRatio,
      fullRoundRadius: fullRoundRadius ?? this.fullRoundRadius,
    );
  }

  @override
  M3EToggleButtonGroupTheme lerp(M3EToggleButtonGroupTheme? other, double t) {
    if (other is! M3EToggleButtonGroupTheme) {
      return this;
    }
    return M3EToggleButtonGroupTheme(
      standardSpacing:
          _lerpDouble(standardSpacing, other.standardSpacing, t)!,
      connectedGap: _lerpDouble(connectedGap, other.connectedGap, t)!,
      dividerThickness:
          _lerpDouble(dividerThickness, other.dividerThickness, t)!,
      connectedInnerRadius:
          _lerpDouble(connectedInnerRadius, other.connectedInnerRadius, t)!,
      connectedPressedInnerRadius: _lerpDouble(
        connectedPressedInnerRadius,
        other.connectedPressedInnerRadius,
        t,
      )!,
      expandedRatio: _lerpDouble(expandedRatio, other.expandedRatio, t)!,
      fullRoundRadius: _lerpDouble(fullRoundRadius, other.fullRoundRadius, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
