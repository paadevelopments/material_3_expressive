import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_nav_bar_enums.dart';
import '../models/m3e_nav_metrics.dart';
import '../res/m3e_nav_bar_constants.dart';

/// Theme values for `M3ENavigationBar`.
@immutable
class M3ENavigationBarTheme extends M3EThemeExtension<M3ENavigationBarTheme> {
  /// M3ENavigationBarTheme.
  const M3ENavigationBarTheme({
    this.heightSmall = M3ENavBarConstants.heightSmall,
    this.heightMedium = M3ENavBarConstants.heightMedium,
    this.iconSize = 24,
    this.indicatorThickness = 3,
    this.compactHeightReduction = 4,
    this.compactIndicatorReduction = 1,
    this.indicatorScaleSpring = M3EMotion.expressiveSpatialDefault,
    this.indicatorFadeSpring = M3EMotion.effectsFast,
    this.elevation = M3ENavBarConstants.elevation,
    this.verticalIndicatorWidth = M3ENavBarConstants.flexibleIndicatorWidth,
    this.verticalIndicatorHeight = M3ENavBarConstants.indicatorHeight,
    this.verticalIndicatorRadius = M3ENavBarConstants.indicatorRadius,
    this.verticalPaddingTop = M3ENavBarConstants.verticalPaddingTop,
    this.verticalPaddingBottom = M3ENavBarConstants.verticalPaddingBottom,
    this.verticalIconLabelGap = M3ENavBarConstants.verticalIconLabelGap,
    this.horizontalIndicatorHeight =
        M3ENavBarConstants.horizontalIndicatorHeight,
    this.horizontalPadding = M3ENavBarConstants.horizontalBarPadding,
    this.horizontalIndicatorInset = M3ENavBarConstants.horizontalIndicatorInset,
    this.horizontalIconLabelGap = M3ENavBarConstants.horizontalIconLabelGap,
    this.baselineExtraPadding = M3ENavBarConstants.baselineExtraPadding,
    this.itemGap = M3ENavBarConstants.itemGap,
    this.wideItemGap = M3ENavBarConstants.wideDestinationGap,
    this.wideEdgePadding = M3ENavBarConstants.wideDestinationGap,
    this.hoverIndicatorWidth = M3ENavBarConstants.hoverIndicatorWidth,
    this.wideBreakpoint = M3ENavBarConstants.mediumWindowBreakpoint,
    this.focusRingThickness = M3ENavBarConstants.focusRingThickness,
    this.focusRingInset = M3ENavBarConstants.focusRingInset,
    this.hoverOpacity = M3ENavBarConstants.stateHoverOpacity,
    this.focusOpacity = M3ENavBarConstants.stateFocusOpacity,
    this.pressedOpacity = M3ENavBarConstants.statePressedOpacity,
    this.labelFontSize = M3ENavBarConstants.labelFontSize,
    this.labelLineHeight = M3ENavBarConstants.labelLineHeight,
    this.labelLetterSpacing = M3ENavBarConstants.labelLetterSpacing,
    this.inactiveLabelWeight = FontWeight.w500,
    this.activeLabelWeight = FontWeight.w700,
    this.restingLabelMaxLines = M3ENavBarConstants.restingLabelMaxLines,
    this.scaledLabelMaxLines = M3ENavBarConstants.scaledLabelMaxLines,
    this.truncationTextScale = M3ENavBarConstants.truncationTextScale,
  });

  /// defaults.
  static const M3ENavigationBarTheme defaults = M3ENavigationBarTheme();

  /// heightSmall.
  final double heightSmall;

  /// heightMedium.
  final double heightMedium;

  /// iconSize.
  final double iconSize;

  /// indicatorThickness.
  final double indicatorThickness;

  /// compactHeightReduction.
  final double compactHeightReduction;

  /// compactIndicatorReduction.
  final double compactIndicatorReduction;

  /// Spatial spring for the selection indicator width scale.
  final M3ESpring indicatorScaleSpring;

  /// Effects spring for the selection indicator fade.
  final M3ESpring indicatorFadeSpring;

  /// Container elevation.
  final double elevation;

  /// Vertical active pill width.
  final double verticalIndicatorWidth;

  /// Vertical active pill height.
  final double verticalIndicatorHeight;

  /// Vertical pill corner radius.
  final double verticalIndicatorRadius;

  /// Padding above the vertical icon pill.
  final double verticalPaddingTop;

  /// Padding below the vertical label.
  final double verticalPaddingBottom;

  /// Gap between the vertical icon pill and the label.
  final double verticalIconLabelGap;

  /// Horizontal pill height before text scale growth.
  final double horizontalIndicatorHeight;

  /// Padding above and below a horizontal pill.
  final double horizontalPadding;

  /// Leading and trailing inset inside a horizontal pill.
  final double horizontalIndicatorInset;

  /// Gap between the icon and the label in a horizontal pill.
  final double horizontalIconLabelGap;

  /// Extra padding the baseline size adds above and below.
  final double baselineExtraPadding;

  /// Gap between vertical destinations.
  final double itemGap;

  /// Gap between horizontal destinations.
  final double wideItemGap;

  /// Inset between a start- or end-aligned horizontal group and the bar edge.
  final double wideEdgePadding;

  /// Inactive hover pill width.
  final double hoverIndicatorWidth;

  /// Auto-layout width that switches to horizontal items.
  final double wideBreakpoint;

  /// Inset focus ring thickness.
  final double focusRingThickness;

  /// Inset of the focus ring from the destination edge.
  final double focusRingInset;

  /// Hover state-layer opacity.
  final double hoverOpacity;

  /// Focus state-layer opacity.
  final double focusOpacity;

  /// Pressed state-layer opacity.
  final double pressedOpacity;

  /// Label size at 1x.
  final double labelFontSize;

  /// Label line height at 1x.
  final double labelLineHeight;

  /// Label tracking.
  final double labelLetterSpacing;

  /// Inactive label weight.
  final FontWeight inactiveLabelWeight;

  /// Active label weight.
  final FontWeight activeLabelWeight;

  /// Label lines at 1x.
  final int restingLabelMaxLines;

  /// Label lines above 1x.
  final int scaledLabelMaxLines;

  /// Text scale above which a label may ellipsize.
  final double truncationTextScale;

  /// metrics.
  M3ENavMetrics metrics(M3ENavBarDensity density, M3ESpacing spacing) {
    var hSmall = heightSmall;
    var hMedium = heightMedium;
    var icon = iconSize;
    var underline = indicatorThickness;

    if (density == M3ENavBarDensity.compact) {
      hSmall -= compactHeightReduction;
      hMedium -= compactHeightReduction;
      underline -= compactIndicatorReduction;
    }

    return M3ENavMetrics(
      heightSmall: hSmall,
      heightMedium: hMedium,
      iconSize: icon,
      padding: EdgeInsets.symmetric(horizontal: spacing.md),
      indicatorThickness: underline,
    );
  }

  /// containerColor.
  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  /// indicatorColor.
  Color indicatorColor(M3EColorScheme scheme) => scheme.secondaryContainer;

  /// Active icon color.
  Color selectedColor(M3EColorScheme scheme) => scheme.onSecondaryContainer;

  /// Active label color.
  Color activeLabelColor(M3EColorScheme scheme) => scheme.onSurface;

  /// Inactive icon and label color.
  Color unselectedColor(M3EColorScheme scheme) => scheme.onSurfaceVariant;

  /// State layer color.
  Color stateLayerColor(M3EColorScheme scheme) => scheme.onSecondaryContainer;

  /// Inset focus ring color.
  Color focusRingColor(M3EColorScheme scheme) => scheme.secondary;

  /// Shadow color at elevation 0.
  Color shadowColor(M3EColorScheme scheme) => scheme.shadow;

  /// Label style. Active labels use [activeLabelWeight].
  TextStyle labelStyle(M3ETypeScale type, {bool selected = false}) {
    return type.labelMedium.copyWith(
      fontSize: labelFontSize,
      height: labelLineHeight / labelFontSize,
      letterSpacing: labelLetterSpacing,
      fontWeight: selected ? activeLabelWeight : inactiveLabelWeight,
    );
  }

  /// containerShape.
  ShapeBorder containerShape(M3ENavBarShapeFamily family) {
    if (family == M3ENavBarShapeFamily.round) {
      return RoundedRectangleBorder(borderRadius: M3EShapes.roundSet.lg);
    }
    return const RoundedRectangleBorder();
  }

  /// indicatorShapePill.
  ShapeBorder indicatorShapePill() => const StadiumBorder();

  /// underlineDecoration.
  BoxDecoration underlineDecoration(Color color, double thickness) {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(color: color, width: thickness),
      ),
    );
  }

  @override
  M3ENavigationBarTheme copyWith({
    double? heightSmall,
    double? heightMedium,
    double? iconSize,
    double? indicatorThickness,
    double? compactHeightReduction,
    double? compactIndicatorReduction,
    M3ESpring? indicatorScaleSpring,
    M3ESpring? indicatorFadeSpring,
    double? elevation,
    double? verticalIndicatorWidth,
    double? verticalIndicatorHeight,
    double? verticalIndicatorRadius,
    double? verticalPaddingTop,
    double? verticalPaddingBottom,
    double? verticalIconLabelGap,
    double? horizontalIndicatorHeight,
    double? horizontalPadding,
    double? horizontalIndicatorInset,
    double? horizontalIconLabelGap,
    double? baselineExtraPadding,
    double? itemGap,
    double? wideItemGap,
    double? wideEdgePadding,
    double? hoverIndicatorWidth,
    double? wideBreakpoint,
    double? focusRingThickness,
    double? focusRingInset,
    double? hoverOpacity,
    double? focusOpacity,
    double? pressedOpacity,
    double? labelFontSize,
    double? labelLineHeight,
    double? labelLetterSpacing,
    FontWeight? inactiveLabelWeight,
    FontWeight? activeLabelWeight,
    int? restingLabelMaxLines,
    int? scaledLabelMaxLines,
    double? truncationTextScale,
  }) {
    return M3ENavigationBarTheme(
      heightSmall: heightSmall ?? this.heightSmall,
      heightMedium: heightMedium ?? this.heightMedium,
      iconSize: iconSize ?? this.iconSize,
      indicatorThickness: indicatorThickness ?? this.indicatorThickness,
      compactHeightReduction:
          compactHeightReduction ?? this.compactHeightReduction,
      compactIndicatorReduction:
          compactIndicatorReduction ?? this.compactIndicatorReduction,
      indicatorScaleSpring: indicatorScaleSpring ?? this.indicatorScaleSpring,
      indicatorFadeSpring: indicatorFadeSpring ?? this.indicatorFadeSpring,
      elevation: elevation ?? this.elevation,
      verticalIndicatorWidth:
          verticalIndicatorWidth ?? this.verticalIndicatorWidth,
      verticalIndicatorHeight:
          verticalIndicatorHeight ?? this.verticalIndicatorHeight,
      verticalIndicatorRadius:
          verticalIndicatorRadius ?? this.verticalIndicatorRadius,
      verticalPaddingTop: verticalPaddingTop ?? this.verticalPaddingTop,
      verticalPaddingBottom:
          verticalPaddingBottom ?? this.verticalPaddingBottom,
      verticalIconLabelGap: verticalIconLabelGap ?? this.verticalIconLabelGap,
      horizontalIndicatorHeight:
          horizontalIndicatorHeight ?? this.horizontalIndicatorHeight,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      horizontalIndicatorInset:
          horizontalIndicatorInset ?? this.horizontalIndicatorInset,
      horizontalIconLabelGap:
          horizontalIconLabelGap ?? this.horizontalIconLabelGap,
      baselineExtraPadding: baselineExtraPadding ?? this.baselineExtraPadding,
      itemGap: itemGap ?? this.itemGap,
      wideItemGap: wideItemGap ?? this.wideItemGap,
      wideEdgePadding: wideEdgePadding ?? this.wideEdgePadding,
      hoverIndicatorWidth: hoverIndicatorWidth ?? this.hoverIndicatorWidth,
      wideBreakpoint: wideBreakpoint ?? this.wideBreakpoint,
      focusRingThickness: focusRingThickness ?? this.focusRingThickness,
      focusRingInset: focusRingInset ?? this.focusRingInset,
      hoverOpacity: hoverOpacity ?? this.hoverOpacity,
      focusOpacity: focusOpacity ?? this.focusOpacity,
      pressedOpacity: pressedOpacity ?? this.pressedOpacity,
      labelFontSize: labelFontSize ?? this.labelFontSize,
      labelLineHeight: labelLineHeight ?? this.labelLineHeight,
      labelLetterSpacing: labelLetterSpacing ?? this.labelLetterSpacing,
      inactiveLabelWeight: inactiveLabelWeight ?? this.inactiveLabelWeight,
      activeLabelWeight: activeLabelWeight ?? this.activeLabelWeight,
      restingLabelMaxLines: restingLabelMaxLines ?? this.restingLabelMaxLines,
      scaledLabelMaxLines: scaledLabelMaxLines ?? this.scaledLabelMaxLines,
      truncationTextScale: truncationTextScale ?? this.truncationTextScale,
    );
  }

  @override
  M3ENavigationBarTheme lerp(M3ENavigationBarTheme? other, double t) {
    if (other is! M3ENavigationBarTheme) {
      return this;
    }
    double mix(double a, double b) => a + (b - a) * t;
    return M3ENavigationBarTheme(
      heightSmall: mix(heightSmall, other.heightSmall),
      heightMedium: mix(heightMedium, other.heightMedium),
      iconSize: mix(iconSize, other.iconSize),
      indicatorThickness: mix(indicatorThickness, other.indicatorThickness),
      compactHeightReduction: mix(
        compactHeightReduction,
        other.compactHeightReduction,
      ),
      compactIndicatorReduction: mix(
        compactIndicatorReduction,
        other.compactIndicatorReduction,
      ),
      indicatorScaleSpring: t < 0.5
          ? indicatorScaleSpring
          : other.indicatorScaleSpring,
      indicatorFadeSpring: t < 0.5
          ? indicatorFadeSpring
          : other.indicatorFadeSpring,
      elevation: mix(elevation, other.elevation),
      verticalIndicatorWidth: mix(
        verticalIndicatorWidth,
        other.verticalIndicatorWidth,
      ),
      verticalIndicatorHeight: mix(
        verticalIndicatorHeight,
        other.verticalIndicatorHeight,
      ),
      verticalIndicatorRadius: mix(
        verticalIndicatorRadius,
        other.verticalIndicatorRadius,
      ),
      verticalPaddingTop: mix(verticalPaddingTop, other.verticalPaddingTop),
      verticalPaddingBottom: mix(
        verticalPaddingBottom,
        other.verticalPaddingBottom,
      ),
      verticalIconLabelGap: mix(
        verticalIconLabelGap,
        other.verticalIconLabelGap,
      ),
      horizontalIndicatorHeight: mix(
        horizontalIndicatorHeight,
        other.horizontalIndicatorHeight,
      ),
      horizontalPadding: mix(horizontalPadding, other.horizontalPadding),
      horizontalIndicatorInset: mix(
        horizontalIndicatorInset,
        other.horizontalIndicatorInset,
      ),
      horizontalIconLabelGap: mix(
        horizontalIconLabelGap,
        other.horizontalIconLabelGap,
      ),
      baselineExtraPadding: mix(
        baselineExtraPadding,
        other.baselineExtraPadding,
      ),
      itemGap: mix(itemGap, other.itemGap),
      wideItemGap: mix(wideItemGap, other.wideItemGap),
      wideEdgePadding: mix(wideEdgePadding, other.wideEdgePadding),
      hoverIndicatorWidth: mix(hoverIndicatorWidth, other.hoverIndicatorWidth),
      wideBreakpoint: mix(wideBreakpoint, other.wideBreakpoint),
      focusRingThickness: mix(focusRingThickness, other.focusRingThickness),
      focusRingInset: mix(focusRingInset, other.focusRingInset),
      hoverOpacity: mix(hoverOpacity, other.hoverOpacity),
      focusOpacity: mix(focusOpacity, other.focusOpacity),
      pressedOpacity: mix(pressedOpacity, other.pressedOpacity),
      labelFontSize: mix(labelFontSize, other.labelFontSize),
      labelLineHeight: mix(labelLineHeight, other.labelLineHeight),
      labelLetterSpacing: mix(labelLetterSpacing, other.labelLetterSpacing),
      inactiveLabelWeight: t < 0.5
          ? inactiveLabelWeight
          : other.inactiveLabelWeight,
      activeLabelWeight: t < 0.5 ? activeLabelWeight : other.activeLabelWeight,
      restingLabelMaxLines: t < 0.5
          ? restingLabelMaxLines
          : other.restingLabelMaxLines,
      scaledLabelMaxLines: t < 0.5
          ? scaledLabelMaxLines
          : other.scaledLabelMaxLines,
      truncationTextScale: mix(truncationTextScale, other.truncationTextScale),
    );
  }
}
