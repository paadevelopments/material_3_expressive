import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/search/m3e_search.dart'
    show M3ESearchBar;
import 'package:material_3_expressive/components/search/m3e_search_bar.dart'
    show M3ESearchBar;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3ESearchBar;

import '../../../foundations/foundations.dart';

/// Theme values for [M3ESearchBar].
@immutable
class M3ESearchBarTheme extends M3EThemeExtension<M3ESearchBarTheme> {
  /// M3ESearchBarTheme.
  const M3ESearchBarTheme({
    this.elevation = 0,
    this.horizontalPadding = 8,
    this.iconSize = 24,
    this.selectionOpacity = 0.4,
    this.disabledOpacity = M3EStateOpacity.disabledContent,
    this.minWidth = 360,
    this.maxWidth = 800,
    this.minHeight = 56,
    this.restingExpandPadding = 8,
    this.expandOnFocus = true,
    this.focusExpandSpring = M3EMotion.expressiveSpatialPress,
    this.noLeadingHintExtraPadding = 12,
    this.pressedOverlayOpacity = 0.1,
    this.hoveredOverlayOpacity = 0.08,
  });

  /// defaults.

  static const M3ESearchBarTheme defaults = M3ESearchBarTheme();

  /// elevation.

  final double elevation;

  /// horizontalPadding.
  final double horizontalPadding;

  /// iconSize.
  final double iconSize;

  /// selectionOpacity.
  final double selectionOpacity;

  /// disabledOpacity.
  final double disabledOpacity;

  /// minWidth.
  final double minWidth;

  /// maxWidth.
  final double maxWidth;

  /// minHeight.
  final double minHeight;

  /// restingExpandPadding.
  final double restingExpandPadding;

  /// expandOnFocus.
  final bool expandOnFocus;

  /// Spring for the minor expand/collapse inset on focus.
  ///
  /// Defaults to [M3EMotion.expressiveSpatialPress] (380 / 0.55) — same
  /// bouncy spatial recipe as the floating toolbar.
  final M3ESpring focusExpandSpring;

  /// noLeadingHintExtraPadding.
  final double noLeadingHintExtraPadding;

  /// pressedOverlayOpacity.
  final double pressedOverlayOpacity;

  /// hoveredOverlayOpacity.
  final double hoveredOverlayOpacity;

  /// constraints.

  BoxConstraints constraints({BoxConstraints? override}) {
    return override ??
        BoxConstraints(
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: minHeight,
        );
  }

  /// backgroundColor.

  Color backgroundColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  /// shadowColor.

  Color shadowColor(M3EColorScheme scheme) => scheme.shadow;

  /// surfaceTintColor.

  Color surfaceTintColor(M3EColorScheme scheme) => const Color(0x00000000);

  /// leadingIconColor.

  Color leadingIconColor(M3EColorScheme scheme) => scheme.onSurface;

  /// trailingIconColor.

  Color trailingIconColor(M3EColorScheme scheme) => scheme.onSurfaceVariant;

  /// textStyle.

  TextStyle textStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurface);

  /// hintStyle.

  TextStyle hintStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurfaceVariant);

  /// cursorColor.

  Color cursorColor(M3EColorScheme scheme) => scheme.primary;

  /// selectionColor.

  Color selectionColor(M3EColorScheme scheme) =>
      scheme.primary.withValues(alpha: selectionOpacity);

  /// padding.

  EdgeInsetsGeometry padding({EdgeInsetsGeometry? override}) {
    return override ?? EdgeInsets.symmetric(horizontal: horizontalPadding);
  }

  /// shape.

  ShapeBorder shape({ShapeBorder? override}) => override ?? M3EShapes.stadium;

  /// resolveElevation.

  double resolveElevation({
    required Set<WidgetState> states,
    WidgetStateProperty<double?>? widgetValue,
    WidgetStateProperty<double?>? themeValue,
  }) {
    return widgetValue?.resolve(states) ??
        themeValue?.resolve(states) ??
        elevation;
  }

  /// resolveBackground.

  Color resolveBackground({
    required M3EColorScheme scheme,
    required Set<WidgetState> states,
    WidgetStateProperty<Color?>? widgetValue,
    WidgetStateProperty<Color?>? themeValue,
  }) {
    return widgetValue?.resolve(states) ??
        themeValue?.resolve(states) ??
        backgroundColor(scheme);
  }

  /// resolveShadowColor.

  Color resolveShadowColor({
    required M3EColorScheme scheme,
    required Set<WidgetState> states,
    WidgetStateProperty<Color?>? widgetValue,
    WidgetStateProperty<Color?>? themeValue,
  }) {
    return widgetValue?.resolve(states) ??
        themeValue?.resolve(states) ??
        shadowColor(scheme);
  }

  /// resolveSurfaceTint.

  Color resolveSurfaceTint({
    required M3EColorScheme scheme,
    required Set<WidgetState> states,
    WidgetStateProperty<Color?>? widgetValue,
    WidgetStateProperty<Color?>? themeValue,
  }) {
    return widgetValue?.resolve(states) ??
        themeValue?.resolve(states) ??
        surfaceTintColor(scheme);
  }

  /// resolveOverlay.

  Color? resolveOverlay({
    required M3EColorScheme scheme,
    required Set<WidgetState> states,
    WidgetStateProperty<Color?>? widgetValue,
    WidgetStateProperty<Color?>? themeValue,
  }) {
    final Color? resolved =
        widgetValue?.resolve(states) ?? themeValue?.resolve(states);
    if (resolved != null) {
      return resolved;
    }
    if (states.contains(WidgetState.pressed)) {
      return scheme.onSurface.withValues(alpha: pressedOverlayOpacity);
    }
    if (states.contains(WidgetState.hovered)) {
      return scheme.onSurface.withValues(alpha: hoveredOverlayOpacity);
    }
    return null;
  }

  /// resolveTextStyle.

  TextStyle resolveTextStyle({
    required M3EThemeData theme,
    required Set<WidgetState> states,
    WidgetStateProperty<TextStyle?>? widgetValue,
    WidgetStateProperty<TextStyle?>? themeValue,
  }) {
    return widgetValue?.resolve(states) ??
        themeValue?.resolve(states) ??
        textStyle(theme.typeScale, theme.colorScheme);
  }

  /// resolveHintStyle.

  TextStyle resolveHintStyle({
    required M3EThemeData theme,
    required Set<WidgetState> states,
    WidgetStateProperty<TextStyle?>? widgetValue,
    WidgetStateProperty<TextStyle?>? themeValue,
    WidgetStateProperty<TextStyle?>? textStyleOverride,
  }) {
    return widgetValue?.resolve(states) ??
        themeValue?.resolve(states) ??
        textStyleOverride?.resolve(states) ??
        hintStyle(theme.typeScale, theme.colorScheme);
  }

  @override
  M3ESearchBarTheme copyWith({
    double? elevation,
    double? horizontalPadding,
    double? iconSize,
    double? selectionOpacity,
    double? disabledOpacity,
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? restingExpandPadding,
    bool? expandOnFocus,
    M3ESpring? focusExpandSpring,
    double? noLeadingHintExtraPadding,
    double? pressedOverlayOpacity,
    double? hoveredOverlayOpacity,
  }) {
    return M3ESearchBarTheme(
      elevation: elevation ?? this.elevation,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      iconSize: iconSize ?? this.iconSize,
      selectionOpacity: selectionOpacity ?? this.selectionOpacity,
      disabledOpacity: disabledOpacity ?? this.disabledOpacity,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      restingExpandPadding: restingExpandPadding ?? this.restingExpandPadding,
      expandOnFocus: expandOnFocus ?? this.expandOnFocus,
      focusExpandSpring: focusExpandSpring ?? this.focusExpandSpring,
      noLeadingHintExtraPadding:
          noLeadingHintExtraPadding ?? this.noLeadingHintExtraPadding,
      pressedOverlayOpacity:
          pressedOverlayOpacity ?? this.pressedOverlayOpacity,
      hoveredOverlayOpacity:
          hoveredOverlayOpacity ?? this.hoveredOverlayOpacity,
    );
  }

  @override
  M3ESearchBarTheme lerp(M3ESearchBarTheme? other, double t) {
    if (other is! M3ESearchBarTheme) {
      return this;
    }
    return M3ESearchBarTheme(
      elevation: _lerpDouble(elevation, other.elevation, t)!,
      horizontalPadding: _lerpDouble(
        horizontalPadding,
        other.horizontalPadding,
        t,
      )!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      selectionOpacity: _lerpDouble(
        selectionOpacity,
        other.selectionOpacity,
        t,
      )!,
      disabledOpacity: _lerpDouble(disabledOpacity, other.disabledOpacity, t)!,
      minWidth: _lerpDouble(minWidth, other.minWidth, t)!,
      maxWidth: _lerpDouble(maxWidth, other.maxWidth, t)!,
      minHeight: _lerpDouble(minHeight, other.minHeight, t)!,
      restingExpandPadding: _lerpDouble(
        restingExpandPadding,
        other.restingExpandPadding,
        t,
      )!,
      expandOnFocus: t < 0.5 ? expandOnFocus : other.expandOnFocus,
      focusExpandSpring: t < 0.5 ? focusExpandSpring : other.focusExpandSpring,
      noLeadingHintExtraPadding: _lerpDouble(
        noLeadingHintExtraPadding,
        other.noLeadingHintExtraPadding,
        t,
      )!,
      pressedOverlayOpacity: _lerpDouble(
        pressedOverlayOpacity,
        other.pressedOverlayOpacity,
        t,
      )!,
      hoveredOverlayOpacity: _lerpDouble(
        hoveredOverlayOpacity,
        other.hoveredOverlayOpacity,
        t,
      )!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
