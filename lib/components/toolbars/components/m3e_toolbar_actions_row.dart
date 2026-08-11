import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/toolbars/m3e_toolbars.dart'
    show M3EToolbar;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3EToolbar;

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

  /// When false, labeled actions snap pill layout width on active changes.
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

    // spaceBetween already distributes free space — skip fixed gaps there.
    final bool insertGaps =
        gap > 0 && mainAxisAlignment != MainAxisAlignment.spaceBetween;
    final List<Widget> children = insertGaps
        ? M3EToolbarItemLayout.withGaps(slots, gap: gap, axis: axis)
        : slots;

    final MainAxisSize mainAxisSize = expand
        ? MainAxisSize.max
        : MainAxisSize.min;

    if (axis == Axis.vertical) {
      return Column(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment: mainAxisAlignment,
        children: children,
      );
    }
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      children: children,
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
