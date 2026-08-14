part of '../m3e_toggle_button.dart';

/// Colors and [ButtonStyle] assembly for [_M3EToggleButtonState].
extension _M3EToggleButtonStyle on _M3EToggleButtonState {
  Widget _buildCore(
    M3EButtonMeasurements m,
    EdgeInsets internalPadding,
    BorderRadius animatedRadius,
  ) {
    final checked = _isChecked;
    final buttonShape = WidgetStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(borderRadius: animatedRadius),
    );
    final padding = WidgetStateProperty.all<EdgeInsetsGeometry>(
      internalPadding,
    );
    final style = _buildButtonStyle(
      checked,
      buttonShape,
      padding,
      animatedRadius,
    );
    final content = _buildContent(m, checked);
    final onPressed = widget.enabled ? _handleTap : null;
    final button = _createMaterialButton(
      style: style,
      content: content,
      onPressed: onPressed,
    );

    Widget result = M3EInkSplashTheme(
      color: widget.decoration?.foregroundGradient != null
          ? m3eGradientForegroundSourceColor
          : _resolvedForegroundColor(checked),
      child: button,
    );
    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip, child: result);
    }

    return Semantics(
      label: widget.semanticLabel,
      checked: _isChecked,
      child: result,
    );
  }

  Widget _createMaterialButton({
    required ButtonStyle style,
    required Widget content,
    required VoidCallback? onPressed,
  }) {
    final onLongPress = widget.enabled ? widget.onLongPress : null;
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
          child: content,
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
          child: content,
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
          child: content,
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
          child: content,
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
          child: content,
        );
    }
  }

  Color _resolvedForegroundColor(bool checked) {
    final cs = _scheme;
    switch (widget.style) {
      case M3EButtonStyle.filled:
        return checked ? cs.onPrimary : cs.onSurfaceVariant;
      case M3EButtonStyle.elevated:
        return checked ? cs.onPrimary : cs.primary;
      case M3EButtonStyle.tonal:
        return checked ? cs.onSecondaryContainer : cs.onSurfaceVariant;
      case M3EButtonStyle.outlined:
        return checked ? cs.onSecondaryContainer : cs.onSurface;
      case M3EButtonStyle.text:
        return checked ? cs.primary : cs.onSurface;
    }
  }

  Color _resolvedBackgroundColor(bool checked) {
    final cs = _scheme;
    switch (widget.style) {
      case M3EButtonStyle.filled:
        return checked ? cs.primary : cs.surfaceContainerHighest;
      case M3EButtonStyle.elevated:
        return checked ? cs.primary : cs.surfaceContainerLow;
      case M3EButtonStyle.tonal:
        return checked ? cs.secondaryContainer : cs.surfaceContainerHighest;
      case M3EButtonStyle.outlined:
        return checked ? cs.secondaryContainer : Colors.transparent;
      case M3EButtonStyle.text:
        return Colors.transparent;
    }
  }

  bool get _isTransparentStyle =>
      widget.style == M3EButtonStyle.outlined ||
      widget.style == M3EButtonStyle.text;

  ButtonStyle _buildButtonStyle(
    bool checked,
    WidgetStateProperty<OutlinedBorder> buttonShape,
    WidgetStateProperty<EdgeInsetsGeometry> padding,
    BorderRadius animatedRadius,
  ) {
    final fgColor = _resolvedForegroundColor(checked);
    final bgColor = _resolvedBackgroundColor(checked);
    final transparent = _isTransparentStyle;
    final bool gradientOverlay = m3eUsesGradientOverlay(
      widget.decoration?.overlayGradient,
    );

    return ButtonStyle(
      alignment: _kAlignmentCenter,
      textStyle: WidgetStateProperty.all(labelStyle),
      minimumSize: WidgetStateProperty.all(Size(0, _measurements.height)),
      padding: padding,
      foregroundColor: _foregroundColorProperty(checked, fgColor),
      backgroundColor: _backgroundColorProperty(checked, bgColor, transparent),
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
      shape: buttonShape,
      elevation: WidgetStateProperty.resolveWith((states) {
        return _buttonTheme.elevation(widget.style, states);
      }),
      side: _sideProperty(checked),
      mouseCursor: _mouseCursorProperty(),
      animationDuration: _kDurationZero,
      visualDensity: _kVisualDensityStandard,
      splashFactory: gradientOverlay
          ? NoSplash.splashFactory
          : (widget.splashFactory ?? InkSparkle.splashFactory),
      overlayColor: gradientOverlay
          ? const WidgetStatePropertyAll<Color?>(Colors.transparent)
          : (widget.decorationOverlayColor ??
                _overlayColorProperty(checked, fgColor)),
      surfaceTintColor: widget.decorationSurfaceTintColor,
      enableFeedback: widget.enableFeedback,
    );
  }

  WidgetStateProperty<Color?> _foregroundColorProperty(
    bool checked,
    Color fgColor,
  ) {
    return WidgetStateProperty.resolveWith((states) {
      return _resolveForegroundForStates(states, checked, fgColor);
    });
  }

  Color? _resolveForegroundForStates(
    Set<WidgetState> states,
    bool checked,
    Color fgColor,
  ) {
    final activeStates = checked ? {...states, WidgetState.selected} : states;

    if (widget.decoration?.foregroundGradient?.resolve(activeStates) != null) {
      return m3eGradientForegroundSourceColor;
    }

    if (widget.decoration?.foregroundColor != null) {
      final color = widget.decoration!.foregroundColor!.resolve(activeStates);
      if (color != null) {
        return color;
      }
    }

    if (states.contains(WidgetState.disabled)) {
      return _scheme.onSurface.withValues(
        alpha: M3EButtonConstants.kDisabledForegroundAlpha,
      );
    }
    return fgColor;
  }

  WidgetStateProperty<Color?> _backgroundColorProperty(
    bool checked,
    Color bgColor,
    bool transparent,
  ) {
    return WidgetStateProperty.resolveWith((states) {
      return _resolveBackgroundForStates(states, checked, bgColor, transparent);
    });
  }

  Color? _resolveBackgroundForStates(
    Set<WidgetState> states,
    bool checked,
    Color bgColor,
    bool transparent,
  ) {
    final activeStates = checked ? {...states, WidgetState.selected} : states;

    if (widget.decoration?.backgroundColor != null) {
      final color = widget.decoration!.backgroundColor!.resolve(activeStates);
      if (color != null) {
        return color;
      }
    }

    if (states.contains(WidgetState.disabled)) {
      return transparent
          ? Colors.transparent
          : _scheme.onSurface.withValues(
              alpha: M3EButtonConstants.kDisabledBackgroundAlpha,
            );
    }
    return transparent || widget.decoration?.backgroundGradient != null
        ? Colors.transparent
        : bgColor;
  }

  WidgetStateProperty<BorderSide?> _sideProperty(bool checked) {
    return WidgetStateProperty.resolveWith((states) {
      return _resolveSideForStates(states, checked);
    });
  }

  BorderSide? _resolveSideForStates(Set<WidgetState> states, bool checked) {
    final activeStates = checked ? {...states, WidgetState.selected} : states;
    if (widget.decoration?.outlineGradient?.resolve(activeStates) != null ||
        widget.decoration?.side != null) {
      return BorderSide.none;
    }
    if (widget.decoration?.side != null) {
      final side = widget.decoration!.side!.resolve(activeStates);
      if (side != null) {
        return side;
      }
    }
    if (widget.style != M3EButtonStyle.outlined) {
      return BorderSide.none;
    }

    if (states.contains(WidgetState.disabled)) {
      return BorderSide(
        color: _scheme.onSurface.withValues(
          alpha: M3EButtonConstants.kDisabledOutlineAlpha,
        ),
      );
    }
    return BorderSide(color: _buttonTheme.outline(_scheme));
  }

  WidgetStateProperty<MouseCursor?> _mouseCursorProperty() {
    return WidgetStateProperty.resolveWith(_resolveMouseCursorForStates);
  }

  MouseCursor? _resolveMouseCursorForStates(Set<WidgetState> states) {
    if (widget.decoration?.mouseCursor != null) {
      final cursor = widget.decoration!.mouseCursor!.resolve(states);
      if (cursor != null) {
        return cursor;
      }
    }
    if (states.contains(WidgetState.disabled)) {
      return SystemMouseCursors.basic;
    }
    return widget.mouseCursor ?? SystemMouseCursors.click;
  }

  WidgetStateProperty<Color?> _overlayColorProperty(
    bool checked,
    Color fgColor,
  ) {
    return WidgetStateProperty.resolveWith((states) {
      return _resolveOverlayForStates(states, checked, fgColor);
    });
  }

  Color? _resolveOverlayForStates(
    Set<WidgetState> states,
    bool checked,
    Color fgColor,
  ) {
    if (states.contains(WidgetState.disabled)) {
      return null;
    }
    if (states.contains(WidgetState.pressed)) {
      return null;
    }
    final activeStates = checked ? {...states, WidgetState.selected} : states;
    Color? foreground;
    if (widget.decoration?.foregroundColor != null) {
      foreground = widget.decoration!.foregroundColor!.resolve(activeStates);
    }
    foreground ??= fgColor;
    return M3EStateLayer.resolveOverlayColor(foreground, states);
  }
}
