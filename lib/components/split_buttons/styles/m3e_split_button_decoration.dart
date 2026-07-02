// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';

import '../../buttons/styles/m3e_button_decoration.dart';
import '../../buttons/enums/m3e_button_enums.dart';
import '../../buttons/styles/m3e_button_motion.dart';

/// Menu presentation style used by [M3ESplitButtonDecoration.menuStyle].
enum SplitButtonMenuStyle {
  /// Spring-animated popup menu anchored to the trailing segment.
  popup,

  /// Modal bottom sheet menu.
  bottomSheet,

  /// Native Flutter popup menu.
  native,
}

/// Selection behavior for bottom-sheet split button menus.
enum SplitButtonSelectionMode {
  /// Single item can be selected at a time.
  single,

  /// Multiple items can be selected together.
  multiple,
}

/// Styling options for split-button popup menus.
@immutable
class M3ESplitButtonPopupDecoration {
  const M3ESplitButtonPopupDecoration({
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.offset = const Offset(0, 4),
    this.minWidth = 120,
    this.maxWidth = 280,
    this.maxHeight = 400,
    this.padding,
    this.motion = M3EButtonMotion.standardPopup,
    this.selectedColor,
    this.selectedBorderRadius,
  });

  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final Offset offset;
  final double minWidth;
  final double maxWidth;
  final double maxHeight;
  final EdgeInsetsGeometry? padding;
  final M3EButtonMotion motion;
  final Color? selectedColor;
  final BorderRadius? selectedBorderRadius;

  M3ESplitButtonPopupDecoration copyWith({
    Color? backgroundColor,
    double? elevation,
    BorderRadius? borderRadius,
    Border? border,
    Offset? offset,
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    EdgeInsetsGeometry? padding,
    M3EButtonMotion? motion,
    Color? selectedColor,
    BorderRadius? selectedBorderRadius,
  }) {
    return M3ESplitButtonPopupDecoration(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      offset: offset ?? this.offset,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      padding: padding ?? this.padding,
      motion: motion ?? this.motion,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedBorderRadius: selectedBorderRadius ?? this.selectedBorderRadius,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3ESplitButtonPopupDecoration &&
          backgroundColor == other.backgroundColor &&
          elevation == other.elevation &&
          borderRadius == other.borderRadius &&
          border == other.border &&
          offset == other.offset &&
          minWidth == other.minWidth &&
          maxWidth == other.maxWidth &&
          maxHeight == other.maxHeight &&
          padding == other.padding &&
          motion == other.motion &&
          selectedColor == other.selectedColor &&
          selectedBorderRadius == other.selectedBorderRadius;

  @override
  int get hashCode => Object.hash(
    backgroundColor,
    elevation,
    borderRadius,
    border,
    offset,
    minWidth,
    maxWidth,
    maxHeight,
    padding,
    motion,
    selectedColor,
    selectedBorderRadius,
  );
}

@immutable
class M3ESplitButtonBottomSheetDecoration {
  const M3ESplitButtonBottomSheetDecoration({
    this.title,
    this.titlePadding,
    this.showDragHandle = true,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.motion = M3EButtonMotion.expressiveSpatialDefault,
    this.selectionMode = SplitButtonSelectionMode.single,
    this.checkboxStyle,
  });

  final Widget? title;
  final EdgeInsetsGeometry? titlePadding;
  final bool showDragHandle;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final M3EButtonMotion motion;
  final SplitButtonSelectionMode selectionMode;
  final M3ESplitButtonCheckboxStyle? checkboxStyle;

  M3ESplitButtonBottomSheetDecoration copyWith({
    Widget? title,
    EdgeInsetsGeometry? titlePadding,
    bool? showDragHandle,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    M3EButtonMotion? motion,
    SplitButtonSelectionMode? selectionMode,
    M3ESplitButtonCheckboxStyle? checkboxStyle,
  }) {
    return M3ESplitButtonBottomSheetDecoration(
      title: title ?? this.title,
      titlePadding: titlePadding ?? this.titlePadding,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      shape: shape ?? this.shape,
      motion: motion ?? this.motion,
      selectionMode: selectionMode ?? this.selectionMode,
      checkboxStyle: checkboxStyle ?? this.checkboxStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3ESplitButtonBottomSheetDecoration &&
          title == other.title &&
          titlePadding == other.titlePadding &&
          showDragHandle == other.showDragHandle &&
          backgroundColor == other.backgroundColor &&
          elevation == other.elevation &&
          shape == other.shape &&
          motion == other.motion &&
          selectionMode == other.selectionMode &&
          checkboxStyle == other.checkboxStyle;

  @override
  int get hashCode => Object.hash(
    title,
    titlePadding,
    showDragHandle,
    backgroundColor,
    elevation,
    shape,
    motion,
    selectionMode,
    checkboxStyle,
  );
}

@immutable
class M3ESplitButtonCheckboxStyle {
  const M3ESplitButtonCheckboxStyle({
    this.activeColor,
    this.iconColor,
    this.nonActiveColor,
    this.borderColor,
    this.activeBorderRadius,
    this.nonActiveBorderRadius,
    this.icon = const Icon(Icons.check_rounded),
  });

  final Color? activeColor;
  final Color? iconColor;
  final Color? nonActiveColor;
  final Color? borderColor;
  final BorderRadius? activeBorderRadius;
  final BorderRadius? nonActiveBorderRadius;
  final Widget? icon;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3ESplitButtonCheckboxStyle &&
          activeColor == other.activeColor &&
          iconColor == other.iconColor &&
          nonActiveColor == other.nonActiveColor &&
          borderColor == other.borderColor &&
          activeBorderRadius == other.activeBorderRadius &&
          nonActiveBorderRadius == other.nonActiveBorderRadius &&
          icon == other.icon;

  @override
  int get hashCode => Object.hash(
    activeColor,
    iconColor,
    nonActiveColor,
    borderColor,
    activeBorderRadius,
    nonActiveBorderRadius,
    icon,
  );
}

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
  final SplitButtonMenuStyle menuStyle;
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
    this.menuStyle = SplitButtonMenuStyle.popup,
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
    SplitButtonMenuStyle menuStyle = SplitButtonMenuStyle.popup,
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
    SplitButtonMenuStyle? menuStyle,
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
