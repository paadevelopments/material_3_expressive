// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// SliderTokens.kt / SliderColors

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../res/m3e_slider_tokens.dart';

/// Resolved colors for an [M3ESlider] / [M3ERangeSlider] paint pass.
@immutable
class M3ESliderColors {
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

  final Color thumb;
  final Color activeTrack;
  final Color inactiveTrack;
  final Color activeTick;
  final Color inactiveTick;
  final Color stopIndicator;
  final Color valueIndicator;
  final Color valueIndicatorLabel;
}

/// Theme values for [M3ESlider] and [M3ERangeSlider].
@immutable
class M3ESliderTheme extends M3EThemeExtension<M3ESliderTheme> {
  const M3ESliderTheme({
    this.height = M3ESliderTokens.handleHeight,
    this.trackHeight = M3ESliderTokens.activeTrackHeight,
    this.handleGap = M3ESliderTokens.thumbTrackGapSize,
    this.handleWidth = M3ESliderTokens.handleWidth,
    this.handleHeight = M3ESliderTokens.handleHeight,
    this.pressedHandleWidth = M3ESliderTokens.pressedHandleWidth,
    this.trackInsideCornerSize = M3ESliderTokens.trackInsideCornerSize,
    this.stopIndicatorSize = M3ESliderTokens.stopIndicatorSize,
    this.tickSize = M3ESliderTokens.tickSize,
    this.valueIndicatorBottomSpace =
        M3ESliderTokens.valueIndicatorActiveBottomSpace,
    this.disabledActiveOpacity = M3ESliderTokens.disabledActiveTrackOpacity,
    this.disabledInactiveOpacity =
        M3ESliderTokens.disabledInactiveTrackOpacity,
  });

  static const M3ESliderTheme defaults = M3ESliderTheme();

  /// Cross-axis extent of the interactive slider layout.
  final double height;

  final double trackHeight;
  final double handleGap;
  final double handleWidth;
  final double handleHeight;
  final double pressedHandleWidth;
  final double trackInsideCornerSize;
  final double stopIndicatorSize;
  final double tickSize;
  final double valueIndicatorBottomSpace;
  final double disabledActiveOpacity;
  final double disabledInactiveOpacity;

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
    return M3ESliderColors(
      thumb: active(scheme.primary),
      activeTrack: activeTrack,
      inactiveTrack: inactiveTrack,
      activeTick: inactiveTrack,
      inactiveTick: activeTrack,
      stopIndicator: inactiveTrack,
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
    double? stopIndicatorSize,
    double? tickSize,
    double? valueIndicatorBottomSpace,
    double? disabledActiveOpacity,
    double? disabledInactiveOpacity,
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
      stopIndicatorSize: stopIndicatorSize ?? this.stopIndicatorSize,
      tickSize: tickSize ?? this.tickSize,
      valueIndicatorBottomSpace:
          valueIndicatorBottomSpace ?? this.valueIndicatorBottomSpace,
      disabledActiveOpacity:
          disabledActiveOpacity ?? this.disabledActiveOpacity,
      disabledInactiveOpacity:
          disabledInactiveOpacity ?? this.disabledInactiveOpacity,
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
      pressedHandleWidth: _lerp(pressedHandleWidth, other.pressedHandleWidth, t),
      trackInsideCornerSize:
          _lerp(trackInsideCornerSize, other.trackInsideCornerSize, t),
      stopIndicatorSize: _lerp(stopIndicatorSize, other.stopIndicatorSize, t),
      tickSize: _lerp(tickSize, other.tickSize, t),
      valueIndicatorBottomSpace:
          _lerp(valueIndicatorBottomSpace, other.valueIndicatorBottomSpace, t),
      disabledActiveOpacity:
          _lerp(disabledActiveOpacity, other.disabledActiveOpacity, t),
      disabledInactiveOpacity:
          _lerp(disabledInactiveOpacity, other.disabledInactiveOpacity, t),
    );
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}
