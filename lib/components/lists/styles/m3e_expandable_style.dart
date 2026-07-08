import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../../buttons/enums/m3e_button_enums.dart';
import '../enums/m3e_expandable_enums.dart';
import 'm3e_list_theme.dart';

/// Visual style configuration for [M3EExpandableList].
@immutable
class M3EExpandableStyle {
  // ── Shape ──

  /// Outer radius for the first and last item (and single items).
  final double outerRadius;

  /// Inner radius for middle items.
  final double innerRadius;

  /// Inner radius applied when the card is hovered.
  final double hoverRadius;

  /// Inner radius applied when the card is pressed.
  final double pressedRadius;

  /// Gap between cards.
  final double gap;

  /// Border radius applied uniformly to the entire card when expanded.
  final double? expandedRadius;

  // ── Appearance ──

  /// Background colour for each card.
  final Color? color;

  /// Border drawn around each card.
  final BorderSide? border;

  /// Elevation of the card.
  final double elevation;

  // ── Padding ──

  /// Padding applied inside each header.
  final EdgeInsetsGeometry? headerPadding;

  /// Padding applied inside each body.
  final EdgeInsetsGeometry? bodyPadding;

  /// Gap between simple-mode title and subtitle/body text.
  final double titleSubtitleGap;

  /// Outer margin around each card.
  final EdgeInsetsGeometry? margin;

  // ── Trailing icon ──

  /// Expand icon padding.
  final EdgeInsetsGeometry iconPadding;

  /// Icon rotation angle in clockwise radians.
  final double iconRotationAngle;

  /// The icon in the collapsed state. Set to null to hide the default icon.
  final Widget? expandIcon;

  /// The icon in the expanded state. Set to null to hide the default icon.
  final Widget? collapseIcon;

  /// Expand icon placement.
  final M3EExpandableIconPlacement iconPlacement;

  // ── Interaction ──

  /// Whether [InkWell] will be used in the header for a ripple effect.
  final bool useInkWell;

  /// If true, the header can be clicked by the user to expand or collapse.
  final bool tapHeaderToToggle;

  /// If true, the body can be clicked by the user to expand.
  final bool tapBodyToExpand;

  /// If true, the body can be clicked by the user to collapse.
  final bool tapBodyToCollapse;

  // ── Layout ──

  /// The alignment of the header relative to the expand icon.
  final CrossAxisAlignment headerAlignment;

  /// The alignment of the body content.
  final AlignmentGeometry bodyAlignment;

  // ── Haptics & Feedback ──

  /// Haptic feedback level on tap.
  final M3EHapticFeedback haptic;

  /// Ink splash colour.
  final Color? splashColor;

  /// Ink highlight colour.
  final Color? highlightColor;

  /// Splash factory.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether detected gestures should provide acoustic / haptic feedback.
  final bool enableFeedback;

  /// If true, toggling expansion/collapse is only possible by tapping the icon.
  final bool tapIconToToggle;

  /// The tooltip message displayed when hovering over or long-pressing the expand icon.
  final String? expandTooltip;

  /// The tooltip message displayed when hovering over or long-pressing the collapse icon.
  final String? collapseTooltip;

  const M3EExpandableStyle({
    this.outerRadius = M3EListExpandableTheme.defaultOuterRadius,
    this.innerRadius = M3EListExpandableTheme.defaultInnerRadius,
    this.hoverRadius = M3EListExpandableTheme.defaultHoverRadius,
    this.pressedRadius = M3EListExpandableTheme.defaultPressedRadius,
    this.gap = M3EListExpandableTheme.defaultGap,
    this.expandedRadius,
    this.color,
    this.border,
    this.elevation = 0,
    this.headerPadding,
    this.bodyPadding,
    this.titleSubtitleGap = M3EListExpandableTheme.defaultTitleSubtitleGap,
    this.margin,
    this.iconPadding = M3EListExpandableTheme.defaultIconPadding,
    this.iconRotationAngle = M3EListExpandableTheme.defaultIconRotationAngle,
    this.expandIcon = const Icon(M3EIcons.expand_more_rounded),
    this.collapseIcon = const Icon(M3EIcons.expand_more_rounded),
    this.iconPlacement = M3EExpandableIconPlacement.right,
    this.useInkWell = true,
    this.tapHeaderToToggle = true,
    this.tapBodyToExpand = false,
    this.tapBodyToCollapse = false,
    this.headerAlignment = CrossAxisAlignment.start,
    this.bodyAlignment = Alignment.topLeft,
    this.haptic = M3EHapticFeedback.none,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.tapIconToToggle = false,
    this.expandTooltip = M3EListExpandableTheme.defaultExpandTooltip,
    this.collapseTooltip = M3EListExpandableTheme.defaultCollapseTooltip,
  });

  /// Builds a style from the given [M3EListExpandableTheme].
  factory M3EExpandableStyle.fromTheme(M3EListExpandableTheme theme) {
    return M3EExpandableStyle(
      outerRadius: theme.outerRadius,
      innerRadius: theme.innerRadius,
      hoverRadius: theme.hoverRadius,
      pressedRadius: theme.pressedRadius,
      gap: theme.gap,
      titleSubtitleGap: theme.titleSubtitleGap,
      iconPadding: theme.iconPadding,
      iconRotationAngle: theme.iconRotationAngle,
      expandTooltip: theme.expandTooltip,
      collapseTooltip: theme.collapseTooltip,
    );
  }

  /// Creates a copy of this decoration with the given fields replaced.
  M3EExpandableStyle copyWith({
    double? outerRadius,
    double? innerRadius,
    double? hoverRadius,
    double? pressedRadius,
    double? gap,
    double? expandedRadius,
    Color? color,
    BorderSide? border,
    double? elevation,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? bodyPadding,
    double? titleSubtitleGap,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? iconPadding,
    double? iconRotationAngle,
    Widget? expandIcon,
    Widget? collapseIcon,
    M3EExpandableIconPlacement? iconPlacement,
    bool? useInkWell,
    bool? tapHeaderToToggle,
    bool? tapBodyToExpand,
    bool? tapBodyToCollapse,
    CrossAxisAlignment? headerAlignment,
    AlignmentGeometry? bodyAlignment,
    M3EHapticFeedback? haptic,
    Color? splashColor,
    Color? highlightColor,
    InteractiveInkFeatureFactory? splashFactory,
    bool? enableFeedback,
    bool? tapIconToToggle,
    String? expandTooltip,
    String? collapseTooltip,
  }) {
    return M3EExpandableStyle(
      outerRadius: outerRadius ?? this.outerRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      hoverRadius: hoverRadius ?? this.hoverRadius,
      pressedRadius: pressedRadius ?? this.pressedRadius,
      gap: gap ?? this.gap,
      expandedRadius: expandedRadius ?? this.expandedRadius,
      color: color ?? this.color,
      border: border ?? this.border,
      elevation: elevation ?? this.elevation,
      headerPadding: headerPadding ?? this.headerPadding,
      bodyPadding: bodyPadding ?? this.bodyPadding,
      titleSubtitleGap: titleSubtitleGap ?? this.titleSubtitleGap,
      margin: margin ?? this.margin,
      iconPadding: iconPadding ?? this.iconPadding,
      iconRotationAngle: iconRotationAngle ?? this.iconRotationAngle,
      expandIcon: expandIcon ?? this.expandIcon,
      collapseIcon: collapseIcon ?? this.collapseIcon,
      iconPlacement: iconPlacement ?? this.iconPlacement,
      useInkWell: useInkWell ?? this.useInkWell,
      tapHeaderToToggle: tapHeaderToToggle ?? this.tapHeaderToToggle,
      tapBodyToExpand: tapBodyToExpand ?? this.tapBodyToExpand,
      tapBodyToCollapse: tapBodyToCollapse ?? this.tapBodyToCollapse,
      headerAlignment: headerAlignment ?? this.headerAlignment,
      bodyAlignment: bodyAlignment ?? this.bodyAlignment,
      haptic: haptic ?? this.haptic,
      splashColor: splashColor ?? this.splashColor,
      highlightColor: highlightColor ?? this.highlightColor,
      splashFactory: splashFactory ?? this.splashFactory,
      enableFeedback: enableFeedback ?? this.enableFeedback,
      tapIconToToggle: tapIconToToggle ?? this.tapIconToToggle,
      expandTooltip: expandTooltip ?? this.expandTooltip,
      collapseTooltip: collapseTooltip ?? this.collapseTooltip,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is M3EExpandableStyle &&
          outerRadius == other.outerRadius &&
          innerRadius == other.innerRadius &&
          hoverRadius == other.hoverRadius &&
          pressedRadius == other.pressedRadius &&
          gap == other.gap &&
          expandedRadius == other.expandedRadius &&
          color == other.color &&
          border == other.border &&
          elevation == other.elevation &&
          headerPadding == other.headerPadding &&
          bodyPadding == other.bodyPadding &&
          titleSubtitleGap == other.titleSubtitleGap &&
          margin == other.margin &&
          iconPadding == other.iconPadding &&
          iconRotationAngle == other.iconRotationAngle &&
          expandIcon == other.expandIcon &&
          collapseIcon == other.collapseIcon &&
          iconPlacement == other.iconPlacement &&
          useInkWell == other.useInkWell &&
          tapHeaderToToggle == other.tapHeaderToToggle &&
          tapBodyToExpand == other.tapBodyToExpand &&
          tapBodyToCollapse == other.tapBodyToCollapse &&
          headerAlignment == other.headerAlignment &&
          bodyAlignment == other.bodyAlignment &&
          haptic == other.haptic &&
          splashColor == other.splashColor &&
          highlightColor == other.highlightColor &&
          splashFactory == other.splashFactory &&
          enableFeedback == other.enableFeedback &&
          tapIconToToggle == other.tapIconToToggle &&
          expandTooltip == other.expandTooltip &&
          collapseTooltip == other.collapseTooltip;

  @override
  int get hashCode => Object.hashAll([
        outerRadius,
        innerRadius,
        hoverRadius,
        pressedRadius,
        gap,
        expandedRadius,
        color,
        border,
        elevation,
        headerPadding,
        bodyPadding,
        titleSubtitleGap,
        margin,
        iconPadding,
        iconRotationAngle,
        expandIcon,
        collapseIcon,
        iconPlacement,
        useInkWell,
        tapHeaderToToggle,
        tapBodyToExpand,
        tapBodyToCollapse,
        headerAlignment,
        bodyAlignment,
        haptic,
        splashColor,
        highlightColor,
        splashFactory,
        enableFeedback,
        tapIconToToggle,
        expandTooltip,
        collapseTooltip,
      ]);
}
