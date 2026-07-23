import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_menu_item_shape.dart';

/// Theme values for `M3EMenu` (Compose `MenuDefaults` expressive tokens).
@immutable
class M3EMenuTheme extends M3EThemeExtension<M3EMenuTheme> {
  const M3EMenuTheme({
    this.minWidth = 112,
    this.maxWidth = 280,
    this.maxHeight = 320,
    this.verticalPadding = 8,
    this.anchorOffset = 4,
    this.entryHeight = 48,
    this.entryHorizontalPadding = 12,
    this.iconSize = 24,
    this.iconGap = 12,
    this.groupSpacing = 8,
    this.groupLabelHorizontalPadding = 12,
    this.groupLabelVerticalPadding = 8,
    this.elevation = M3EElevation.level2,
    this.disabledOpacity = 0.38,
    this.scrimAlpha = 0.0,
    this.screenEdgePadding = 12,
    this.openMotion = M3EMotion.expressiveSpatialDefault,
    this.closeMotion = M3EMotion.expressiveSpatialDefault,
    this.itemGap = 0,
  });

  static const M3EMenuTheme defaults = M3EMenuTheme();

  final double minWidth;
  final double maxWidth;
  final double maxHeight;
  final double verticalPadding;
  final double anchorOffset;
  final double entryHeight;
  final double entryHorizontalPadding;
  final double iconSize;
  final double iconGap;
  final double groupSpacing;
  final double groupLabelHorizontalPadding;
  final double groupLabelVerticalPadding;
  final double elevation;
  final double disabledOpacity;
  final double scrimAlpha;
  final double screenEdgePadding;

  /// Spring for expand — same default as [M3EDropdownMenu.openMotion].
  final M3ESpring openMotion;

  /// Spring for collapse — same default as [M3EDropdownMenu.closeMotion].
  final M3ESpring closeMotion;

  final double itemGap;

  BorderRadius get borderRadius => M3EShapes.radiusExtraSmall;

  /// Standalone / ungrouped item radius.
  BorderRadius get standaloneItemShape => M3EShapes.radiusExtraSmall;

  /// Leading item in a group (top corners rounded).
  BorderRadius get leadingItemShape => const BorderRadius.only(
        topLeft: Radius.circular(M3EShapes.extraSmall),
        topRight: Radius.circular(M3EShapes.extraSmall),
      );

  BorderRadius get middleItemShape => BorderRadius.zero;

  /// Trailing item in a group (bottom corners rounded).
  BorderRadius get trailingItemShape => const BorderRadius.only(
        bottomLeft: Radius.circular(M3EShapes.extraSmall),
        bottomRight: Radius.circular(M3EShapes.extraSmall),
      );

  BorderRadius itemShape(M3EMenuItemShape shape) {
    return switch (shape) {
      M3EMenuItemShape.standalone => standaloneItemShape,
      M3EMenuItemShape.leading => leadingItemShape,
      M3EMenuItemShape.middle => middleItemShape,
      M3EMenuItemShape.trailing => trailingItemShape,
    };
  }

  /// Applies Compose-style leading/middle/trailing shapes for [index] in [count].
  M3EMenuItemShape shapeForIndex(int index, int count) {
    if (count <= 1) {
      return M3EMenuItemShape.standalone;
    }
    if (index == 0) {
      return M3EMenuItemShape.leading;
    }
    if (index == count - 1) {
      return M3EMenuItemShape.trailing;
    }
    return M3EMenuItemShape.middle;
  }

  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainer;

  Color dividerColor(M3EColorScheme scheme) => scheme.outlineVariant;

  Color selectedContainerColor(M3EColorScheme scheme) =>
      scheme.secondaryContainer;

  Color scrimColor(M3EColorScheme scheme) =>
      M3EColorUtils.withOpacity(scheme.scrim, scrimAlpha);

  Color entryForegroundColor(
    M3EColorScheme scheme, {
    required bool enabled,
    bool isDestructive = false,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, disabledOpacity);
    }
    if (isDestructive) {
      return scheme.error;
    }
    return scheme.onSurface;
  }

  TextStyle entryLabelStyle(
    M3ETypeScale type,
    M3EColorScheme scheme, {
    required bool enabled,
    bool isDestructive = false,
  }) =>
      type.labelLarge.copyWith(
        color: entryForegroundColor(
          scheme,
          enabled: enabled,
          isDestructive: isDestructive,
        ),
      );

  TextStyle supportingTextStyle(
    M3ETypeScale type,
    M3EColorScheme scheme, {
    required bool enabled,
  }) =>
      type.labelMedium.copyWith(
        color: enabled
            ? scheme.onSurfaceVariant
            : M3EColorUtils.withOpacity(scheme.onSurface, disabledOpacity),
      );

  TextStyle groupLabelStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.labelLarge.copyWith(color: scheme.onSurfaceVariant);

  @override
  M3EMenuTheme copyWith({
    double? minWidth,
    double? maxWidth,
    double? maxHeight,
    double? verticalPadding,
    double? anchorOffset,
    double? entryHeight,
    double? entryHorizontalPadding,
    double? iconSize,
    double? iconGap,
    double? groupSpacing,
    double? groupLabelHorizontalPadding,
    double? groupLabelVerticalPadding,
    double? elevation,
    double? disabledOpacity,
    double? scrimAlpha,
    double? screenEdgePadding,
    M3ESpring? openMotion,
    M3ESpring? closeMotion,
    double? itemGap,
  }) {
    return M3EMenuTheme(
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      anchorOffset: anchorOffset ?? this.anchorOffset,
      entryHeight: entryHeight ?? this.entryHeight,
      entryHorizontalPadding:
          entryHorizontalPadding ?? this.entryHorizontalPadding,
      iconSize: iconSize ?? this.iconSize,
      iconGap: iconGap ?? this.iconGap,
      groupSpacing: groupSpacing ?? this.groupSpacing,
      groupLabelHorizontalPadding:
          groupLabelHorizontalPadding ?? this.groupLabelHorizontalPadding,
      groupLabelVerticalPadding:
          groupLabelVerticalPadding ?? this.groupLabelVerticalPadding,
      elevation: elevation ?? this.elevation,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      scrimAlpha: scrimAlpha ?? this.scrimAlpha,
      screenEdgePadding: screenEdgePadding ?? this.screenEdgePadding,
      openMotion: openMotion ?? this.openMotion,
      closeMotion: closeMotion ?? this.closeMotion,
      itemGap: itemGap ?? this.itemGap,
    );
  }

  @override
  M3EMenuTheme lerp(M3EMenuTheme? other, double t) {
    if (other is! M3EMenuTheme) {
      return this;
    }
    return M3EMenuTheme(
      minWidth: _lerpDouble(minWidth, other.minWidth, t)!,
      maxWidth: _lerpDouble(maxWidth, other.maxWidth, t)!,
      maxHeight: _lerpDouble(maxHeight, other.maxHeight, t)!,
      verticalPadding: _lerpDouble(verticalPadding, other.verticalPadding, t)!,
      anchorOffset: _lerpDouble(anchorOffset, other.anchorOffset, t)!,
      entryHeight: _lerpDouble(entryHeight, other.entryHeight, t)!,
      entryHorizontalPadding:
          _lerpDouble(entryHorizontalPadding, other.entryHorizontalPadding, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      iconGap: _lerpDouble(iconGap, other.iconGap, t)!,
      groupSpacing: _lerpDouble(groupSpacing, other.groupSpacing, t)!,
      groupLabelHorizontalPadding: _lerpDouble(
        groupLabelHorizontalPadding,
        other.groupLabelHorizontalPadding,
        t,
      )!,
      groupLabelVerticalPadding: _lerpDouble(
        groupLabelVerticalPadding,
        other.groupLabelVerticalPadding,
        t,
      )!,
      elevation: _lerpDouble(elevation, other.elevation, t)!,
      disabledOpacity: _lerpDouble(disabledOpacity, other.disabledOpacity, t)!,
      scrimAlpha: _lerpDouble(scrimAlpha, other.scrimAlpha, t)!,
      screenEdgePadding:
          _lerpDouble(screenEdgePadding, other.screenEdgePadding, t)!,
      openMotion: t < 0.5 ? openMotion : other.openMotion,
      closeMotion: t < 0.5 ? closeMotion : other.closeMotion,
      itemGap: _lerpDouble(itemGap, other.itemGap, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
