import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'm3e_list_card_list_theme.dart';

/// Theme values for expandable list widgets.
///
/// Stack geometry ([defaultOuterRadius], [defaultInnerRadius], [defaultGap])
/// matches [M3EListCardListTheme].
@immutable
class M3EListExpandableTheme {
  /// defaultOuterRadius.
  static const double defaultOuterRadius =
      M3EListCardListTheme.defaultOuterRadius;

  /// defaultInnerRadius.
  static const double defaultInnerRadius =
      M3EListCardListTheme.defaultInnerRadius;

  /// defaultHoverRadius.
  static const double defaultHoverRadius = defaultOuterRadius;

  /// defaultPressedRadius.
  ///
  /// Press uses the 16dp outer radius on every corner.
  static const double defaultPressedRadius = defaultOuterRadius;

  /// defaultGap.
  static const double defaultGap = M3EListCardListTheme.defaultGap;

  /// defaultTitleSubtitleGap.
  static const double defaultTitleSubtitleGap = 4;

  /// defaultHeaderPadding.
  ///
  /// Matches [M3EListCardListTheme.defaultItemPadding] so expandable headers
  /// align with card / dismissible list rows.
  static const EdgeInsets defaultHeaderPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );

  /// defaultBodyPadding.
  static const EdgeInsets defaultBodyPadding = EdgeInsets.fromLTRB(
    16,
    0,
    16,
    20,
  );

  /// defaultIconPadding.
  static const EdgeInsets defaultIconPadding = EdgeInsets.all(8);

  /// Side length of the square behind the trailing expand icon.
  ///
  /// The box stays this size when collapsed or expanded; only the fill is
  /// shown while expanded. Set to `0` to disable the chrome entirely.
  static const double defaultExpandedIconBackgroundSize = 32;

  /// defaultIconRotationAngle.
  static const double defaultIconRotationAngle = math.pi;

  /// defaultExpandTooltip.
  static const String defaultExpandTooltip = 'Expand';

  /// defaultCollapseTooltip.
  static const String defaultCollapseTooltip = 'Collapse';

  /// M3EListExpandableTheme.

  const M3EListExpandableTheme({
    this.outerRadius = defaultOuterRadius,
    this.innerRadius = defaultInnerRadius,
    this.hoverRadius = defaultHoverRadius,
    this.pressedRadius = defaultPressedRadius,
    this.gap = defaultGap,
    this.titleSubtitleGap = defaultTitleSubtitleGap,
    this.headerPadding = defaultHeaderPadding,
    this.bodyPadding = defaultBodyPadding,
    this.iconPadding = defaultIconPadding,
    this.expandedIconBackgroundSize = defaultExpandedIconBackgroundSize,
    this.expandedIconBackground,
    this.iconRotationAngle = defaultIconRotationAngle,
    this.expandTooltip = defaultExpandTooltip,
    this.collapseTooltip = defaultCollapseTooltip,
    this.expandMotion = M3EMotion.expressiveSpatialDefault,
    this.collapseMotion = M3EMotion.expressiveSpatialDefault,
    this.allowMultipleExpanded = false,
  });

  /// defaults.

  static const M3EListExpandableTheme defaults = M3EListExpandableTheme();

  /// outerRadius.

  final double outerRadius;

  /// innerRadius.
  final double innerRadius;

  /// hoverRadius.
  final double hoverRadius;

  /// pressedRadius.
  final double pressedRadius;

  /// gap.
  final double gap;

  /// titleSubtitleGap.
  final double titleSubtitleGap;

  /// headerPadding.
  final EdgeInsetsGeometry headerPadding;

  /// bodyPadding.
  final EdgeInsetsGeometry bodyPadding;

  /// iconPadding.
  final EdgeInsetsGeometry iconPadding;

  /// Side length of the square behind the trailing expand icon.
  ///
  /// Size is stable across expand and collapse; only the fill toggles.
  /// Set to `0` to disable.
  final double expandedIconBackgroundSize;

  /// Fill for the expanded trailing-icon chrome.
  ///
  /// When null, resolves to [M3EColorScheme.surfaceContainer].
  final Color? expandedIconBackground;

  /// iconRotationAngle.
  final double iconRotationAngle;

  /// expandTooltip.
  final String expandTooltip;

  /// collapseTooltip.
  final String collapseTooltip;

  /// expandMotion.
  final M3ESpring expandMotion;

  /// collapseMotion.
  final M3ESpring collapseMotion;

  /// allowMultipleExpanded.
  final bool allowMultipleExpanded;

  /// backgroundColor.

  Color backgroundColor(M3EColorScheme scheme) => scheme.surface;

  /// Expanded trailing-icon chrome color.
  Color resolvedExpandedIconBackground(M3EColorScheme scheme) =>
      expandedIconBackground ?? scheme.surfaceContainer;

  /// copyWith.

  M3EListExpandableTheme copyWith({
    double? outerRadius,
    double? innerRadius,
    double? hoverRadius,
    double? pressedRadius,
    double? gap,
    double? titleSubtitleGap,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? bodyPadding,
    EdgeInsetsGeometry? iconPadding,
    double? expandedIconBackgroundSize,
    Color? expandedIconBackground,
    double? iconRotationAngle,
    String? expandTooltip,
    String? collapseTooltip,
    M3ESpring? expandMotion,
    M3ESpring? collapseMotion,
    bool? allowMultipleExpanded,
  }) {
    return M3EListExpandableTheme(
      outerRadius: outerRadius ?? this.outerRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      hoverRadius: hoverRadius ?? this.hoverRadius,
      pressedRadius: pressedRadius ?? this.pressedRadius,
      gap: gap ?? this.gap,
      titleSubtitleGap: titleSubtitleGap ?? this.titleSubtitleGap,
      headerPadding: headerPadding ?? this.headerPadding,
      bodyPadding: bodyPadding ?? this.bodyPadding,
      iconPadding: iconPadding ?? this.iconPadding,
      expandedIconBackgroundSize:
          expandedIconBackgroundSize ?? this.expandedIconBackgroundSize,
      expandedIconBackground:
          expandedIconBackground ?? this.expandedIconBackground,
      iconRotationAngle: iconRotationAngle ?? this.iconRotationAngle,
      expandTooltip: expandTooltip ?? this.expandTooltip,
      collapseTooltip: collapseTooltip ?? this.collapseTooltip,
      expandMotion: expandMotion ?? this.expandMotion,
      collapseMotion: collapseMotion ?? this.collapseMotion,
      allowMultipleExpanded:
          allowMultipleExpanded ?? this.allowMultipleExpanded,
    );
  }
}
