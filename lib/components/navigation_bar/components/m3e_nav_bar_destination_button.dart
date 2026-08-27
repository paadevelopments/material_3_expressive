import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../navigation_rail/components/m3e_nav_icon_scale.dart';
import '../enums/m3e_nav_bar_enums.dart';
import '../models/m3e_navigation_bar_destination.dart';
import '../res/m3e_nav_bar_constants.dart';

/// Single destination cell inside the M3E navigation bar.
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
    required this.iconBehavior,
    required this.layout,
    required this.indicatorStyle,
    required this.indicatorKey,
    required this.indicatorWidth,
    required this.indicatorHeight,
    required this.underlineThickness,
    required this.underlineColor,
    required this.indicatorColor,
    required this.onTap,
    this.wideDestinationWidth,
    this.haptic = M3EHapticFeedback.none,
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

  /// iconBehavior.
  final M3ENavBarIconBehavior iconBehavior;

  /// layout.
  final M3ENavBarLayout layout;

  /// indicatorStyle.
  final M3ENavBarIndicatorStyle indicatorStyle;

  /// indicatorKey.
  final GlobalKey indicatorKey;

  /// indicatorWidth.
  final double indicatorWidth;

  /// indicatorHeight.
  final double indicatorHeight;

  /// Fixed chip width in wide layout (ignored in compact).
  final double? wideDestinationWidth;

  /// underlineThickness.
  final double underlineThickness;

  /// underlineColor.
  final Color underlineColor;

  /// indicatorColor.
  final Color indicatorColor;

  /// onTap.
  final VoidCallback onTap;

  /// Haptic intensity on tap. Defaults to [M3EHapticFeedback.none].
  final M3EHapticFeedback haptic;

  /// When false, the shared liquid overlay owns the pill (during travel).
  final bool showRestingPill;

  bool get _showLabel {
    if (!destination.hasLabel) {
      return false;
    }
    return switch (labelBehavior) {
      M3ENavBarLabelBehavior.alwaysShow => true,
      M3ENavBarLabelBehavior.onlySelected => selected,
      M3ENavBarLabelBehavior.alwaysHide => false,
    };
  }

  bool get _showIcon {
    if (!destination.hasIcon) {
      return false;
    }
    return switch (iconBehavior) {
      M3ENavBarIconBehavior.alwaysShow => true,
      M3ENavBarIconBehavior.onlySelected => selected,
      M3ENavBarIconBehavior.alwaysHide => false,
    };
  }

  bool get _paintRestingPill =>
      selected &&
      showRestingPill &&
      indicatorStyle == M3ENavBarIndicatorStyle.pill;

  @override
  Widget build(BuildContext context) {
    final Color fg = selected ? selectedColor : unselectedColor;
    final Widget content = layout == M3ENavBarLayout.wide
        ? _buildWideContent(fg)
        : _buildCompactContent(fg);

    return Semantics(
      button: true,
      selected: selected,
      label: destination.resolvedSemanticLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            M3EHaptics.trigger(haptic);
            onTap();
          },
          child: content,
        ),
      ),
    );
  }

  Widget _buildCompactContent(Color fg) {
    Widget? icon;
    if (_showIcon) {
      icon = M3ENavIconScale(
        selected: selected,
        child: IconTheme.merge(
          data: IconThemeData(color: fg, size: iconSize),
          child: destination.buildIcon(selected: selected),
        ),
      );
      icon = KeyedSubtree(
        key: indicatorKey,
        child: SizedBox(
          width: indicatorWidth,
          height: indicatorHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _paintRestingPill
                  ? indicatorColor
                  : const Color(0x00000000),
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
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ?icon,
        if (_showLabel) ...<Widget>[
          if (icon != null) const SizedBox(height: 4),
          Text(
            destination.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: labelStyle.copyWith(color: fg),
          ),
        ],
      ],
    );
  }

  Widget _buildWideContent(Color fg) {
    final List<Widget> children = _wideChipChildren(fg);
    Widget chip = _buildWideChip(children);
    if (indicatorStyle == M3ENavBarIndicatorStyle.underline && selected) {
      chip = _wrapWideUnderline(chip);
    }
    return Center(child: chip);
  }

  List<Widget> _wideChipChildren(Color fg) {
    final children = <Widget>[];
    if (_showIcon) {
      children.add(
        M3ENavIconScale(
          selected: selected,
          child: IconTheme.merge(
            data: IconThemeData(color: fg, size: iconSize),
            child: destination.buildIcon(selected: selected),
          ),
        ),
      );
    }
    if (_showLabel) {
      if (children.isNotEmpty) {
        children.add(
          const SizedBox(width: M3ENavBarConstants.wideIconLabelGap),
        );
      }
      children.add(
        Flexible(
          child: Text(
            destination.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: labelStyle.copyWith(color: fg),
          ),
        ),
      );
    }
    return children;
  }

  double get _wideChipHorizontalPadding {
    // Stadium radius is height/2; horizontal padding must clear the curved
    // caps or the icon sits in the cutout and looks clipped by the pill.
    return math.max(
      M3ENavBarConstants.widePillHorizontalPadding,
      indicatorHeight / 2 + M3ENavBarConstants.widePillCapClearance,
    );
  }

  Widget _buildWideChip(List<Widget> children) {
    final double chipWidth =
        wideDestinationWidth ?? M3ENavBarConstants.wideDestinationWidth;
    return KeyedSubtree(
      key: indicatorKey,
      child: SizedBox(
        width: chipWidth,
        height: indicatorHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _paintRestingPill ? indicatorColor : const Color(0x00000000),
            borderRadius: BorderRadius.circular(indicatorHeight / 2),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _wideChipHorizontalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Widget _wrapWideUnderline(Widget chip) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: underlineColor, width: underlineThickness),
        ),
      ),
      child: chip,
    );
  }
}
