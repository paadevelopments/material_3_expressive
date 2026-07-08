import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';
import '../enums/m3e_button_enums.dart';
import '../models/m3e_button_measurements.dart';
import '../res/m3e_button_constants.dart';

/// Theme values for [M3EButton].
@immutable
class M3EButtonTheme extends M3EThemeExtension<M3EButtonTheme> {
  const M3EButtonTheme({
    this.focusRingWidth = 2,
    this.focusRingGap = M3EButtonConstants.kFocusRingGap,
    this.minWidthFloor = 48,
    this.dividerHeight = 24,
    this.connectedInnerRadius = 8,
    this.connectedPressedInnerRadius = 4,
  });

  static const M3EButtonTheme defaults = M3EButtonTheme();

  final double focusRingWidth;
  final double focusRingGap;
  final double minWidthFloor;
  final double dividerHeight;
  final double connectedInnerRadius;
  final double connectedPressedInnerRadius;

  static final Map<M3EButtonSize, double> _squareRadiusTable = {
    M3EButtonSize.xs: 12,
    M3EButtonSize.sm: 12,
    M3EButtonSize.md: 16,
    M3EButtonSize.lg: 28,
    M3EButtonSize.xl: 28,
  };

  static final Map<M3EButtonSize, double> _pressedRadiusTable = {
    M3EButtonSize.xs: 8,
    M3EButtonSize.sm: 8,
    M3EButtonSize.md: 12,
    M3EButtonSize.lg: 16,
    M3EButtonSize.xl: 16,
  };

  static final Map<M3EButtonSize, double> _hoveredRadiusTable = {
    M3EButtonSize.xs: 10,
    M3EButtonSize.sm: 10,
    M3EButtonSize.md: 14,
    M3EButtonSize.lg: 22,
    M3EButtonSize.xl: 22,
  };

  static final Map<M3EButtonSize, double> _equalizedMinWidthTable = {
    M3EButtonSize.xs: 40,
    M3EButtonSize.sm: 56,
    M3EButtonSize.md: 72,
    M3EButtonSize.lg: 96,
    M3EButtonSize.xl: 120,
  };

  static final Map<M3EButtonSize, M3EButtonMeasurements> _measurementsTable = {
    M3EButtonSize.xs: const M3EButtonMeasurements(
      height: 32,
      hPadding: 16,
      iconSize: 20,
      iconGap: 8,
    ),
    M3EButtonSize.sm: const M3EButtonMeasurements(
      height: 40,
      hPadding: 16,
      iconSize: 20,
      iconGap: 8,
    ),
    M3EButtonSize.md: const M3EButtonMeasurements(
      height: 56,
      hPadding: 24,
      iconSize: 24,
      iconGap: 8,
    ),
    M3EButtonSize.lg: const M3EButtonMeasurements(
      height: 96,
      hPadding: 48,
      iconSize: 32,
      iconGap: 12,
    ),
    M3EButtonSize.xl: const M3EButtonMeasurements(
      height: 136,
      hPadding: 64,
      iconSize: 40,
      iconGap: 16,
    ),
  };

  Color container(M3EColorScheme scheme, M3EButtonStyle style) {
    switch (style) {
      case M3EButtonStyle.filled:
        return scheme.primary;
      case M3EButtonStyle.tonal:
        return scheme.secondaryContainer;
      case M3EButtonStyle.elevated:
        return scheme.surfaceContainerLow;
      case M3EButtonStyle.outlined:
      case M3EButtonStyle.text:
        return Colors.transparent;
    }
  }

  Color foreground(M3EColorScheme scheme, M3EButtonStyle style) {
    switch (style) {
      case M3EButtonStyle.filled:
        return scheme.onPrimary;
      case M3EButtonStyle.tonal:
        return scheme.onSecondaryContainer;
      case M3EButtonStyle.elevated:
      case M3EButtonStyle.outlined:
      case M3EButtonStyle.text:
        return scheme.primary;
    }
  }

  Color outline(M3EColorScheme scheme) => scheme.outline;

  Color focusRingColor(M3EColorScheme scheme) => scheme.primary;

  double elevation(M3EButtonStyle style, Set<WidgetState> states) {
    final hovered = states.contains(WidgetState.hovered);
    final pressed = states.contains(WidgetState.pressed);
    final disabled = states.contains(WidgetState.disabled);
    if (disabled) return 0;
    switch (style) {
      case M3EButtonStyle.elevated:
        return pressed ? 0 : hovered ? 3 : 1;
      case M3EButtonStyle.filled:
      case M3EButtonStyle.tonal:
        return pressed ? 0 : hovered ? 1 : 0;
      case M3EButtonStyle.outlined:
      case M3EButtonStyle.text:
        return 0;
    }
  }

  double squareRadius(M3EButtonSize size) => _squareRadiusTable[size] ?? 12;

  double pressedRadius(M3EButtonSize size) => _pressedRadiusTable[size] ?? 12;

  double hoveredRadius(M3EButtonSize size) => _hoveredRadiusTable[size] ?? 16;

  double equalizedMinWidth(M3EButtonSize size) =>
      _equalizedMinWidthTable[size] ?? 72;

  M3EButtonMeasurements measurements(
    M3EButtonSize size, {
    M3EButtonSize? override,
  }) {
    final base = _tokenMeasurements(size);
    if (override == null) {
      if (size.name == 'custom') {
        return base.applyCustomSize(size);
      }
      return base;
    }
    final overrideBase = _tokenMeasurements(override);
    return overrideBase.applyCustomSize(override);
  }

  M3EButtonMeasurements _tokenMeasurements(M3EButtonSize size) {
    for (final variant in _measurementsTable.keys) {
      if (variant.name == size.name) return _measurementsTable[variant]!;
    }
    return _measurementsTable[M3EButtonSize.md]!;
  }

  @override
  M3EButtonTheme copyWith({
    double? focusRingWidth,
    double? focusRingGap,
    double? minWidthFloor,
    double? dividerHeight,
    double? connectedInnerRadius,
    double? connectedPressedInnerRadius,
  }) {
    return M3EButtonTheme(
      focusRingWidth: focusRingWidth ?? this.focusRingWidth,
      focusRingGap: focusRingGap ?? this.focusRingGap,
      minWidthFloor: minWidthFloor ?? this.minWidthFloor,
      dividerHeight: dividerHeight ?? this.dividerHeight,
      connectedInnerRadius: connectedInnerRadius ?? this.connectedInnerRadius,
      connectedPressedInnerRadius:
          connectedPressedInnerRadius ?? this.connectedPressedInnerRadius,
    );
  }

  @override
  M3EButtonTheme lerp(M3EButtonTheme? other, double t) {
    if (other is! M3EButtonTheme) {
      return this;
    }
    return M3EButtonTheme(
      focusRingWidth: _lerpDouble(focusRingWidth, other.focusRingWidth, t)!,
      focusRingGap: _lerpDouble(focusRingGap, other.focusRingGap, t)!,
      minWidthFloor: _lerpDouble(minWidthFloor, other.minWidthFloor, t)!,
      dividerHeight: _lerpDouble(dividerHeight, other.dividerHeight, t)!,
      connectedInnerRadius:
          _lerpDouble(connectedInnerRadius, other.connectedInnerRadius, t)!,
      connectedPressedInnerRadius: _lerpDouble(
        connectedPressedInnerRadius,
        other.connectedPressedInnerRadius,
        t,
      )!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
