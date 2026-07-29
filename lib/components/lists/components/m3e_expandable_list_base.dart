import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../styles/m3e_expandable_style.dart';
import 'm3e_expandable_item.dart';

/// M3EExpandableListBase.

abstract class M3EExpandableListBase extends StatefulWidget {
  /// itemCount.
  final int itemCount;

  /// headerBuilder.
  final M3EExpandableHeaderBuilder headerBuilder;

  /// bodyBuilder.
  final M3EExpandableBodyBuilder bodyBuilder;

  /// allowMultipleExpanded.
  final bool? allowMultipleExpanded;

  /// initiallyExpanded.
  final Set<int> initiallyExpanded;

  /// style.
  final M3EExpandableStyle? style;

  /// expandMotion.
  final M3ESpring? expandMotion;

  /// collapseMotion.
  final M3ESpring? collapseMotion;

  /// Called when an item expands or collapses.
  final void Function(int index, {required bool isExpanded})?
  onExpansionChanged;

  /// M3EExpandableListBase.

  const M3EExpandableListBase({
    super.key,
    required this.itemCount,
    required this.headerBuilder,
    required this.bodyBuilder,
    this.allowMultipleExpanded,
    this.initiallyExpanded = const {},
    this.style,
    this.expandMotion,
    this.collapseMotion,
    this.onExpansionChanged,
  });
}

/// M3EExpandableStateMixin.

mixin M3EExpandableStateMixin<T extends M3EExpandableListBase> on State<T> {
  late Set<int> _expandedIndices;

  /// The expandedIndices.
  Set<int> get expandedIndices => _expandedIndices;

  @override
  void initState() {
    super.initState();
    _expandedIndices = Set<int>.from(widget.initiallyExpanded);
  }

  /// handleToggle.

  void handleToggle(
    int index, {
    required bool allowMultipleExpanded,
    required M3EHapticFeedback haptic,
    void Function(int index, {required bool isExpanded})? onExpansionChanged,
  }) {
    M3EHaptics.trigger(haptic);
    final isExpanding = !_expandedIndices.contains(index);
    setState(() {
      if (isExpanding) {
        if (!allowMultipleExpanded) {
          _expandedIndices.clear();
        }
        _expandedIndices.add(index);
      } else {
        _expandedIndices.remove(index);
      }
    });
    onExpansionChanged?.call(index, isExpanded: isExpanding);
  }

  /// isExpanded.

  bool isExpanded(int index) => _expandedIndices.contains(index);

  /// buildItem.

  Widget buildItem(BuildContext context, int index) {
    final expandable = M3ETheme.of(context).listTheme.expandable;
    final effectiveStyle =
        widget.style ?? M3EExpandableStyle.fromTheme(expandable);
    final effectiveExpandMotion =
        widget.expandMotion ?? expandable.expandMotion;
    final effectiveCollapseMotion =
        widget.collapseMotion ?? expandable.collapseMotion;
    final effectiveAllowMultiple =
        widget.allowMultipleExpanded ?? expandable.allowMultipleExpanded;

    return M3EExpandableItem(
      index: index,
      totalCount: widget.itemCount,
      isExpanded: isExpanded(index),
      headerBuilder: widget.headerBuilder,
      bodyBuilder: widget.bodyBuilder,
      decoration: effectiveStyle,
      expandMotion: effectiveExpandMotion,
      collapseMotion: effectiveCollapseMotion,
      onToggle: () => handleToggle(
        index,
        allowMultipleExpanded: effectiveAllowMultiple,
        haptic: effectiveStyle.haptic,
        onExpansionChanged: widget.onExpansionChanged,
      ),
    );
  }
}
