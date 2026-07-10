import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/lists/m3e_lists.dart' show M3ECardList;
import 'package:material_3_expressive/material_3_expressive.dart' show M3ECardList;

import '../../../foundations/foundations.dart';
import '../../buttons/enums/m3e_button_enums.dart';
import '../../cards/m3e_cards.dart';
import '../enums/m3e_list_enums.dart';
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
    super.key,
  });

  final int index;
  final M3ECardPosition position;
  final Widget child;
  final double outerRadius;
  final double innerRadius;
  final double gap;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final void Function(int index)? onTap;
  final void Function(int index)? onLongPress;
  final String? semanticLabel;
  final MouseCursor? mouseCursor;
  final M3EHapticFeedback haptic;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final cardListTheme = theme.listTheme.cardList;

    final borderRadius = calculateCardRadius(
      position: position,
      outerRadius: outerRadius,
      innerRadius: innerRadius,
    );

    final bool isLast =
        position == M3ECardPosition.last || position == M3ECardPosition.single;

    final VoidCallback? wrappedOnTap = onTap != null ? () => onTap!(index) : null;
    final VoidCallback? wrappedOnLongPress =
        onLongPress != null ? () => onLongPress!(index) : null;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : gap),
      child: M3ECard(
        variant: M3ECardVariant.filled,
        borderRadius: borderRadius,
        color: color ?? cardListTheme.backgroundColor(scheme),
        padding: padding ?? cardListTheme.itemPadding,
        onPressed: wrappedOnTap,
        onLongPress: wrappedOnLongPress,
        mouseCursor: mouseCursor,
        semanticLabel: semanticLabel,
        haptic: haptic,
        width: double.infinity,
        child: M3EListItemScope(child: child),
      ),
    );
  }
}
