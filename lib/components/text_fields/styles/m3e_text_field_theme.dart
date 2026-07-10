import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ETextField`.
@immutable
class M3ETextFieldTheme extends M3EThemeExtension<M3ETextFieldTheme> {
  const M3ETextFieldTheme({
    this.minHeight = 56,
    this.horizontalPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.iconSize = 24,
    this.iconGap = 12,
    this.labelFloatingTopPadding = 8,
    this.labelRestingTopPadding = 16,
    this.labelBottomPadding = 2,
    this.selectionOpacity = 0.4,
    this.supportingTextPadding =
        const EdgeInsets.only(left: 16, top: 4, right: 16),
  });

  static const M3ETextFieldTheme defaults = M3ETextFieldTheme();

  final double minHeight;
  final EdgeInsets horizontalPadding;
  final double iconSize;
  final double iconGap;
  final double labelFloatingTopPadding;
  final double labelRestingTopPadding;
  final double labelBottomPadding;
  final double selectionOpacity;
  final EdgeInsets supportingTextPadding;

  Color accentColor(
    M3EColorScheme scheme, {
    required bool enabled,
    required bool hasError,
  }) {
    if (!enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return hasError ? scheme.error : scheme.primary;
  }

  BoxDecoration decoration(
    M3EColorScheme scheme, {
    required Color accent,
    required bool outlined,
    required bool focused,
    required bool hasError,
  }) {
    if (outlined) {
      return BoxDecoration(
        borderRadius: M3EShapes.radiusExtraSmall,
        border: Border.all(
          color: focused || hasError ? accent : scheme.outline,
          width: focused ? 2 : 1,
        ),
      );
    }
    return BoxDecoration(
      color: scheme.surfaceContainerHighest,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      border: Border(
        bottom: BorderSide(
          color: focused || hasError ? accent : scheme.onSurfaceVariant,
          width: focused ? 2 : 1,
        ),
      ),
    );
  }

  @override
  M3ETextFieldTheme copyWith({
    double? minHeight,
    EdgeInsets? horizontalPadding,
    double? iconSize,
    double? iconGap,
    double? labelFloatingTopPadding,
    double? labelRestingTopPadding,
    double? labelBottomPadding,
    double? selectionOpacity,
    EdgeInsets? supportingTextPadding,
  }) {
    return M3ETextFieldTheme(
      minHeight: minHeight ?? this.minHeight,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      iconSize: iconSize ?? this.iconSize,
      iconGap: iconGap ?? this.iconGap,
      labelFloatingTopPadding:
          labelFloatingTopPadding ?? this.labelFloatingTopPadding,
      labelRestingTopPadding:
          labelRestingTopPadding ?? this.labelRestingTopPadding,
      labelBottomPadding: labelBottomPadding ?? this.labelBottomPadding,
      selectionOpacity: selectionOpacity ?? this.selectionOpacity,
      supportingTextPadding:
          supportingTextPadding ?? this.supportingTextPadding,
    );
  }

  @override
  M3ETextFieldTheme lerp(M3ETextFieldTheme? other, double t) {
    if (other is! M3ETextFieldTheme) {
      return this;
    }
    return M3ETextFieldTheme(
      minHeight: _lerpDouble(minHeight, other.minHeight, t)!,
      horizontalPadding:
          EdgeInsets.lerp(horizontalPadding, other.horizontalPadding, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      iconGap: _lerpDouble(iconGap, other.iconGap, t)!,
      labelFloatingTopPadding: _lerpDouble(
        labelFloatingTopPadding,
        other.labelFloatingTopPadding,
        t,
      )!,
      labelRestingTopPadding: _lerpDouble(
        labelRestingTopPadding,
        other.labelRestingTopPadding,
        t,
      )!,
      labelBottomPadding:
          _lerpDouble(labelBottomPadding, other.labelBottomPadding, t)!,
      selectionOpacity:
          _lerpDouble(selectionOpacity, other.selectionOpacity, t)!,
      supportingTextPadding: EdgeInsets.lerp(
        supportingTextPadding,
        other.supportingTextPadding,
        t,
      )!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
