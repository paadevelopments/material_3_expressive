import 'package:material_3_expressive/components/navigation_rail/components/m3e_nav_selection_indicator.dart'
    show M3ENavSelectionIndicator;
import 'package:material_3_expressive/components/navigation_rail/styles/m3e_navigation_rail_theme.dart'
    show M3ENavigationRailTheme;
import 'package:material_ui/material_ui.dart';

import '../../../foundations/foundations.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';
import '../../tooltips/m3e_tooltips.dart';
import '../enums/m3e_navigation_rail_enums.dart';
import 'm3e_nav_icon_scale.dart';
import 'm3e_rail_badge_view.dart';

/// Internal button used by the NavigationRail item that can look like
/// an IconButton (collapsed) or a text button (expanded) without
/// switching widget types. This avoids animation hitches when the
/// rail animates between collapsed and expanded.
///
/// Expanded destinations own their keyboard focus (shared [M3EFocusRing] plus
/// Space/Enter activation); collapsed ones defer to the inner [M3EIconButton].
class M3ERailItemButton extends StatefulWidget {
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
    this.haptic = M3EHapticFeedback.none,
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

  /// Key for the local indicator when [useLocalIndicator] is true.
  final GlobalKey? indicatorKey;

  /// Haptic intensity on tap. Defaults to [M3EHapticFeedback.none].
  final M3EHapticFeedback haptic;

  @override
  State<M3ERailItemButton> createState() => _M3ERailItemButtonState();
}

class _M3ERailItemButtonState extends State<M3ERailItemButton> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    M3EFocusInteraction.instance.addListener(_onFocusInteractionChanged);
  }

  @override
  void dispose() {
    M3EFocusInteraction.instance.removeListener(_onFocusInteractionChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusInteractionChanged() {
    _handleFocusHighlight(_focusNode.hasPrimaryFocus);
  }

  void _handleFocusHighlight(bool value) {
    if (!mounted) {
      return;
    }
    final bool show =
        value &&
        M3EFocusInteraction.instance.ringsAllowed &&
        M3EFocusRing.shouldShow(_focusNode, context);
    if (_focused == show) {
      return;
    }
    setState(() => _focused = show);
    if (show) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        M3EFocusInteraction.ensureVisibleIfKeyboard(context);
      });
    }
  }

  void _select({bool fromPointer = false}) {
    if (fromPointer) {
      M3EFocusInteraction.instance.notePointerInteraction();
      _focusNode.requestFocus();
    }
    M3EHaptics.trigger(widget.haptic);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context).navigationRailTheme;
    final m3e = M3ETheme.of(context);
    final scheme = m3e.colorScheme;
    final bool expanded = widget.expanded;
    final double height =
        widget.heightOverride ??
        (expanded ? theme.itemExpandedHeight : theme.itemCollapsedHeight);
    final bool selected = widget.isSelected;
    final Color fg = selected
        ? theme.activeIconAndLabelColor(scheme)
        : theme.inactiveIconAndLabelColor(scheme);
    final Color bg = widget.useLocalIndicator && expanded && selected
        ? theme.activeIndicatorColorResolved(scheme)
        : Colors.transparent;
    final ShapeBorder shape = expanded
        ? (theme.indicatorShapeFull ??
              RoundedRectangleBorder(borderRadius: M3EShapes.roundSet.xs))
        : const RoundedRectangleBorder();
    final Widget scaledIcon = _buildScaledIcon(fg: fg, theme: theme);
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
    final Widget material = _buildItemMaterial(
      theme: theme,
      expanded: expanded,
      bg: bg,
      shape: shape,
      fg: fg,
      content: content,
    );
    Widget sized = ConstrainedBox(
      constraints: BoxConstraints(minHeight: height),
      child: material,
    );
    if (expanded) {
      sized = M3EFocusRing(
        focused: _focused,
        radius: _ringRadius(shape),
        child: sized,
      );
    }
    final Widget withTooltip = expanded
        ? sized
        : M3ETooltip(
            message: widget.semanticLabel ?? widget.label,
            child: sized,
          );
    return Semantics(
      button: true,
      selected: selected,
      label: expanded ? null : (widget.semanticLabel ?? widget.label),
      child: expanded
          ? _wrapExpandedFocus(withTooltip)
          : MouseRegion(cursor: SystemMouseCursors.click, child: withTooltip),
    );
  }

  Widget _buildScaledIcon({
    required Color fg,
    required M3ENavigationRailTheme theme,
  }) {
    return M3ENavIconScale(
      selected: widget.isSelected,
      child: IconTheme.merge(
        data: IconThemeData(color: fg, size: theme.iconSize),
        child: widget.isSelected && widget.selectedIcon != null
            ? widget.selectedIcon!
            : widget.icon,
      ),
    );
  }

  Widget _buildItemMaterial({
    required M3ENavigationRailTheme theme,
    required bool expanded,
    required Color bg,
    required ShapeBorder shape,
    required Color fg,
    required Widget content,
  }) {
    return Material(
      key: expanded ? widget.indicatorKey : null,
      color: bg,
      shape: shape,
      child: InkWell(
        onTap: () => _select(fromPointer: true),
        mouseCursor: SystemMouseCursors.click,
        // Focus is owned by the expanded destination's detector below, and by
        // the inner icon button when collapsed.
        canRequestFocus: false,
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
  }

  Widget _wrapExpandedFocus(Widget child) {
    return FocusableActionDetector(
      focusNode: _focusNode,
      mouseCursor: SystemMouseCursors.click,
      onShowFocusHighlight: _handleFocusHighlight,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (ActivateIntent intent) {
            _select();
            return null;
          },
        ),
        ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
          onInvoke: (ButtonActivateIntent intent) {
            _select();
            return null;
          },
        ),
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) {
          M3EFocusInteraction.instance.notePointerInteraction();
        },
        child: child,
      ),
    );
  }

  BorderRadius _ringRadius(ShapeBorder shape) {
    if (shape is RoundedRectangleBorder) {
      return shape.borderRadius.resolve(Directionality.of(context));
    }
    return M3EShapes.roundSet.xs;
  }

  Widget _buildExpandedContent({
    required M3EThemeData m3e,
    required M3ENavigationRailTheme theme,
    required Color fg,
    required Widget scaledIcon,
  }) {
    // Spec: when icon is followed by text, place the large badge at the
    // trailing edge (after the label), not on the icon.
    return Row(
      children: [
        scaledIcon,
        SizedBox(width: theme.iconLabelGap),
        Expanded(
          child: Text(
            widget.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            semanticsLabel: widget.semanticLabel ?? widget.label,
            style: m3e.typeScale.labelLarge.copyWith(color: fg),
          ),
        ),
        if (widget.badgeCount != null) ...[
          SizedBox(width: theme.iconLabelGap),
          M3ERailBadge.standalone(count: widget.badgeCount),
        ],
      ],
    );
  }

  Widget _buildCollapsedContent({
    required M3EThemeData m3e,
    required M3ENavigationRailTheme theme,
    required Color fg,
    required Widget scaledIcon,
  }) {
    final M3ENavigationRailLabelBehavior labelBehavior = widget.labelBehavior;
    final bool showLabel =
        labelBehavior == M3ENavigationRailLabelBehavior.alwaysShow ||
        (widget.isSelected &&
            labelBehavior != M3ENavigationRailLabelBehavior.alwaysHide);
    return Column(
      children: [
        KeyedSubtree(
          key: widget.indicatorKey,
          child: M3EIconButton(
            // Collapsed: badge on the leading icon.
            icon: M3ERailBadge(count: widget.badgeCount, child: scaledIcon),
            width: M3EIconButtonWidth.wide,
            onPressed: widget.onPressed,
            suppressInk: true,
            haptic: widget.haptic,
            variant: widget.useLocalIndicator && widget.isSelected
                ? M3EIconButtonVariant.tonal
                : M3EIconButtonVariant.standard,
          ),
        ),
        if (showLabel)
          Flexible(
            child: Text(
              widget.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              semanticsLabel: widget.semanticLabel ?? widget.label,
              style: m3e.typeScale.labelMedium.copyWith(color: fg),
            ),
          ),
      ],
    );
  }
}
