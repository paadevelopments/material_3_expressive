import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';
import '../enums/m3e_progress_enums.dart';

/// Measured layout values for a linear progress indicator lane.
@immutable
class M3ELinearProgressLayout {
  const M3ELinearProgressLayout({
    required this.trackHeight,
    required this.gap,
    required this.dotDiameter,
    required this.dotOffset,
    required this.trailingMargin,
    required this.isWavy,
    this.waveAmplitude = 0,
    this.wavePeriod = 40,
  });

  final double trackHeight;
  final double gap;
  final double dotDiameter;
  final double dotOffset;
  final double trailingMargin;
  final bool isWavy;
  final double waveAmplitude;
  final double wavePeriod;
}

/// Theme values for [M3ELinearProgress].
@immutable
class M3ELinearProgressTheme extends M3EThemeExtension<M3ELinearProgressTheme> {
  const M3ELinearProgressTheme();

  static const M3ELinearProgressTheme defaults = M3ELinearProgressTheme();

  M3ELinearProgressLayout resolve({
    required M3ELinearProgressSize size,
    required M3EProgressShape shape,
  }) =>
      switch ((shape, size)) {
        (M3EProgressShape.flat, M3ELinearProgressSize.s) =>
          const M3ELinearProgressLayout(
            trackHeight: 4,
            gap: 4,
            dotDiameter: 4,
            dotOffset: 4,
            trailingMargin: 4,
            isWavy: false,
          ),
        (M3EProgressShape.flat, M3ELinearProgressSize.m) =>
          const M3ELinearProgressLayout(
            trackHeight: 8,
            gap: 4,
            dotDiameter: 4,
            dotOffset: 2,
            trailingMargin: 8,
            isWavy: false,
          ),
        (M3EProgressShape.wavy, M3ELinearProgressSize.s) =>
          const M3ELinearProgressLayout(
            trackHeight: 4,
            gap: 4,
            dotDiameter: 4,
            dotOffset: 2,
            trailingMargin: 10,
            isWavy: true,
            waveAmplitude: 3,
          ),
        (M3EProgressShape.wavy, M3ELinearProgressSize.m) =>
          const M3ELinearProgressLayout(
            trackHeight: 8,
            gap: 4,
            dotDiameter: 4,
            dotOffset: 2,
            trailingMargin: 14,
            isWavy: true,
            waveAmplitude: 3,
          ),
      };

  @override
  M3ELinearProgressTheme copyWith() => this;

  @override
  M3ELinearProgressTheme lerp(M3ELinearProgressTheme? other, double t) => this;
}

/// Theme values for [M3ECircularProgress].
@immutable
class M3ECircularProgressTheme
    extends M3EThemeExtension<M3ECircularProgressTheme> {
  const M3ECircularProgressTheme({
    this.defaultSize = 40,
    this.defaultStrokeWidth = 4,
  });

  static const M3ECircularProgressTheme defaults = M3ECircularProgressTheme();

  final double defaultSize;
  final double defaultStrokeWidth;

  Color trackColor(M3EColorScheme scheme) => scheme.secondaryContainer;

  Color activeColor(M3EColorScheme scheme) => scheme.primary;

  @override
  M3ECircularProgressTheme copyWith({
    double? defaultSize,
    double? defaultStrokeWidth,
  }) {
    return M3ECircularProgressTheme(
      defaultSize: defaultSize ?? this.defaultSize,
      defaultStrokeWidth: defaultStrokeWidth ?? this.defaultStrokeWidth,
    );
  }

  @override
  M3ECircularProgressTheme lerp(M3ECircularProgressTheme? other, double t) {
    if (other is! M3ECircularProgressTheme) {
      return this;
    }
    return M3ECircularProgressTheme(
      defaultSize: _lerpDouble(defaultSize, other.defaultSize, t)!,
      defaultStrokeWidth:
          _lerpDouble(defaultStrokeWidth, other.defaultStrokeWidth, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

/// Theme values for progress indicator widgets.
@immutable
class M3EProgressIndicatorTheme
    extends M3EThemeExtension<M3EProgressIndicatorTheme> {
  const M3EProgressIndicatorTheme({
    this.linear = M3ELinearProgressTheme.defaults,
    this.circular = M3ECircularProgressTheme.defaults,
  });

  static const M3EProgressIndicatorTheme defaults = M3EProgressIndicatorTheme();

  final M3ELinearProgressTheme linear;
  final M3ECircularProgressTheme circular;

  @override
  M3EProgressIndicatorTheme copyWith({
    M3ELinearProgressTheme? linear,
    M3ECircularProgressTheme? circular,
  }) {
    return M3EProgressIndicatorTheme(
      linear: linear ?? this.linear,
      circular: circular ?? this.circular,
    );
  }

  @override
  M3EProgressIndicatorTheme lerp(M3EProgressIndicatorTheme? other, double t) {
    if (other is! M3EProgressIndicatorTheme) {
      return this;
    }
    return M3EProgressIndicatorTheme(
      linear: linear.lerp(other.linear, t),
      circular: circular.lerp(other.circular, t),
    );
  }
}
