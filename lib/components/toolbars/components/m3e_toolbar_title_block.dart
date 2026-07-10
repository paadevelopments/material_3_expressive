import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/toolbars/m3e_toolbars.dart' show M3EToolbar;
import 'package:material_3_expressive/material_3_expressive.dart' show M3EToolbar;

/// Title and optional subtitle for [M3EToolbar].
class M3EToolbarTitleBlock extends StatelessWidget {
  const M3EToolbarTitleBlock({
    required this.title,
    required this.subtitle,
    required this.center,
    required this.titleStyle,
    required this.subtitleStyle,
    super.key,
  });

  final Widget? title;
  final Widget? subtitle;
  final bool center;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    if (title == null && subtitle == null) {
      return const SizedBox.shrink();
    }

    final Widget column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          DefaultTextStyle.merge(style: titleStyle, child: title!),
        if (subtitle != null)
          DefaultTextStyle.merge(style: subtitleStyle, child: subtitle!),
      ],
    );

    if (center) {
      return Align(child: column);
    }
    return column;
  }
}
