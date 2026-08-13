import 'package:flutter/material.dart';

import 'm3e_button_gradient_fill.dart';
import 'm3e_button_gradient_overlay.dart';

/// Fill plus overlay for Material backgroundBuilder, clipped to [clipRadius].
ButtonLayerBuilder? m3eGradientSurfaceBuilder({
  required BorderRadius clipRadius,
  WidgetStateProperty<Gradient?>? backgroundGradient,
  WidgetStateProperty<Gradient?>? overlayGradient,
  ButtonLayerBuilder? explicitBuilder,
}) {
  if (explicitBuilder == null &&
      backgroundGradient == null &&
      overlayGradient == null) {
    return null;
  }
  final ButtonLayerBuilder? fill = m3eGradientBackgroundBuilder(
    clipRadius: clipRadius,
    gradient: backgroundGradient,
    explicitBuilder: explicitBuilder,
  );
  return (BuildContext context, Set<WidgetState> states, Widget? child) {
    Widget result = child ?? const SizedBox.shrink();
    if (fill != null) {
      result = fill(context, states, result);
    }
    return m3eResolveGradientOverlay(
      clipRadius: clipRadius,
      states: states,
      overlayGradient: overlayGradient,
      child: result,
    );
  };
}
