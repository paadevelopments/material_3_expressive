// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_button_enums.dart';

/// Shared numeric constants used throughout the button package.
abstract final class M3EButtonConstants {
  /// Minimum distance between any popup / dropdown and the screen edge (dp).
  static const double kScreenEdgePadding = 12.0;

  /// Spring progress threshold at which a pending press-release is committed.
  static const double kPressReleaseThreshold = 0.75;

  /// How long to wait for a press-release threshold before forcing a reset.
  static const Duration kReleaseTimeout = Duration(seconds: 1);

  /// Default natural-width fallback for icon-only buttons.
  static const double kIconOnlyNaturalSizeFallback = 40.0;

  /// Sentinel `index` for the overflow trigger button.
  static const int kOverflowTriggerScopeIndex = 999;

  /// Gap between the component edge and the focus ring outline (dp).
  static const double kFocusRingGap = 2.0;

  /// Stroke width of the focus ring outline (dp).
  static const double kFocusRingWidth = 2.0;

  /// Alpha value for disabled foreground color (text/icons).
  static const double kDisabledForegroundAlpha = 0.38;

  /// Alpha value for disabled background color.
  static const double kDisabledBackgroundAlpha = 0.12;

  /// Alpha value for disabled outline/border color.
  static const double kDisabledOutlineAlpha = 0.12;

  /// Ratio used to calculate pressed corner radius from square radius.
  static const double kPressedRadiusRatio = 0.6;

  /// Minimum pressed corner radius in dp.
  static const double kMinPressedRadius = 6.0;

  /// Maximum pressed corner radius in dp.
  static const double kMaxPressedRadius = 18.0;

  /// Minimum delta threshold for triggering animation progress update.
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

/// Material 3 Button Measurements
@immutable
class M3EButtonMeasurements {
  const M3EButtonMeasurements({
    required this.height,
    required this.hPadding,
    required this.iconSize,
    required this.iconGap,
  });
  final double height;
  final double hPadding;
  final double iconSize;
  final double iconGap;

  M3EButtonMeasurements applyCustomSize(M3EButtonSize? custom) {
    if (custom == null) return this;
    return M3EButtonMeasurements(
      height: custom.height ?? height,
      hPadding: custom.hPadding ?? hPadding,
      iconSize: custom.iconSize ?? iconSize,
      iconGap: custom.iconGap ?? iconGap,
    );
  }
}

/// Material 3 Button Tokens Adapter
class M3EButtonTokens {
  M3EButtonTokens(this.context) {
    _updateCache();
  }
  final BuildContext context;

  ColorScheme? _cachedColorScheme;
  TextTheme? _cachedTextTheme;

  Color? _cachedOutline;
  Color? _cachedFocusRingColor;
  double? _cachedFocusRingWidth;
  double? _cachedFocusRingGap;
  double? _cachedMinWidthFloor;
  double? _cachedDividerHeight;

  static final Map<M3EButtonSize, double> _squareRadiusTable = {
    M3EButtonSize.xs: 12.0,
    M3EButtonSize.sm: 12.0,
    M3EButtonSize.md: 16.0,
    M3EButtonSize.lg: 28.0,
    M3EButtonSize.xl: 28.0,
  };

  static final Map<M3EButtonSize, double> _pressedRadiusTable = {
    M3EButtonSize.xs: 8.0,
    M3EButtonSize.sm: 8.0,
    M3EButtonSize.md: 12.0,
    M3EButtonSize.lg: 16.0,
    M3EButtonSize.xl: 16.0,
  };

  static final Map<M3EButtonSize, double> _hoveredRadiusTable = {
    M3EButtonSize.xs: 10.0,
    M3EButtonSize.sm: 10.0,
    M3EButtonSize.md: 14.0,
    M3EButtonSize.lg: 22.0,
    M3EButtonSize.xl: 22.0,
  };

  static final Map<M3EButtonSize, double> _equalizedMinWidthTable = {
    M3EButtonSize.xs: 40.0,
    M3EButtonSize.sm: 56.0,
    M3EButtonSize.md: 72.0,
    M3EButtonSize.lg: 96.0,
    M3EButtonSize.xl: 120.0,
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

  bool _shouldRecache() {
    final theme = m3eMaterialTheme(context);
    final currentColorScheme = theme.colorScheme;
    final currentTextTheme = theme.textTheme;
    return !identical(_cachedColorScheme, currentColorScheme) ||
        !identical(_cachedTextTheme, currentTextTheme);
  }

  void _updateCache() {
    final theme = m3eMaterialTheme(context);
    _cachedColorScheme = theme.colorScheme;
    _cachedTextTheme = theme.textTheme;

    _cachedOutline = _cachedColorScheme!.outline;
    _cachedFocusRingColor = _cachedColorScheme!.primary;
    _cachedFocusRingWidth = 2.0;
    _cachedFocusRingGap = M3EButtonConstants.kFocusRingGap;
    _cachedMinWidthFloor = 48.0;
    _cachedDividerHeight = 24.0;
  }

  void didChangeDependencies() {
    if (_shouldRecache()) {
      _updateCache();
    }
  }

  ColorScheme get c =>
      _cachedColorScheme ?? m3eMaterialTheme(context).colorScheme;

  Color container(M3EButtonStyle style) {
    switch (style) {
      case M3EButtonStyle.filled:
        return c.primary;
      case M3EButtonStyle.tonal:
        return c.secondaryContainer;
      case M3EButtonStyle.elevated:
        return c.surfaceContainerLow;
      case M3EButtonStyle.outlined:
      case M3EButtonStyle.text:
        return Colors.transparent;
    }
  }

  Color foreground(M3EButtonStyle style) {
    switch (style) {
      case M3EButtonStyle.filled:
        return c.onPrimary;
      case M3EButtonStyle.tonal:
        return c.onSecondaryContainer;
      case M3EButtonStyle.elevated:
      case M3EButtonStyle.outlined:
      case M3EButtonStyle.text:
        return c.primary;
    }
  }

  Color outline() => _cachedOutline ?? c.outline;
  Color focusRingColor() => _cachedFocusRingColor ?? c.primary;
  double focusRingWidth() => _cachedFocusRingWidth ?? 2.0;
  double focusRingGap() => _cachedFocusRingGap ?? 4.0;

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
  double pressedRadius(M3EButtonSize size) => _pressedRadiusTable[size] ?? 12.0;
  double hoveredRadius(M3EButtonSize size) => _hoveredRadiusTable[size] ?? 16.0;

  double connectedInnerRadius() => 8.0;
  double connectedPressedInnerRadius() => 4.0;
  double minWidthFloor() => _cachedMinWidthFloor ?? 48.0;
  double equalizedMinWidth(M3EButtonSize size) => _equalizedMinWidthTable[size] ?? 72.0;
  double dividerHeight() => _cachedDividerHeight ?? 24.0;

  M3EButtonMeasurements measurements(M3EButtonSize size, {M3EButtonSize? override}) {
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
}
