// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/foundations.dart';

import '../res/m3e_button_constants.dart';

abstract class _ConstProperties {
  static const double focusRingGap = M3EButtonConstants.kFocusRingGap;
  static const double focusRingWidth = M3EButtonConstants.kFocusRingWidth;
}

/// A decorator that draws the Material 3 Expressive focus ring around its child.
class M3EFocusRing extends StatelessWidget {
  final BorderRadius radius;
  final Widget child;
  final bool focused;
  final Duration animationDuration;

  const M3EFocusRing({
    super.key,
    required this.radius,
    required this.child,
    this.focused = false,
    this.animationDuration = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (!focused) return RepaintBoundary(child: child);

    final color = M3ETheme.of(context).colorScheme.primary;

    const double gap = _ConstProperties.focusRingGap;
    const double width = _ConstProperties.focusRingWidth;
    const double outset = gap + width;

    final adjustedRadius = BorderRadius.only(
      topLeft: Radius.circular(radius.topLeft.x + outset),
      topRight: Radius.circular(radius.topRight.x + outset),
      bottomLeft: Radius.circular(radius.bottomLeft.x + outset),
      bottomRight: Radius.circular(radius.bottomRight.x + outset),
    );

    return RepaintBoundary(
      child: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            top: -outset,
            bottom: -outset,
            left: -outset,
            right: -outset,
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: animationDuration,
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  border: Border.all(color: color, width: width),
                  borderRadius: adjustedRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
