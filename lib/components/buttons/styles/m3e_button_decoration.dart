// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';

import '../enums/m3e_button_enums.dart';
import 'm3e_button_motion.dart';

/// Styling overrides for [M3EButton].
@immutable
class M3EButtonDecoration {
  final WidgetStateProperty<Color?>? backgroundColor;
  final WidgetStateProperty<Color?>? foregroundColor;
  final WidgetStateProperty<Color?>? shadowColor;
  final WidgetStateProperty<double?>? elevation;
  final WidgetStateProperty<BorderSide?>? side;
  final WidgetStateProperty<MouseCursor?>? mouseCursor;
  final WidgetStateProperty<Color?>? overlayColor;
  final WidgetStateProperty<Color?>? surfaceTintColor;
  final double? iconSize;
  final IconAlignment? iconAlignment;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Size? minimumSize;
  final Size? fixedSize;
  final Size? maximumSize;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? tapTargetSize;
  final Duration? animationDuration;
  final bool? enableFeedback;
  final AlignmentGeometry? alignment;
  final InteractiveInkFeatureFactory? splashFactory;
  final ButtonLayerBuilder? backgroundBuilder;
  final ButtonLayerBuilder? foregroundBuilder;
  final M3EButtonMotion? motion;
  final M3EHapticFeedback? haptic;
  final double? borderRadius;
  final double? hoveredRadius;
  final double? pressedRadius;

  const M3EButtonDecoration({
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.elevation,
    this.side,
    this.mouseCursor,
    this.overlayColor,
    this.surfaceTintColor,
    this.iconSize,
    this.iconAlignment,
    this.textStyle,
    this.padding,
    this.minimumSize,
    this.fixedSize,
    this.maximumSize,
    this.visualDensity,
    this.tapTargetSize,
    this.animationDuration,
    this.enableFeedback,
    this.alignment,
    this.splashFactory,
    this.backgroundBuilder,
    this.foregroundBuilder,
    this.motion,
    this.haptic,
    this.borderRadius,
    this.hoveredRadius,
    this.pressedRadius,
  });

  static M3EButtonDecoration styleFrom({
    Color? foregroundColor,
    Color? backgroundColor,
    Color? disabledForegroundColor,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    Color? surfaceTintColor,
    Color? overlayColor,
    double? iconSize,
    IconAlignment? iconAlignment,
    double? elevation,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    BorderSide? side,
    MouseCursor? enabledMouseCursor,
    MouseCursor? disabledMouseCursor,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
    ButtonLayerBuilder? backgroundBuilder,
    ButtonLayerBuilder? foregroundBuilder,
    M3EButtonMotion? motion,
    M3EHapticFeedback? haptic,
    double? borderRadius,
    double? hoveredRadius,
    double? pressedRadius,
  }) {
    final WidgetStateProperty<Color?>? backgroundColorProp =
        (backgroundColor == null && disabledBackgroundColor == null)
            ? null
            : _StyleFromColorProperty(backgroundColor, disabledBackgroundColor);

    final WidgetStateProperty<Color?>? foregroundColorProp =
        (foregroundColor == null && disabledForegroundColor == null)
            ? null
            : _StyleFromColorProperty(foregroundColor, disabledForegroundColor);

    final WidgetStateProperty<Color?>? shadowColorProp =
        shadowColor == null ? null : WidgetStatePropertyAll<Color?>(shadowColor);
    final WidgetStateProperty<Color?>? surfaceTintColorProp =
        surfaceTintColor == null
            ? null
            : WidgetStatePropertyAll<Color?>(surfaceTintColor);
    final WidgetStateProperty<Color?>? overlayColorProp =
        overlayColor == null ? null : WidgetStatePropertyAll<Color?>(overlayColor);
    final WidgetStateProperty<double?>? elevationProp =
        elevation == null ? null : WidgetStatePropertyAll<double?>(elevation);
    final WidgetStateProperty<BorderSide?>? sideProp =
        side == null ? null : WidgetStatePropertyAll<BorderSide?>(side);

    final WidgetStateProperty<MouseCursor?>? mouseCursorProp =
        (enabledMouseCursor == null && disabledMouseCursor == null)
            ? null
            : _StyleFromCursorProperty(enabledMouseCursor, disabledMouseCursor);

    return M3EButtonDecoration(
      backgroundColor: backgroundColorProp,
      foregroundColor: foregroundColorProp,
      shadowColor: shadowColorProp,
      surfaceTintColor: surfaceTintColorProp,
      overlayColor: overlayColorProp,
      elevation: elevationProp,
      side: sideProp,
      mouseCursor: mouseCursorProp,
      iconSize: iconSize,
      iconAlignment: iconAlignment,
      textStyle: textStyle,
      padding: padding,
      minimumSize: minimumSize,
      fixedSize: fixedSize,
      maximumSize: maximumSize,
      visualDensity: visualDensity,
      tapTargetSize: tapTargetSize,
      animationDuration: animationDuration,
      enableFeedback: enableFeedback,
      alignment: alignment,
      splashFactory: splashFactory,
      backgroundBuilder: backgroundBuilder,
      foregroundBuilder: foregroundBuilder,
      motion: motion,
      haptic: haptic,
      borderRadius: borderRadius,
      hoveredRadius: hoveredRadius,
      pressedRadius: pressedRadius,
    );
  }

  M3EButtonDecoration copyWith({
    WidgetStateProperty<Color?>? backgroundColor,
    WidgetStateProperty<Color?>? foregroundColor,
    WidgetStateProperty<Color?>? shadowColor,
    WidgetStateProperty<double?>? elevation,
    WidgetStateProperty<BorderSide?>? side,
    WidgetStateProperty<MouseCursor?>? mouseCursor,
    WidgetStateProperty<Color?>? overlayColor,
    WidgetStateProperty<Color?>? surfaceTintColor,
    double? iconSize,
    IconAlignment? iconAlignment,
    TextStyle? textStyle,
    EdgeInsetsGeometry? padding,
    Size? minimumSize,
    Size? fixedSize,
    Size? maximumSize,
    VisualDensity? visualDensity,
    MaterialTapTargetSize? tapTargetSize,
    Duration? animationDuration,
    bool? enableFeedback,
    AlignmentGeometry? alignment,
    InteractiveInkFeatureFactory? splashFactory,
    ButtonLayerBuilder? backgroundBuilder,
    ButtonLayerBuilder? foregroundBuilder,
    M3EButtonMotion? motion,
    M3EHapticFeedback? haptic,
    double? borderRadius,
    double? hoveredRadius,
    double? pressedRadius,
  }) {
    return M3EButtonDecoration(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
      side: side ?? this.side,
      mouseCursor: mouseCursor ?? this.mouseCursor,
      overlayColor: overlayColor ?? this.overlayColor,
      surfaceTintColor: surfaceTintColor ?? this.surfaceTintColor,
      iconSize: iconSize ?? this.iconSize,
      iconAlignment: iconAlignment ?? this.iconAlignment,
      textStyle: textStyle ?? this.textStyle,
      padding: padding ?? this.padding,
      minimumSize: minimumSize ?? this.minimumSize,
      fixedSize: fixedSize ?? this.fixedSize,
      maximumSize: maximumSize ?? this.maximumSize,
      visualDensity: visualDensity ?? this.visualDensity,
      tapTargetSize: tapTargetSize ?? this.tapTargetSize,
      animationDuration: animationDuration ?? this.animationDuration,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      alignment: alignment ?? this.alignment,
      splashFactory: splashFactory ?? this.splashFactory,
      backgroundBuilder: backgroundBuilder ?? this.backgroundBuilder,
      foregroundBuilder: foregroundBuilder ?? this.foregroundBuilder,
      motion: motion ?? this.motion,
      haptic: haptic ?? this.haptic,
      borderRadius: borderRadius ?? this.borderRadius,
      hoveredRadius: hoveredRadius ?? this.hoveredRadius,
      pressedRadius: pressedRadius ?? this.pressedRadius,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EButtonDecoration &&
          backgroundColor == other.backgroundColor &&
          foregroundColor == other.foregroundColor &&
          shadowColor == other.shadowColor &&
          elevation == other.elevation &&
          side == other.side &&
          mouseCursor == other.mouseCursor &&
          overlayColor == other.overlayColor &&
          surfaceTintColor == other.surfaceTintColor &&
          iconSize == other.iconSize &&
          iconAlignment == other.iconAlignment &&
          textStyle == other.textStyle &&
          padding == other.padding &&
          minimumSize == other.minimumSize &&
          fixedSize == other.fixedSize &&
          maximumSize == other.maximumSize &&
          visualDensity == other.visualDensity &&
          tapTargetSize == other.tapTargetSize &&
          animationDuration == other.animationDuration &&
          enableFeedback == other.enableFeedback &&
          alignment == other.alignment &&
          splashFactory == other.splashFactory &&
          backgroundBuilder == other.backgroundBuilder &&
          foregroundBuilder == other.foregroundBuilder &&
          motion == other.motion &&
          haptic == other.haptic &&
          borderRadius == other.borderRadius &&
          hoveredRadius == other.hoveredRadius &&
          pressedRadius == other.pressedRadius;

  @override
  int get hashCode => Object.hashAll([
        backgroundColor,
        foregroundColor,
        shadowColor,
        elevation,
        side,
        mouseCursor,
        overlayColor,
        surfaceTintColor,
        iconSize,
        iconAlignment,
        textStyle,
        padding,
        minimumSize,
        fixedSize,
        maximumSize,
        visualDensity,
        tapTargetSize,
        animationDuration,
        enableFeedback,
        alignment,
        splashFactory,
        backgroundBuilder,
        foregroundBuilder,
        motion,
        haptic,
        borderRadius,
        hoveredRadius,
        pressedRadius,
      ]);
}

/// Styling overrides for [M3EToggleButton] and [M3EButtonGroup].
@immutable
class M3EToggleButtonDecoration {
  final WidgetStateProperty<Color?>? backgroundColor;
  final WidgetStateProperty<Color?>? foregroundColor;
  final WidgetStateProperty<BorderSide?>? side;
  final WidgetStateProperty<MouseCursor?>? mouseCursor;
  final WidgetStateProperty<Color?>? overlayColor;
  final WidgetStateProperty<Color?>? surfaceTintColor;
  final M3EButtonMotion? motion;
  final M3EHapticFeedback? haptic;
  final double? borderRadius;
  final double? checkedRadius;
  final double? uncheckedRadius;
  final double? pressedRadius;
  final double? hoveredRadius;
  final double? connectedInnerRadius;

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
  });

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

    final WidgetStateProperty<BorderSide?>? sideProp =
        side == null ? null : WidgetStatePropertyAll<BorderSide?>(side);
    final WidgetStateProperty<Color?>? overlayColorProp =
        overlayColor == null ? null : WidgetStatePropertyAll<Color?>(overlayColor);
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
    );
  }

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
          connectedInnerRadius == other.connectedInnerRadius;

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
      ]);
}

@immutable
class _StyleFromColorProperty implements WidgetStateProperty<Color?> {
  const _StyleFromColorProperty(this.color, this.disabledColor);
  final Color? color;
  final Color? disabledColor;

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return disabledColor;
    }
    return color;
  }
}

@immutable
class _StyleFromCursorProperty implements WidgetStateProperty<MouseCursor?> {
  const _StyleFromCursorProperty(this.enabledCursor, this.disabledCursor);
  final MouseCursor? enabledCursor;
  final MouseCursor? disabledCursor;

  @override
  MouseCursor? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return disabledCursor;
    }
    return enabledCursor;
  }
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
