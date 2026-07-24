import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../navigation_rail/components/m3e_nav_icon_scale.dart';
import '../enums/m3e_nav_bar_enums.dart';
import '../models/m3e_navigation_bar_destination.dart';

/// Single destination cell inside [M3ENavigationBar].
///
/// No ink splash — selection feedback is the pill (local resting fill plus the
/// shared liquid morph overlay while traveling).
class M3ENavBarDestinationButton extends StatelessWidget {
  const M3ENavBarDestinationButton({
    required this.destination,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.labelStyle,
    required this.iconSize,
    required this.labelBehavior,
    required this.indicatorStyle,
    required this.indicatorKey,
    required this.indicatorWidth,
    required this.indicatorHeight,
    required this.underlineThickness,
    required this.underlineColor,
    required this.indicatorColor,
    required this.onTap,
    this.showRestingPill = true,
    super.key,
  });

  final M3ENavigationBarDestination destination;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;
  final TextStyle labelStyle;
  final double iconSize;
  final M3ENavBarLabelBehavior labelBehavior;
  final M3ENavBarIndicatorStyle indicatorStyle;
  final GlobalKey indicatorKey;
  final double indicatorWidth;
  final double indicatorHeight;
  final double underlineThickness;
  final Color underlineColor;
  final Color indicatorColor;
  final VoidCallback onTap;

  /// When false, the shared liquid overlay owns the pill (during travel).
  final bool showRestingPill;

  bool get _showLabel {
    switch (labelBehavior) {
      case M3ENavBarLabelBehavior.alwaysShow:
        return true;
      case M3ENavBarLabelBehavior.onlySelected:
        return selected;
      case M3ENavBarLabelBehavior.alwaysHide:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color fg = selected ? selectedColor : unselectedColor;
    Widget icon = M3ENavIconScale(
      selected: selected,
      child: IconTheme.merge(
        data: IconThemeData(color: fg, size: iconSize),
        child: destination.buildIcon(selected),
      ),
    );

    final bool paintRestingPill = selected &&
        showRestingPill &&
        indicatorStyle == M3ENavBarIndicatorStyle.pill;

    icon = KeyedSubtree(
      key: indicatorKey,
      child: SizedBox(
        width: indicatorWidth,
        height: indicatorHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: paintRestingPill ? indicatorColor : const Color(0x00000000),
            borderRadius: BorderRadius.circular(
              math.min(indicatorWidth, indicatorHeight) / 2,
            ),
          ),
          child: Center(child: icon),
        ),
      ),
    );

    if (indicatorStyle == M3ENavBarIndicatorStyle.underline && selected) {
      icon = DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: underlineColor,
              width: underlineThickness,
            ),
          ),
        ),
        child: icon,
      );
    }

    return Semantics(
      button: true,
      selected: selected,
      label: destination.semanticLabel ?? destination.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            if (_showLabel) ...<Widget>[
              const SizedBox(height: 4),
              Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle.copyWith(color: fg),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
