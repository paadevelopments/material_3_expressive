import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'models/m3e_segment.dart';

export 'models/m3e_segment.dart';

/// A Material 3 Expressive segmented button.
///
/// Presents 2-5 connected [M3ESegment]s for selecting options, switching views
/// or sorting. Supports single or multiple selection and shows a check icon on
/// selected segments.
class M3ESegmentedButton<T> extends StatelessWidget {
  const M3ESegmentedButton({
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
    this.multiSelect = false,
    this.showSelectedIcon = true,
    super.key,
  }) : assert(segments.length >= 2, 'A segmented button needs 2+ segments.');

  static const double _height = 40;

  final List<M3ESegment<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>> onSelectionChanged;
  final bool multiSelect;
  final bool showSelectedIcon;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final borderRadius = M3EShapes.resolve(_height / 2);

    return Container(
      height: _height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: scheme.outline),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildSegments(theme),
        ),
      ),
    );
  }

  List<Widget> _buildSegments(M3EThemeData theme) {
    final children = <Widget>[];
    for (var i = 0; i < segments.length; i++) {
      if (i > 0) {
        children.add(
          Container(width: 1, color: theme.colorScheme.outline),
        );
      }
      children.add(
        Flexible(child: _M3ESegmentTile<T>(theme: theme, index: i, parent: this)),
      );
    }
    return children;
  }

  void _handleTap(T value) {
    final next = Set<T>.of(selected);
    if (multiSelect) {
      if (next.contains(value)) {
        next.remove(value);
      } else {
        next.add(value);
      }
    } else {
      next
        ..clear()
        ..add(value);
    }
    onSelectionChanged(next);
  }
}

class _M3ESegmentTile<T> extends StatelessWidget {
  const _M3ESegmentTile({
    required this.theme,
    required this.index,
    required this.parent,
  });

  final M3EThemeData theme;
  final int index;
  final M3ESegmentedButton<T> parent;

  @override
  Widget build(BuildContext context) {
    final M3ESegment<T> segment = parent.segments[index];
    final scheme = theme.colorScheme;
    final bool isSelected = parent.selected.contains(segment.value);
    final Color foreground =
        isSelected ? scheme.onSecondaryContainer : scheme.onSurface;

    return M3ETappable(
      onTap: () => parent._handleTap(segment.value),
      semanticLabel: segment.label,
      builder: (BuildContext context, M3EInteractionState state) {
        return Container(
          height: M3ESegmentedButton._height,
          alignment: Alignment.center,
          color: isSelected ? scheme.secondaryContainer : null,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(
                child: IgnorePointer(
                  child: ColoredBox(
                    color: foreground.withValues(alpha: state.opacity),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildLabel(segment, foreground, isSelected),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(M3ESegment<T> segment, Color foreground, bool selected) {
    final Widget? leading = _resolveLeading(segment, foreground, selected);
    final children = <Widget>[
      if (leading != null) ...<Widget>[leading, const SizedBox(width: 8)],
      if (segment.label != null)
        Flexible(
          child: Text(
            segment.label!,
            style: theme.typeScale.labelLarge.copyWith(color: foreground),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget? _resolveLeading(M3ESegment<T> segment, Color foreground, bool sel) {
    if (sel && parent.showSelectedIcon) {
      return Icon(M3EIcons.check, size: 18, color: foreground);
    }
    if (segment.icon != null) {
      return IconTheme.merge(
        data: IconThemeData(color: foreground, size: 18),
        child: segment.icon!,
      );
    }
    return null;
  }
}
