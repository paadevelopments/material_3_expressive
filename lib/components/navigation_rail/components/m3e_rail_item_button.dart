// Vendored from the `navigation_rail_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_rail_m3e/lib).
// The logic is kept identical to the reference `RailItemButtonM3E`; only the
// public identifiers carry the `M3E` prefix and it uses this package's own
// `M3EIconButton`.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.

import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/navigation_rail/components/m3e_nav_selection_indicator.dart'
    show M3ENavSelectionIndicator;
import 'package:material_3_expressive/components/navigation_rail/styles/m3e_navigation_rail_theme.dart'
    show M3ENavigationRailTheme;

import '../../../foundations/foundations.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';
import '../enums/m3e_navigation_rail_enums.dart';
import 'm3e_nav_icon_scale.dart';
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
    this.useLocalIndicator = true,
    this.indicatorKey,
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

  /// When false, selection fill is drawn by [M3ENavSelectionIndicator] instead.
  final bool useLocalIndicator;

  /// Key on the region the shared selection indicator should cover.
  final GlobalKey? indicatorKey;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context).navigationRailTheme;
    final m3e = M3ETheme.of(context);
    final scheme = m3e.colorScheme;
    final double height =
        heightOverride ??
        (expanded ? theme.itemExpandedHeight : theme.itemCollapsedHeight);
    final bool selected = isSelected;
    final Color fg = selected
        ? theme.activeIconAndLabelColor(scheme)
        : theme.inactiveIconAndLabelColor(scheme);
    final Color bg = useLocalIndicator && expanded && selected
        ? theme.activeIndicatorColorResolved(scheme)
        : Colors.transparent;
    final ShapeBorder shape = expanded
        ? (theme.indicatorShapeFull ??
              RoundedRectangleBorder(borderRadius: M3EShapes.roundSet.xs))
        : const RoundedRectangleBorder();
    final Widget scaledIcon = M3ENavIconScale(
      selected: selected,
      child: IconTheme.merge(
        data: IconThemeData(color: fg, size: theme.iconSize),
        child: selected && selectedIcon != null ? selectedIcon! : icon,
      ),
    );
    final Widget content = expanded
        ? _buildExpandedContent(
            m3e: m3e,
            theme: theme,
            fg: fg,
            scaledIcon: scaledIcon,
          )
        : _buildCollapsedContent(
            m3e: m3e,
            theme: theme,
            fg: fg,
            scaledIcon: scaledIcon,
          );
    final material = Material(
      key: expanded ? indicatorKey : null,
      color: bg,
      shape: shape,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        splashFactory: NoSplash.splashFactory,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
        child: Padding(
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

  Widget _buildExpandedContent({
    required M3EThemeData m3e,
    required M3ENavigationRailTheme theme,
    required Color fg,
    required Widget scaledIcon,
  }) {
    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              scaledIcon,
              SizedBox(width: theme.iconLabelGap),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  semanticsLabel: semanticLabel ?? label,
                  style: m3e.typeScale.labelLarge.copyWith(color: fg),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: theme.iconLabelGap),
          child: M3ERailBadge(count: badgeCount),
        ),
      ],
    );
  }

  Widget _buildCollapsedContent({
    required M3EThemeData m3e,
    required M3ENavigationRailTheme theme,
    required Color fg,
    required Widget scaledIcon,
  }) {
    final bool showLabel =
        labelBehavior == M3ENavigationRailLabelBehavior.alwaysShow ||
        (isSelected &&
            labelBehavior != M3ENavigationRailLabelBehavior.alwaysHide);
    return Column(
      children: [
        KeyedSubtree(
          key: indicatorKey,
          child: M3EIconButton(
            icon: scaledIcon,
            width: M3EIconButtonWidth.wide,
            badgeValue: badgeCount,
            onPressed: onPressed,
            suppressInk: true,
            variant: useLocalIndicator && isSelected
                ? M3EIconButtonVariant.tonal
                : M3EIconButtonVariant.standard,
          ),
        ),
        if (showLabel)
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              semanticsLabel: semanticLabel ?? label,
              style: m3e.typeScale.labelMedium.copyWith(color: fg),
            ),
          ),
      ],
    );
  }
}
