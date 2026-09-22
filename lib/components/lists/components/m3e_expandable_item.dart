import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../../cards/m3e_cards.dart';
import '../../tooltips/m3e_tooltips.dart';
import '../enums/m3e_expandable_enums.dart';
import '../enums/m3e_list_selection_enums.dart';
import '../styles/m3e_expandable_style.dart';
import '../styles/m3e_list_reorder_state.dart';
import '../styles/m3e_list_selection_state.dart';
import '../utils/m3e_expandable_spring_motion.dart';
import '../utils/m3e_list_immediate_tap.dart';
import '../utils/m3e_list_selection_fill.dart';
import '../utils/m3e_measure_size.dart';
import 'm3e_card_list_item.dart';
import 'm3e_expandable_expanded.dart';
import 'm3e_expandable_nest_scope.dart';
import 'm3e_expandable_snap_collapse.dart';
import 'm3e_expandable_sublist.dart';
import 'm3e_list_feature_scope.dart';
import 'm3e_list_reorder_exclude.dart';

part 'm3e_expandable_item_body.dart';

/// M3EExpandableHeaderBuilder.

typedef M3EExpandableHeaderBuilder = Widget Function(
  BuildContext context,
  int index,
  double progress,
);

/// M3EExpandableBodyBuilder.
typedef M3EExpandableBodyBuilder = Widget Function(
  BuildContext context,
  int index,
  double progress,
);

/// Resolved header/card tap wiring for an expandable item.
typedef _HeaderInteraction = ({
  bool separateLeadingSelect,
  bool entireCardTappable,
  VoidCallback? rawHeaderOrOuter,
  VoidCallback? outerTap,
  VoidCallback? headerTap,
  String? outerTooltip,
  VoidCallback? doubleTap,
});

/// M3EExpandableItem.

class M3EExpandableItem extends StatefulWidget {
  /// M3EExpandableItem.
  const M3EExpandableItem({
    super.key,
    required this.index,
    required this.totalCount,
    required this.isExpanded,
    required this.headerBuilder,
    required this.bodyBuilder,
    required this.decoration,
    required this.expandMotion,
    required this.collapseMotion,
    required this.onToggle,
    this.expanded,
  });

  /// index.

  final int index;

  /// totalCount.
  final int totalCount;

  /// isExpanded.
  final bool isExpanded;

  /// headerBuilder.
  final M3EExpandableHeaderBuilder headerBuilder;

  /// bodyBuilder.
  final M3EExpandableBodyBuilder bodyBuilder;

  /// Optional expanded content (list rows or freeform child).
  final M3EExpandableExpanded? expanded;

  /// decoration.
  final M3EExpandableStyle decoration;

  /// expandMotion.
  final M3ESpring expandMotion;

  /// collapseMotion.
  final M3ESpring collapseMotion;

  /// onToggle.
  final VoidCallback onToggle;

  @override
  State<M3EExpandableItem> createState() => _M3EExpandableItemState();
}

class _M3EExpandableItemState extends State<M3EExpandableItem>
    with TickerProviderStateMixin {
  late final SingleMotionController _expandCtrl;

  bool _isPressed = false;

  /// Node of the item's single toggle target (whole card or header row).
  final FocusNode _toggleFocusNode = FocusNode();
  bool _focused = false;

  double? _collapsedHeight;
  double? _expandedHeight;

  @override
  void initState() {
    super.initState();
    final motion = widget.isExpanded
        ? widget.expandMotion.toMotion()
        : widget.collapseMotion.toMotion();

    _expandCtrl = SingleMotionController(motion: motion, vsync: this)
      ..value = widget.isExpanded ? 1.0 : 0.0;
    _toggleFocusNode.addListener(_handleToggleFocusChanged);
    FocusManager.instance.addHighlightModeListener(_handleHighlightModeChanged);
    M3EFocusInteraction.instance.addListener(_handleToggleFocusChanged);
  }

  void _handleHighlightModeChanged(FocusHighlightMode mode) {
    _handleToggleFocusChanged();
  }

  @override
  void didUpdateWidget(covariant M3EExpandableItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isExpanded != widget.isExpanded) {
      final bool snap = M3EExpandableSnapCollapse.of(context);
      if (snap) {
        _expandCtrl.value = widget.isExpanded ? 1.0 : 0.0;
      } else {
        final motion = widget.isExpanded
            ? widget.expandMotion.toMotion()
            : widget.collapseMotion.toMotion();
        _expandCtrl.motion = motion;
        _expandCtrl.animateTo(widget.isExpanded ? 1.0 : 0.0);
      }
    }
  }

  void _handleTapDown() => setState(() => _isPressed = true);
  void _handleTapUp() => setState(() => _isPressed = false);
  void _handleTapCancel() => setState(() => _isPressed = false);

  void _handleCardStateChanged(M3EInteractionState state) {
    if (_isPressed == state.pressed) {
      return;
    }
    setState(() => _isPressed = state.pressed);
  }

  void _handleToggleFocusChanged() {
    if (!mounted) {
      return;
    }
    final bool show = M3EFocusRing.shouldShow(_toggleFocusNode, context);
    if (_focused != show) {
      setState(() => _focused = show);
    }
  }

  @override
  void dispose() {
    M3EFocusInteraction.instance.removeListener(_handleToggleFocusChanged);
    FocusManager.instance.removeHighlightModeListener(
      _handleHighlightModeChanged,
    );
    _toggleFocusNode
      ..removeListener(_handleToggleFocusChanged)
      ..dispose();
    _expandCtrl.dispose();
    super.dispose();
  }

  bool get _hasListExpansion {
    final M3EExpandableExpanded? expanded = widget.expanded;
    return expanded != null && expanded.isList;
  }

  BorderRadius _buildEffectiveRadius() {
    final d = widget.decoration;
    final BorderRadius? selectedRadius = m3eSelectionRadius(
      context,
      widget.index,
      outerRadius: d.outerRadius,
    );
    if (selectedRadius != null) {
      return selectedRadius;
    }

    if (_hasListExpansion) {
      return m3eExpandableParentRadius(
        globalPosition: calculateCardPosition(widget.index, widget.totalCount),
        outerRadius: d.outerRadius,
        innerRadius: _isPressed ? d.pressedRadius : d.innerRadius,
        isExpanded: widget.isExpanded,
        hasSublist: true,
      );
    }

    final isFirst = widget.index == 0;
    final isLast = widget.index == widget.totalCount - 1;
    final isSingle = widget.totalCount == 1;

    if (widget.isExpanded && d.expandedRadius != null) {
      return BorderRadius.circular(d.expandedRadius!);
    }

    if (isSingle) {
      return BorderRadius.circular(d.outerRadius);
    }

    final effectiveInnerRadius = _isPressed ? d.pressedRadius : d.innerRadius;

    if (isFirst) {
      return BorderRadius.vertical(
        top: Radius.circular(d.outerRadius),
        bottom: Radius.circular(effectiveInnerRadius),
      );
    }
    if (isLast) {
      return BorderRadius.vertical(
        top: Radius.circular(effectiveInnerRadius),
        bottom: Radius.circular(d.outerRadius),
      );
    }
    return BorderRadius.circular(effectiveInnerRadius);
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final d = widget.decoration;
    final isLast = widget.index == widget.totalCount - 1;
    final hasList = _hasListExpansion;
    final interaction = _resolveHeaderInteraction(d: d, hasList: hasList);

    Widget content = _buildHeaderCard(
      scheme: scheme,
      d: d,
      hasList: hasList,
      interaction: interaction,
    );
    if (hasList) {
      content = _buildListExpansionColumn(
        headerCard: content,
        d: d,
        isLast: isLast,
      );
    }

    // Same local reading-order group as dropdown panel items: header, then
    // revealed sublist rows, then the next sibling outside this group.
    return RepaintBoundary(
      child: Padding(
        padding: d.margin ?? EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : d.gap),
          child: FocusTraversalGroup(
            policy: ReadingOrderTraversalPolicy(),
            child: content,
          ),
        ),
      ),
    );
  }
}
