import 'package:flutter/widgets.dart';
import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_motion.dart';
import '../styles/m3e_expandable_style.dart';
import '../../buttons/enums/m3e_button_enums.dart';
import '../../buttons/res/m3e_button_constants.dart';
import 'm3e_expandable_item.dart';

abstract class M3EExpandableListBase extends StatefulWidget {
  final int itemCount;
  final M3EExpandableHeaderBuilder headerBuilder;
  final M3EExpandableBodyBuilder bodyBuilder;
  final bool? allowMultipleExpanded;
  final Set<int> initiallyExpanded;
  final M3EExpandableStyle? style;
  final M3ESpring? expandMotion;
  final M3ESpring? collapseMotion;
  final void Function(int index, bool isExpanded)? onExpansionChanged;

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

mixin M3EExpandableStateMixin<T extends M3EExpandableListBase> on State<T> {
  late Set<int> _expandedIndices;
  Set<int> get expandedIndices => _expandedIndices;

  @override
  void initState() {
    super.initState();
    _expandedIndices = Set<int>.from(widget.initiallyExpanded);
  }

  void handleToggle(
    int index, {
    required bool allowMultipleExpanded,
    required M3EHapticFeedback haptic,
    void Function(int index, bool isExpanding)? onExpansionChanged,
  }) {
    M3EButtonConstants.triggerHapticFeedback(haptic);
    final isExpanding = !_expandedIndices.contains(index);
    setState(() {
      if (isExpanding) {
        if (!allowMultipleExpanded) _expandedIndices.clear();
        _expandedIndices.add(index);
      } else {
        _expandedIndices.remove(index);
      }
    });
    onExpansionChanged?.call(index, isExpanding);
  }

  bool isExpanded(int index) => _expandedIndices.contains(index);

  Widget buildItem(BuildContext context, int index) {
    final expandable = M3ETheme.of(context).listTheme.expandable;
    final effectiveStyle =
        widget.style ?? M3EExpandableStyle.fromTheme(expandable);
    final effectiveExpandMotion = widget.expandMotion ?? expandable.expandMotion;
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
