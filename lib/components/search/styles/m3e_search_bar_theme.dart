import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for [M3ESearchBar].
@immutable
class M3ESearchBarTheme extends M3EThemeExtension<M3ESearchBarTheme> {
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
    this.focusExpandSpring = M3EMotion.expressiveSpatialFast,
    this.noLeadingHintExtraPadding = 12,
    this.pressedOverlayOpacity = 0.1,
    this.hoveredOverlayOpacity = 0.08,
  });

  static const M3ESearchBarTheme defaults = M3ESearchBarTheme();

  final double elevation;
  final double horizontalPadding;
  final double iconSize;
  final double selectionOpacity;
  final double disabledOpacity;
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double restingExpandPadding;
  final bool expandOnFocus;
  final M3ESpring focusExpandSpring;
  final double noLeadingHintExtraPadding;
  final double pressedOverlayOpacity;
  final double hoveredOverlayOpacity;

  BoxConstraints constraints({BoxConstraints? override}) {
    return override ??
        BoxConstraints(
          minWidth: minWidth,
          maxWidth: maxWidth,
          minHeight: minHeight,
        );
  }

  Color backgroundColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  Color shadowColor(M3EColorScheme scheme) => scheme.shadow;

  Color surfaceTintColor(M3EColorScheme scheme) => const Color(0x00000000);

  Color leadingIconColor(M3EColorScheme scheme) => scheme.onSurface;

  Color trailingIconColor(M3EColorScheme scheme) => scheme.onSurfaceVariant;

  TextStyle textStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurface);

  TextStyle hintStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurfaceVariant);

  Color cursorColor(M3EColorScheme scheme) => scheme.primary;

  Color selectionColor(M3EColorScheme scheme) =>
      scheme.primary.withValues(alpha: selectionOpacity);

  EdgeInsetsGeometry padding({EdgeInsetsGeometry? override}) {
    return override ?? EdgeInsets.symmetric(horizontal: horizontalPadding);
  }

  ShapeBorder shape({ShapeBorder? override}) => override ?? M3EShapes.stadium;

  double resolveElevation({
    required Set<WidgetState> states,
    WidgetStateProperty<double?>? widgetValue,
    WidgetStateProperty<double?>? themeValue,
  }) {
    return widgetValue?.resolve(states) ??
        themeValue?.resolve(states) ??
        elevation;
  }

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
      restingExpandPadding:
          restingExpandPadding ?? this.restingExpandPadding,
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
      horizontalPadding:
          _lerpDouble(horizontalPadding, other.horizontalPadding, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      selectionOpacity:
          _lerpDouble(selectionOpacity, other.selectionOpacity, t)!,
      disabledOpacity:
          _lerpDouble(disabledOpacity, other.disabledOpacity, t)!,
      minWidth: _lerpDouble(minWidth, other.minWidth, t)!,
      maxWidth: _lerpDouble(maxWidth, other.maxWidth, t)!,
      minHeight: _lerpDouble(minHeight, other.minHeight, t)!,
      restingExpandPadding:
          _lerpDouble(restingExpandPadding, other.restingExpandPadding, t)!,
      expandOnFocus: t < 0.5 ? expandOnFocus : other.expandOnFocus,
      focusExpandSpring:
          t < 0.5 ? focusExpandSpring : other.focusExpandSpring,
      noLeadingHintExtraPadding: _lerpDouble(
        noLeadingHintExtraPadding,
        other.noLeadingHintExtraPadding,
        t,
      )!,
      pressedOverlayOpacity:
          _lerpDouble(pressedOverlayOpacity, other.pressedOverlayOpacity, t)!,
      hoveredOverlayOpacity:
          _lerpDouble(hoveredOverlayOpacity, other.hoveredOverlayOpacity, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
