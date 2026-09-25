import 'dart:ui' show lerpDouble;

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_card_variant.dart';

/// Theme values for cards and card groups.
@immutable
class M3ECardTheme extends M3EThemeExtension<M3ECardTheme> {
  /// Creates card theme tokens.
  const M3ECardTheme({
    this.contentPadding = const EdgeInsets.all(16),
    this.radius = 12,
    this.gap = 8,
    this.maxGap = 8,
    this.iconSize = 24,
    this.outlineWidth = 1,
    this.focusThickness = 3,
    this.focusGap = 2,
    this.disabledOpacity = 0.38,
    this.disabledOutlineOpacity = 0.12,
    this.scrimOpacity = 0.32,
    this.swipeThreshold = 0.4,
    this.compactBreakpoint = 600,
    this.expandedBreakpoint = 840,
    this.columnMinWidth = 280,
    this.carouselCardWidth = 280,
    this.transformEndRadius = 0,
    this.transformContentFadeStart = 0.4,
    this.transformContentVisibleAt = 0.55,
    this.transformSpring = M3EMotion.expressiveSpatialDefault,
    this.contentOverlayPlate = false,
    this.elevatedElevation = M3EElevation.level1,
    this.elevatedHoverElevation = M3EElevation.level2,
    this.elevatedFocusElevation = M3EElevation.level1,
    this.elevatedPressedElevation = M3EElevation.level1,
    this.elevatedDraggedElevation = M3EElevation.level4,
    this.filledElevation = M3EElevation.level0,
    this.filledHoverElevation = M3EElevation.level1,
    this.filledFocusElevation = M3EElevation.level0,
    this.filledPressedElevation = M3EElevation.level0,
    this.filledDraggedElevation = M3EElevation.level3,
    this.outlinedElevation = M3EElevation.level0,
    this.outlinedHoverElevation = M3EElevation.level1,
    this.outlinedFocusElevation = M3EElevation.level0,
    this.outlinedPressedElevation = M3EElevation.level0,
    this.outlinedDraggedElevation = M3EElevation.level3,
    this.containerColor,
    this.elevatedContainerColor,
    this.filledContainerColor,
    this.outlinedContainerColor,
    this.disabledElevatedColor,
    this.disabledFilledColor,
    this.outlineColorOverride,
    this.disabledOutlineColor,
    this.focusedOutlineColor,
    this.iconColor,
    this.shadowColor,
    this.surfaceTint,
    this.focusColor,
    this.stateLayerColor,
    this.scrimColor,
    this.transformScrimColor,
    this.transformOpenColor,
    this.headlineColor,
    this.subheadColor,
    this.supportingColor,
    this.overlayPlateColor,
    this.maxHeight,
  });

  /// Package defaults.
  static const M3ECardTheme defaults = M3ECardTheme();

  /// Padding inside the container, 16 on every side.
  ///
  /// Media and an edge-to-edge divider sit outside this inset. A padding
  /// divider lines up with it on both sides.
  final EdgeInsets contentPadding;

  /// Corner radius for every state.
  final double radius;

  /// Space between cards in a collection.
  final double gap;

  /// Largest allowed collection gap. Raise this to allow a larger [gap].
  final double maxGap;

  /// Icon size drawn by card content.
  final double iconSize;

  /// Outlined stroke width.
  final double outlineWidth;

  /// Focus ring thickness.
  final double focusThickness;

  /// Gap between the card edge and the focus ring.
  final double focusGap;

  /// Disabled elevated and filled container opacity.
  final double disabledOpacity;

  /// Disabled outlined stroke opacity.
  final double disabledOutlineOpacity;

  /// Scrim opacity when text sits on media, and for the container transform.
  final double scrimOpacity;

  /// Fraction of the card width a swipe must travel.
  final double swipeThreshold;

  /// Width below which a group is one full-width column.
  final double compactBreakpoint;

  /// Width at which a group may use several columns or turn vertical.
  final double expandedBreakpoint;

  /// Narrowest column when fitting as many cards as the width allows.
  final double columnMinWidth;

  /// Width of a card in a horizontal row.
  final double carouselCardWidth;

  /// Corner radius of the open container-transform surface.
  final double transformEndRadius;

  /// Progress at which incoming transform content starts to fade in.
  final double transformContentFadeStart;

  /// Progress at which incoming transform content is shown.
  final double transformContentVisibleAt;

  /// Spring for the container transform.
  final M3ESpring transformSpring;

  /// When true, text on media sits on a plate instead of a scrim.
  final bool contentOverlayPlate;

  /// Resting elevation for an elevated card.
  final double elevatedElevation;

  /// Hover elevation for an elevated card.
  final double elevatedHoverElevation;

  /// Focus elevation for an elevated card.
  final double elevatedFocusElevation;

  /// Pressed elevation for an elevated card.
  final double elevatedPressedElevation;

  /// Dragged elevation for an elevated card.
  final double elevatedDraggedElevation;

  /// Resting elevation for a filled card.
  final double filledElevation;

  /// Hover elevation for a filled card.
  final double filledHoverElevation;

  /// Focus elevation for a filled card.
  final double filledFocusElevation;

  /// Pressed elevation for a filled card.
  final double filledPressedElevation;

  /// Dragged elevation for a filled card.
  final double filledDraggedElevation;

  /// Resting elevation for an outlined card.
  final double outlinedElevation;

  /// Hover elevation for an outlined card.
  final double outlinedHoverElevation;

  /// Focus elevation for an outlined card.
  final double outlinedFocusElevation;

  /// Pressed elevation for an outlined card.
  final double outlinedPressedElevation;

  /// Dragged elevation for an outlined card.
  final double outlinedDraggedElevation;

  /// Optional fill used for every variant.
  final Color? containerColor;

  /// Optional elevated fill.
  final Color? elevatedContainerColor;

  /// Optional filled fill.
  final Color? filledContainerColor;

  /// Optional outlined fill.
  final Color? outlinedContainerColor;

  /// Optional disabled elevated fill.
  final Color? disabledElevatedColor;

  /// Optional disabled filled fill.
  final Color? disabledFilledColor;

  /// Optional outline color.
  final Color? outlineColorOverride;

  /// Optional disabled outline color.
  final Color? disabledOutlineColor;

  /// Optional focused outline color.
  final Color? focusedOutlineColor;

  /// Optional icon color.
  final Color? iconColor;

  /// Optional shadow color.
  final Color? shadowColor;

  /// Elevation tint role. Stored only; it is not blended onto the fill.
  final Color? surfaceTint;

  /// Optional focus ring color.
  final Color? focusColor;

  /// Optional state-layer color.
  final Color? stateLayerColor;

  /// Optional media scrim color.
  final Color? scrimColor;

  /// Optional container-transform scrim color.
  final Color? transformScrimColor;

  /// Optional open container-transform fill.
  final Color? transformOpenColor;

  /// Optional headline color.
  final Color? headlineColor;

  /// Optional subhead color.
  final Color? subheadColor;

  /// Optional supporting-text color.
  final Color? supportingColor;

  /// Optional plate color behind text on media.
  final Color? overlayPlateColor;

  /// Cap for unexpanded content. Null means the card grows with its child.
  final double? maxHeight;

  /// Resolved outer radius.
  BorderRadius get borderRadius => BorderRadius.circular(radius);

  /// Collection gap clamped to [maxGap].
  double resolveGap([double? override]) {
    final double value = override ?? gap;
    if (value > maxGap) {
      return maxGap;
    }
    return value;
  }

  /// Enabled container color for [variant].
  Color backgroundColor(M3EColorScheme scheme, M3ECardVariant variant) {
    final Color? shared = containerColor;
    if (shared != null) {
      return shared;
    }
    switch (variant) {
      case M3ECardVariant.elevated:
        return elevatedContainerColor ?? scheme.surfaceContainerLow;
      case M3ECardVariant.filled:
        return filledContainerColor ?? scheme.surfaceContainerHighest;
      case M3ECardVariant.outlined:
        return outlinedContainerColor ?? scheme.surface;
    }
  }

  /// Container color, including the disabled roles.
  Color containerColorFor(
    M3EColorScheme scheme,
    M3ECardVariant variant, {
    required bool enabled,
  }) {
    if (enabled) {
      return backgroundColor(scheme, variant);
    }
    switch (variant) {
      case M3ECardVariant.elevated:
        return disabledElevatedColor ?? scheme.surface;
      case M3ECardVariant.filled:
        return disabledFilledColor ?? scheme.onSurface;
      case M3ECardVariant.outlined:
        return backgroundColor(scheme, variant);
    }
  }

  /// Enabled outline color.
  Color outlineColor(M3EColorScheme scheme) =>
      outlineColorOverride ?? scheme.outlineVariant;

  /// Outline color for the current enabled and focus state.
  Color outlineColorFor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool focused,
  }) {
    if (!enabled) {
      return disabledOutlineColor ??
          scheme.outline.withValues(alpha: disabledOutlineOpacity);
    }
    if (focused) {
      return focusedOutlineColor ?? scheme.onSurface;
    }
    return outlineColor(scheme);
  }

  /// Icon color.
  Color resolveIconColor(M3EColorScheme scheme) => iconColor ?? scheme.primary;

  /// Shadow color.
  Color resolveShadowColor(M3EColorScheme scheme) =>
      shadowColor ?? scheme.shadow;

  /// Surface tint role. Not painted on the container.
  Color resolveSurfaceTint(M3EColorScheme scheme) =>
      surfaceTint ?? scheme.primary;

  /// Focus ring color.
  Color resolveFocusColor(M3EColorScheme scheme) =>
      focusColor ?? scheme.secondary;

  /// State-layer color.
  Color resolveStateLayerColor(M3EColorScheme scheme) =>
      stateLayerColor ?? scheme.onSurface;

  /// Scrim behind text on media.
  Color resolveScrimColor(M3EColorScheme scheme) =>
      (scrimColor ?? scheme.scrim).withValues(alpha: scrimOpacity);

  /// Container-transform scrim.
  Color resolveTransformScrim(M3EColorScheme scheme) =>
      (transformScrimColor ?? scheme.scrim).withValues(alpha: scrimOpacity);

  /// Open container-transform fill.
  Color resolveTransformOpenColor(M3EColorScheme scheme) =>
      transformOpenColor ?? scheme.surface;

  /// Plate behind text on media.
  Color resolveOverlayPlate(M3EColorScheme scheme) =>
      overlayPlateColor ?? scheme.surfaceContainerHigh;

  /// Elevation for [variant] and the active interaction.
  ///
  /// Disabled wins, then dragged, pressed, focused, hovered, then resting.
  double elevation(
    M3ECardVariant variant, {
    required bool hovered,
    bool focused = false,
    bool pressed = false,
    bool dragged = false,
    bool enabled = true,
  }) {
    if (!enabled) {
      return M3EElevation.level0;
    }
    if (dragged) {
      return _draggedElevation(variant);
    }
    if (pressed) {
      return _pressedElevation(variant);
    }
    if (focused) {
      return _focusedElevation(variant);
    }
    if (hovered) {
      return _hoverElevation(variant);
    }
    return _restingElevation(variant);
  }

  double _restingElevation(M3ECardVariant variant) {
    switch (variant) {
      case M3ECardVariant.elevated:
        return elevatedElevation;
      case M3ECardVariant.filled:
        return filledElevation;
      case M3ECardVariant.outlined:
        return outlinedElevation;
    }
  }

  double _hoverElevation(M3ECardVariant variant) {
    switch (variant) {
      case M3ECardVariant.elevated:
        return elevatedHoverElevation;
      case M3ECardVariant.filled:
        return filledHoverElevation;
      case M3ECardVariant.outlined:
        return outlinedHoverElevation;
    }
  }

  double _focusedElevation(M3ECardVariant variant) {
    switch (variant) {
      case M3ECardVariant.elevated:
        return elevatedFocusElevation;
      case M3ECardVariant.filled:
        return filledFocusElevation;
      case M3ECardVariant.outlined:
        return outlinedFocusElevation;
    }
  }

  double _pressedElevation(M3ECardVariant variant) {
    switch (variant) {
      case M3ECardVariant.elevated:
        return elevatedPressedElevation;
      case M3ECardVariant.filled:
        return filledPressedElevation;
      case M3ECardVariant.outlined:
        return outlinedPressedElevation;
    }
  }

  double _draggedElevation(M3ECardVariant variant) {
    switch (variant) {
      case M3ECardVariant.elevated:
        return elevatedDraggedElevation;
      case M3ECardVariant.filled:
        return filledDraggedElevation;
      case M3ECardVariant.outlined:
        return outlinedDraggedElevation;
    }
  }

  /// Headline style.
  TextStyle headlineStyle(M3EThemeData theme) {
    return theme.typeScale.titleMedium.copyWith(
      color: headlineColor ?? theme.colorScheme.onSurface,
    );
  }

  /// Subhead style.
  TextStyle subheadStyle(M3EThemeData theme) {
    return theme.typeScale.titleSmall.copyWith(
      color: subheadColor ?? theme.colorScheme.onSurfaceVariant,
    );
  }

  /// Supporting text style.
  TextStyle supportingStyle(M3EThemeData theme) {
    return theme.typeScale.bodyMedium.copyWith(
      color: supportingColor ?? theme.colorScheme.onSurfaceVariant,
    );
  }

  @override
  M3ECardTheme copyWith({
    EdgeInsets? contentPadding,
    double? radius,
    double? gap,
    double? maxGap,
    double? iconSize,
    double? outlineWidth,
    double? focusThickness,
    double? focusGap,
    double? disabledOpacity,
    double? disabledOutlineOpacity,
    double? scrimOpacity,
    double? swipeThreshold,
    double? compactBreakpoint,
    double? expandedBreakpoint,
    double? columnMinWidth,
    double? carouselCardWidth,
    double? transformEndRadius,
    double? transformContentFadeStart,
    double? transformContentVisibleAt,
    M3ESpring? transformSpring,
    bool? contentOverlayPlate,
    double? elevatedElevation,
    double? elevatedHoverElevation,
    double? elevatedFocusElevation,
    double? elevatedPressedElevation,
    double? elevatedDraggedElevation,
    double? filledElevation,
    double? filledHoverElevation,
    double? filledFocusElevation,
    double? filledPressedElevation,
    double? filledDraggedElevation,
    double? outlinedElevation,
    double? outlinedHoverElevation,
    double? outlinedFocusElevation,
    double? outlinedPressedElevation,
    double? outlinedDraggedElevation,
    Color? containerColor,
    Color? elevatedContainerColor,
    Color? filledContainerColor,
    Color? outlinedContainerColor,
    Color? disabledElevatedColor,
    Color? disabledFilledColor,
    Color? outlineColorOverride,
    Color? disabledOutlineColor,
    Color? focusedOutlineColor,
    Color? iconColor,
    Color? shadowColor,
    Color? surfaceTint,
    Color? focusColor,
    Color? stateLayerColor,
    Color? scrimColor,
    Color? transformScrimColor,
    Color? transformOpenColor,
    Color? headlineColor,
    Color? subheadColor,
    Color? supportingColor,
    Color? overlayPlateColor,
    double? maxHeight,
    bool clearMaxHeight = false,
  }) {
    return M3ECardTheme(
      contentPadding: contentPadding ?? this.contentPadding,
      radius: radius ?? this.radius,
      gap: gap ?? this.gap,
      maxGap: maxGap ?? this.maxGap,
      iconSize: iconSize ?? this.iconSize,
      outlineWidth: outlineWidth ?? this.outlineWidth,
      focusThickness: focusThickness ?? this.focusThickness,
      focusGap: focusGap ?? this.focusGap,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      disabledOutlineOpacity:
          disabledOutlineOpacity ?? this.disabledOutlineOpacity,
      scrimOpacity: scrimOpacity ?? this.scrimOpacity,
      swipeThreshold: swipeThreshold ?? this.swipeThreshold,
      compactBreakpoint: compactBreakpoint ?? this.compactBreakpoint,
      expandedBreakpoint: expandedBreakpoint ?? this.expandedBreakpoint,
      columnMinWidth: columnMinWidth ?? this.columnMinWidth,
      carouselCardWidth: carouselCardWidth ?? this.carouselCardWidth,
      transformEndRadius: transformEndRadius ?? this.transformEndRadius,
      transformContentFadeStart:
          transformContentFadeStart ?? this.transformContentFadeStart,
      transformContentVisibleAt:
          transformContentVisibleAt ?? this.transformContentVisibleAt,
      transformSpring: transformSpring ?? this.transformSpring,
      contentOverlayPlate: contentOverlayPlate ?? this.contentOverlayPlate,
      elevatedElevation: elevatedElevation ?? this.elevatedElevation,
      elevatedHoverElevation:
          elevatedHoverElevation ?? this.elevatedHoverElevation,
      elevatedFocusElevation:
          elevatedFocusElevation ?? this.elevatedFocusElevation,
      elevatedPressedElevation:
          elevatedPressedElevation ?? this.elevatedPressedElevation,
      elevatedDraggedElevation:
          elevatedDraggedElevation ?? this.elevatedDraggedElevation,
      filledElevation: filledElevation ?? this.filledElevation,
      filledHoverElevation: filledHoverElevation ?? this.filledHoverElevation,
      filledFocusElevation: filledFocusElevation ?? this.filledFocusElevation,
      filledPressedElevation:
          filledPressedElevation ?? this.filledPressedElevation,
      filledDraggedElevation:
          filledDraggedElevation ?? this.filledDraggedElevation,
      outlinedElevation: outlinedElevation ?? this.outlinedElevation,
      outlinedHoverElevation:
          outlinedHoverElevation ?? this.outlinedHoverElevation,
      outlinedFocusElevation:
          outlinedFocusElevation ?? this.outlinedFocusElevation,
      outlinedPressedElevation:
          outlinedPressedElevation ?? this.outlinedPressedElevation,
      outlinedDraggedElevation:
          outlinedDraggedElevation ?? this.outlinedDraggedElevation,
      containerColor: containerColor ?? this.containerColor,
      elevatedContainerColor:
          elevatedContainerColor ?? this.elevatedContainerColor,
      filledContainerColor: filledContainerColor ?? this.filledContainerColor,
      outlinedContainerColor:
          outlinedContainerColor ?? this.outlinedContainerColor,
      disabledElevatedColor:
          disabledElevatedColor ?? this.disabledElevatedColor,
      disabledFilledColor: disabledFilledColor ?? this.disabledFilledColor,
      outlineColorOverride: outlineColorOverride ?? this.outlineColorOverride,
      disabledOutlineColor: disabledOutlineColor ?? this.disabledOutlineColor,
      focusedOutlineColor: focusedOutlineColor ?? this.focusedOutlineColor,
      iconColor: iconColor ?? this.iconColor,
      shadowColor: shadowColor ?? this.shadowColor,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      focusColor: focusColor ?? this.focusColor,
      stateLayerColor: stateLayerColor ?? this.stateLayerColor,
      scrimColor: scrimColor ?? this.scrimColor,
      transformScrimColor: transformScrimColor ?? this.transformScrimColor,
      transformOpenColor: transformOpenColor ?? this.transformOpenColor,
      headlineColor: headlineColor ?? this.headlineColor,
      subheadColor: subheadColor ?? this.subheadColor,
      supportingColor: supportingColor ?? this.supportingColor,
      overlayPlateColor: overlayPlateColor ?? this.overlayPlateColor,
      maxHeight: clearMaxHeight ? null : (maxHeight ?? this.maxHeight),
    );
  }

  @override
  M3ECardTheme lerp(M3ECardTheme? other, double t) {
    if (other is! M3ECardTheme) {
      return this;
    }
    return M3ECardTheme(
      contentPadding: EdgeInsets.lerp(contentPadding, other.contentPadding, t)!,
      radius: _lerp(radius, other.radius, t),
      gap: _lerp(gap, other.gap, t),
      maxGap: _lerp(maxGap, other.maxGap, t),
      iconSize: _lerp(iconSize, other.iconSize, t),
      outlineWidth: _lerp(outlineWidth, other.outlineWidth, t),
      focusThickness: _lerp(focusThickness, other.focusThickness, t),
      focusGap: _lerp(focusGap, other.focusGap, t),
      disabledOpacity: _lerp(disabledOpacity, other.disabledOpacity, t),
      disabledOutlineOpacity: _lerp(
        disabledOutlineOpacity,
        other.disabledOutlineOpacity,
        t,
      ),
      scrimOpacity: _lerp(scrimOpacity, other.scrimOpacity, t),
      swipeThreshold: _lerp(swipeThreshold, other.swipeThreshold, t),
      compactBreakpoint: _lerp(compactBreakpoint, other.compactBreakpoint, t),
      expandedBreakpoint: _lerp(
        expandedBreakpoint,
        other.expandedBreakpoint,
        t,
      ),
      columnMinWidth: _lerp(columnMinWidth, other.columnMinWidth, t),
      carouselCardWidth: _lerp(carouselCardWidth, other.carouselCardWidth, t),
      transformEndRadius: _lerp(
        transformEndRadius,
        other.transformEndRadius,
        t,
      ),
      transformContentFadeStart: _lerp(
        transformContentFadeStart,
        other.transformContentFadeStart,
        t,
      ),
      transformContentVisibleAt: _lerp(
        transformContentVisibleAt,
        other.transformContentVisibleAt,
        t,
      ),
      transformSpring: M3ESpring(
        stiffness: _lerp(
          transformSpring.stiffness,
          other.transformSpring.stiffness,
          t,
        ),
        damping: _lerp(
          transformSpring.damping,
          other.transformSpring.damping,
          t,
        ),
      ),
      contentOverlayPlate: t < 0.5
          ? contentOverlayPlate
          : other.contentOverlayPlate,
      elevatedElevation: _lerp(elevatedElevation, other.elevatedElevation, t),
      elevatedHoverElevation: _lerp(
        elevatedHoverElevation,
        other.elevatedHoverElevation,
        t,
      ),
      elevatedFocusElevation: _lerp(
        elevatedFocusElevation,
        other.elevatedFocusElevation,
        t,
      ),
      elevatedPressedElevation: _lerp(
        elevatedPressedElevation,
        other.elevatedPressedElevation,
        t,
      ),
      elevatedDraggedElevation: _lerp(
        elevatedDraggedElevation,
        other.elevatedDraggedElevation,
        t,
      ),
      filledElevation: _lerp(filledElevation, other.filledElevation, t),
      filledHoverElevation: _lerp(
        filledHoverElevation,
        other.filledHoverElevation,
        t,
      ),
      filledFocusElevation: _lerp(
        filledFocusElevation,
        other.filledFocusElevation,
        t,
      ),
      filledPressedElevation: _lerp(
        filledPressedElevation,
        other.filledPressedElevation,
        t,
      ),
      filledDraggedElevation: _lerp(
        filledDraggedElevation,
        other.filledDraggedElevation,
        t,
      ),
      outlinedElevation: _lerp(outlinedElevation, other.outlinedElevation, t),
      outlinedHoverElevation: _lerp(
        outlinedHoverElevation,
        other.outlinedHoverElevation,
        t,
      ),
      outlinedFocusElevation: _lerp(
        outlinedFocusElevation,
        other.outlinedFocusElevation,
        t,
      ),
      outlinedPressedElevation: _lerp(
        outlinedPressedElevation,
        other.outlinedPressedElevation,
        t,
      ),
      outlinedDraggedElevation: _lerp(
        outlinedDraggedElevation,
        other.outlinedDraggedElevation,
        t,
      ),
      containerColor: Color.lerp(containerColor, other.containerColor, t),
      elevatedContainerColor: Color.lerp(
        elevatedContainerColor,
        other.elevatedContainerColor,
        t,
      ),
      filledContainerColor: Color.lerp(
        filledContainerColor,
        other.filledContainerColor,
        t,
      ),
      outlinedContainerColor: Color.lerp(
        outlinedContainerColor,
        other.outlinedContainerColor,
        t,
      ),
      disabledElevatedColor: Color.lerp(
        disabledElevatedColor,
        other.disabledElevatedColor,
        t,
      ),
      disabledFilledColor: Color.lerp(
        disabledFilledColor,
        other.disabledFilledColor,
        t,
      ),
      outlineColorOverride: Color.lerp(
        outlineColorOverride,
        other.outlineColorOverride,
        t,
      ),
      disabledOutlineColor: Color.lerp(
        disabledOutlineColor,
        other.disabledOutlineColor,
        t,
      ),
      focusedOutlineColor: Color.lerp(
        focusedOutlineColor,
        other.focusedOutlineColor,
        t,
      ),
      iconColor: Color.lerp(iconColor, other.iconColor, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      surfaceTint: Color.lerp(surfaceTint, other.surfaceTint, t),
      focusColor: Color.lerp(focusColor, other.focusColor, t),
      stateLayerColor: Color.lerp(stateLayerColor, other.stateLayerColor, t),
      scrimColor: Color.lerp(scrimColor, other.scrimColor, t),
      transformScrimColor: Color.lerp(
        transformScrimColor,
        other.transformScrimColor,
        t,
      ),
      transformOpenColor: Color.lerp(
        transformOpenColor,
        other.transformOpenColor,
        t,
      ),
      headlineColor: Color.lerp(headlineColor, other.headlineColor, t),
      subheadColor: Color.lerp(subheadColor, other.subheadColor, t),
      supportingColor: Color.lerp(supportingColor, other.supportingColor, t),
      overlayPlateColor: Color.lerp(
        overlayPlateColor,
        other.overlayPlateColor,
        t,
      ),
      maxHeight: lerpDouble(maxHeight, other.maxHeight, t),
    );
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  @override
  bool operator ==(Object other) {
    return other is M3ECardTheme &&
        other.contentPadding == contentPadding &&
        other.radius == radius &&
        other.gap == gap &&
        other.maxGap == maxGap &&
        other.iconSize == iconSize &&
        other.outlineWidth == outlineWidth &&
        other.focusThickness == focusThickness &&
        other.focusGap == focusGap &&
        other.disabledOpacity == disabledOpacity &&
        other.disabledOutlineOpacity == disabledOutlineOpacity &&
        other.scrimOpacity == scrimOpacity &&
        other.swipeThreshold == swipeThreshold &&
        other.compactBreakpoint == compactBreakpoint &&
        other.expandedBreakpoint == expandedBreakpoint &&
        other.columnMinWidth == columnMinWidth &&
        other.carouselCardWidth == carouselCardWidth &&
        other.transformEndRadius == transformEndRadius &&
        other.transformContentFadeStart == transformContentFadeStart &&
        other.transformContentVisibleAt == transformContentVisibleAt &&
        other.transformSpring == transformSpring &&
        other.contentOverlayPlate == contentOverlayPlate &&
        other.elevatedElevation == elevatedElevation &&
        other.elevatedHoverElevation == elevatedHoverElevation &&
        other.elevatedFocusElevation == elevatedFocusElevation &&
        other.elevatedPressedElevation == elevatedPressedElevation &&
        other.elevatedDraggedElevation == elevatedDraggedElevation &&
        other.filledElevation == filledElevation &&
        other.filledHoverElevation == filledHoverElevation &&
        other.filledFocusElevation == filledFocusElevation &&
        other.filledPressedElevation == filledPressedElevation &&
        other.filledDraggedElevation == filledDraggedElevation &&
        other.outlinedElevation == outlinedElevation &&
        other.outlinedHoverElevation == outlinedHoverElevation &&
        other.outlinedFocusElevation == outlinedFocusElevation &&
        other.outlinedPressedElevation == outlinedPressedElevation &&
        other.outlinedDraggedElevation == outlinedDraggedElevation &&
        other.containerColor == containerColor &&
        other.elevatedContainerColor == elevatedContainerColor &&
        other.filledContainerColor == filledContainerColor &&
        other.outlinedContainerColor == outlinedContainerColor &&
        other.disabledElevatedColor == disabledElevatedColor &&
        other.disabledFilledColor == disabledFilledColor &&
        other.outlineColorOverride == outlineColorOverride &&
        other.disabledOutlineColor == disabledOutlineColor &&
        other.focusedOutlineColor == focusedOutlineColor &&
        other.iconColor == iconColor &&
        other.shadowColor == shadowColor &&
        other.surfaceTint == surfaceTint &&
        other.focusColor == focusColor &&
        other.stateLayerColor == stateLayerColor &&
        other.scrimColor == scrimColor &&
        other.transformScrimColor == transformScrimColor &&
        other.transformOpenColor == transformOpenColor &&
        other.headlineColor == headlineColor &&
        other.subheadColor == subheadColor &&
        other.supportingColor == supportingColor &&
        other.overlayPlateColor == overlayPlateColor &&
        other.maxHeight == maxHeight;
  }

  @override
  int get hashCode => Object.hashAll(<Object?>[
    contentPadding,
    radius,
    gap,
    maxGap,
    iconSize,
    outlineWidth,
    focusThickness,
    focusGap,
    disabledOpacity,
    disabledOutlineOpacity,
    scrimOpacity,
    swipeThreshold,
    compactBreakpoint,
    expandedBreakpoint,
    columnMinWidth,
    carouselCardWidth,
    transformEndRadius,
    transformContentFadeStart,
    transformContentVisibleAt,
    transformSpring,
    contentOverlayPlate,
    elevatedElevation,
    elevatedHoverElevation,
    elevatedFocusElevation,
    elevatedPressedElevation,
    elevatedDraggedElevation,
    filledElevation,
    filledHoverElevation,
    filledFocusElevation,
    filledPressedElevation,
    filledDraggedElevation,
    outlinedElevation,
    outlinedHoverElevation,
    outlinedFocusElevation,
    outlinedPressedElevation,
    outlinedDraggedElevation,
    containerColor,
    elevatedContainerColor,
    filledContainerColor,
    outlinedContainerColor,
    disabledElevatedColor,
    disabledFilledColor,
    outlineColorOverride,
    disabledOutlineColor,
    focusedOutlineColor,
    iconColor,
    shadowColor,
    surfaceTint,
    focusColor,
    stateLayerColor,
    scrimColor,
    transformScrimColor,
    transformOpenColor,
    headlineColor,
    subheadColor,
    supportingColor,
    overlayPlateColor,
    maxHeight,
  ]);
}
