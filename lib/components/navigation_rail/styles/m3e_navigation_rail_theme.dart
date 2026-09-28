import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ENavigationRail`.
@immutable
class M3ENavigationRailTheme extends M3EThemeExtension<M3ENavigationRailTheme> {
  /// M3ENavigationRailTheme.
  const M3ENavigationRailTheme({
    this.collapsedWidth = 96,
    this.narrowCollapsedWidth = 80,
    this.collapsedHorizontalPadding = 20,
    this.narrowHorizontalPadding = 12,
    this.expandedMinWidth = 220,
    this.expandedMaxWidth = 360,
    this.itemExpandedHeight = 56,
    this.itemCollapsedHeight = 64,
    this.shortItemHeight = 56,
    this.iconSize = 24,
    this.indicatorLeading = 16,
    this.indicatorTrailing = 16,
    this.expandedItemInset = 24,
    this.iconLabelGap = 8,
    this.verticalIconLabelGap = 4,
    this.itemVerticalGap = 4,
    this.expandedItemGap = 0,
    this.itemVerticalPadding = 6,
    this.topSpace = 44,
    this.destinationTopPadding = 12,
    this.expandedTrailingSpace = 20,
    this.headerMinSpace = 40,
    this.sectionHeaderSpacingTop = 12,
    this.sectionHeaderSpacingBottom = 8,
    this.verticalIndicatorWidth = 56,
    this.verticalIndicatorHeight = 32,
    this.verticalIndicatorRadius = 16,
    this.expandedIndicatorHeight = 56,
    this.expandedIndicatorRadius = 28,
    this.noLabelIndicatorSize = 56,
    this.containerColor,
    this.modalContainerColor,
    this.scrolledContainerColor,
    this.activeIndicatorColor,
    this.activeIconAndLabel,
    this.activeLabelColor,
    this.inactiveIconAndLabel,
    this.menuColor,
    this.badgeBackground,
    this.badgeLargeLabel,
    this.stateLayerColor,
    this.focusRingColor,
    this.dividerColor,
    this.indicatorShapeFull,
    this.indicatorFillsWidth = false,
    this.elevation = M3EElevation.level0,
    this.scrolledElevation = M3EElevation.level1,
    this.modalScrimOpacity = 0.32,
    this.containerRadius = 0,
    this.modalContainerRadius = 0,
    this.dividerThickness = 1,
    this.hoverOpacity = 0.08,
    this.focusOpacity = 0.1,
    this.pressedOpacity = 0.1,
    this.focusRingThickness = 3,
    this.focusRingInset = 3,
    this.labelFontSize = 12,
    this.labelLineHeight = 16,
    this.labelLetterSpacing = 0.1,
    this.inactiveLabelWeight = FontWeight.w500,
    this.activeLabelWeight = FontWeight.w700,
    this.scaledLabelMaxLines = 2,
    this.truncationTextScale = 2,
    this.indicatorLeadSpring = const M3ESpring(stiffness: 380, damping: 0.45),
    this.indicatorTrailSpring = const M3ESpring(stiffness: 380, damping: 0.55),
    this.indicatorScaleSpring = M3EMotion.expressiveSpatialDefault,
    this.indicatorFadeSpring = M3EMotion.effectsFast,
    this.iconScaleSpring = const M3ESpring(stiffness: 380, damping: 0.5),
    this.widthSpring = M3EMotion.expressiveSpatialDefault,
  });

  /// defaults.
  static const M3ENavigationRailTheme defaults = M3ENavigationRailTheme();

  /// Collapsed rail width.
  final double collapsedWidth;

  /// Narrow collapsed width. Not selected automatically.
  final double narrowCollapsedWidth;

  /// Side inset that centers the collapsed pill in [collapsedWidth].
  final double collapsedHorizontalPadding;

  /// Side inset for [narrowCollapsedWidth].
  final double narrowHorizontalPadding;

  /// expandedMinWidth.
  final double expandedMinWidth;

  /// expandedMaxWidth.
  final double expandedMaxWidth;

  /// Expanded destination target height.
  final double itemExpandedHeight;

  /// Collapsed destination height when a label is shown.
  final double itemCollapsedHeight;

  /// Collapsed destination height without a label.
  final double shortItemHeight;

  /// iconSize.
  final double iconSize;

  /// Leading inset inside an expanded pill.
  final double indicatorLeading;

  /// Trailing inset inside an expanded pill.
  final double indicatorTrailing;

  /// Inset from the expanded rail edge to the destination pill and the FAB.
  final double expandedItemInset;

  /// Gap between an expanded icon and its label.
  final double iconLabelGap;

  /// Gap between a collapsed icon and its label.
  final double verticalIconLabelGap;

  /// Gap between collapsed destinations.
  final double itemVerticalGap;

  /// Gap between expanded destinations.
  final double expandedItemGap;

  /// Vertical padding inside a collapsed destination.
  final double itemVerticalPadding;

  /// Space from the top of the rail to the menu.
  final double topSpace;

  /// Inner top padding of the destination list when a menu, FAB, or leading
  /// control is present. Omitted when those controls are absent.
  final double destinationTopPadding;

  /// Space below the last expanded destination.
  final double expandedTrailingSpace;

  /// headerMinSpace.
  final double headerMinSpace;

  /// sectionHeaderSpacingTop.
  final double sectionHeaderSpacingTop;

  /// sectionHeaderSpacingBottom.
  final double sectionHeaderSpacingBottom;

  /// Collapsed pill width.
  final double verticalIndicatorWidth;

  /// Collapsed pill height.
  final double verticalIndicatorHeight;

  /// Collapsed pill corner radius.
  final double verticalIndicatorRadius;

  /// Expanded pill height.
  final double expandedIndicatorHeight;

  /// Expanded pill corner radius.
  final double expandedIndicatorRadius;

  /// Circular indicator size when the destination has no label.
  final double noLabelIndicatorSize;

  /// containerColor.
  final Color? containerColor;

  /// Modal rail container color.
  final Color? modalContainerColor;

  /// Container color while horizontal body content is scrolled.
  final Color? scrolledContainerColor;

  /// activeIndicatorColor.
  final Color? activeIndicatorColor;

  /// Active icon color.
  final Color? activeIconAndLabel;

  /// Active label color.
  final Color? activeLabelColor;

  /// inactiveIconAndLabel.
  final Color? inactiveIconAndLabel;

  /// menuColor.
  final Color? menuColor;

  /// badgeBackground.
  final Color? badgeBackground;

  /// badgeLargeLabel.
  final Color? badgeLargeLabel;

  /// Hover, focus, and press layer color.
  final Color? stateLayerColor;

  /// Keyboard focus ring color.
  final Color? focusRingColor;

  /// Optional content-edge divider color.
  final Color? dividerColor;

  /// indicatorShapeFull.
  final ShapeBorder? indicatorShapeFull;

  /// When true, the expanded pill fills the destination instead of hugging it.
  final bool indicatorFillsWidth;

  /// Resting elevation.
  final double elevation;

  /// Elevation while horizontal content is scrolled under the rail.
  final double scrolledElevation;

  /// Modal scrim opacity.
  final double modalScrimOpacity;

  /// Resting container corner radius.
  final double containerRadius;

  /// Modal container corner radius.
  final double modalContainerRadius;

  /// Content-edge divider thickness.
  final double dividerThickness;

  /// Hover state-layer opacity.
  final double hoverOpacity;

  /// Focus state-layer opacity.
  final double focusOpacity;

  /// Press state-layer opacity.
  final double pressedOpacity;

  /// Focus ring thickness.
  final double focusRingThickness;

  /// Focus ring inset from the pill edge.
  final double focusRingInset;

  /// Label size.
  final double labelFontSize;

  /// Label line height.
  final double labelLineHeight;

  /// Label tracking.
  final double labelLetterSpacing;

  /// Inactive label weight.
  final FontWeight inactiveLabelWeight;

  /// Active label weight.
  final FontWeight activeLabelWeight;

  /// Maximum label lines while text scale is above 1 and at most 2.
  final int scaledLabelMaxLines;

  /// Text scale above which labels may ellipsize.
  final double truncationTextScale;

  /// Retained theme field. Selection no longer travels, so this spring is unused.
  final M3ESpring indicatorLeadSpring;

  /// Retained theme field. Selection no longer travels, so this spring is unused.
  final M3ESpring indicatorTrailSpring;

  /// Spatial spring for the selection indicator width scale.
  final M3ESpring indicatorScaleSpring;

  /// Effects spring for the selection indicator fade.
  final M3ESpring indicatorFadeSpring;

  /// Icon scale pop on newly selected items.
  final M3ESpring iconScaleSpring;

  /// Spring for rail width, show/hide, and modal travel.
  final M3ESpring widthSpring;

  /// Active icon color.
  Color activeIconColor(M3EColorScheme scheme) =>
      activeIconAndLabel ?? scheme.onSecondaryContainer;

  /// Active label color.
  Color activeLabelColorResolved(M3EColorScheme scheme) =>
      activeLabelColor ?? scheme.onSurface;

  /// Kept for callers that still ask for one active color.
  Color activeIconAndLabelColor(M3EColorScheme scheme) =>
      activeIconColor(scheme);

  /// inactiveIconAndLabelColor.
  Color inactiveIconAndLabelColor(M3EColorScheme scheme) =>
      inactiveIconAndLabel ?? scheme.onSurfaceVariant;

  /// activeIndicatorColorResolved.
  Color activeIndicatorColorResolved(M3EColorScheme scheme) =>
      activeIndicatorColor ?? scheme.secondaryContainer;

  /// containerColorResolved.
  Color containerColorResolved(M3EColorScheme scheme) =>
      containerColor ?? scheme.surface;

  /// Modal container color.
  Color modalContainerColorResolved(M3EColorScheme scheme) =>
      modalContainerColor ?? scheme.surfaceContainer;

  /// Scrolled container color.
  Color scrolledContainerColorResolved(M3EColorScheme scheme) =>
      scrolledContainerColor ?? scheme.surfaceContainer;

  /// State layer color.
  Color stateLayerColorResolved(M3EColorScheme scheme) =>
      stateLayerColor ?? scheme.onSecondaryContainer;

  /// Focus ring color.
  Color focusRingColorResolved(M3EColorScheme scheme) =>
      focusRingColor ?? scheme.secondary;

  /// Menu icon color.
  Color menuColorResolved(M3EColorScheme scheme) =>
      menuColor ?? scheme.onSurfaceVariant;

  /// Badge fill.
  Color badgeBackgroundResolved(M3EColorScheme scheme) =>
      badgeBackground ?? scheme.error;

  /// Badge label.
  Color badgeLabelResolved(M3EColorScheme scheme) =>
      badgeLargeLabel ?? scheme.onError;

  /// Divider color.
  Color dividerColorResolved(M3EColorScheme scheme) =>
      dividerColor ?? scheme.outlineVariant;

  /// Label style for [selected].
  TextStyle labelStyle(M3EColorScheme scheme, {required bool selected}) {
    return TextStyle(
      fontSize: labelFontSize,
      height: labelLineHeight / labelFontSize,
      letterSpacing: labelLetterSpacing,
      fontWeight: selected ? activeLabelWeight : inactiveLabelWeight,
      color: selected
          ? activeLabelColorResolved(scheme)
          : inactiveIconAndLabelColor(scheme),
    );
  }

  @override
  M3ENavigationRailTheme copyWith({
    double? collapsedWidth,
    double? narrowCollapsedWidth,
    double? collapsedHorizontalPadding,
    double? narrowHorizontalPadding,
    double? expandedMinWidth,
    double? expandedMaxWidth,
    double? itemExpandedHeight,
    double? itemCollapsedHeight,
    double? itemHeight,
    double? itemShortHeight,
    double? shortItemHeight,
    double? iconSize,
    double? indicatorLeading,
    double? indicatorTrailing,
    double? expandedItemInset,
    double? iconLabelGap,
    double? verticalIconLabelGap,
    double? itemVerticalGap,
    double? expandedItemGap,
    double? itemVerticalPadding,
    double? topSpace,
    double? destinationTopPadding,
    double? expandedTrailingSpace,
    double? headerMinSpace,
    double? sectionHeaderSpacingTop,
    double? sectionHeaderSpacingBottom,
    double? verticalIndicatorWidth,
    double? verticalIndicatorHeight,
    double? verticalIndicatorRadius,
    double? expandedIndicatorHeight,
    double? expandedIndicatorRadius,
    double? noLabelIndicatorSize,
    Color? containerColor,
    Color? modalContainerColor,
    Color? scrolledContainerColor,
    Color? activeIndicatorColor,
    Color? activeIconAndLabel,
    Color? activeLabelColor,
    Color? inactiveIconAndLabel,
    Color? menuColor,
    Color? badgeBackground,
    Color? badgeLargeLabel,
    Color? stateLayerColor,
    Color? focusRingColor,
    Color? dividerColor,
    ShapeBorder? indicatorShapeFull,
    bool? indicatorFillsWidth,
    double? elevation,
    double? scrolledElevation,
    double? modalScrimOpacity,
    double? containerRadius,
    double? modalContainerRadius,
    double? dividerThickness,
    double? hoverOpacity,
    double? focusOpacity,
    double? pressedOpacity,
    double? focusRingThickness,
    double? focusRingInset,
    double? labelFontSize,
    double? labelLineHeight,
    double? labelLetterSpacing,
    FontWeight? inactiveLabelWeight,
    FontWeight? activeLabelWeight,
    int? scaledLabelMaxLines,
    double? truncationTextScale,
    M3ESpring? indicatorLeadSpring,
    M3ESpring? indicatorTrailSpring,
    M3ESpring? indicatorScaleSpring,
    M3ESpring? indicatorFadeSpring,
    M3ESpring? iconScaleSpring,
    M3ESpring? widthSpring,
  }) {
    return M3ENavigationRailTheme(
      collapsedWidth: collapsedWidth ?? this.collapsedWidth,
      narrowCollapsedWidth: narrowCollapsedWidth ?? this.narrowCollapsedWidth,
      collapsedHorizontalPadding:
          collapsedHorizontalPadding ?? this.collapsedHorizontalPadding,
      narrowHorizontalPadding:
          narrowHorizontalPadding ?? this.narrowHorizontalPadding,
      expandedMinWidth: expandedMinWidth ?? this.expandedMinWidth,
      expandedMaxWidth: expandedMaxWidth ?? this.expandedMaxWidth,
      itemExpandedHeight:
          itemHeight ?? itemExpandedHeight ?? this.itemExpandedHeight,
      itemCollapsedHeight:
          itemShortHeight ?? itemCollapsedHeight ?? this.itemCollapsedHeight,
      shortItemHeight: shortItemHeight ?? this.shortItemHeight,
      iconSize: iconSize ?? this.iconSize,
      indicatorLeading: indicatorLeading ?? this.indicatorLeading,
      indicatorTrailing: indicatorTrailing ?? this.indicatorTrailing,
      expandedItemInset: expandedItemInset ?? this.expandedItemInset,
      iconLabelGap: iconLabelGap ?? this.iconLabelGap,
      verticalIconLabelGap: verticalIconLabelGap ?? this.verticalIconLabelGap,
      itemVerticalGap: itemVerticalGap ?? this.itemVerticalGap,
      expandedItemGap: expandedItemGap ?? this.expandedItemGap,
      itemVerticalPadding: itemVerticalPadding ?? this.itemVerticalPadding,
      topSpace: topSpace ?? this.topSpace,
      destinationTopPadding:
          destinationTopPadding ?? this.destinationTopPadding,
      expandedTrailingSpace:
          expandedTrailingSpace ?? this.expandedTrailingSpace,
      headerMinSpace: headerMinSpace ?? this.headerMinSpace,
      sectionHeaderSpacingTop:
          sectionHeaderSpacingTop ?? this.sectionHeaderSpacingTop,
      sectionHeaderSpacingBottom:
          sectionHeaderSpacingBottom ?? this.sectionHeaderSpacingBottom,
      verticalIndicatorWidth:
          verticalIndicatorWidth ?? this.verticalIndicatorWidth,
      verticalIndicatorHeight:
          verticalIndicatorHeight ?? this.verticalIndicatorHeight,
      verticalIndicatorRadius:
          verticalIndicatorRadius ?? this.verticalIndicatorRadius,
      expandedIndicatorHeight:
          expandedIndicatorHeight ?? this.expandedIndicatorHeight,
      expandedIndicatorRadius:
          expandedIndicatorRadius ?? this.expandedIndicatorRadius,
      noLabelIndicatorSize: noLabelIndicatorSize ?? this.noLabelIndicatorSize,
      containerColor: containerColor ?? this.containerColor,
      modalContainerColor: modalContainerColor ?? this.modalContainerColor,
      scrolledContainerColor:
          scrolledContainerColor ?? this.scrolledContainerColor,
      activeIndicatorColor: activeIndicatorColor ?? this.activeIndicatorColor,
      activeIconAndLabel: activeIconAndLabel ?? this.activeIconAndLabel,
      activeLabelColor: activeLabelColor ?? this.activeLabelColor,
      inactiveIconAndLabel: inactiveIconAndLabel ?? this.inactiveIconAndLabel,
      menuColor: menuColor ?? this.menuColor,
      badgeBackground: badgeBackground ?? this.badgeBackground,
      badgeLargeLabel: badgeLargeLabel ?? this.badgeLargeLabel,
      stateLayerColor: stateLayerColor ?? this.stateLayerColor,
      focusRingColor: focusRingColor ?? this.focusRingColor,
      dividerColor: dividerColor ?? this.dividerColor,
      indicatorShapeFull: indicatorShapeFull ?? this.indicatorShapeFull,
      indicatorFillsWidth: indicatorFillsWidth ?? this.indicatorFillsWidth,
      elevation: elevation ?? this.elevation,
      scrolledElevation: scrolledElevation ?? this.scrolledElevation,
      modalScrimOpacity: modalScrimOpacity ?? this.modalScrimOpacity,
      containerRadius: containerRadius ?? this.containerRadius,
      modalContainerRadius: modalContainerRadius ?? this.modalContainerRadius,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      hoverOpacity: hoverOpacity ?? this.hoverOpacity,
      focusOpacity: focusOpacity ?? this.focusOpacity,
      pressedOpacity: pressedOpacity ?? this.pressedOpacity,
      focusRingThickness: focusRingThickness ?? this.focusRingThickness,
      focusRingInset: focusRingInset ?? this.focusRingInset,
      labelFontSize: labelFontSize ?? this.labelFontSize,
      labelLineHeight: labelLineHeight ?? this.labelLineHeight,
      labelLetterSpacing: labelLetterSpacing ?? this.labelLetterSpacing,
      inactiveLabelWeight: inactiveLabelWeight ?? this.inactiveLabelWeight,
      activeLabelWeight: activeLabelWeight ?? this.activeLabelWeight,
      scaledLabelMaxLines: scaledLabelMaxLines ?? this.scaledLabelMaxLines,
      truncationTextScale: truncationTextScale ?? this.truncationTextScale,
      indicatorLeadSpring: indicatorLeadSpring ?? this.indicatorLeadSpring,
      indicatorTrailSpring: indicatorTrailSpring ?? this.indicatorTrailSpring,
      indicatorScaleSpring: indicatorScaleSpring ?? this.indicatorScaleSpring,
      indicatorFadeSpring: indicatorFadeSpring ?? this.indicatorFadeSpring,
      iconScaleSpring: iconScaleSpring ?? this.iconScaleSpring,
      widthSpring: widthSpring ?? this.widthSpring,
    );
  }

  @override
  M3ENavigationRailTheme lerp(M3ENavigationRailTheme? other, double t) {
    if (other is! M3ENavigationRailTheme) {
      return this;
    }
    return M3ENavigationRailTheme(
      collapsedWidth: _ld(collapsedWidth, other.collapsedWidth, t),
      narrowCollapsedWidth: _ld(
        narrowCollapsedWidth,
        other.narrowCollapsedWidth,
        t,
      ),
      collapsedHorizontalPadding: _ld(
        collapsedHorizontalPadding,
        other.collapsedHorizontalPadding,
        t,
      ),
      narrowHorizontalPadding: _ld(
        narrowHorizontalPadding,
        other.narrowHorizontalPadding,
        t,
      ),
      expandedMinWidth: _ld(expandedMinWidth, other.expandedMinWidth, t),
      expandedMaxWidth: _ld(expandedMaxWidth, other.expandedMaxWidth, t),
      itemExpandedHeight: _ld(itemExpandedHeight, other.itemExpandedHeight, t),
      itemCollapsedHeight: _ld(
        itemCollapsedHeight,
        other.itemCollapsedHeight,
        t,
      ),
      shortItemHeight: _ld(shortItemHeight, other.shortItemHeight, t),
      iconSize: _ld(iconSize, other.iconSize, t),
      indicatorLeading: _ld(indicatorLeading, other.indicatorLeading, t),
      indicatorTrailing: _ld(indicatorTrailing, other.indicatorTrailing, t),
      expandedItemInset: _ld(expandedItemInset, other.expandedItemInset, t),
      iconLabelGap: _ld(iconLabelGap, other.iconLabelGap, t),
      verticalIconLabelGap: _ld(
        verticalIconLabelGap,
        other.verticalIconLabelGap,
        t,
      ),
      itemVerticalGap: _ld(itemVerticalGap, other.itemVerticalGap, t),
      expandedItemGap: _ld(expandedItemGap, other.expandedItemGap, t),
      itemVerticalPadding: _ld(
        itemVerticalPadding,
        other.itemVerticalPadding,
        t,
      ),
      topSpace: _ld(topSpace, other.topSpace, t),
      destinationTopPadding: _ld(
        destinationTopPadding,
        other.destinationTopPadding,
        t,
      ),
      expandedTrailingSpace: _ld(
        expandedTrailingSpace,
        other.expandedTrailingSpace,
        t,
      ),
      headerMinSpace: _ld(headerMinSpace, other.headerMinSpace, t),
      sectionHeaderSpacingTop: _ld(
        sectionHeaderSpacingTop,
        other.sectionHeaderSpacingTop,
        t,
      ),
      sectionHeaderSpacingBottom: _ld(
        sectionHeaderSpacingBottom,
        other.sectionHeaderSpacingBottom,
        t,
      ),
      verticalIndicatorWidth: _ld(
        verticalIndicatorWidth,
        other.verticalIndicatorWidth,
        t,
      ),
      verticalIndicatorHeight: _ld(
        verticalIndicatorHeight,
        other.verticalIndicatorHeight,
        t,
      ),
      verticalIndicatorRadius: _ld(
        verticalIndicatorRadius,
        other.verticalIndicatorRadius,
        t,
      ),
      expandedIndicatorHeight: _ld(
        expandedIndicatorHeight,
        other.expandedIndicatorHeight,
        t,
      ),
      expandedIndicatorRadius: _ld(
        expandedIndicatorRadius,
        other.expandedIndicatorRadius,
        t,
      ),
      noLabelIndicatorSize: _ld(
        noLabelIndicatorSize,
        other.noLabelIndicatorSize,
        t,
      ),
      containerColor: Color.lerp(containerColor, other.containerColor, t),
      modalContainerColor: Color.lerp(
        modalContainerColor,
        other.modalContainerColor,
        t,
      ),
      scrolledContainerColor: Color.lerp(
        scrolledContainerColor,
        other.scrolledContainerColor,
        t,
      ),
      activeIndicatorColor: Color.lerp(
        activeIndicatorColor,
        other.activeIndicatorColor,
        t,
      ),
      activeIconAndLabel: Color.lerp(
        activeIconAndLabel,
        other.activeIconAndLabel,
        t,
      ),
      activeLabelColor: Color.lerp(activeLabelColor, other.activeLabelColor, t),
      inactiveIconAndLabel: Color.lerp(
        inactiveIconAndLabel,
        other.inactiveIconAndLabel,
        t,
      ),
      menuColor: Color.lerp(menuColor, other.menuColor, t),
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t),
      badgeLargeLabel: Color.lerp(badgeLargeLabel, other.badgeLargeLabel, t),
      stateLayerColor: Color.lerp(stateLayerColor, other.stateLayerColor, t),
      focusRingColor: Color.lerp(focusRingColor, other.focusRingColor, t),
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t),
      indicatorShapeFull: ShapeBorder.lerp(
        indicatorShapeFull,
        other.indicatorShapeFull,
        t,
      ),
      indicatorFillsWidth: t < 0.5
          ? indicatorFillsWidth
          : other.indicatorFillsWidth,
      elevation: _ld(elevation, other.elevation, t),
      scrolledElevation: _ld(scrolledElevation, other.scrolledElevation, t),
      modalScrimOpacity: _ld(modalScrimOpacity, other.modalScrimOpacity, t),
      containerRadius: _ld(containerRadius, other.containerRadius, t),
      modalContainerRadius: _ld(
        modalContainerRadius,
        other.modalContainerRadius,
        t,
      ),
      dividerThickness: _ld(dividerThickness, other.dividerThickness, t),
      hoverOpacity: _ld(hoverOpacity, other.hoverOpacity, t),
      focusOpacity: _ld(focusOpacity, other.focusOpacity, t),
      pressedOpacity: _ld(pressedOpacity, other.pressedOpacity, t),
      focusRingThickness: _ld(focusRingThickness, other.focusRingThickness, t),
      focusRingInset: _ld(focusRingInset, other.focusRingInset, t),
      labelFontSize: _ld(labelFontSize, other.labelFontSize, t),
      labelLineHeight: _ld(labelLineHeight, other.labelLineHeight, t),
      labelLetterSpacing: _ld(labelLetterSpacing, other.labelLetterSpacing, t),
      inactiveLabelWeight: t < 0.5
          ? inactiveLabelWeight
          : other.inactiveLabelWeight,
      activeLabelWeight: t < 0.5 ? activeLabelWeight : other.activeLabelWeight,
      scaledLabelMaxLines: t < 0.5
          ? scaledLabelMaxLines
          : other.scaledLabelMaxLines,
      truncationTextScale: _ld(
        truncationTextScale,
        other.truncationTextScale,
        t,
      ),
      indicatorLeadSpring: t < 0.5
          ? indicatorLeadSpring
          : other.indicatorLeadSpring,
      indicatorTrailSpring: t < 0.5
          ? indicatorTrailSpring
          : other.indicatorTrailSpring,
      indicatorScaleSpring: t < 0.5
          ? indicatorScaleSpring
          : other.indicatorScaleSpring,
      indicatorFadeSpring: t < 0.5
          ? indicatorFadeSpring
          : other.indicatorFadeSpring,
      iconScaleSpring: t < 0.5 ? iconScaleSpring : other.iconScaleSpring,
      widthSpring: t < 0.5 ? widthSpring : other.widthSpring,
    );
  }

  double _ld(double a, double b, double t) => a + (b - a) * t;
}
