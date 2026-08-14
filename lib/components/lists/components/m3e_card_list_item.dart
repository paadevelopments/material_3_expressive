import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/lists/m3e_lists.dart'
    show M3ECardList;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3ECardList;

import '../../../foundations/foundations.dart';
import '../../cards/m3e_cards.dart';
import '../enums/m3e_list_enums.dart';
import 'm3e_card_radius_motion.dart';
import 'm3e_list_item_scope.dart';

/// Internal helper to calculate [M3ECardPosition] based on index and total.
M3ECardPosition calculateCardPosition(int index, int total) => total == 1
    ? M3ECardPosition.single
    : index == 0
    ? M3ECardPosition.first
    : index == total - 1
    ? M3ECardPosition.last
    : M3ECardPosition.middle;

/// Internal helper to calculate [BorderRadius] based on [M3ECardPosition].
BorderRadius calculateCardRadius({
  required M3ECardPosition position,
  required double outerRadius,
  required double innerRadius,
}) {
  switch (position) {
    case M3ECardPosition.single:
      return BorderRadius.circular(outerRadius);
    case M3ECardPosition.first:
      return BorderRadius.vertical(
        top: Radius.circular(outerRadius),
        bottom: Radius.circular(innerRadius),
      );
    case M3ECardPosition.last:
      return BorderRadius.vertical(
        top: Radius.circular(innerRadius),
        bottom: Radius.circular(outerRadius),
      );
    case M3ECardPosition.middle:
      return BorderRadius.circular(innerRadius);
  }
}

/// A single card item within an [M3ECardList].
class M3ECardListItem extends StatelessWidget {
  /// M3ECardListItem.
  const M3ECardListItem({
    required this.index,
    required this.position,
    required this.child,
    required this.outerRadius,
    required this.innerRadius,
    required this.gap,
    this.color,
    this.padding,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
    this.mouseCursor,
    this.haptic = M3EHapticFeedback.none,
    this.variant = M3ECardVariant.filled,
    this.border,
    this.resolvedColor,
    this.resolvedBorderRadius,
    super.key,
  });

  /// index.

  final int index;

  /// position.
  final M3ECardPosition position;

  /// child.
  final Widget child;

  /// outerRadius.
  final double outerRadius;

  /// innerRadius.
  final double innerRadius;

  /// gap.
  final double gap;

  /// color.
  final Color? color;

  /// padding.
  final EdgeInsetsGeometry? padding;

  /// Function.
  final void Function(int index)? onTap;

  /// Function.
  final void Function(int index)? onLongPress;

  /// semanticLabel.
  final String? semanticLabel;

  /// mouseCursor.
  final MouseCursor? mouseCursor;

  /// haptic.
  final M3EHapticFeedback haptic;

  /// Card variant for this item.
  final M3ECardVariant variant;

  /// Optional card outline.
  final BorderSide? border;

  /// Per-item color override. When null for an index, uses [color].
  final Color? resolvedColor;

  /// Per-item radius override. When null, uses position-based radii.
  final BorderRadius? resolvedBorderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final cardListTheme = theme.listTheme.cardList;

    final borderRadius =
        resolvedBorderRadius ??
        calculateCardRadius(
          position: position,
          outerRadius: outerRadius,
          innerRadius: innerRadius,
        );

    final bool isLast =
        position == M3ECardPosition.last || position == M3ECardPosition.single;

    final VoidCallback? wrappedOnTap = onTap != null
        ? () => onTap!(index)
        : null;
    final VoidCallback? wrappedOnLongPress = onLongPress != null
        ? () => onLongPress!(index)
        : null;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : gap),
      child: M3ECardRadiusMotion(
        radius: borderRadius,
        builder: (BuildContext context, BorderRadius animatedRadius) {
          return M3ECard(
            variant: variant,
            border: border,
            borderRadius: animatedRadius,
            color:
                resolvedColor ?? color ?? cardListTheme.backgroundColor(scheme),
            padding: padding ?? cardListTheme.itemPadding,
            onPressed: wrappedOnTap,
            onLongPress: wrappedOnLongPress,
            mouseCursor: mouseCursor,
            semanticLabel: semanticLabel,
            haptic: haptic,
            width: double.infinity,
            animationDuration: Duration.zero,
            child: M3EListItemScope(child: child),
          );
        },
      ),
    );
  }
}
