import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/toolbars/m3e_toolbars.dart'
    show M3EToolbar;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3EToolbar;

import '../../../foundations/foundations.dart';
import '../../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../models/m3e_toolbar_item.dart';
import '../utils/m3e_toolbar_item_layout.dart';
import 'm3e_toolbar_icon_button.dart';
import 'm3e_toolbar_overflow_menu.dart';

/// Inline and overflow actions for [M3EToolbar].
///
/// Used for docked bars and non-expanding floating layouts. Expand-trigger
/// styling is ignored here — all actions render as standard icon buttons.
class M3EToolbarActionsRow extends StatelessWidget {
  /// M3EToolbarActionsRow.
  const M3EToolbarActionsRow({
    required this.actions,
    required this.maxInline,
    required this.overflowIcon,
    required this.iconButtonSize,
    required this.overflowTextStyle,
    required this.destructiveColor,
    required this.availableExtent,
    this.gap = 0,
    this.opticalInset = 0,
    this.axis = Axis.horizontal,
    this.expand = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.pillActiveSpring = true,
    super.key,
  });

  /// actions.

  final List<M3EToolbarItem> actions;

  /// maxInline.
  final int maxInline;

  /// overflowIcon.
  final Widget overflowIcon;

  /// iconButtonSize.
  final M3EIconButtonSize iconButtonSize;

  /// overflowTextStyle.
  final TextStyle overflowTextStyle;

  /// destructiveColor.
  final Color destructiveColor;

  /// Remaining cross-axis size after bar content padding.
  final double availableExtent;

  /// Space between consecutive inline items (actions, widgets, overflow).
  final double gap;

  /// Icon-button target overhang; applied to widget slots for optical parity.
  final double opticalInset;

  /// axis.
  final Axis axis;

  /// When true, the row fills the cross-axis parent's main-axis extent.
  final bool expand;

  /// mainAxisAlignment.
  final MainAxisAlignment mainAxisAlignment;

  /// When false, reserves a fixed pill width for labeled selection (widest
  /// labeled action + icon-only neighbors) and distributes leftover space
  /// evenly between actions.
  final bool pillActiveSpring;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }

    final partitioned = M3EToolbarItemLayout.partitionInline(
      items: actions,
      maxInline: maxInline,
    );
    final List<M3EToolbarItem> inline = partitioned.inline;
    final List<M3EToolbarAction> overflow = partitioned.overflow;

    final slots = <Widget>[
      for (final M3EToolbarItem item in inline)
        _buildSlot(
          item: item,
          availableExtent: availableExtent,
          opticalInset: opticalInset,
          iconButtonSize: iconButtonSize,
          expandWidgets: expand,
        ),
      if (overflow.isNotEmpty)
        M3EToolbarOverflowMenu(
          actions: overflow,
          icon: overflowIcon,
          iconButtonSize: iconButtonSize,
          textStyle: overflowTextStyle,
          destructiveColor: destructiveColor,
        ),
    ];

    // Fixed-pill selection keeps theme [gap] inside the reserved width and
    // distributes leftover space evenly between slots (no trailing dead zone).
    final double? reservedWidth = _reservedSelectionWidth(
      context: context,
      inline: inline,
      hasOverflow: overflow.isNotEmpty,
    );
    final evenlySpace = reservedWidth != null;
    final insertGaps =
        gap > 0 &&
        !evenlySpace &&
        mainAxisAlignment != MainAxisAlignment.spaceBetween;
    final List<Widget> children = insertGaps
        ? M3EToolbarItemLayout.withGaps(slots, gap: gap, axis: axis)
        : slots;

    final MainAxisAlignment alignment = evenlySpace
        ? MainAxisAlignment.spaceBetween
        : mainAxisAlignment;
    final MainAxisSize mainAxisSize = expand || evenlySpace
        ? MainAxisSize.max
        : MainAxisSize.min;

    Widget content;
    if (axis == Axis.vertical) {
      content = Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: alignment,
        children: children,
      );
    } else {
      content = Row(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: alignment,
        children: children,
      );
    }

    if (reservedWidth == null) {
      return content;
    }
    return SizedBox(width: reservedWidth, child: content);
  }

  double? _reservedSelectionWidth({
    required BuildContext context,
    required List<M3EToolbarItem> inline,
    required bool hasOverflow,
  }) {
    if (pillActiveSpring) {
      return null;
    }
    final theme = M3ETheme.of(context);
    final iconTheme = theme.iconButtonTheme;
    final Size visual = iconTheme.visual(
      iconButtonSize,
      M3EIconButtonWidth.defaultWidth,
    );
    final Size target = iconTheme.target(
      iconButtonSize,
      M3EIconButtonWidth.defaultWidth,
    );
    final double iconSlot = visual.width > target.width
        ? visual.width
        : target.width;
    return M3EToolbarItemLayout.reservedLabeledSelectionExtent(
      inline: inline,
      axis: axis,
      iconVisualExtent: visual.width,
      iconSlotExtent: iconSlot,
      labelStyle: theme.typeScale.labelLarge.copyWith(
        fontWeight: FontWeight.w600,
      ),
      textScaler: MediaQuery.textScalerOf(context),
      // Minimum inter-action space; leftover width is shared via spaceBetween.
      gap: gap,
      labelGap: M3EToolbarIconButton.labelGap,
      includeOverflowSlot: hasOverflow,
    );
  }

  /// Builds one inline slot; flexes [M3EToolbarWidget]s when [expandWidgets].
  Widget _buildSlot({
    required M3EToolbarItem item,
    required double availableExtent,
    required double opticalInset,
    required M3EIconButtonSize iconButtonSize,
    required bool expandWidgets,
  }) {
    final Widget built = M3EToolbarItemLayout.buildItem(
      item: item,
      availableExtent: availableExtent,
      axis: axis,
      opticalInset: opticalInset,
      buildAction: (M3EToolbarAction action) => M3EToolbarIconButton(
        action: action,
        size: iconButtonSize,
        pillActiveSpring: pillActiveSpring,
      ),
    );
    if (expandWidgets && item is M3EToolbarWidget) {
      return Expanded(child: built);
    }
    return built;
  }
}
