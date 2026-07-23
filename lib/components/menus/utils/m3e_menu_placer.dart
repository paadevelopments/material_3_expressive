import 'package:flutter/widgets.dart';

import '../enums/m3e_menu_anchor_position.dart';
import '../models/m3e_menu_node.dart';
import '../styles/m3e_menu_theme.dart';

/// Computed placement for an anchored menu popup.
@immutable
class M3EMenuPlacement {
  const M3EMenuPlacement({
    required this.left,
    required this.width,
    required this.maxHeight,
    required this.scaleAlignment,
    required this.opensAbove,
    this.top,
    this.bottom,
  }) : assert(
          (top == null) != (bottom == null),
          'Exactly one of top or bottom must be set.',
        );

  final double left;

  /// Distance from the top of the screen when opening below the anchor.
  final double? top;

  /// Distance from the bottom of the screen when opening above the anchor.
  ///
  /// Pinning with [bottom] keeps the menu flush under the available space
  /// regardless of content height (unlike subtracting [maxHeight] from [top]).
  final double? bottom;

  final double width;
  final double maxHeight;
  final Alignment scaleAlignment;
  final bool opensAbove;
}

/// Collision-aware menu placement (Compose popup position provider).
abstract final class M3EMenuPlacer {
  const M3EMenuPlacer._();

  static M3EMenuPlacement compute({
    required Size screenSize,
    required Rect anchorRect,
    required M3EMenuTheme theme,
    required M3EMenuAnchorPosition position,
    required TextDirection textDirection,
    required int approximateItemCount,
    double? preferredWidth,
  }) {
    final edge = theme.screenEdgePadding;
    final width = (preferredWidth ??
            (anchorRect.width + 176.0).clamp(theme.minWidth, theme.maxWidth))
        .clamp(theme.minWidth, theme.maxWidth)
        .toDouble();

    final approxHeight = (approximateItemCount * theme.entryHeight)
        .clamp(theme.entryHeight * 2, theme.maxHeight)
        .toDouble();

    final spaceBelow = screenSize.height - anchorRect.bottom - edge;
    final spaceAbove = anchorRect.top - edge;
    final isRtl = textDirection == TextDirection.rtl;

    final isSide = position == M3EMenuAnchorPosition.end ||
        position == M3EMenuAnchorPosition.start;

    var opensAbove = false;
    if (!isSide) {
      final preferAbove = position == M3EMenuAnchorPosition.topStart ||
          position == M3EMenuAnchorPosition.topEnd;
      if (preferAbove) {
        opensAbove = spaceAbove >= approxHeight || spaceAbove > spaceBelow;
      } else {
        opensAbove = spaceBelow < approxHeight && spaceAbove > spaceBelow;
      }
    }

    final alignEnd = switch (position) {
      M3EMenuAnchorPosition.bottomEnd ||
      M3EMenuAnchorPosition.topEnd ||
      M3EMenuAnchorPosition.end =>
        !isRtl,
      M3EMenuAnchorPosition.bottomStart ||
      M3EMenuAnchorPosition.topStart ||
      M3EMenuAnchorPosition.start =>
        isRtl,
    };

    late double left;
    var opensTowardStart = false;

    if (isSide) {
      final openEnd = position == M3EMenuAnchorPosition.end;
      final preferRight = (openEnd && !isRtl) || (!openEnd && isRtl);
      if (preferRight) {
        left = anchorRect.right + theme.anchorOffset;
        if (left + width > screenSize.width - edge) {
          left = anchorRect.left - width - theme.anchorOffset;
          opensTowardStart = true;
        }
      } else {
        left = anchorRect.left - width - theme.anchorOffset;
        opensTowardStart = true;
        if (left < edge) {
          left = anchorRect.right + theme.anchorOffset;
          opensTowardStart = false;
        }
      }
    } else if (alignEnd) {
      left = anchorRect.right - width;
    } else {
      left = anchorRect.left;
    }

    left = left.clamp(edge, screenSize.width - width - edge).toDouble();

    final maxHeight = (isSide
            ? (screenSize.height - edge - edge)
            : (opensAbove ? spaceAbove : spaceBelow))
        .clamp(0.0, theme.maxHeight)
        .toDouble();

    double? top;
    double? bottom;
    if (isSide) {
      top = anchorRect.top;
      if (top + maxHeight > screenSize.height - edge) {
        top = (screenSize.height - edge - maxHeight).clamp(edge, double.infinity);
      }
    } else if (opensAbove) {
      // Pin the menu's bottom edge just above the anchor so short menus sit
      // flush (same gap as opening below), instead of top = anchor - maxHeight.
      bottom = screenSize.height - anchorRect.top + theme.anchorOffset;
    } else {
      top = anchorRect.bottom + theme.anchorOffset;
    }

    final isClampedToLeft = left <= edge + 0.5;
    final Alignment scaleAlignment;
    if (isSide) {
      scaleAlignment = Alignment(opensTowardStart ? 1.0 : -1.0, -1.0);
    } else {
      final h = isClampedToLeft ? -1.0 : (alignEnd ? 1.0 : -1.0);
      scaleAlignment = Alignment(h, opensAbove ? 1.0 : -1.0);
    }

    return M3EMenuPlacement(
      left: left,
      top: top,
      bottom: bottom,
      width: width,
      maxHeight: maxHeight,
      scaleAlignment: scaleAlignment,
      opensAbove: opensAbove,
    );
  }

  /// Rough visible row count for height estimation.
  static int approximateItemCount(List<M3EMenuNode> nodes) {
    var count = 0;
    for (final node in nodes) {
      switch (node) {
        case M3EMenuGroup(:final children, :final label):
          if (label != null) {
            count += 1;
          }
          count += approximateItemCount(children);
        case M3EMenuDivider():
          count += 1;
        case M3EMenuEntry() ||
              M3EMenuSelectable() ||
              M3EMenuToggleable() ||
              M3EMenuSubmenu() ||
              M3EMenuWidget():
          count += 1;
      }
    }
    return count == 0 ? 1 : count;
  }
}
