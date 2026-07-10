import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../foundations/m3e_theme_extension.dart';
import '../enums/m3e_icon_button_enums.dart';

/// Theme values for `M3EIconButton`.
@immutable
class M3EIconButtonTheme extends M3EThemeExtension<M3EIconButtonTheme> {
  const M3EIconButtonTheme({
    this.outlineWidth = 1,
    this.morphDuration = const Duration(milliseconds: 120),
    this.morphCurve = Curves.easeOut,
  });

  static const M3EIconButtonTheme defaults = M3EIconButtonTheme();

  final double outlineWidth;
  final Duration morphDuration;
  final Curve morphCurve;

  static const Map<M3EIconButtonSize, double> _icon = {
    M3EIconButtonSize.xs: 20,
    M3EIconButtonSize.sm: 24,
    M3EIconButtonSize.md: 24,
    M3EIconButtonSize.lg: 32,
    M3EIconButtonSize.xl: 40,
  };

  static const Map<M3EIconButtonSize, Map<M3EIconButtonWidth, Size>> _visual = {
    M3EIconButtonSize.xs: {
      M3EIconButtonWidth.defaultWidth: Size(32, 32),
      M3EIconButtonWidth.narrow: Size(28, 32),
      M3EIconButtonWidth.wide: Size(40, 32),
    },
    M3EIconButtonSize.sm: {
      M3EIconButtonWidth.defaultWidth: Size(40, 40),
      M3EIconButtonWidth.narrow: Size(32, 40),
      M3EIconButtonWidth.wide: Size(52, 40),
    },
    M3EIconButtonSize.md: {
      M3EIconButtonWidth.defaultWidth: Size(56, 56),
      M3EIconButtonWidth.narrow: Size(48, 56),
      M3EIconButtonWidth.wide: Size(72, 56),
    },
    M3EIconButtonSize.lg: {
      M3EIconButtonWidth.defaultWidth: Size(96, 96),
      M3EIconButtonWidth.narrow: Size(64, 96),
      M3EIconButtonWidth.wide: Size(128, 96),
    },
    M3EIconButtonSize.xl: {
      M3EIconButtonWidth.defaultWidth: Size(136, 136),
      M3EIconButtonWidth.narrow: Size(104, 136),
      M3EIconButtonWidth.wide: Size(184, 136),
    },
  };

  static const Map<M3EIconButtonSize, Map<M3EIconButtonWidth, Size>> _target = {
    M3EIconButtonSize.xs: {
      M3EIconButtonWidth.defaultWidth: Size(48, 48),
      M3EIconButtonWidth.narrow: Size(48, 48),
      M3EIconButtonWidth.wide: Size(48, 48),
    },
    M3EIconButtonSize.sm: {
      M3EIconButtonWidth.defaultWidth: Size(48, 48),
      M3EIconButtonWidth.narrow: Size(48, 48),
      M3EIconButtonWidth.wide: Size(52, 48),
    },
    M3EIconButtonSize.md: {
      M3EIconButtonWidth.defaultWidth: Size(56, 56),
      M3EIconButtonWidth.narrow: Size(48, 56),
      M3EIconButtonWidth.wide: Size(72, 56),
    },
    M3EIconButtonSize.lg: {
      M3EIconButtonWidth.defaultWidth: Size(96, 96),
      M3EIconButtonWidth.narrow: Size(64, 96),
      M3EIconButtonWidth.wide: Size(128, 96),
    },
    M3EIconButtonSize.xl: {
      M3EIconButtonWidth.defaultWidth: Size(136, 136),
      M3EIconButtonWidth.narrow: Size(104, 136),
      M3EIconButtonWidth.wide: Size(184, 136),
    },
  };

  static const Map<M3EIconButtonSize, double> _radiusRestRound = {
    M3EIconButtonSize.xs: 16,
    M3EIconButtonSize.sm: 20,
    M3EIconButtonSize.md: 28,
    M3EIconButtonSize.lg: 48,
    M3EIconButtonSize.xl: 68,
  };

  static const Map<M3EIconButtonSize, double> _radiusRestSquare = {
    M3EIconButtonSize.xs: 8,
    M3EIconButtonSize.sm: 10,
    M3EIconButtonSize.md: 14,
    M3EIconButtonSize.lg: 24,
    M3EIconButtonSize.xl: 34,
  };

  static const Map<M3EIconButtonSize, double> _radiusPressed = {
    M3EIconButtonSize.xs: 6,
    M3EIconButtonSize.sm: 8,
    M3EIconButtonSize.md: 11,
    M3EIconButtonSize.lg: 19,
    M3EIconButtonSize.xl: 27,
  };

  double iconSize(M3EIconButtonSize size) => _icon[size]!;

  Size visual(M3EIconButtonSize size, M3EIconButtonWidth width) =>
      _visual[size]![width]!;

  Size target(M3EIconButtonSize size, M3EIconButtonWidth width) =>
      _target[size]![width]!;

  double radiusRestRound(M3EIconButtonSize size) => _radiusRestRound[size]!;

  double radiusRestSquare(M3EIconButtonSize size) => _radiusRestSquare[size]!;

  double radiusPressed(M3EIconButtonSize size) => _radiusPressed[size]!;

  @override
  M3EIconButtonTheme copyWith({
    double? outlineWidth,
    Duration? morphDuration,
    Curve? morphCurve,
  }) {
    return M3EIconButtonTheme(
      outlineWidth: outlineWidth ?? this.outlineWidth,
      morphDuration: morphDuration ?? this.morphDuration,
      morphCurve: morphCurve ?? this.morphCurve,
    );
  }

  @override
  M3EIconButtonTheme lerp(M3EIconButtonTheme? other, double t) {
    if (other is! M3EIconButtonTheme) {
      return this;
    }
    return M3EIconButtonTheme(
      outlineWidth: _lerpDouble(outlineWidth, other.outlineWidth, t)!,
      morphDuration: Duration(
        milliseconds: _lerpDouble(
          morphDuration.inMilliseconds.toDouble(),
          other.morphDuration.inMilliseconds.toDouble(),
          t,
        )!.round(),
      ),
      morphCurve: t < 0.5 ? morphCurve : other.morphCurve,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
