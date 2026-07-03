import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../buttons/enums/m3e_button_enums.dart';
import '../../buttons/styles/m3e_button_tokens.dart';
import '../enums/m3e_list_enums.dart';
import '../styles/m3e_card_list_tokens.dart';

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

    final borderRadius = calculateCardRadius(
      position: position,
      outerRadius: outerRadius,
      innerRadius: innerRadius,
    );

    final bool isLast =
        position == M3ECardPosition.last || position == M3ECardPosition.single;

    final VoidCallback? wrappedOnTap = onTap != null
        ? () {
            onTap!(index);
            M3EButtonConstants.triggerHapticFeedback(haptic);
          }
        : null;

    final VoidCallback? wrappedOnLongPress =
        onLongPress != null ? () => onLongPress!(index) : null;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : gap),
      child: M3ETappable(
        onTap: wrappedOnTap,
        onLongPress: wrappedOnLongPress,
        mouseCursor: mouseCursor,
        semanticLabel: semanticLabel,
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              color: color ?? M3ECardListTokens.backgroundColor(scheme),
              borderRadius: borderRadius,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                M3EStateLayerOverlay(
                  state: state,
                  color: scheme.onSurface,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                ),
                Padding(
                  padding: padding ?? M3ECardListTokens.itemPadding,
                  child: child,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
