import 'package:flutter/widgets.dart';
import '../../../foundations/foundations.dart';
import '../styles/m3e_expandable_style.dart';
import 'm3e_expandable_data.dart';
import 'm3e_expandable_item.dart';

/// buildM3ESimpleHeader.

Widget buildM3ESimpleHeader(
  BuildContext context,
  M3EExpandableData data,
  double progress,
) {
  final theme = M3ETheme.of(context);
  final clampedProgress = progress.clamp(0.0, 1.0);
  final resolvedStyle = _resolveTitleStyle(theme, data, clampedProgress);

  return Row(
    children: [
      if (data.leading != null) ...[data.leading!, const SizedBox(width: 16)],
      Expanded(child: Text(data.title, style: resolvedStyle)),
      if (data.trailing != null) ...[const SizedBox(width: 16), data.trailing!],
    ],
  );
}

TextStyle _resolveTitleStyle(
  M3EThemeData theme,
  M3EExpandableData data,
  double clampedProgress,
) {
  if (data.titleStyle != null && data.titleStyle!.length == 2) {
    return TextStyle.lerp(
      data.titleStyle![0],
      data.titleStyle![1],
      clampedProgress,
    )!;
  }
  if (data.titleStyle != null && data.titleStyle!.length == 1) {
    return data.titleStyle![0];
  }
  return TextStyle.lerp(
    theme.typeScale.titleSmall.copyWith(
      fontWeight: FontWeight.w400,
      color: theme.colorScheme.onSurface,
    ),
    theme.typeScale.titleSmall.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.onSurface,
    ),
    clampedProgress,
  )!;
}

/// buildM3ESimpleBody.

Widget buildM3ESimpleBody(
  BuildContext context,
  M3EExpandableData data,
  double progress,
  M3EExpandableStyle decoration,
) {
  final theme = M3ETheme.of(context);
  final children = <Widget>[];

  final subtitle = _buildSubtitleSection(theme, data, progress, decoration);
  if (subtitle != null) {
    children.add(subtitle);
  }

  final body = _buildBodySection(context, data, progress, decoration, children);
  if (body != null) {
    children.add(body);
  }

  if (children.isEmpty) {
    return const SizedBox.shrink();
  }
  if (children.length == 1) {
    return children.first;
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: children,
  );
}

Widget? _buildSubtitleSection(
  M3EThemeData theme,
  M3EExpandableData data,
  double progress,
  M3EExpandableStyle decoration,
) {
  if (data.subtitle == null || data.subtitle!.isEmpty) {
    return null;
  }

  final styles = _resolveSubtitleStyles(theme, data);
  final alignment = decoration.bodyAlignment;
  final mappedTextAlign = _textAlignForAlignment(alignment);
  final maxLines = data.subtitleMaxLines ?? 1;
  final showCollapsedSubtitle = progress < 0.5;
  final showExpandedSubtitle = progress >= 0.5;

  return Padding(
    padding: EdgeInsets.only(top: decoration.titleSubtitleGap),
    child: Stack(
      children: [
        if (showCollapsedSubtitle)
          Align(
            alignment: alignment,
            child: Text(
              data.subtitle!,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              style: styles.collapsed,
              textAlign: mappedTextAlign,
            ),
          ),
        if (showExpandedSubtitle)
          ClipRect(
            child: Align(
              alignment: alignment,
              heightFactor: 1,
              child: Text(
                data.subtitle!,
                style: styles.expanded,
                textAlign: mappedTextAlign,
              ),
            ),
          ),
      ],
    ),
  );
}

({TextStyle collapsed, TextStyle expanded}) _resolveSubtitleStyles(
  M3EThemeData theme,
  M3EExpandableData data,
) {
  if (data.subtitleStyle != null && data.subtitleStyle!.length == 2) {
    return (
      collapsed: data.subtitleStyle![0],
      expanded: data.subtitleStyle![1],
    );
  }
  if (data.subtitleStyle != null && data.subtitleStyle!.length == 1) {
    return (
      collapsed: data.subtitleStyle![0],
      expanded: data.subtitleStyle![0],
    );
  }
  final fallback = theme.typeScale.bodyMedium.copyWith(
    color: theme.colorScheme.onSurfaceVariant,
  );
  return (collapsed: fallback, expanded: fallback);
}

TextAlign _textAlignForAlignment(AlignmentGeometry alignment) {
  if (alignment == Alignment.topCenter ||
      alignment == Alignment.center ||
      alignment == Alignment.bottomCenter) {
    return TextAlign.center;
  }
  if (alignment == Alignment.topRight ||
      alignment == Alignment.centerRight ||
      alignment == Alignment.bottomRight) {
    return TextAlign.right;
  }
  return TextAlign.start;
}

Widget? _buildBodySection(
  BuildContext context,
  M3EExpandableData data,
  double progress,
  M3EExpandableStyle decoration,
  List<Widget> existingChildren,
) {
  if ((data.body == null && data.bodyBuilder == null) || progress <= 0.0) {
    return null;
  }
  return ClipRect(
    child: Align(
      alignment: decoration.bodyAlignment,
      heightFactor: progress.clamp(0.0, 1.0),
      child: Padding(
        padding: EdgeInsets.only(top: existingChildren.isEmpty ? 0 : 12),
        child: data.bodyBuilder?.call(context) ?? data.body!,
      ),
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
