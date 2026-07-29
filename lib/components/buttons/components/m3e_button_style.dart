// ButtonStyle assembly extracted for function_length / cognitive_complexity.
part of '../m3e_buttons.dart';

extension _M3EButtonStyle on _M3EButtonState {
  ButtonStyle _buildBaseStyle() {
    final dec = widget.decoration;
    final effectivePadding = dec?.padding != null
        ? WidgetStateProperty.all<EdgeInsetsGeometry>(dec!.padding!)
        : null;
    final defaultMinSize = Size(
      _buttonTheme.minWidthFloor,
      _measurements.height,
    );
    final effectiveMinSize = dec?.minimumSize != null
        ? WidgetStateProperty.all(dec!.minimumSize!)
        : WidgetStateProperty.all(defaultMinSize);

    return ButtonStyle(
      alignment: dec?.alignment ?? _kAlignmentCenter,
      padding: effectivePadding,
      textStyle: WidgetStateProperty.all(dec?.textStyle ?? labelStyle),
      minimumSize: effectiveMinSize,
      fixedSize: dec?.fixedSize != null
          ? WidgetStateProperty.all(dec!.fixedSize)
          : null,
      maximumSize: dec?.maximumSize != null
          ? WidgetStateProperty.all(dec!.maximumSize)
          : null,
      iconSize: dec?.iconSize != null
          ? WidgetStateProperty.all(dec!.iconSize)
          : null,
      iconAlignment: dec?.iconAlignment,
      shadowColor: dec?.shadowColor,
      visualDensity: dec?.visualDensity ?? _kVisualDensityStandard,
      tapTargetSize: dec?.tapTargetSize,
      animationDuration: dec?.animationDuration ?? _kDurationZero,
      splashFactory:
          dec?.splashFactory ??
          widget.splashFactory ??
          InkSparkle.splashFactory,
      foregroundColor: WidgetStateProperty.resolveWith(_resolveForegroundColor),
      backgroundColor: WidgetStateProperty.resolveWith(_resolveBackgroundColor),
      elevation: WidgetStateProperty.resolveWith(_resolveElevation),
      side: WidgetStateProperty.resolveWith(_resolveSide),
      mouseCursor: WidgetStateProperty.resolveWith(_resolveMouseCursor),
      overlayColor:
          dec?.overlayColor ??
          WidgetStateProperty.resolveWith(_resolveOverlayColor),
      surfaceTintColor: dec?.surfaceTintColor,
      enableFeedback:
          (dec?.haptic ?? M3EHapticFeedback.none) == M3EHapticFeedback.none &&
          (dec?.enableFeedback ?? widget.enableFeedback),
    );
  }

  Color? _resolveForegroundColor(Set<WidgetState> states) {
    final dec = widget.decoration;
    if (dec?.foregroundColor != null) {
      final color = dec!.foregroundColor!.resolve(states);
      if (color != null) {
        return color;
      }
    }
    if (states.contains(WidgetState.disabled)) {
      return _scheme.onSurface.withValues(
        alpha: M3EButtonConstants.kDisabledForegroundAlpha,
      );
    }
    return _buttonTheme.foreground(_scheme, widget.style);
  }

  Color? _resolveBackgroundColor(Set<WidgetState> states) {
    final dec = widget.decoration;
    if (dec?.backgroundColor != null) {
      final color = dec!.backgroundColor!.resolve(states);
      if (color != null) {
        return color;
      }
    }
    final isTransparent =
        widget.style == M3EButtonStyle.outlined ||
        widget.style == M3EButtonStyle.text;

    if (states.contains(WidgetState.disabled)) {
      return isTransparent
          ? Colors.transparent
          : _scheme.onSurface.withValues(
              alpha: M3EButtonConstants.kDisabledBackgroundAlpha,
            );
    }
    return (dec?.backgroundBuilder != null || isTransparent)
        ? Colors.transparent
        : _buttonTheme.container(_scheme, widget.style);
  }

  double? _resolveElevation(Set<WidgetState> states) {
    final dec = widget.decoration;
    if (dec?.elevation != null) {
      final e = dec!.elevation!.resolve(states);
      if (e != null) {
        return e;
      }
    }
    return _buttonTheme.elevation(widget.style, states);
  }

  BorderSide? _resolveSide(Set<WidgetState> states) {
    final dec = widget.decoration;
    if (dec?.side != null) {
      final s = dec!.side!.resolve(states);
      if (s != null) {
        return s;
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

  MouseCursor? _resolveMouseCursor(Set<WidgetState> states) {
    final dec = widget.decoration;
    if (dec?.mouseCursor != null) {
      final cursor = dec!.mouseCursor!.resolve(states);
      if (cursor != null) {
        return cursor;
      }
    }
    if (states.contains(WidgetState.disabled)) {
      return SystemMouseCursors.basic;
    }
    return widget.mouseCursor;
  }

  Color? _resolveOverlayColor(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled) ||
        states.contains(WidgetState.pressed)) {
      return null;
    }
    final dec = widget.decoration;
    Color? foreground;
    if (dec?.foregroundColor != null) {
      foreground = dec!.foregroundColor!.resolve(states);
    }
    foreground ??= _buttonTheme.foreground(_scheme, widget.style);
    return M3EStateLayer.resolveOverlayColor(foreground, states);
  }
}
