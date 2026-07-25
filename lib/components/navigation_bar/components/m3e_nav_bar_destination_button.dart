import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/navigation_bar/m3e_navigation_bar.dart'
    show M3ENavigationBar;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3ENavigationBar;

import '../../navigation_rail/components/m3e_nav_icon_scale.dart';
import '../enums/m3e_nav_bar_enums.dart';
import '../models/m3e_navigation_bar_destination.dart';

/// Single destination cell inside [M3ENavigationBar].
///
/// No ink splash — selection feedback is the pill (local resting fill plus the
/// shared liquid morph overlay while traveling).
class M3ENavBarDestinationButton extends StatelessWidget {
  /// M3ENavBarDestinationButton.
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

  /// destination.

  final M3ENavigationBarDestination destination;

  /// selected.
  final bool selected;

  /// selectedColor.
  final Color selectedColor;

  /// unselectedColor.
  final Color unselectedColor;

  /// labelStyle.
  final TextStyle labelStyle;

  /// iconSize.
  final double iconSize;

  /// labelBehavior.
  final M3ENavBarLabelBehavior labelBehavior;

  /// indicatorStyle.
  final M3ENavBarIndicatorStyle indicatorStyle;

  /// indicatorKey.
  final GlobalKey indicatorKey;

  /// indicatorWidth.
  final double indicatorWidth;

  /// indicatorHeight.
  final double indicatorHeight;

  /// underlineThickness.
  final double underlineThickness;

  /// underlineColor.
  final Color underlineColor;

  /// indicatorColor.
  final Color indicatorColor;

  /// onTap.
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
        child: destination.buildIcon(selected: selected),
      ),
    );

    final bool paintRestingPill =
        selected &&
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
