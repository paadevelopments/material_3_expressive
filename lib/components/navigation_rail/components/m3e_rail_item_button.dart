// Vendored from the `navigation_rail_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_rail_m3e/lib).
// The logic is kept identical to the reference `RailItemButtonM3E`; only the
// public identifiers carry the `M3E` prefix and it uses this package's own
// `M3EIconButton`.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';
import '../enums/m3e_navigation_rail_enums.dart';
import 'm3e_rail_badge_view.dart';

/// Internal button used by the NavigationRail item that can look like
/// an IconButton (collapsed) or a text button (expanded) without
/// switching widget types. This avoids animation hitches when the
/// rail animates between collapsed and expanded.
class M3ERailItemButton extends StatelessWidget {
  /// Creates a [M3ERailItemButton].
  const M3ERailItemButton({
    super.key,
    required this.icon,
    this.selectedIcon,
    required this.isSelected,
    required this.onPressed,
    required this.expanded,
    required this.labelBehavior,
    required this.label,
    this.semanticLabel,
    this.suppressInk = false,
    this.badgeCount,
    this.heightOverride,
  });

  /// Icon to display.
  final Widget icon;

  /// Optional icon to display when [isSelected] is true; falls back to [icon].
  final Widget? selectedIcon;

  /// Whether this destination is currently selected.
  final bool isSelected;

  /// Callback when the button is tapped.
  final VoidCallback onPressed;

  /// Whether the rail is in expanded layout.
  final bool expanded;

  /// Controls when the text label is visible in collapsed mode.
  final M3ENavigationRailLabelBehavior labelBehavior;

  /// Text label for the destination.
  final String label;

  /// Semantic label used for accessibility (and tooltip when collapsed).
  final String? semanticLabel;

  /// If true, suppresses Ink splash/hover effects.
  final bool suppressInk;

  /// Optional numeric badge value to show.
  final int? badgeCount;

  /// Optional min height to enforce for the tap target. When null, defaults
  /// to the theme's [M3ENavigationRailTheme.itemExpandedHeight] or
  /// [M3ENavigationRailTheme.itemCollapsedHeight] depending on [expanded].
  final double? heightOverride;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context).navigationRailTheme;
    final m3e = M3ETheme.of(context);
    final scheme = m3e.colorScheme;

    final double defaultHeight =
        expanded ? theme.itemExpandedHeight : theme.itemCollapsedHeight;
    final double height = heightOverride ?? defaultHeight;

    final bool selected = isSelected;

    // Prefer theme overrides; otherwise match M3 rail tokens (same as nav bar).
    final Color activeIconLabel =
        theme.activeIconAndLabelColor(scheme);
    final Color inactiveIconLabel =
        theme.inactiveIconAndLabelColor(scheme);
    final Color activeIndicator =
        theme.activeIndicatorColorResolved(scheme);
    final ShapeBorder indicatorShape = theme.indicatorShapeFull ??
        RoundedRectangleBorder(borderRadius: M3EShapes.roundSet.xs);

    final Color fg = selected ? activeIconLabel : inactiveIconLabel;
    final Color bg = expanded && selected ? activeIndicator : Colors.transparent;
    final ShapeBorder shape =
        expanded ? indicatorShape : const RoundedRectangleBorder();

    // Content
    final Widget effectiveIcon =
        selected && selectedIcon != null ? selectedIcon! : icon;

    Widget content;
    if (expanded) {
      final textExpanded = Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: semanticLabel ?? label,
          style: m3e.typeScale.labelLarge.copyWith(color: fg),
        ),
      );

      content = Row(
        children: [
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme.merge(
                  data: IconThemeData(color: fg, size: theme.iconSize),
                  child: effectiveIcon,
                ),
                SizedBox(width: theme.iconLabelGap),
                textExpanded,
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: theme.iconLabelGap),
            child: M3ERailBadge(count: badgeCount),
          ),
        ],
      );
    } else {
      final textCollapsed = Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: semanticLabel ?? label,
          style: m3e.typeScale.labelMedium.copyWith(color: fg),
        ),
      );

      content = Column(
        children: [
          M3EIconButton(
            icon: IconTheme.merge(
              data: IconThemeData(color: fg, size: theme.iconSize),
              child: effectiveIcon,
            ),
            width: M3EIconButtonWidth.wide,
            badgeValue: badgeCount,
            onPressed: onPressed,
            variant: isSelected
                ? M3EIconButtonVariant.tonal
                : M3EIconButtonVariant.standard,
            shape: M3EIconButtonShapeVariant.round,
          ),
          if (labelBehavior == M3ENavigationRailLabelBehavior.alwaysShow ||
              (isSelected == true &&
                  labelBehavior != M3ENavigationRailLabelBehavior.alwaysHide))
            textCollapsed,
        ],
      );
    }

    // Material/Ink wrapper. Respect [suppressInk] to avoid flicker during transitions.
    final bool noInk = suppressInk || !expanded;
    final Material material = Material(
      color: bg,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        splashFactory: noInk ? NoSplash.splashFactory : null,
        hoverColor: noInk ? Colors.transparent : null,
        highlightColor: noInk ? Colors.transparent : null,
        child: Padding(
          // Horizontal padding similar to ButtonM3E sm; for collapsed, none.
          padding: expanded
              ? EdgeInsetsDirectional.only(
                  start: theme.indicatorLeading,
                  end: theme.indicatorTrailing,
                )
              : EdgeInsets.zero,
          child: Align(
            alignment: expanded ? Alignment.centerLeft : Alignment.center,
            child: IconTheme.merge(
              data: IconThemeData(color: fg, size: theme.iconSize),
              child: content,
            ),
          ),
        ),
      ),
    );

    final Widget sized = ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: material,
    );

    // Tooltip semantics for collapsed state.
    final Widget withTooltip = expanded
        ? sized
        : Tooltip(
            message: semanticLabel ?? label,
            preferBelow: false,
            child: sized,
          );

    return Semantics(
      button: true,
      selected: selected,
      label: expanded ? null : (semanticLabel ?? label),
      child: withTooltip,
    );
  }
}
