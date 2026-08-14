part of 'm3e_button_decoration.dart';

/// Styling overrides for [M3EToggleButton] and [M3EButtonGroup].
@immutable
class M3EToggleButtonDecoration {
  /// backgroundColor.
  final WidgetStateProperty<Color?>? backgroundColor;

  /// foregroundColor.
  final WidgetStateProperty<Color?>? foregroundColor;

  /// side.
  final WidgetStateProperty<BorderSide?>? side;

  /// mouseCursor.
  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  /// overlayColor.
  final WidgetStateProperty<Color?>? overlayColor;

  /// surfaceTintColor.
  final WidgetStateProperty<Color?>? surfaceTintColor;

  /// motion.
  final M3EButtonMotion? motion;

  /// haptic.
  final M3EHapticFeedback? haptic;

  /// borderRadius.
  final double? borderRadius;

  /// checkedRadius.
  final double? checkedRadius;

  /// uncheckedRadius.
  final double? uncheckedRadius;

  /// pressedRadius.
  final double? pressedRadius;

  /// hoveredRadius.
  final double? hoveredRadius;

  /// connectedInnerRadius.
  final double? connectedInnerRadius;

  /// Optional gradient fill (same precedence as [M3EButtonDecoration]).
  final WidgetStateProperty<Gradient?>? backgroundGradient;

  /// Optional gradient for text and icons.
  final WidgetStateProperty<Gradient?>? foregroundGradient;

  /// Optional gradient state layer (hover / focus / pressed).
  final WidgetStateProperty<Gradient?>? overlayGradient;

  /// Optional gradient outline. Solid [side] still supplies stroke width.
  final WidgetStateProperty<Gradient?>? outlineGradient;

  /// backgroundBuilder.
  final ButtonLayerBuilder? backgroundBuilder;

  /// foregroundBuilder.
  final ButtonLayerBuilder? foregroundBuilder;

  /// M3EToggleButtonDecoration.
  const M3EToggleButtonDecoration({
    this.backgroundColor,
    this.foregroundColor,
    this.side,
    this.mouseCursor,
    this.overlayColor,
    this.surfaceTintColor,
    this.motion,
    this.haptic,
    this.borderRadius,
    this.checkedRadius,
    this.uncheckedRadius,
    this.pressedRadius,
    this.hoveredRadius,
    this.connectedInnerRadius,
    this.backgroundGradient,
    this.foregroundGradient,
    this.overlayGradient,
    this.outlineGradient,
    this.backgroundBuilder,
    this.foregroundBuilder,
  });

  /// styleFrom.
  static M3EToggleButtonDecoration styleFrom({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? checkedBackgroundColor,
    Color? checkedForegroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    BorderSide? side,
    M3EButtonMotion? motion,
    M3EHapticFeedback? haptic,
    double? borderRadius,
    double? checkedRadius,
    double? uncheckedRadius,
    double? pressedRadius,
    double? hoveredRadius,
    double? connectedInnerRadius,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    Color? overlayColor,
    Color? surfaceTintColor,
    WidgetStateProperty<Gradient?>? backgroundGradient,
    WidgetStateProperty<Gradient?>? foregroundGradient,
    WidgetStateProperty<Gradient?>? overlayGradient,
    WidgetStateProperty<Gradient?>? outlineGradient,
    ButtonLayerBuilder? backgroundBuilder,
    ButtonLayerBuilder? foregroundBuilder,
  }) {
    final WidgetStateProperty<Color?>? backgroundColorProp =
        (backgroundColor == null &&
            disabledBackgroundColor == null &&
            checkedBackgroundColor == null)
        ? null
        : _ToggleStyleFromColorProperty(
            backgroundColor,
            disabledBackgroundColor,
            checkedBackgroundColor,
          );

    final WidgetStateProperty<Color?>? foregroundColorProp =
        (foregroundColor == null &&
            disabledForegroundColor == null &&
            checkedForegroundColor == null)
        ? null
        : _ToggleStyleFromColorProperty(
            foregroundColor,
            disabledForegroundColor,
            checkedForegroundColor,
          );

    final WidgetStateProperty<BorderSide?>? sideProp = side == null
        ? null
        : WidgetStatePropertyAll<BorderSide?>(side);
    final WidgetStateProperty<Color?>? overlayColorProp = overlayColor == null
        ? null
        : WidgetStatePropertyAll<Color?>(overlayColor);
    final WidgetStateProperty<Color?>? surfaceTintColorProp =
        surfaceTintColor == null
        ? null
        : WidgetStatePropertyAll<Color?>(surfaceTintColor);

    final WidgetStateProperty<MouseCursor?>? mouseCursorProp =
        (enabledMouseCursor == null && disabledMouseCursor == null)
        ? null
        : _StyleFromCursorProperty(enabledMouseCursor, disabledMouseCursor);

    return M3EToggleButtonDecoration(
      backgroundColor: backgroundColorProp,
      foregroundColor: foregroundColorProp,
      side: sideProp,
      motion: motion,
      haptic: haptic,
      borderRadius: borderRadius,
      checkedRadius: checkedRadius,
      uncheckedRadius: uncheckedRadius,
      pressedRadius: pressedRadius,
      hoveredRadius: hoveredRadius,
      connectedInnerRadius: connectedInnerRadius,
      mouseCursor: mouseCursorProp,
      overlayColor: overlayColorProp,
      surfaceTintColor: surfaceTintColorProp,
      backgroundGradient: backgroundGradient,
      foregroundGradient: foregroundGradient,
      overlayGradient: overlayGradient,
      outlineGradient: outlineGradient,
      backgroundBuilder: backgroundBuilder,
      foregroundBuilder: foregroundBuilder,
    );
  }

  /// copyWith.
  M3EToggleButtonDecoration copyWith({
    WidgetStateProperty<Color?>? backgroundColor,
    WidgetStateProperty<Color?>? foregroundColor,
    WidgetStateProperty<BorderSide?>? side,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    WidgetStateProperty<Color?>? overlayColor,
    WidgetStateProperty<Color?>? surfaceTintColor,
    M3EButtonMotion? motion,
    M3EHapticFeedback? haptic,
    double? borderRadius,
    double? checkedRadius,
    double? uncheckedRadius,
    double? pressedRadius,
    double? hoveredRadius,
    double? connectedInnerRadius,
    WidgetStateProperty<Gradient?>? backgroundGradient,
    WidgetStateProperty<Gradient?>? foregroundGradient,
    WidgetStateProperty<Gradient?>? overlayGradient,
    WidgetStateProperty<Gradient?>? outlineGradient,
    ButtonLayerBuilder? backgroundBuilder,
    ButtonLayerBuilder? foregroundBuilder,
  }) {
    return M3EToggleButtonDecoration(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      side: side ?? this.side,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      overlayColor: overlayColor ?? this.overlayColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      motion: motion ?? this.motion,
      haptic: haptic ?? this.haptic,
      borderRadius: borderRadius ?? this.borderRadius,
      checkedRadius: checkedRadius ?? this.checkedRadius,
      uncheckedRadius: uncheckedRadius ?? this.uncheckedRadius,
      pressedRadius: pressedRadius ?? this.pressedRadius,
      hoveredRadius: hoveredRadius ?? this.hoveredRadius,
      connectedInnerRadius: connectedInnerRadius ?? this.connectedInnerRadius,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      foregroundGradient: foregroundGradient ?? this.foregroundGradient,
      overlayGradient: overlayGradient ?? this.overlayGradient,
      outlineGradient: outlineGradient ?? this.outlineGradient,
      backgroundBuilder: backgroundBuilder ?? this.backgroundBuilder,
      foregroundBuilder: foregroundBuilder ?? this.foregroundBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EToggleButtonDecoration &&
          backgroundColor == other.backgroundColor &&
          foregroundColor == other.foregroundColor &&
          side == other.side &&
          mouseCursor == other.mouseCursor &&
          overlayColor == other.overlayColor &&
          surfaceTintColor == other.surfaceTintColor &&
          motion == other.motion &&
          haptic == other.haptic &&
          borderRadius == other.borderRadius &&
          checkedRadius == other.checkedRadius &&
          uncheckedRadius == other.uncheckedRadius &&
          pressedRadius == other.pressedRadius &&
          hoveredRadius == other.hoveredRadius &&
          connectedInnerRadius == other.connectedInnerRadius &&
          backgroundGradient == other.backgroundGradient &&
          foregroundGradient == other.foregroundGradient &&
          overlayGradient == other.overlayGradient &&
          outlineGradient == other.outlineGradient &&
          backgroundBuilder == other.backgroundBuilder &&
          foregroundBuilder == other.foregroundBuilder;

  @override
  int get hashCode => Object.hashAll([
    backgroundColor,
    foregroundColor,
    side,
    mouseCursor,
    overlayColor,
    surfaceTintColor,
    motion,
    haptic,
    borderRadius,
    checkedRadius,
    uncheckedRadius,
    pressedRadius,
    hoveredRadius,
    connectedInnerRadius,
    backgroundGradient,
    foregroundGradient,
    overlayGradient,
    outlineGradient,
    backgroundBuilder,
    foregroundBuilder,
  ]);
}

@immutable
class _ToggleStyleFromColorProperty implements WidgetStateProperty<Color?> {
  const _ToggleStyleFromColorProperty(
    this.color,
    this.disabledColor,
    this.checkedColor,
  );
  final Color? color;
  final Color? disabledColor;
  final Color? checkedColor;

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return disabledColor;
    }
    if (states.contains(WidgetState.selected)) {
      return checkedColor ?? color;
    }
    return color;
  }
}
