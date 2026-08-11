import 'package:flutter/material.dart';

import '../res/m3e_button_constants.dart';

/// Builds a [ButtonLayerBuilder] that paints [gradient] behind the child.
///
/// When [explicitBuilder] is set, it wins (existing precedence). When both
/// [gradient] and [explicitBuilder] are null, returns null.
ButtonLayerBuilder? m3eGradientBackgroundBuilder(
  WidgetStateProperty<Gradient?>? gradient, {
  ButtonLayerBuilder? explicitBuilder,
}) {
  if (explicitBuilder != null) {
    return explicitBuilder;
  }
  if (gradient == null) {
    return null;
  }
  return (BuildContext context, Set<WidgetState> states, Widget? child) {
    final Gradient? resolved = gradient.resolve(states);
    if (resolved == null) {
      return child ?? const SizedBox.shrink();
    }
    Widget layer = DecoratedBox(
      decoration: BoxDecoration(gradient: resolved),
      child: child,
    );
    if (states.contains(WidgetState.disabled)) {
      layer = Opacity(
        opacity: M3EButtonConstants.kDisabledBackgroundAlpha,
        child: layer,
      );
    }
    return layer;
  };
}
