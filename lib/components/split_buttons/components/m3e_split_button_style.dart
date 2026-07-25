part of '../m3e_split_buttons.dart';

/// Colors, radii, elevation, and decoration helpers for the split button.
extension _M3ESplitButtonStyle<T> on _M3ESplitButtonState<T> {
  Set<WidgetState> _segmentStates({
    required bool focused,
    required bool hovered,
    required bool pressed,
    required bool enabled,
    bool selected = false,
  }) {
    return {
      if (!enabled) WidgetState.disabled,
      if (focused) WidgetState.focused,
      if (hovered) WidgetState.hovered,
      if (pressed) WidgetState.pressed,
      if (selected) WidgetState.selected,
    };
  }

  Widget _applyDecorationLayers({
    required BuildContext context,
    required Set<WidgetState> states,
    required BorderRadius radius,
    required Widget child,
  }) {
    var result = child;

    if (widget.decoration?.backgroundBuilder != null) {
      result = ClipRRect(
        borderRadius: radius,
        child: widget.decoration!.backgroundBuilder!(context, states, result),
      );
    }

    if (widget.decoration?.foregroundBuilder != null) {
      result = ClipRRect(
        borderRadius: radius,
        child: widget.decoration!.foregroundBuilder!(context, states, result),
      );
    }

    return result;
  }

  (Color, Color, BorderSide?, double?) _resolveColorsAndShapes(
    BuildContext context, {
    required bool segmentEnabled,
  }) {
    Color fgColor =
        widget.decorationForegroundColor?.resolve({}) ??
        _buttonTheme.foreground(_scheme, widget.style);
    Color bgColor =
        widget.decorationBackgroundColor?.resolve({}) ??
        (widget.style == M3EButtonStyle.outlined
            ? Colors.transparent
            : _buttonTheme.container(_scheme, widget.style));

    BorderSide? outlineSide;
    if (widget.style == M3EButtonStyle.outlined) {
      outlineSide =
          widget.decorationBorderSide?.resolve({}) ??
          BorderSide(color: _buttonTheme.outline(_scheme));
    }

    if (!segmentEnabled) {
      return _resolveDisabledColors(outlineSide);
    }

    return (bgColor, fgColor, outlineSide, null);
  }

  (Color, Color, BorderSide?, double?) _resolveDisabledColors(
    BorderSide? outlineSide,
  ) {
    final cs = _scheme;
    final resolvedFg =
        widget.decoration?.foregroundColor?.resolve({WidgetState.disabled}) ??
        cs.onSurface.withValues(
          alpha: M3EButtonConstants.kDisabledForegroundAlpha,
        );

    final Color resolvedBg;
    if (widget.decoration?.backgroundColor?.resolve({WidgetState.disabled}) !=
        null) {
      resolvedBg = widget.decoration!.backgroundColor!.resolve({
        WidgetState.disabled,
      })!;
    } else {
      resolvedBg = (widget.style == M3EButtonStyle.outlined)
          ? Colors.transparent
          : cs.onSurface.withValues(
              alpha: M3EButtonConstants.kDisabledBackgroundAlpha,
            );
    }

    final BorderSide? resolvedOutline = outlineSide == null
        ? null
        : BorderSide(
            color: cs.onSurface.withValues(
              alpha: M3EButtonConstants.kDisabledOutlineAlpha,
            ),
            width: outlineSide.width,
            style: outlineSide.style,
          );

    return (resolvedBg, resolvedFg, resolvedOutline, null);
  }

  _CornerRadii _leadingRadii({
    required TextDirection dir,
    required double outer,
    required double inner,
    double? hovered,
    double? pressed,
  }) {
    final i = pressed ?? hovered ?? inner;
    return _CornerRadii(
      topStart: outer,
      bottomStart: outer,
      topEnd: i,
      bottomEnd: i,
    );
  }

  _CornerRadii _trailingRadii({
    required TextDirection dir,
    required double outer,
    required double inner,
    double? hovered,
    double? pressed,
    double? selected,
  }) {
    final o = selected ?? outer;
    final i = selected ?? pressed ?? hovered ?? inner;
    return _CornerRadii(topStart: i, bottomStart: i, topEnd: o, bottomEnd: o);
  }

  double? _segmentElevation({
    required bool hovered,
    required bool pressed,
    required bool segmentEnabled,
  }) {
    final states = <WidgetState>{
      if (!segmentEnabled) WidgetState.disabled,
      if (hovered) WidgetState.hovered,
      if (pressed) WidgetState.pressed,
    };
    final value = _buttonTheme.elevation(widget.style, states);
    return value == 0 ? null : value;
  }

  void _triggerHaptic() {
    final haptic = widget.decorationHaptic;
    if (haptic == M3EHapticFeedback.none) {
      return;
    }
    M3EButtonConstants.triggerHapticFeedback(haptic);
  }

  MouseCursor _segmentMouseCursor({
    required bool enabled,
    required Set<WidgetState> segmentStates,
  }) {
    if (!enabled) {
      return SystemMouseCursors.basic;
    }
    return widget.decoration?.mouseCursor?.resolve({...segmentStates}) ??
        widget.mouseCursor ??
        SystemMouseCursors.click;
  }

  List<BoxShadow>? _segmentShadows({
    required Color shadowColor,
    required double? elevation,
  }) {
    if (elevation == null || elevation <= 0) {
      return null;
    }
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.15),
        blurRadius: elevation * 2,
        offset: Offset(0, elevation),
      ),
    ];
  }

  Widget _wrapSegmentChrome({
    required double minTap,
    required double? fixedWidth,
    required String? tooltip,
    required Widget child,
    Key? key,
  }) {
    Widget wrapped = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minTap),
      child: Center(child: child),
    );
    if (key != null) {
      wrapped = KeyedSubtree(key: key, child: wrapped);
    }
    if (fixedWidth != null) {
      wrapped = SizedBox(width: fixedWidth, child: wrapped);
    }
    if (tooltip == null) {
      return wrapped;
    }
    return Tooltip(message: tooltip, child: wrapped);
  }
}
