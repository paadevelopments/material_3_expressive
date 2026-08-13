// Button build / core widget assembly for function_length.
part of '../m3e_buttons.dart';

extension _M3EButtonContent on _M3EButtonState {
  Widget _buildContent(BuildContext context) {
    final m = _measurements;
    final baseInternalPadding = EdgeInsets.symmetric(horizontal: m.hPadding);
    final shapes = _resolveShapes(m);
    final baseStyle = _buildBaseStyle();

    return wrapWithPointerPressTracking(
      enabled: widget.enabled && widget.onPressed != null,
      child: buildAnimatedContent(
        builder:
            (
              context, {
              required isPressed,
              required isHovered,
              required isFocused,
            }) {
              return _buildAnimatedCore(
                m: m,
                baseStyle: baseStyle,
                baseInternalPadding: baseInternalPadding,
                shapes: shapes,
                isPressed: isPressed,
                isHovered: isHovered,
                isFocused: isFocused,
              );
            },
      ),
    );
  }

  ({
    BorderRadius defaultShape,
    BorderRadius pressedShape,
    BorderRadius hoveredShape,
  })
  _resolveShapes(M3EButtonMeasurements m) {
    final fullyRound = BorderRadius.circular(m.height / 2);
    final explicitBorderRadius = widget.decorationBorderRadius;
    final tokenPressed = _buttonTheme.pressedRadius(widget.size);
    final defaultShape = explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : widget.shape == M3EButtonShape.round
        ? fullyRound
        : BorderRadius.circular(_buttonTheme.squareRadius(widget.size));

    final explicitPressed = widget.decorationPressedRadius;
    final pressedShape = explicitPressed != null
        ? BorderRadius.circular(explicitPressed)
        : explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : BorderRadius.circular(tokenPressed);

    final tokenHovered = _buttonTheme.hoveredRadius(widget.size);
    final defaultExplicitHovered = widget.decoration?.hoveredRadius;
    final hoveredShape = defaultExplicitHovered != null
        ? BorderRadius.circular(defaultExplicitHovered)
        : explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : BorderRadius.circular(tokenHovered);

    return (
      defaultShape: defaultShape,
      pressedShape: pressedShape,
      hoveredShape: hoveredShape,
    );
  }

  Widget _buildAnimatedCore({
    required M3EButtonMeasurements m,
    required ButtonStyle baseStyle,
    required EdgeInsets baseInternalPadding,
    required ({
      BorderRadius defaultShape,
      BorderRadius pressedShape,
      BorderRadius hoveredShape,
    })
    shapes,
    required bool isPressed,
    required bool isHovered,
    required bool isFocused,
  }) {
    final effectivelyEnabled = widget.enabled && widget.onPressed != null;
    final targetRadius = (effectivelyEnabled && isPressed)
        ? shapes.pressedShape
        : (effectivelyEnabled && isHovered)
        ? shapes.hoveredShape
        : shapes.defaultShape;

    Widget core = RepaintBoundary(
      child: M3ERadiusAndPaddingMotion(
        motion: springMotion,
        internalLeft: baseInternalPadding.left,
        internalRight: baseInternalPadding.right,
        internalTop: baseInternalPadding.top,
        internalBottom: baseInternalPadding.bottom,
        targetRadius: targetRadius,
        builder: (animatedInternal, animatedRadius) {
          final buttonCore = _buildButtonCore(
            m,
            baseStyle,
            animatedInternal,
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

    final dec = widget.decoration;
    final hasDecorationSize =
        dec?.fixedSize != null ||
        dec?.minimumSize != null ||
        dec?.maximumSize != null;
    final fixedWidth = hasDecorationSize ? null : widget.size.width;
    if (fixedWidth != null) {
      core = SizedBox(width: fixedWidth, child: core);
    }
    return core;
  }

  Widget _buildButtonCore(
    M3EButtonMeasurements m,
    ButtonStyle baseStyle,
    EdgeInsets internalPadding,
    BorderRadius animatedRadius,
  ) {
    Widget child = widget.child ?? const SizedBox.shrink();
    if (widget.semanticLabel != null) {
      child = ExcludeSemantics(child: child);
    }

    final style = baseStyle.copyWith(
      padding: widget.decoration?.padding != null
          ? WidgetStateProperty.all<EdgeInsetsGeometry>(
              widget.decoration!.padding!,
            )
          : WidgetStateProperty.all<EdgeInsetsGeometry>(internalPadding),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: animatedRadius),
      ),
      backgroundBuilder: m3eGradientSurfaceBuilder(
        clipRadius: animatedRadius,
        backgroundGradient: widget.decoration?.backgroundGradient,
        overlayGradient: widget.decoration?.overlayGradient,
        outlineGradient: widget.decoration?.outlineGradient,
        outlineSide: widget.decoration?.side,
        explicitBuilder: widget.decoration?.backgroundBuilder,
      ),
      foregroundBuilder: m3eGradientForegroundBuilder(
        clipRadius: animatedRadius,
        gradient: widget.decoration?.foregroundGradient,
        explicitBuilder: widget.decoration?.foregroundBuilder,
      ),
    );

    final button = _createMaterialButton(
      style: style,
      onPressed: _effectiveOnPressed,
      onLongPress: widget.enabled ? widget.onLongPress : null,
      child: child,
    );

    return _wrapButtonChrome(button);
  }

  VoidCallback? get _effectiveOnPressed {
    if (!widget.enabled || widget.onPressed == null) {
      return null;
    }
    return () {
      M3EHaptics.trigger(widget.decoration?.haptic ?? M3EHapticFeedback.none);
      widget.onPressed?.call();
    };
  }

  Widget _createMaterialButton({
    required ButtonStyle style,
    required VoidCallback? onPressed,
    required VoidCallback? onLongPress,
    required Widget child,
  }) {
    switch (widget.style) {
      case M3EButtonStyle.filled:
        return FilledButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.tonal:
        return FilledButton.tonal(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.elevated:
        return ElevatedButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.outlined:
        return OutlinedButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.text:
        return TextButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
    }
  }

  Widget _wrapButtonChrome(Widget button) {
    final dec = widget.decoration;
    Color inkSplashColor = _buttonTheme.foreground(_scheme, widget.style);
    if (dec?.foregroundColor != null) {
      inkSplashColor =
          dec!.foregroundColor!.resolve(const <WidgetState>{}) ??
          inkSplashColor;
    }

    Widget result = M3EInkSplashTheme(color: inkSplashColor, child: button);
    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip, child: result);
    }
    if (widget.semanticLabel != null) {
      result = Semantics(label: widget.semanticLabel, child: result);
    }
    return result;
  }
}
