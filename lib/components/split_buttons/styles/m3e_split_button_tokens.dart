import 'package:flutter/material.dart';
import '../../buttons/enums/m3e_button_enums.dart';

/// Design tokens for Material 3 Expressive Split Buttons.
abstract class M3ESplitButtonTokens {
  static final Map<M3EButtonSize, double> _splitHeight = {
    M3EButtonSize.xs: 32.0,
    M3EButtonSize.sm: 40.0,
    M3EButtonSize.md: 56.0,
    M3EButtonSize.lg: 96.0,
    M3EButtonSize.xl: 136.0,
  };

  static final Map<M3EButtonSize, double> _splitTrailingWidth = {
    M3EButtonSize.xs: 22.0,
    M3EButtonSize.sm: 22.0,
    M3EButtonSize.md: 26.0,
    M3EButtonSize.lg: 38.0,
    M3EButtonSize.xl: 50.0,
  };

  static final Map<M3EButtonSize, double> _splitInnerCornerRadius = {
    M3EButtonSize.xs: 4.0,
    M3EButtonSize.sm: 4.0,
    M3EButtonSize.md: 4.0,
    M3EButtonSize.lg: 8.0,
    M3EButtonSize.xl: 12.0,
  };

  static final Map<M3EButtonSize, double> _splitHoveredInnerCornerRadius = {
    M3EButtonSize.xs: 8.0,
    M3EButtonSize.sm: 12.0,
    M3EButtonSize.md: 12.0,
    M3EButtonSize.lg: 20.0,
    M3EButtonSize.xl: 20.0,
  };

  static final Map<M3EButtonSize, double> _splitInnerPadding = {
    M3EButtonSize.xs: 4.0,
    M3EButtonSize.sm: 4.0,
    M3EButtonSize.md: 4.0,
    M3EButtonSize.lg: 8.0,
    M3EButtonSize.xl: 12.0,
  };

  static final Map<M3EButtonSize, double> _splitMenuIconOffset = {
    M3EButtonSize.xs: -1.0,
    M3EButtonSize.sm: -1.0,
    M3EButtonSize.md: -2.0,
    M3EButtonSize.lg: -3.0,
    M3EButtonSize.xl: -6.0,
  };

  static final Map<M3EButtonSize, double> _splitIcon = {
    M3EButtonSize.xs: 20.0,
    M3EButtonSize.sm: 24.0,
    M3EButtonSize.md: 24.0,
    M3EButtonSize.lg: 32.0,
    M3EButtonSize.xl: 40.0,
  };

  static final Map<M3EButtonSize, double> _splitOuterRadiusRound = {
    M3EButtonSize.xs: 16.0,
    M3EButtonSize.sm: 20.0,
    M3EButtonSize.md: 28.0,
    M3EButtonSize.lg: 48.0,
    M3EButtonSize.xl: 68.0,
  };

  static final Map<M3EButtonSize, double> _splitOuterRadiusSquare = {
    M3EButtonSize.xs: 8.0,
    M3EButtonSize.sm: 10.0,
    M3EButtonSize.md: 14.0,
    M3EButtonSize.lg: 24.0,
    M3EButtonSize.xl: 34.0,
  };

  static final Map<M3EButtonSize, double> _splitPressedRadius = {
    M3EButtonSize.xs: 2.0,
    M3EButtonSize.sm: 2.0,
    M3EButtonSize.md: 2.0,
    M3EButtonSize.lg: 4.0,
    M3EButtonSize.xl: 6.0,
  };

  static final Map<M3EButtonSize, double> _splitLeadingIconBlockWidth = {
    M3EButtonSize.xs: 20.0,
    M3EButtonSize.sm: 20.0,
    M3EButtonSize.md: 24.0,
    M3EButtonSize.lg: 32.0,
    M3EButtonSize.xl: 40.0,
  };

  static final Map<M3EButtonSize, double> _splitLeftOuterPadding = {
    M3EButtonSize.xs: 12.0,
    M3EButtonSize.sm: 16.0,
    M3EButtonSize.md: 24.0,
    M3EButtonSize.lg: 48.0,
    M3EButtonSize.xl: 64.0,
  };

  static final Map<M3EButtonSize, double> _splitGapIconToLabel = {
    M3EButtonSize.xs: 4.0,
    M3EButtonSize.sm: 8.0,
    M3EButtonSize.md: 8.0,
    M3EButtonSize.lg: 12.0,
    M3EButtonSize.xl: 16.0,
  };

  static final Map<M3EButtonSize, double> _splitLabelRightPadding = {
    M3EButtonSize.xs: 10.0,
    M3EButtonSize.sm: 12.0,
    M3EButtonSize.md: 24.0,
    M3EButtonSize.lg: 48.0,
    M3EButtonSize.xl: 64.0,
  };

  static final Map<M3EButtonSize, double> _splitTrailingLeftInnerPadding = {
    M3EButtonSize.xs: 13.0,
    M3EButtonSize.sm: 13.0,
    M3EButtonSize.md: 15.0,
    M3EButtonSize.lg: 29.0,
    M3EButtonSize.xl: 43.0,
  };

  static final Map<M3EButtonSize, double> _splitRightOuterPadding = {
    M3EButtonSize.xs: 13.0,
    M3EButtonSize.sm: 13.0,
    M3EButtonSize.md: 15.0,
    M3EButtonSize.lg: 29.0,
    M3EButtonSize.xl: 43.0,
  };

  static final Map<M3EButtonSize, double> _splitSidePaddingSelected = {
    M3EButtonSize.xs: 13.0,
    M3EButtonSize.sm: 13.0,
    M3EButtonSize.md: 15.0,
    M3EButtonSize.lg: 29.0,
    M3EButtonSize.xl: 43.0,
  };

  static double splitHeight(M3EButtonSize size) => _splitHeight[size] ?? 56.0;

  static double splitTrailingWidth(M3EButtonSize size) {
    for (final variant in _splitTrailingWidth.keys) {
      if (variant.name == size.name) return _splitTrailingWidth[variant]!;
    }
    return 26.0;
  }

  static double splitInnerCornerRadius(M3EButtonSize size) =>
      _splitInnerCornerRadius[size] ?? 4.0;

  static double splitHoveredInnerCornerRadius(M3EButtonSize size) =>
      _splitHoveredInnerCornerRadius[size] ?? 12.0;

  static double splitInnerPadding(M3EButtonSize size) =>
      _splitInnerPadding[size] ?? 4.0;

  static double splitMenuIconOffset(M3EButtonSize size) =>
      _splitMenuIconOffset[size] ?? -2.0;

  static double splitIcon(M3EButtonSize size) => _splitIcon[size] ?? 24.0;

  static double splitOuterRadiusRound(M3EButtonSize size) =>
      _splitOuterRadiusRound[size] ?? 28.0;

  static double splitOuterRadiusSquare(M3EButtonSize size) =>
      _splitOuterRadiusSquare[size] ?? 14.0;

  static double splitPressedRadius(M3EButtonSize size) =>
      _splitPressedRadius[size] ?? 2.0;

  static double splitLeadingIconBlockWidth(M3EButtonSize size) {
    for (final variant in _splitLeadingIconBlockWidth.keys) {
      if (variant.name == size.name) {
        return _splitLeadingIconBlockWidth[variant]!;
      }
    }
    return 24.0;
  }

  static double splitLeftOuterPadding(M3EButtonSize size) =>
      _splitLeftOuterPadding[size] ?? 24.0;

  static double splitGapIconToLabel(M3EButtonSize size) {
    for (final variant in _splitGapIconToLabel.keys) {
      if (variant.name == size.name) {
        return _splitGapIconToLabel[variant]!;
      }
    }
    return 8.0;
  }

  static double splitLabelRightPadding(M3EButtonSize size) =>
      _splitLabelRightPadding[size] ?? 24.0;

  static double splitTrailingLeftInnerPadding(M3EButtonSize size) =>
      _splitTrailingLeftInnerPadding[size] ?? 13.0;

  static double splitRightOuterPadding(M3EButtonSize size) =>
      _splitRightOuterPadding[size] ?? 17.0;

  static double splitSidePaddingSelected(M3EButtonSize size) {
    for (final variant in _splitSidePaddingSelected.keys) {
      if (variant.name == size.name) return _splitSidePaddingSelected[variant]!;
    }
    return 15.0;
  }

  static double get splitMinTapTarget => 48.0;
  static double get splitInnerGap => 2.0;
  static double get splitElevatedInnerGap => 4.0;
  static double get splitChevronOpenTurns => 0.5;

  static double splitLeadingButtonLeadingSpace(M3EButtonSize size) =>
      splitLeftOuterPadding(size);

  static double splitLeadingButtonTrailingSpace(M3EButtonSize size) =>
      splitLabelRightPadding(size);

  static double splitTrailingIconSize(M3EButtonSize size) =>
      _splitTrailingWidth[size] ?? 26.0;

  static double splitTrailingButtonLeadingSpace(M3EButtonSize size) =>
      splitTrailingLeftInnerPadding(size);

  static double splitTrailingButtonTrailingSpace(M3EButtonSize size) =>
      splitRightOuterPadding(size);

  static double get splitTrailingInnerSelectedCornerPercent => 50.0;
}
