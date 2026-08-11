import 'package:flutter/widgets.dart';

import '../../../foundations/m3e_color_scheme.dart';
import '../../../foundations/m3e_theme_extension.dart';
import '../../cards/enums/m3e_card_variant.dart';
import '../../lists/styles/m3e_list_theme.dart';

/// Theme values for selection list and selection app bar.
@immutable
class M3ESelectionTheme extends M3EThemeExtension<M3ESelectionTheme> {
  /// Creates a selection theme.
  const M3ESelectionTheme({
    this.outerRadius = M3EListCardListTheme.defaultOuterRadius,
    this.innerRadius = M3EListCardListTheme.defaultInnerRadius,
    this.gap = M3EListCardListTheme.defaultGap,
    this.itemPadding = M3EListCardListTheme.defaultItemPadding,
    this.variant = M3ECardVariant.filled,
    this.border,
    this.leadingFlipDuration = const Duration(milliseconds: 220),
    this.selectAllHeight = 48,
    this.contextualToolbarHeight = 64,
  });

  /// defaults.
  static const M3ESelectionTheme defaults = M3ESelectionTheme();

  /// Outer card radius (also used for selected equal corners).
  final double outerRadius;

  /// Inner card radius for unselected stacked cards.
  final double innerRadius;

  /// Gap between cards.
  final double gap;

  /// Padding inside each card.
  final EdgeInsetsGeometry itemPadding;

  /// Card variant.
  final M3ECardVariant variant;

  /// Optional outline.
  final BorderSide? border;

  /// Duration for leading horizontal flip.
  final Duration leadingFlipDuration;

  /// Height of the select-all row under the contextual bar.
  final double selectAllHeight;

  /// Height of the contextual selection toolbar (excluding safe area).
  final double contextualToolbarHeight;

  /// Selected card fill.
  Color selectedColor(M3EColorScheme scheme) => scheme.secondaryContainer;

  /// Contextual selection app bar container.
  Color contextualBackground(M3EColorScheme scheme) => scheme.primaryContainer;

  /// Content on the contextual selection app bar.
  Color contextualForeground(M3EColorScheme scheme) =>
      scheme.onPrimaryContainer;

  @override
  M3ESelectionTheme copyWith({
    double? outerRadius,
    double? innerRadius,
    double? gap,
    EdgeInsetsGeometry? itemPadding,
    M3ECardVariant? variant,
    BorderSide? border,
    Duration? leadingFlipDuration,
    double? selectAllHeight,
    double? contextualToolbarHeight,
  }) {
    return M3ESelectionTheme(
      outerRadius: outerRadius ?? this.outerRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      gap: gap ?? this.gap,
      itemPadding: itemPadding ?? this.itemPadding,
      variant: variant ?? this.variant,
      border: border ?? this.border,
      leadingFlipDuration: leadingFlipDuration ?? this.leadingFlipDuration,
      selectAllHeight: selectAllHeight ?? this.selectAllHeight,
      contextualToolbarHeight:
          contextualToolbarHeight ?? this.contextualToolbarHeight,
    );
  }

  @override
  M3ESelectionTheme lerp(M3ESelectionTheme? other, double t) {
    if (other is! M3ESelectionTheme) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}
