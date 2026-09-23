import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../styles/m3e_expandable_style.dart';
import '../utils/m3e_list_row_features.dart';
import 'm3e_expandable_data.dart';
import 'm3e_expandable_expanded.dart';
import 'm3e_expandable_header_tap_scope.dart';
import 'm3e_expandable_item.dart';
import 'm3e_list_feature_scope.dart';

/// buildM3ESimpleHeader.
Widget buildM3ESimpleHeader(
  BuildContext context,
  M3EExpandableData data,
  double progress,
) {
  final theme = M3ETheme.of(context);
  final expandable = theme.listTheme.expandable;
  final titleStyle = _resolveTitleStyle(theme, data);
  final int? index = M3EListItemIndex.maybeOf(context);
  final Widget? leading = m3eResolveListLeading(
    context: context,
    index: index,
    leading: data.leading,
  );
  final Widget? trailing = m3eResolveListTrailing(
    context: context,
    trailing: data.trailing,
  );

  final String? subtitle = data.subtitle;
  final Widget textColumn = M3EExpandableHeaderTapTarget(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(data.title, style: titleStyle),
        if (subtitle != null && subtitle.isNotEmpty) ...<Widget>[
          SizedBox(height: expandable.titleSubtitleGap),
          Text(
            subtitle,
            maxLines: data.subtitleMaxLines ?? 2,
            overflow: TextOverflow.ellipsis,
            style: _resolveSubtitleStyle(theme, data),
          ),
        ],
      ],
    ),
  );

  return Row(
    children: <Widget>[
      if (leading != null) ...<Widget>[leading, const SizedBox(width: 16)],
      Expanded(child: textColumn),
      if (trailing != null) ...<Widget>[const SizedBox(width: 16), trailing],
    ],
  );
}

TextStyle _resolveTitleStyle(M3EThemeData theme, M3EExpandableData data) {
  if (data.titleStyle != null && data.titleStyle!.isNotEmpty) {
    return data.titleStyle!.first;
  }
  return theme.typeScale.titleSmall.copyWith(
    fontWeight: FontWeight.w400,
    color: theme.colorScheme.onSurface,
  );
}

TextStyle _resolveSubtitleStyle(M3EThemeData theme, M3EExpandableData data) {
  if (data.subtitleStyle != null && data.subtitleStyle!.isNotEmpty) {
    return data.subtitleStyle!.first;
  }
  return theme.typeScale.bodyMedium.copyWith(
    color: theme.colorScheme.onSurfaceVariant,
  );
}

/// buildM3ESimpleBody.
///
/// Only renders [M3EExpandableExpanded.content] — subtitle lives in the header.
Widget buildM3ESimpleBody(
  BuildContext context,
  M3EExpandableData data,
  double progress,
  M3EExpandableStyle decoration,
) {
  final M3EExpandableExpanded? expanded = data.expanded;
  if (expanded == null || expanded.isList || progress <= 0.0) {
    return const SizedBox.shrink();
  }
  return ClipRect(
    child: Align(
      alignment: decoration.bodyAlignment,
      heightFactor: progress.clamp(0.0, 1.0),
      child: expanded.child,
    ),
  );
}

/// m3eSimpleHeaderBuilder.

M3EExpandableHeaderBuilder m3eSimpleHeaderBuilder(
  List<M3EExpandableData> items,
) {
  return (context, index, progress) =>
      buildM3ESimpleHeader(context, items[index], progress);
}

/// m3eSimpleBodyBuilder.

M3EExpandableBodyBuilder m3eSimpleBodyBuilder(
  List<M3EExpandableData> items,
  M3EExpandableStyle decoration,
) {
  return (context, index, progress) =>
      buildM3ESimpleBody(context, items[index], progress, decoration);
}

/// Resolves expanded config per data item.
M3EExpandableExpanded? Function(int index) m3eSimpleExpandedBuilder(
  List<M3EExpandableData> items,
) {
  return (int index) => items[index].expanded;
}
