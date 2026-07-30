// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// SliderTokens.kt / SliderColors

import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/sliders/m3e_sliders.dart'
    show M3ERangeSlider, M3ESlider;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3ERangeSlider, M3ESlider;

import '../../../foundations/foundations.dart';
import '../res/m3e_slider_tokens.dart';

/// Resolved colors for an [M3ESlider] / [M3ERangeSlider] paint pass.
@immutable
class M3ESliderColors {
  /// M3ESliderColors.
  const M3ESliderColors({
    required this.thumb,
    required this.activeTrack,
    required this.inactiveTrack,
    required this.activeTick,
    required this.inactiveTick,
    required this.stopIndicator,
    required this.valueIndicator,
    required this.valueIndicatorLabel,
  });

  /// thumb.

  final Color thumb;

  /// activeTrack.
  final Color activeTrack;

  /// inactiveTrack.
  final Color inactiveTrack;

  /// activeTick.
  final Color activeTick;

  /// inactiveTick.
  final Color inactiveTick;

  /// stopIndicator.
  final Color stopIndicator;

  /// valueIndicator.
  final Color valueIndicator;

  /// valueIndicatorLabel.
  final Color valueIndicatorLabel;
}

/// Theme values for [M3ESlider] and [M3ERangeSlider].
@immutable
class M3ESliderTheme extends M3EThemeExtension<M3ESliderTheme> {
  /// M3ESliderTheme.
  const M3ESliderTheme({
    this.height = M3ESliderTokens.handleHeight,
    this.trackHeight = M3ESliderTokens.activeTrackHeight,
    this.handleGap = M3ESliderTokens.thumbTrackGapSize,
    this.handleWidth = M3ESliderTokens.handleWidth,
    this.handleHeight = M3ESliderTokens.handleHeight,
    this.pressedHandleWidth = M3ESliderTokens.pressedHandleWidth,
    this.trackInsideCornerSize = M3ESliderTokens.trackInsideCornerSize,
    this.trackCornerRadius = M3ESliderTokens.trackCornerRadius,
    this.stopIndicatorSize = M3ESliderTokens.stopIndicatorSize,
    this.tickSize = M3ESliderTokens.tickSize,
    this.stopIndicatorTrailingSpace =
        M3ESliderTokens.stopIndicatorTrailingSpace,
    this.iconEdgeInset = M3ESliderTokens.iconEdgeInset,
    this.valueIndicatorBottomSpace =
        M3ESliderTokens.valueIndicatorActiveBottomSpace,
    this.disabledActiveOpacity = M3ESliderTokens.disabledActiveTrackOpacity,
    this.disabledInactiveOpacity = M3ESliderTokens.disabledInactiveTrackOpacity,
    this.waveAmplitude = M3ESliderTokens.waveAmplitude,
    this.wavelength = M3ESliderTokens.wavelength,
  });

  /// defaults.

  static const M3ESliderTheme defaults = M3ESliderTheme();

  /// Cross-axis extent of the interactive slider layout.
  final double height;

  /// trackHeight.

  final double trackHeight;

  /// handleGap.
  final double handleGap;

  /// handleWidth.
  final double handleWidth;

  /// handleHeight.
  final double handleHeight;

  /// pressedHandleWidth.
  final double pressedHandleWidth;

  /// trackInsideCornerSize.
  final double trackInsideCornerSize;

  /// Outer corner radius for active and inactive track ends.
  ///
  /// Fixed default; not derived from [trackHeight].
  final double trackCornerRadius;

  /// stopIndicatorSize.
  final double stopIndicatorSize;

  /// tickSize.
  final double tickSize;

  /// Clear space between each track end and the outer edge of end markers.
  final double stopIndicatorTrailingSpace;

  /// Clear space between the track edge and the relocating [M3ESlider.icon].
  final double iconEdgeInset;

  /// valueIndicatorBottomSpace.
  final double valueIndicatorBottomSpace;

  /// disabledActiveOpacity.
  final double disabledActiveOpacity;

  /// disabledInactiveOpacity.
  final double disabledInactiveOpacity;

  /// Peak offset of the wavy active track from the centerline.
  final double waveAmplitude;

  /// Length of one full sine cycle on a wavy active track.
  final double wavelength;

  /// Compose wavy determinate amplitude: full mid-progress, zero near ends.
  double amplitudeForProgress(double progress) {
    if (progress <= 0.1 || progress >= 0.95) {
      return 0;
    }
    return 1;
  }

  /// Resolves Compose-accurate slider colors for the current [scheme].
  M3ESliderColors colors(M3EColorScheme scheme, {required bool enabled}) {
    Color active(Color c) => enabled
        ? c
        : M3EColorUtils.withOpacity(scheme.onSurface, disabledActiveOpacity);
    Color inactive(Color c) => enabled
        ? c
        : M3EColorUtils.withOpacity(scheme.onSurface, disabledInactiveOpacity);

    final Color activeTrack = active(scheme.primary);
    final Color inactiveTrack = inactive(scheme.secondaryContainer);
    // Compose reverses tick colors relative to track roles.
    // Stop indicators use active-track color (visible on inactive ends).
    return M3ESliderColors(
      thumb: active(scheme.primary),
      activeTrack: activeTrack,
      inactiveTrack: inactiveTrack,
      activeTick: inactiveTrack,
      inactiveTick: activeTrack,
      stopIndicator: activeTrack,
      valueIndicator: scheme.inverseSurface,
      valueIndicatorLabel: scheme.onInverseSurface,
    );
  }

  /// Legacy helper retained for call sites that only need one role color.
  Color color(
    M3EColorScheme scheme, {
    required Color enabledColor,
    required bool enabled,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledActiveOpacity);
    }
    return enabledColor;
  }

  @override
  M3ESliderTheme copyWith({
    double? height,
    double? trackHeight,
    double? handleGap,
    double? handleWidth,
    double? handleHeight,
    double? pressedHandleWidth,
    double? trackInsideCornerSize,
    double? trackCornerRadius,
    double? stopIndicatorSize,
    double? tickSize,
    double? stopIndicatorTrailingSpace,
    double? iconEdgeInset,
    double? valueIndicatorBottomSpace,
    double? disabledActiveOpacity,
    double? disabledInactiveOpacity,
    double? waveAmplitude,
    double? wavelength,
  }) {
    return M3ESliderTheme(
      height: height ?? this.height,
      trackHeight: trackHeight ?? this.trackHeight,
      handleGap: handleGap ?? this.handleGap,
      handleWidth: handleWidth ?? this.handleWidth,
      handleHeight: handleHeight ?? this.handleHeight,
      pressedHandleWidth: pressedHandleWidth ?? this.pressedHandleWidth,
      trackInsideCornerSize:
          trackInsideCornerSize ?? this.trackInsideCornerSize,
      trackCornerRadius: trackCornerRadius ?? this.trackCornerRadius,
      stopIndicatorSize: stopIndicatorSize ?? this.stopIndicatorSize,
      tickSize: tickSize ?? this.tickSize,
      stopIndicatorTrailingSpace:
          stopIndicatorTrailingSpace ?? this.stopIndicatorTrailingSpace,
      iconEdgeInset: iconEdgeInset ?? this.iconEdgeInset,
      valueIndicatorBottomSpace:
          valueIndicatorBottomSpace ?? this.valueIndicatorBottomSpace,
      disabledActiveOpacity:
          disabledActiveOpacity ?? this.disabledActiveOpacity,
      disabledInactiveOpacity:
          disabledInactiveOpacity ?? this.disabledInactiveOpacity,
      waveAmplitude: waveAmplitude ?? this.waveAmplitude,
      wavelength: wavelength ?? this.wavelength,
    );
  }

  @override
  M3ESliderTheme lerp(M3ESliderTheme? other, double t) {
    if (other is! M3ESliderTheme) {
      return this;
    }
    return M3ESliderTheme(
      height: _lerp(height, other.height, t),
      trackHeight: _lerp(trackHeight, other.trackHeight, t),
      handleGap: _lerp(handleGap, other.handleGap, t),
      handleWidth: _lerp(handleWidth, other.handleWidth, t),
      handleHeight: _lerp(handleHeight, other.handleHeight, t),
      pressedHandleWidth: _lerp(
        pressedHandleWidth,
        other.pressedHandleWidth,
        t,
      ),
      trackInsideCornerSize: _lerp(
        trackInsideCornerSize,
        other.trackInsideCornerSize,
        t,
      ),
      trackCornerRadius: _lerp(trackCornerRadius, other.trackCornerRadius, t),
      stopIndicatorSize: _lerp(stopIndicatorSize, other.stopIndicatorSize, t),
      tickSize: _lerp(tickSize, other.tickSize, t),
      stopIndicatorTrailingSpace: _lerp(
        stopIndicatorTrailingSpace,
        other.stopIndicatorTrailingSpace,
        t,
      ),
      iconEdgeInset: _lerp(iconEdgeInset, other.iconEdgeInset, t),
      valueIndicatorBottomSpace: _lerp(
        valueIndicatorBottomSpace,
        other.valueIndicatorBottomSpace,
        t,
      ),
      disabledActiveOpacity: _lerp(
        disabledActiveOpacity,
        other.disabledActiveOpacity,
        t,
      ),
      disabledInactiveOpacity: _lerp(
        disabledInactiveOpacity,
        other.disabledInactiveOpacity,
        t,
      ),
      waveAmplitude: _lerp(waveAmplitude, other.waveAmplitude, t),
      wavelength: _lerp(wavelength, other.wavelength, t),
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}
