import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3ETextField`.
@immutable
class M3ETextFieldTheme extends M3EThemeExtension<M3ETextFieldTheme> {
  /// M3ETextFieldTheme.
  const M3ETextFieldTheme({
    this.minHeight = 56,
    this.contentHeight = 48,
    this.contentVerticalPadding = 4,
    this.labelRestingOffset = 12,
    this.horizontalPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.iconSize = 24,
    this.iconGap = 12,
    this.labelFloatingTopPadding = 8,
    this.labelRestingTopPadding = 16,
    this.labelBottomPadding = 2,
    this.selectionOpacity = 0.4,
    this.supportingTextPadding = const EdgeInsets.only(
      left: 16,
      top: 4,
      right: 16,
    ),
  });

  /// defaults.

  static const M3ETextFieldTheme defaults = M3ETextFieldTheme();

  /// minHeight.

  final double minHeight;

  /// Minimum height of the label + input area. The area grows with the value.
  final double contentHeight;

  /// Breathing room around the input so multi-line values clear the outline.
  final double contentVerticalPadding;

  /// labelRestingOffset.
  final double labelRestingOffset;

  /// horizontalPadding.
  final EdgeInsets horizontalPadding;

  /// iconSize.
  final double iconSize;

  /// iconGap.
  final double iconGap;

  /// labelFloatingTopPadding.
  final double labelFloatingTopPadding;

  /// labelRestingTopPadding.
  final double labelRestingTopPadding;

  /// labelBottomPadding.
  final double labelBottomPadding;

  /// selectionOpacity.
  final double selectionOpacity;

  /// supportingTextPadding.
  final EdgeInsets supportingTextPadding;

  /// Height reserved above the input for the floating label.
  ///
  /// Reserved whether or not the label has floated, so focus never changes the
  /// field's height.
  double labelSlotHeight(M3ETypeScale type) {
    final TextStyle style = type.bodySmall;
    final double fontSize = style.fontSize ?? 12;
    return fontSize * (style.height ?? 1) + labelBottomPadding;
  }

  /// accentColor.

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

  /// Container fill and shape, without the indicator or outline.
  ///
  /// Paired with [borderDecoration] as a foreground decoration so the focused
  /// stroke width never changes the field's size.
  BoxDecoration backgroundDecoration(
    M3EColorScheme scheme, {
    required bool outlined,
  }) {
    if (outlined) {
      return const BoxDecoration(borderRadius: M3EShapes.radiusExtraSmall);
    }
    return BoxDecoration(
      color: scheme.surfaceContainerHighest,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
    );
  }

  /// Indicator or outline only, for painting over the container.
  BoxDecoration borderDecoration(
    M3EColorScheme scheme, {
    required Color accent,
    required bool outlined,
    required bool focused,
    required bool hasError,
  }) {
    final Color color = focused || hasError
        ? accent
        : (outlined ? scheme.outline : scheme.onSurfaceVariant);
    final double width = focused ? 2 : 1;
    if (outlined) {
      return BoxDecoration(
        borderRadius: M3EShapes.radiusExtraSmall,
        border: Border.all(color: color, width: width),
      );
    }
    return BoxDecoration(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      border: Border(
        bottom: BorderSide(color: color, width: width),
      ),
    );
  }

  /// Fill and border in one decoration.
  ///
  /// The field itself paints [backgroundDecoration] and [borderDecoration]
  /// separately so focus cannot resize it.
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
    double? contentHeight,
    double? contentVerticalPadding,
    double? labelRestingOffset,
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
      contentHeight: contentHeight ?? this.contentHeight,
      contentVerticalPadding:
          contentVerticalPadding ?? this.contentVerticalPadding,
      labelRestingOffset: labelRestingOffset ?? this.labelRestingOffset,
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
      contentHeight: _lerpDouble(contentHeight, other.contentHeight, t)!,
      contentVerticalPadding: _lerpDouble(
        contentVerticalPadding,
        other.contentVerticalPadding,
        t,
      )!,
      labelRestingOffset: _lerpDouble(
        labelRestingOffset,
        other.labelRestingOffset,
        t,
      )!,
      horizontalPadding: EdgeInsets.lerp(
        horizontalPadding,
        other.horizontalPadding,
        t,
      )!,
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
      labelBottomPadding: _lerpDouble(
        labelBottomPadding,
        other.labelBottomPadding,
        t,
      )!,
      selectionOpacity: _lerpDouble(
        selectionOpacity,
        other.selectionOpacity,
        t,
      )!,
      supportingTextPadding: EdgeInsets.lerp(
        supportingTextPadding,
        other.supportingTextPadding,
        t,
      )!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
