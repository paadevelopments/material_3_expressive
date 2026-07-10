import 'package:flutter/material.dart' show CircleAvatar;
import 'package:flutter/widgets.dart';

/// A data container used to configure items for `M3EExpandableList`.
class M3EExpandableData {
  /// The main title text shown in the header.
  final String title;

  /// Optional custom text styles for the title.
  ///
  /// Provide a list of 2 styles: `[collapsedStyle, expandedStyle]` to enable
  /// smooth lerp animation between them.
  final List<TextStyle>? titleStyle;

  /// An optional text-only subtitle.
  final String? subtitle;

  /// Optional custom text styles for the subtitle.
  final List<TextStyle>? subtitleStyle;

  /// Maximum number of lines for the subtitle when collapsed.
  final int? subtitleMaxLines;

  /// A custom widget to display in the expanded body.
  final Widget? body;

  /// A builder function to create the body content dynamically.
  final Widget Function(BuildContext context)? bodyBuilder;

  /// An optional leading widget for the header (e.g., an [Icon] or [CircleAvatar]).
  final Widget? leading;

  /// An optional trailing widget for the header.
  final Widget? trailing;

  /// Creates a data configuration for an expandable item.
  const M3EExpandableData({
    required this.title,
    this.titleStyle,
    this.subtitle,
    this.subtitleStyle,
    this.subtitleMaxLines,
    this.body,
    this.bodyBuilder,
    this.leading,
    this.trailing,
  }) : assert(
          subtitle != null || body != null || bodyBuilder != null,
          'Provide either a subtitle (text), a body (widget), or a bodyBuilder to display content.',
        );
}
