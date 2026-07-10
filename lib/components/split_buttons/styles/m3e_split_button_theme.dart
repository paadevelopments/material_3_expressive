import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../buttons/enums/m3e_button_enums.dart';
import '../../buttons/styles/m3e_button_motion.dart';

/// Theme values for `M3ESplitButton`.
@immutable
class M3ESplitButtonTheme extends M3EThemeExtension<M3ESplitButtonTheme> {
  const M3ESplitButtonTheme({
    this.minTapTarget = 48,
    this.innerGap = 2,
    this.elevatedInnerGap = 4,
    this.chevronOpenTurns = 0.5,
    this.trailingInnerSelectedCornerPercent = 50,
    this.popupElevation = 3,
    this.popupBorderRadius = 18,
    this.popupPadding = const EdgeInsets.symmetric(vertical: 8),
    this.popupOffset = const Offset(0, 4),
    this.popupMinWidth = 120,
    this.popupMaxWidth = 280,
    this.popupMaxHeight = 400,
    this.popupScrimAlpha = 0.26,
    this.popupMotion = M3EButtonMotion.standardPopup,
  });

  static const M3ESplitButtonTheme defaults = M3ESplitButtonTheme();

  final double minTapTarget;
  final double innerGap;
  final double elevatedInnerGap;
  final double chevronOpenTurns;
  final double trailingInnerSelectedCornerPercent;
  final double popupElevation;
  final double popupBorderRadius;
  final EdgeInsetsGeometry popupPadding;
  final Offset popupOffset;
  final double popupMinWidth;
  final double popupMaxWidth;
  final double popupMaxHeight;
  final double popupScrimAlpha;
  final M3EButtonMotion popupMotion;

  static final Map<M3EButtonSize, double> _splitHeight = {
    M3EButtonSize.xs: 32,
    M3EButtonSize.sm: 40,
    M3EButtonSize.md: 56,
    M3EButtonSize.lg: 96,
    M3EButtonSize.xl: 136,
  };

  static final Map<M3EButtonSize, double> _splitTrailingWidth = {
    M3EButtonSize.xs: 22,
    M3EButtonSize.sm: 22,
    M3EButtonSize.md: 26,
    M3EButtonSize.lg: 38,
    M3EButtonSize.xl: 50,
  };

  static final Map<M3EButtonSize, double> _splitInnerCornerRadius = {
    M3EButtonSize.xs: 4,
    M3EButtonSize.sm: 4,
    M3EButtonSize.md: 4,
    M3EButtonSize.lg: 8,
    M3EButtonSize.xl: 12,
  };

  static final Map<M3EButtonSize, double> _splitHoveredInnerCornerRadius = {
    M3EButtonSize.xs: 8,
    M3EButtonSize.sm: 12,
    M3EButtonSize.md: 12,
    M3EButtonSize.lg: 20,
    M3EButtonSize.xl: 20,
  };

  static final Map<M3EButtonSize, double> _splitInnerPadding = {
    M3EButtonSize.xs: 4,
    M3EButtonSize.sm: 4,
    M3EButtonSize.md: 4,
    M3EButtonSize.lg: 8,
    M3EButtonSize.xl: 12,
  };

  static final Map<M3EButtonSize, double> _splitMenuIconOffset = {
    M3EButtonSize.xs: -1,
    M3EButtonSize.sm: -1,
    M3EButtonSize.md: -2,
    M3EButtonSize.lg: -3,
    M3EButtonSize.xl: -6,
  };

  static final Map<M3EButtonSize, double> _splitIcon = {
    M3EButtonSize.xs: 20,
    M3EButtonSize.sm: 24,
    M3EButtonSize.md: 24,
    M3EButtonSize.lg: 32,
    M3EButtonSize.xl: 40,
  };

  static final Map<M3EButtonSize, double> _splitOuterRadiusRound = {
    M3EButtonSize.xs: 16,
    M3EButtonSize.sm: 20,
    M3EButtonSize.md: 28,
    M3EButtonSize.lg: 48,
    M3EButtonSize.xl: 68,
  };

  static final Map<M3EButtonSize, double> _splitOuterRadiusSquare = {
    M3EButtonSize.xs: 8,
    M3EButtonSize.sm: 10,
    M3EButtonSize.md: 14,
    M3EButtonSize.lg: 24,
    M3EButtonSize.xl: 34,
  };

  static final Map<M3EButtonSize, double> _splitPressedRadius = {
    M3EButtonSize.xs: 2,
    M3EButtonSize.sm: 2,
    M3EButtonSize.md: 2,
    M3EButtonSize.lg: 4,
    M3EButtonSize.xl: 6,
  };

  static final Map<M3EButtonSize, double> _splitLeadingIconBlockWidth = {
    M3EButtonSize.xs: 20,
    M3EButtonSize.sm: 20,
    M3EButtonSize.md: 24,
    M3EButtonSize.lg: 32,
    M3EButtonSize.xl: 40,
  };

  static final Map<M3EButtonSize, double> _splitLeftOuterPadding = {
    M3EButtonSize.xs: 12,
    M3EButtonSize.sm: 16,
    M3EButtonSize.md: 24,
    M3EButtonSize.lg: 48,
    M3EButtonSize.xl: 64,
  };

  static final Map<M3EButtonSize, double> _splitGapIconToLabel = {
    M3EButtonSize.xs: 4,
    M3EButtonSize.sm: 8,
    M3EButtonSize.md: 8,
    M3EButtonSize.lg: 12,
    M3EButtonSize.xl: 16,
  };

  static final Map<M3EButtonSize, double> _splitLabelRightPadding = {
    M3EButtonSize.xs: 10,
    M3EButtonSize.sm: 12,
    M3EButtonSize.md: 24,
    M3EButtonSize.lg: 48,
    M3EButtonSize.xl: 64,
  };

  static final Map<M3EButtonSize, double> _splitTrailingLeftInnerPadding = {
    M3EButtonSize.xs: 13,
    M3EButtonSize.sm: 13,
    M3EButtonSize.md: 15,
    M3EButtonSize.lg: 29,
    M3EButtonSize.xl: 43,
  };

  static final Map<M3EButtonSize, double> _splitRightOuterPadding = {
    M3EButtonSize.xs: 13,
    M3EButtonSize.sm: 13,
    M3EButtonSize.md: 15,
    M3EButtonSize.lg: 29,
    M3EButtonSize.xl: 43,
  };

  static final Map<M3EButtonSize, double> _splitSidePaddingSelected = {
    M3EButtonSize.xs: 13,
    M3EButtonSize.sm: 13,
    M3EButtonSize.md: 15,
    M3EButtonSize.lg: 29,
    M3EButtonSize.xl: 43,
  };

  double splitHeight(M3EButtonSize size) => _splitHeight[size] ?? 56;

  double splitTrailingWidth(M3EButtonSize size) {
    for (final variant in _splitTrailingWidth.keys) {
      if (variant.name == size.name) {
        return _splitTrailingWidth[variant]!;
      }
    }
    return 26;
  }

  double splitInnerCornerRadius(M3EButtonSize size) =>
      _splitInnerCornerRadius[size] ?? 4;

  double splitHoveredInnerCornerRadius(M3EButtonSize size) =>
      _splitHoveredInnerCornerRadius[size] ?? 12;

  double splitInnerPadding(M3EButtonSize size) =>
      _splitInnerPadding[size] ?? 4;

  double splitMenuIconOffset(M3EButtonSize size) =>
      _splitMenuIconOffset[size] ?? -2;

  double splitIcon(M3EButtonSize size) => _splitIcon[size] ?? 24;

  double splitOuterRadiusRound(M3EButtonSize size) =>
      _splitOuterRadiusRound[size] ?? 28;

  double splitOuterRadiusSquare(M3EButtonSize size) =>
      _splitOuterRadiusSquare[size] ?? 14;

  double splitPressedRadius(M3EButtonSize size) =>
      _splitPressedRadius[size] ?? 2;

  double splitLeadingIconBlockWidth(M3EButtonSize size) {
    for (final variant in _splitLeadingIconBlockWidth.keys) {
      if (variant.name == size.name) {
        return _splitLeadingIconBlockWidth[variant]!;
      }
    }
    return 24;
  }

  double splitLeftOuterPadding(M3EButtonSize size) =>
      _splitLeftOuterPadding[size] ?? 24;

  double splitGapIconToLabel(M3EButtonSize size) {
    for (final variant in _splitGapIconToLabel.keys) {
      if (variant.name == size.name) {
        return _splitGapIconToLabel[variant]!;
      }
    }
    return 8;
  }

  double splitLabelRightPadding(M3EButtonSize size) =>
      _splitLabelRightPadding[size] ?? 24;

  double splitTrailingLeftInnerPadding(M3EButtonSize size) =>
      _splitTrailingLeftInnerPadding[size] ?? 13;

  double splitRightOuterPadding(M3EButtonSize size) =>
      _splitRightOuterPadding[size] ?? 17;

  double splitSidePaddingSelected(M3EButtonSize size) {
    for (final variant in _splitSidePaddingSelected.keys) {
      if (variant.name == size.name) {
        return _splitSidePaddingSelected[variant]!;
      }
    }
    return 15;
  }

  double splitLeadingButtonLeadingSpace(M3EButtonSize size) =>
      splitLeftOuterPadding(size);

  double splitLeadingButtonTrailingSpace(M3EButtonSize size) =>
      splitLabelRightPadding(size);

  double splitTrailingIconSize(M3EButtonSize size) =>
      _splitTrailingWidth[size] ?? 26;

  double splitTrailingButtonLeadingSpace(M3EButtonSize size) =>
      splitTrailingLeftInnerPadding(size);

  double splitTrailingButtonTrailingSpace(M3EButtonSize size) =>
      splitRightOuterPadding(size);

  Color popupBackgroundColor(M3EColorScheme scheme) => scheme.surfaceContainer;

  Color menuBackgroundColor(
    M3EColorScheme scheme, {
    required bool containerIsTransparent,
    required Color containerColor,
  }) {
    if (containerIsTransparent) {
      return scheme.surfaceContainerHigh;
    }
    return containerColor;
  }

  Color menuForegroundColor(
    M3EColorScheme scheme, {
    required bool containerIsTransparent,
    required Color onContainerColor,
  }) {
    if (containerIsTransparent) {
      return scheme.onSurface;
    }
    return onContainerColor;
  }

  @override
  M3ESplitButtonTheme copyWith({
    double? minTapTarget,
    double? innerGap,
    double? elevatedInnerGap,
    double? chevronOpenTurns,
    double? trailingInnerSelectedCornerPercent,
    double? popupElevation,
    double? popupBorderRadius,
    EdgeInsetsGeometry? popupPadding,
    Offset? popupOffset,
    double? popupMinWidth,
    double? popupMaxWidth,
    double? popupMaxHeight,
    double? popupScrimAlpha,
    M3EButtonMotion? popupMotion,
  }) {
    return M3ESplitButtonTheme(
      minTapTarget: minTapTarget ?? this.minTapTarget,
      innerGap: innerGap ?? this.innerGap,
      elevatedInnerGap: elevatedInnerGap ?? this.elevatedInnerGap,
      chevronOpenTurns: chevronOpenTurns ?? this.chevronOpenTurns,
      trailingInnerSelectedCornerPercent: trailingInnerSelectedCornerPercent ??
          this.trailingInnerSelectedCornerPercent,
      popupElevation: popupElevation ?? this.popupElevation,
      popupBorderRadius: popupBorderRadius ?? this.popupBorderRadius,
      popupPadding: popupPadding ?? this.popupPadding,
      popupOffset: popupOffset ?? this.popupOffset,
      popupMinWidth: popupMinWidth ?? this.popupMinWidth,
      popupMaxWidth: popupMaxWidth ?? this.popupMaxWidth,
      popupMaxHeight: popupMaxHeight ?? this.popupMaxHeight,
      popupScrimAlpha: popupScrimAlpha ?? this.popupScrimAlpha,
      popupMotion: popupMotion ?? this.popupMotion,
    );
  }

  @override
  M3ESplitButtonTheme lerp(M3ESplitButtonTheme? other, double t) {
    if (other is! M3ESplitButtonTheme) {
      return this;
    }
    return M3ESplitButtonTheme(
      minTapTarget: _lerpDouble(minTapTarget, other.minTapTarget, t)!,
      innerGap: _lerpDouble(innerGap, other.innerGap, t)!,
      elevatedInnerGap:
          _lerpDouble(elevatedInnerGap, other.elevatedInnerGap, t)!,
      chevronOpenTurns:
          _lerpDouble(chevronOpenTurns, other.chevronOpenTurns, t)!,
      trailingInnerSelectedCornerPercent: _lerpDouble(
        trailingInnerSelectedCornerPercent,
        other.trailingInnerSelectedCornerPercent,
        t,
      )!,
      popupElevation: _lerpDouble(popupElevation, other.popupElevation, t)!,
      popupBorderRadius:
          _lerpDouble(popupBorderRadius, other.popupBorderRadius, t)!,
      popupPadding: EdgeInsets.lerp(
        popupPadding as EdgeInsets?,
        other.popupPadding as EdgeInsets?,
        t,
      )!,
      popupOffset: Offset.lerp(popupOffset, other.popupOffset, t)!,
      popupMinWidth: _lerpDouble(popupMinWidth, other.popupMinWidth, t)!,
      popupMaxWidth: _lerpDouble(popupMaxWidth, other.popupMaxWidth, t)!,
      popupMaxHeight: _lerpDouble(popupMaxHeight, other.popupMaxHeight, t)!,
      popupScrimAlpha: _lerpDouble(popupScrimAlpha, other.popupScrimAlpha, t)!,
      popupMotion: t < 0.5 ? popupMotion : other.popupMotion,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
