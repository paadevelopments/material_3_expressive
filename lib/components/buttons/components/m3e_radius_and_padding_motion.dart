// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

const double kAnimationDeltaThreshold = 0.005;
const double kSpringRetargetTolerance = 0.1;

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

/// Animates shape and padding changes using a single spring progress value (0→1)
/// that drives ALL corners and padding edges simultaneously.
class M3ERadiusAndPaddingMotion extends StatefulWidget {
  final SpringMotion motion;
  final double internalLeft;
  final double internalRight;
  final double internalTop;
  final double internalBottom;
  final BorderRadius targetRadius;

  final bool freezeTopLeft;
  final bool freezeTopRight;
  final bool freezeBottomLeft;
  final bool freezeBottomRight;

  final Widget Function(EdgeInsets padding, BorderRadius radius) builder;

  const M3ERadiusAndPaddingMotion({
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
  State<M3ERadiusAndPaddingMotion> createState() =>
      _M3ERadiusAndPaddingMotionState();
}

class _M3ERadiusAndPaddingMotionState extends State<M3ERadiusAndPaddingMotion> {
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
  void didUpdateWidget(covariant M3ERadiusAndPaddingMotion oldWidget) {
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

  bool _frozenCornersChanged(M3ERadiusAndPaddingMotion old) {
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

  bool _targetsChanged(M3ERadiusAndPaddingMotion old) {
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
