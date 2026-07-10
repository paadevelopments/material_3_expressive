import 'package:flutter/widgets.dart';
import '../../../foundations/foundations.dart';
import '../styles/m3e_expandable_style.dart';
import 'm3e_expandable_data.dart';
import 'm3e_expandable_item.dart';

Widget buildM3ESimpleHeader(
  BuildContext context,
  M3EExpandableData data,
  double progress,
) {
  final theme = M3ETheme.of(context);
  final clampedProgress = progress.clamp(0.0, 1.0);
  TextStyle resolvedStyle;

  if (data.titleStyle != null && data.titleStyle!.length == 2) {
    resolvedStyle = TextStyle.lerp(
      data.titleStyle![0],
      data.titleStyle![1],
      clampedProgress,
    )!;
  } else if (data.titleStyle != null && data.titleStyle!.length == 1) {
    resolvedStyle = data.titleStyle![0];
  } else {
    resolvedStyle = TextStyle.lerp(
      theme.typeScale.titleSmall.copyWith(fontWeight: FontWeight.w400),
      theme.typeScale.titleSmall.copyWith(fontWeight: FontWeight.bold),
      clampedProgress,
    )!;
  }

  return Row(
    children: [
      if (data.leading != null) ...[data.leading!, const SizedBox(width: 16)],
      Expanded(child: Text(data.title, style: resolvedStyle)),
      if (data.trailing != null) ...[const SizedBox(width: 16), data.trailing!],
    ],
  );
}

Widget buildM3ESimpleBody(
  BuildContext context,
  M3EExpandableData data,
  double progress,
  M3EExpandableStyle decoration,
) {
  final theme = M3ETheme.of(context);
  final List<Widget> children = [];

  if (data.subtitle != null && data.subtitle!.isNotEmpty) {
    TextStyle collapsedSubtitleStyle;
    TextStyle expandedSubtitleStyle;

    if (data.subtitleStyle != null && data.subtitleStyle!.length == 2) {
      collapsedSubtitleStyle = data.subtitleStyle![0];
      expandedSubtitleStyle = data.subtitleStyle![1];
    } else if (data.subtitleStyle != null && data.subtitleStyle!.length == 1) {
      collapsedSubtitleStyle = data.subtitleStyle![0];
      expandedSubtitleStyle = data.subtitleStyle![0];
    } else {
      collapsedSubtitleStyle = theme.typeScale.bodyMedium;
      expandedSubtitleStyle = theme.typeScale.bodyMedium;
    }

    final alignment = decoration.bodyAlignment;
    final maxLines = data.subtitleMaxLines ?? 1;

    TextAlign mappedTextAlign = TextAlign.start;
    if (alignment == Alignment.topCenter ||
        alignment == Alignment.center ||
        alignment == Alignment.bottomCenter) {
      mappedTextAlign = TextAlign.center;
    } else if (alignment == Alignment.topRight ||
        alignment == Alignment.centerRight ||
        alignment == Alignment.bottomRight) {
      mappedTextAlign = TextAlign.right;
    }

    final showCollapsedSubtitle = progress < 0.5;
    final showExpandedSubtitle = progress >= 0.5;

    children.add(
      Padding(
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
                  style: collapsedSubtitleStyle,
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
                    style: expandedSubtitleStyle,
                    textAlign: mappedTextAlign,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  if ((data.body != null || data.bodyBuilder != null) && progress > 0.0) {
    children.add(
      ClipRect(
        child: Align(
          alignment: decoration.bodyAlignment,
          heightFactor: progress.clamp(0.0, 1.0),
          child: Padding(
            padding: EdgeInsets.only(top: children.isEmpty ? 0 : 12),
            child: data.bodyBuilder?.call(context) ?? data.body!,
          ),
        ),
      ),
    );
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

M3EExpandableHeaderBuilder m3eSimpleHeaderBuilder(
  List<M3EExpandableData> items,
) {
  return (context, index, progress) =>
      buildM3ESimpleHeader(context, items[index], progress);
}

M3EExpandableBodyBuilder m3eSimpleBodyBuilder(
  List<M3EExpandableData> items,
  M3EExpandableStyle decoration,
) {
  return (context, index, progress) =>
      buildM3ESimpleBody(context, items[index], progress, decoration);
}
