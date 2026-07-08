import 'package:flutter/foundation.dart';

import '../enums/m3e_progress_enums.dart';

/// The measured layout tokens for a linear progress indicator.
///
/// Port of the reference `LinearSpec`.
@immutable
class M3ELinearProgressTokens {
  const M3ELinearProgressTokens({
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

  /// Vertical space between the active lane and the track lane.
  final double gap;
  final double dotDiameter;

  /// Center offset of the end dot from the end of the active segment.
  final double dotOffset;

  /// Empty space kept at the far right.
  final double trailingMargin;
  final bool isWavy;
  final double waveAmplitude;
  final double wavePeriod;

  /// Returns the tokens for the given [size] and [shape].
  static M3ELinearProgressTokens resolve({
    required M3ELinearProgressSize size,
    required M3EProgressShape shape,
  }) =>
      switch ((shape, size)) {
        (M3EProgressShape.flat, M3ELinearProgressSize.s) =>
          const M3ELinearProgressTokens(
            trackHeight: 4,
            gap: 4,
            dotDiameter: 4,
            dotOffset: 4,
            trailingMargin: 4,
            isWavy: false,
          ),
        (M3EProgressShape.flat, M3ELinearProgressSize.m) =>
          const M3ELinearProgressTokens(
            trackHeight: 8,
            gap: 4,
            dotDiameter: 4,
            dotOffset: 2,
            trailingMargin: 8,
            isWavy: false,
          ),
        (M3EProgressShape.wavy, M3ELinearProgressSize.s) =>
          const M3ELinearProgressTokens(
            trackHeight: 4,
            gap: 4,
            dotDiameter: 4,
            dotOffset: 2,
            trailingMargin: 10,
            isWavy: true,
            waveAmplitude: 3,
          ),
        (M3EProgressShape.wavy, M3ELinearProgressSize.m) =>
          const M3ELinearProgressTokens(
            trackHeight: 8,
            gap: 4,
            dotDiameter: 4,
            dotOffset: 2,
            trailingMargin: 14,
            isWavy: true,
            waveAmplitude: 3,
          ),
      };
}
