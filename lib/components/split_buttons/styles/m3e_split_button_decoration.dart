// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';

import '../../buttons/enums/m3e_button_enums.dart';
import '../../buttons/styles/m3e_button_decoration.dart';
import '../../buttons/styles/m3e_button_motion.dart';
import '../enums/m3e_split_button_menu_style.dart';
import 'm3e_split_button_bottom_sheet_decoration.dart';
import 'm3e_split_button_popup_decoration.dart';

@immutable
class M3ESplitButtonDecoration extends M3EButtonDecoration {
  final Color? trailingBackgroundColor;
  final Color? trailingForegroundColor;
  final Color? menuBackgroundColor;
  final Color? menuForegroundColor;
  final Color? dividerColor;
  final M3EButtonSize? leadingCustomSize;
  final M3EButtonSize? trailingCustomSize;
  final double? trailingSelectedRadius;
  final double? gap;
  final M3ESplitButtonMenuStyle menuStyle;
  final M3ESplitButtonPopupDecoration? popupDecoration;
  final M3ESplitButtonBottomSheetDecoration? bottomSheetDecoration;

  const M3ESplitButtonDecoration({
    super.backgroundColor,
    super.foregroundColor,
    super.shadowColor,
    super.elevation,
    super.side,
    super.mouseCursor,
    super.overlayColor,
    super.surfaceTintColor,
    super.iconSize,
    super.iconAlignment,
    super.textStyle,
    super.padding,
    super.minimumSize,
    super.fixedSize,
    super.maximumSize,
    super.visualDensity,
    super.tapTargetSize,
    super.animationDuration,
    super.enableFeedback,
    super.alignment,
    super.splashFactory,
    super.backgroundBuilder,
    super.foregroundBuilder,
    super.motion,
    super.haptic,
    super.borderRadius,
    super.hoveredRadius,
    super.pressedRadius,
    this.trailingBackgroundColor,
    this.trailingForegroundColor,
    this.menuBackgroundColor,
    this.menuForegroundColor,
    this.dividerColor,
    this.leadingCustomSize,
    this.trailingCustomSize,
    this.trailingSelectedRadius,
    this.gap,
    this.menuStyle = M3ESplitButtonMenuStyle.popup,
    this.popupDecoration,
    this.bottomSheetDecoration,
  });

  static M3ESplitButtonDecoration styleFrom({
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
    Color? trailingBackgroundColor,
    Color? trailingForegroundColor,
    Color? menuBackgroundColor,
    Color? menuForegroundColor,
    Color? dividerColor,
    M3EButtonSize? leadingCustomSize,
    M3EButtonSize? trailingCustomSize,
    double? trailingSelectedRadius,
    double? gap,
    M3ESplitButtonMenuStyle menuStyle = M3ESplitButtonMenuStyle.popup,
    M3ESplitButtonPopupDecoration? popupDecoration,
    M3ESplitButtonBottomSheetDecoration? bottomSheetDecoration,
  }) {
    final base = M3EButtonDecoration.styleFrom(
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      overlayColor: overlayColor,
      iconSize: iconSize,
      iconAlignment: iconAlignment,
      elevation: elevation,
      textStyle: textStyle,
      padding: padding,
      minimumSize: minimumSize,
      fixedSize: fixedSize,
      maximumSize: maximumSize,
      side: side,
      enabledMouseCursor: enabledMouseCursor,
      disabledMouseCursor: disabledMouseCursor,
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

    return M3ESplitButtonDecoration(
      backgroundColor: base.backgroundColor,
      foregroundColor: base.foregroundColor,
      shadowColor: base.shadowColor,
      elevation: base.elevation,
      side: base.side,
      mouseCursor: base.mouseCursor,
      overlayColor: base.overlayColor,
      surfaceTintColor: base.surfaceTintColor,
      iconSize: base.iconSize,
      iconAlignment: base.iconAlignment,
      textStyle: base.textStyle,
      padding: base.padding,
      minimumSize: base.minimumSize,
      fixedSize: base.fixedSize,
      maximumSize: base.maximumSize,
      visualDensity: base.visualDensity,
      tapTargetSize: base.tapTargetSize,
      animationDuration: base.animationDuration,
      enableFeedback: base.enableFeedback,
      alignment: base.alignment,
      splashFactory: base.splashFactory,
      backgroundBuilder: base.backgroundBuilder,
      foregroundBuilder: base.foregroundBuilder,
      motion: base.motion,
      haptic: base.haptic,
      hoveredRadius: base.hoveredRadius,
      pressedRadius: base.pressedRadius,
      trailingBackgroundColor: trailingBackgroundColor,
      trailingForegroundColor: trailingForegroundColor,
      menuBackgroundColor: menuBackgroundColor,
      menuForegroundColor: menuForegroundColor,
      dividerColor: dividerColor,
      leadingCustomSize: leadingCustomSize,
      trailingCustomSize: trailingCustomSize,
      trailingSelectedRadius: trailingSelectedRadius,
      gap: gap,
      menuStyle: menuStyle,
      popupDecoration: popupDecoration,
      bottomSheetDecoration: bottomSheetDecoration,
    );
  }

  @override
  M3ESplitButtonDecoration copyWith({
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
    Color? trailingBackgroundColor,
    Color? trailingForegroundColor,
    Color? menuBackgroundColor,
    Color? menuForegroundColor,
    Color? dividerColor,
    M3EButtonSize? leadingCustomSize,
    M3EButtonSize? trailingCustomSize,
    double? trailingSelectedRadius,
    double? gap,
    M3ESplitButtonMenuStyle? menuStyle,
    M3ESplitButtonPopupDecoration? popupDecoration,
    M3ESplitButtonBottomSheetDecoration? bottomSheetDecoration,
  }) {
    return M3ESplitButtonDecoration(
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
      trailingBackgroundColor:
          trailingBackgroundColor ?? this.trailingBackgroundColor,
      trailingForegroundColor:
          trailingForegroundColor ?? this.trailingForegroundColor,
      menuBackgroundColor: menuBackgroundColor ?? this.menuBackgroundColor,
      menuForegroundColor: menuForegroundColor ?? this.menuForegroundColor,
      dividerColor: dividerColor ?? this.dividerColor,
      leadingCustomSize: leadingCustomSize ?? this.leadingCustomSize,
      trailingCustomSize: trailingCustomSize ?? this.trailingCustomSize,
      trailingSelectedRadius:
          trailingSelectedRadius ?? this.trailingSelectedRadius,
      gap: gap ?? this.gap,
      menuStyle: menuStyle ?? this.menuStyle,
      popupDecoration: popupDecoration ?? this.popupDecoration,
      bottomSheetDecoration:
          bottomSheetDecoration ?? this.bottomSheetDecoration,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3ESplitButtonDecoration &&
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
          pressedRadius == other.pressedRadius &&
          trailingBackgroundColor == other.trailingBackgroundColor &&
          trailingForegroundColor == other.trailingForegroundColor &&
          menuBackgroundColor == other.menuBackgroundColor &&
          menuForegroundColor == other.menuForegroundColor &&
          dividerColor == other.dividerColor &&
          leadingCustomSize == other.leadingCustomSize &&
          trailingCustomSize == other.trailingCustomSize &&
          trailingSelectedRadius == other.trailingSelectedRadius &&
          gap == other.gap &&
          menuStyle == other.menuStyle &&
          popupDecoration == other.popupDecoration &&
          bottomSheetDecoration == other.bottomSheetDecoration;

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
    trailingBackgroundColor,
    trailingForegroundColor,
    menuBackgroundColor,
    menuForegroundColor,
    dividerColor,
    leadingCustomSize,
    trailingCustomSize,
    trailingSelectedRadius,
    gap,
    menuStyle,
    popupDecoration,
    bottomSheetDecoration,
  ]);
}
