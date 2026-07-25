part of '../m3e_toggle_button.dart';

/// Shape / radius resolution for [_M3EToggleButtonState].
extension _M3EToggleButtonShape on _M3EToggleButtonState {
  Widget _buildWidget(BuildContext context) {
    final m = _measurements;
    final halfHeight = m.height / 2;
    final explicitBorderRadius = widget.decorationBorderRadius;
    final shapes = _resolveShapeTokens(
      context: context,
      halfHeight: halfHeight,
      explicitBorderRadius: explicitBorderRadius,
    );
    final hPad = _hasLabel ? m.hPadding : m.hPadding / 2;

    return wrapWithPointerPressTracking(
      enabled: widget.enabled,
      child: buildAnimatedContent(
        builder:
            (
              context, {
              required isPressed,
              required isHovered,
              required isFocused,
            }) {
              return _buildAnimatedShell(
                measurements: m,
                shapes: shapes,
                horizontalPadding: hPad,
                isPressed: isPressed,
                isHovered: isHovered,
                isFocused: isFocused,
              );
            },
      ),
    );
  }

  _M3EToggleShapeTokens _resolveShapeTokens({
    required BuildContext context,
    required double halfHeight,
    required double? explicitBorderRadius,
  }) {
    final squareRad = _buttonTheme.squareRadius(widget.size);
    final pressRad = _buttonTheme.pressedRadius(widget.size);
    final fullyRound = BorderRadius.circular(halfHeight);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final outerRad = explicitBorderRadius ?? halfHeight;
    final innerRad =
        explicitBorderRadius ??
        widget.decorationConnectedInnerRadius ??
        _groupTheme.connectedInnerRadius;
    final pressInnerRad =
        widget.decorationPressedRadius ??
        explicitBorderRadius ??
        _groupTheme.connectedPressedInnerRadius;

    final freezeStart = widget.isFirstInGroup;
    final freezeEnd = widget.isLastInGroup;

    return _M3EToggleShapeTokens(
      explicitBorderRadius: explicitBorderRadius,
      outerRad: outerRad,
      innerRad: innerRad,
      pressInnerRad: pressInnerRad,
      freezeLeft: isRtl ? freezeEnd : freezeStart,
      freezeRight: isRtl ? freezeStart : freezeEnd,
      restingShape: widget.decorationUncheckedRadius != null
          ? BorderRadius.circular(widget.decorationUncheckedRadius!)
          : explicitBorderRadius != null
          ? BorderRadius.circular(explicitBorderRadius)
          : fullyRound,
      squareShape: BorderRadius.circular(
        widget.decorationCheckedRadius ?? explicitBorderRadius ?? squareRad,
      ),
      pressSquish: BorderRadius.circular(
        widget.decorationPressedRadius ?? explicitBorderRadius ?? pressRad,
      ),
      checkedConnectedShape: explicitBorderRadius != null
          ? BorderRadius.circular(explicitBorderRadius)
          : fullyRound,
    );
  }

  Widget _buildAnimatedShell({
    required M3EButtonMeasurements measurements,
    required _M3EToggleShapeTokens shapes,
    required double horizontalPadding,
    required bool isPressed,
    required bool isHovered,
    required bool isFocused,
  }) {
    final targetRadius = _resolveTargetRadius(
      shapes: shapes,
      checked: _isChecked,
      effectivelyEnabled: widget.enabled,
      pressed: isPressed,
      hovered: isHovered,
    );

    Widget core = RepaintBoundary(
      child: M3ERadiusAndPaddingMotion(
        motion: springMotion,
        internalLeft: horizontalPadding,
        internalRight: horizontalPadding,
        internalTop: 0,
        internalBottom: 0,
        targetRadius: targetRadius,
        freezeTopLeft: widget.isGroupConnected && shapes.freezeLeft,
        freezeBottomLeft: widget.isGroupConnected && shapes.freezeLeft,
        freezeTopRight: widget.isGroupConnected && shapes.freezeRight,
        freezeBottomRight: widget.isGroupConnected && shapes.freezeRight,
        builder: (animatedPadding, animatedRadius) {
          final buttonCore = _buildCore(
            measurements,
            animatedPadding,
            animatedRadius,
          );
          return M3EFocusRing(
            focused: isFocused,
            radius: animatedRadius,
            child: buttonCore,
          );
        },
      ),
    );

    final fixedWidth = widget.size.width;
    if (fixedWidth != null) {
      core = SizedBox(width: fixedWidth, child: core);
    }
    return core;
  }

  BorderRadius _resolveTargetRadius({
    required _M3EToggleShapeTokens shapes,
    required bool checked,
    required bool effectivelyEnabled,
    required bool pressed,
    required bool hovered,
  }) {
    if (widget.isGroupConnected) {
      return _resolveConnectedTargetRadius(
        shapes: shapes,
        checked: checked,
        effectivelyEnabled: effectivelyEnabled,
        pressed: pressed,
        hovered: hovered,
      );
    }
    return _resolveStandaloneTargetRadius(
      shapes: shapes,
      checked: checked,
      effectivelyEnabled: effectivelyEnabled,
      pressed: pressed,
      hovered: hovered,
    );
  }

  BorderRadius _resolveConnectedTargetRadius({
    required _M3EToggleShapeTokens shapes,
    required bool checked,
    required bool effectivelyEnabled,
    required bool pressed,
    required bool hovered,
  }) {
    final restingRadius = BorderRadiusDirectional.horizontal(
      start: Radius.circular(
        widget.isFirstInGroup ? shapes.outerRad : shapes.innerRad,
      ),
      end: Radius.circular(
        widget.isLastInGroup ? shapes.outerRad : shapes.innerRad,
      ),
    ).resolve(Directionality.of(context));

    final pressRadius = BorderRadiusDirectional.horizontal(
      start: Radius.circular(
        widget.isFirstInGroup ? shapes.outerRad : shapes.pressInnerRad,
      ),
      end: Radius.circular(
        widget.isLastInGroup ? shapes.outerRad : shapes.pressInnerRad,
      ),
    ).resolve(Directionality.of(context));

    final hoverInnerRad =
        widget.decoration?.hoveredRadius ??
        shapes.explicitBorderRadius ??
        _buttonTheme.hoveredRadius(widget.size);
    final hoverRadius = BorderRadiusDirectional.horizontal(
      start: Radius.circular(
        widget.isFirstInGroup ? shapes.outerRad : hoverInnerRad,
      ),
      end: Radius.circular(
        widget.isLastInGroup ? shapes.outerRad : hoverInnerRad,
      ),
    ).resolve(Directionality.of(context));

    if (effectivelyEnabled && pressed) {
      return pressRadius;
    }
    if (effectivelyEnabled && hovered) {
      return hoverRadius;
    }
    if (checked) {
      return shapes.checkedConnectedShape;
    }
    return restingRadius;
  }

  BorderRadius _resolveStandaloneTargetRadius({
    required _M3EToggleShapeTokens shapes,
    required bool checked,
    required bool effectivelyEnabled,
    required bool pressed,
    required bool hovered,
  }) {
    final hoverShape = widget.decoration?.hoveredRadius != null
        ? BorderRadius.circular(widget.decoration!.hoveredRadius!)
        : shapes.explicitBorderRadius != null
        ? BorderRadius.circular(shapes.explicitBorderRadius!)
        : BorderRadius.circular(_buttonTheme.hoveredRadius(widget.size));

    if (effectivelyEnabled && pressed) {
      return shapes.pressSquish;
    }
    if (effectivelyEnabled && hovered) {
      return hoverShape;
    }
    if (checked) {
      return shapes.squareShape;
    }
    return shapes.restingShape;
  }
}

class _M3EToggleShapeTokens {
  const _M3EToggleShapeTokens({
    required this.explicitBorderRadius,
    required this.outerRad,
    required this.innerRad,
    required this.pressInnerRad,
    required this.freezeLeft,
    required this.freezeRight,
    required this.restingShape,
    required this.squareShape,
    required this.pressSquish,
    required this.checkedConnectedShape,
  });

  final double? explicitBorderRadius;
  final double outerRad;
  final double innerRad;
  final double pressInnerRad;
  final bool freezeLeft;
  final bool freezeRight;
  final BorderRadius restingShape;
  final BorderRadius squareShape;
  final BorderRadius pressSquish;
  final BorderRadius checkedConnectedShape;
}
