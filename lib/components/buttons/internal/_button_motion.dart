// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

import 'package:material_3_expressive/components/buttons/internal/button_constants.dart';

const double kAnimationDeltaThreshold = 0.005;
const double kSpringRetargetTolerance = 0.1;

abstract class _ConstProperties {
  static const double focusRingGap = ButtonConstants.kFocusRingGap;
  static const double focusRingWidth = ButtonConstants.kFocusRingWidth;
}

class _CachedLerpResult {
  double tl = 0;
  double tr = 0;
  double bl = 0;
  double br = 0;
  double l = 0;
  double r = 0;
  double t = 0;
  double b = 0;
  EdgeInsets? cachedInsets;
  BorderRadius? cachedRadius;

  _CachedLerpResult();

  bool hasChangedSignificantly(_CachedLerpResult other) {
    return (tl - other.tl).abs() > kAnimationDeltaThreshold ||
        (tr - other.tr).abs() > kAnimationDeltaThreshold ||
        (bl - other.bl).abs() > kAnimationDeltaThreshold ||
        (br - other.br).abs() > kAnimationDeltaThreshold ||
        (l - other.l).abs() > kAnimationDeltaThreshold ||
        (r - other.r).abs() > kAnimationDeltaThreshold ||
        (t - other.t).abs() > kAnimationDeltaThreshold ||
        (b - other.b).abs() > kAnimationDeltaThreshold;
  }
}

abstract final class _MotionConstants {
  static const double tolerance = kSpringRetargetTolerance;
}

class _RadiusAndPaddingMotionKeys {
  final double internalLeft;
  final double internalRight;
  final double internalTop;
  final double internalBottom;
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  const _RadiusAndPaddingMotionKeys({
    required this.internalLeft,
    required this.internalRight,
    required this.internalTop,
    required this.internalBottom,
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });

  factory _RadiusAndPaddingMotionKeys.from(
    double iL,
    double iR,
    double iT,
    double iB,
    BorderRadius radius,
  ) {
    return _RadiusAndPaddingMotionKeys(
      internalLeft: iL,
      internalRight: iR,
      internalTop: iT,
      internalBottom: iB,
      topLeft: radius.topLeft.x,
      topRight: radius.topRight.x,
      bottomLeft: radius.bottomLeft.x,
      bottomRight: radius.bottomRight.x,
    );
  }

  bool matches(
    double iL,
    double iR,
    double iT,
    double iB,
    BorderRadius radius, {
    double tolerance = _MotionConstants.tolerance,
  }) {
    return (internalLeft - iL).abs() <= tolerance &&
        (internalRight - iR).abs() <= tolerance &&
        (internalTop - iT).abs() <= tolerance &&
        (internalBottom - iB).abs() <= tolerance &&
        (topLeft - radius.topLeft.x).abs() <= tolerance &&
        (topRight - radius.topRight.x).abs() <= tolerance &&
        (bottomLeft - radius.bottomLeft.x).abs() <= tolerance &&
        (bottomRight - radius.bottomRight.x).abs() <= tolerance;
  }
}

// ---------------------------------------------------------------------------
// Motion helper — single coordinated spring (Compose rememberAnimatedShape parity)
// ---------------------------------------------------------------------------

/// Animates shape and padding changes using a single spring progress value (0→1)
/// that drives ALL corners and padding edges simultaneously.
///
/// This matches Compose's `rememberAnimatedShape` approach exactly:
/// - One spring drives the whole transition
/// - All corners and padding edges are lerped from the same progress
/// - Mid-flight retargeting starts from the *current animated position*
class RadiusAndPaddingMotion extends StatefulWidget {
  final SpringMotion motion;
  final double internalLeft;
  final double internalRight;
  final double internalTop;
  final double internalBottom;
  final BorderRadius targetRadius;

  /// When true the corresponding corner is locked: it stays at [targetRadius]
  /// and doesn't participate in the animation.
  final bool freezeTopLeft;
  final bool freezeTopRight;
  final bool freezeBottomLeft;
  final bool freezeBottomRight;

  final Widget Function(EdgeInsets padding, BorderRadius radius) builder;

  const RadiusAndPaddingMotion({
    super.key,
    required this.motion,
    required this.internalLeft,
    required this.internalRight,
    required this.internalTop,
    required this.internalBottom,
    required this.targetRadius,
    this.freezeTopLeft = false,
    this.freezeTopRight = false,
    this.freezeBottomLeft = false,
    this.freezeBottomRight = false,
    required this.builder,
  });

  @override
  State<RadiusAndPaddingMotion> createState() => _RadiusAndPaddingMotionState();
}

class _RadiusAndPaddingMotionState extends State<RadiusAndPaddingMotion> {
  late double _srcTopLeft, _srcTopRight, _srcBottomLeft, _srcBottomRight;
  late double _srcLeft, _srcRight, _srcTop, _srcBottom;

  late double _curTopLeft, _curTopRight, _curBottomLeft, _curBottomRight;
  late double _curLeft, _curRight, _curTop, _curBottom;

  double _progressTarget = 1.0;

  final _CachedLerpResult _lastFrame = _CachedLerpResult();
  _RadiusAndPaddingMotionKeys? _lastKeys;

  @override
  void initState() {
    super.initState();
    _initValues();
  }

  void _initValues() {
    _curTopLeft = _srcTopLeft = widget.targetRadius.topLeft.x;
    _curTopRight = _srcTopRight = widget.targetRadius.topRight.x;
    _curBottomLeft = _srcBottomLeft = widget.targetRadius.bottomLeft.x;
    _curBottomRight = _srcBottomRight = widget.targetRadius.bottomRight.x;

    _curLeft = _srcLeft = widget.internalLeft;
    _curRight = _srcRight = widget.internalRight;
    _curTop = _srcTop = widget.internalTop;
    _curBottom = _srcBottom = widget.internalBottom;

    _lastKeys = _RadiusAndPaddingMotionKeys.from(
      widget.internalLeft,
      widget.internalRight,
      widget.internalTop,
      widget.internalBottom,
      widget.targetRadius,
    );
  }

  @override
  void didUpdateWidget(covariant RadiusAndPaddingMotion oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_targetsChanged(oldWidget)) {
      final newKeys = _RadiusAndPaddingMotionKeys.from(
        widget.internalLeft,
        widget.internalRight,
        widget.internalTop,
        widget.internalBottom,
        widget.targetRadius,
      );

      if (_lastKeys != null &&
          _lastKeys!.matches(
            widget.internalLeft,
            widget.internalRight,
            widget.internalTop,
            widget.internalBottom,
            widget.targetRadius,
          )) {
        return;
      }

      final bool paddingChanged =
          widget.internalLeft != oldWidget.internalLeft ||
          widget.internalRight != oldWidget.internalRight ||
          widget.internalTop != oldWidget.internalTop ||
          widget.internalBottom != oldWidget.internalBottom;

      final bool frozenCornersChanged = _frozenCornersChanged(oldWidget);

      if (!paddingChanged && frozenCornersChanged) {
        // Only frozen corners changed — snap them immediately, no animation.
        _updateFrozenCornerValues();
        _lastKeys = newKeys;
        return;
      }

      _lastKeys = newKeys;

      _srcTopLeft = _curTopLeft;
      _srcTopRight = _curTopRight;
      _srcBottomLeft = _curBottomLeft;
      _srcBottomRight = _curBottomRight;
      _srcLeft = _curLeft;
      _srcRight = _curRight;
      _srcTop = _curTop;
      _srcBottom = _curBottom;

      _progressTarget = _progressTarget == 0.0 ? 1.0 : 0.0;
    }
  }

  bool _frozenCornersChanged(RadiusAndPaddingMotion old) {
    if (widget.freezeTopLeft &&
        widget.targetRadius.topLeft.x != old.targetRadius.topLeft.x) {
      return true;
    }
    if (widget.freezeTopRight &&
        widget.targetRadius.topRight.x != old.targetRadius.topRight.x) {
      return true;
    }
    if (widget.freezeBottomLeft &&
        widget.targetRadius.bottomLeft.x != old.targetRadius.bottomLeft.x) {
      return true;
    }
    if (widget.freezeBottomRight &&
        widget.targetRadius.bottomRight.x != old.targetRadius.bottomRight.x) {
      return true;
    }
    return false;
  }

  void _updateFrozenCornerValues() {
    if (widget.freezeTopLeft) {
      _curTopLeft = _srcTopLeft = widget.targetRadius.topLeft.x;
    }
    if (widget.freezeTopRight) {
      _curTopRight = _srcTopRight = widget.targetRadius.topRight.x;
    }
    if (widget.freezeBottomLeft) {
      _curBottomLeft = _srcBottomLeft = widget.targetRadius.bottomLeft.x;
    }
    if (widget.freezeBottomRight) {
      _curBottomRight = _srcBottomRight = widget.targetRadius.bottomRight.x;
    }
  }

  bool _targetsChanged(RadiusAndPaddingMotion old) {
    return widget.targetRadius != old.targetRadius ||
        widget.internalLeft != old.internalLeft ||
        widget.internalRight != old.internalRight ||
        widget.internalTop != old.internalTop ||
        widget.internalBottom != old.internalBottom;
  }

  void _onFrame({
    required double tl,
    required double tr,
    required double bl,
    required double br,
    required double l,
    required double r,
    required double t,
    required double b,
  }) {
    _curTopLeft = tl;
    _curTopRight = tr;
    _curBottomLeft = bl;
    _curBottomRight = br;
    _curLeft = l;
    _curRight = r;
    _curTop = t;
    _curBottom = b;
  }

  bool _shouldThrottleUpdate(
    double tl,
    double tr,
    double bl,
    double br,
    double l,
    double r,
    double t,
    double b,
  ) {
    final current = _CachedLerpResult()
      ..tl = tl
      ..tr = tr
      ..bl = bl
      ..br = br
      ..l = l
      ..r = r
      ..t = t
      ..b = b;

    if (_lastFrame.hasChangedSignificantly(current)) {
      _lastFrame.tl = tl;
      _lastFrame.tr = tr;
      _lastFrame.bl = bl;
      _lastFrame.br = br;
      _lastFrame.l = l;
      _lastFrame.r = r;
      _lastFrame.t = t;
      _lastFrame.b = b;
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SingleMotionBuilder(
        motion: widget.motion,
        value: _progressTarget,
        builder: (context, t, _) {
          final double rawFactor = _progressTarget == 1.0 ? t : 1.0 - t;
          final double factor = rawFactor.isFinite
              ? rawFactor.clamp(0.0, 1.0)
              : 0.0;

          final double tl = widget.freezeTopLeft
              ? widget.targetRadius.topLeft.x
              : lerpDouble(_srcTopLeft, widget.targetRadius.topLeft.x, factor)!;
          final double tr = widget.freezeTopRight
              ? widget.targetRadius.topRight.x
              : lerpDouble(
                  _srcTopRight,
                  widget.targetRadius.topRight.x,
                  factor,
                )!;
          final double bl = widget.freezeBottomLeft
              ? widget.targetRadius.bottomLeft.x
              : lerpDouble(
                  _srcBottomLeft,
                  widget.targetRadius.bottomLeft.x,
                  factor,
                )!;
          final double br = widget.freezeBottomRight
              ? widget.targetRadius.bottomRight.x
              : lerpDouble(
                  _srcBottomRight,
                  widget.targetRadius.bottomRight.x,
                  factor,
                )!;
          final double curL = lerpDouble(
            _srcLeft,
            widget.internalLeft,
            factor,
          )!;
          final double curR = lerpDouble(
            _srcRight,
            widget.internalRight,
            factor,
          )!;
          final double curT = lerpDouble(_srcTop, widget.internalTop, factor)!;
          final double curB = lerpDouble(
            _srcBottom,
            widget.internalBottom,
            factor,
          )!;

          _onFrame(
            tl: tl,
            tr: tr,
            bl: bl,
            br: br,
            l: curL,
            r: curR,
            t: curT,
            b: curB,
          );

          if (_shouldThrottleUpdate(tl, tr, bl, br, curL, curR, curT, curB)) {
            return widget.builder(
              _lastFrame.cachedInsets ??
                  EdgeInsets.fromLTRB(curL, curT, curR, curB),
              _lastFrame.cachedRadius ??
                  BorderRadius.only(
                    topLeft: Radius.circular(tl),
                    topRight: Radius.circular(tr),
                    bottomLeft: Radius.circular(bl),
                    bottomRight: Radius.circular(br),
                  ),
            );
          }

          _lastFrame.cachedInsets = EdgeInsets.fromLTRB(curL, curT, curR, curB);
          _lastFrame.cachedRadius = BorderRadius.only(
            topLeft: Radius.circular(tl),
            topRight: Radius.circular(tr),
            bottomLeft: Radius.circular(bl),
            bottomRight: Radius.circular(br),
          );

          return widget.builder(
            _lastFrame.cachedInsets!,
            _lastFrame.cachedRadius!,
          );
        },
      ),
    );
  }
}

/// A decorator that draws the Material 3 Expressive focus ring around its child.
///
/// The ring paints as a **zero-layout-impact overlay**: it does not inflate the
/// child's bounding box. Instead it uses [Stack] with [Clip.none] and a
/// [Positioned] child offset by [_outset] on all sides, so the ring is free
/// to paint outside the button's natural bounds without pushing surrounding
/// content apart.
///
/// Each corner of the ring is expanded by exactly [_ConstProperties.focusRingGap]
/// from the corresponding button corner. This ensures that for asymmetric
/// buttons (e.g. a split-button leading segment with outer ≈ 16 dp and
/// inner ≈ 4 dp) the ring follows the exact contour of the button rather
/// than approximating it with a uniform inflation.
class FocusRing extends StatelessWidget {
  final BorderRadius radius;
  final Widget child;
  final bool focused;
  final Duration animationDuration;

  const FocusRing({
    super.key,
    required this.radius,
    required this.child,
    this.focused = false,
    this.animationDuration = Duration.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (!focused) return RepaintBoundary(child: child);

    final color = m3eMaterialTheme(context).colorScheme.primary;

    const double gap = _ConstProperties.focusRingGap;
    const double width = _ConstProperties.focusRingWidth;
    // The ring's outer edge sits gap+width outside the button boundary;
    // that is the distance we need to push the Positioned box outward.
    const double outset = gap + width;

    // To be perfectly concentric and mathematically bullet-proof so the gap
    // is uniformly exactly `gap` dp all the way around the curve (even on diagonal),
    // the focus ring's outer corner radius MUST increase by exactly `outset`.
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
