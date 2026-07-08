import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_toolbar_color.dart';

export 'enums/m3e_toolbar_color.dart';
export 'styles/m3e_toolbar_theme.dart';

/// A Material 3 Expressive floating toolbar.
///
/// A pill-shaped, elevated surface hosting frequently used actions. It can be
/// laid out horizontally or vertically and floats above content.
class M3EToolbar extends StatelessWidget {
  const M3EToolbar({
    required this.children,
    this.axis = Axis.horizontal,
    this.color = M3EToolbarColor.standard,
    super.key,
  });

  final List<Widget> children;
  final Axis axis;
  final M3EToolbarColor color;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final toolbarTheme = theme.toolbarTheme;
    final scheme = theme.colorScheme;
    final Color background = toolbarTheme.backgroundColor(scheme, color);
    final Color foreground = toolbarTheme.foregroundColor(scheme, color);

    return Container(
      padding: toolbarTheme.padding,
      decoration: ShapeDecoration(
        shape: M3EShapes.stadium,
        color: background,
        shadows: M3EElevation.shadows(
          toolbarTheme.elevation,
          shadowColor: scheme.shadow,
        ),
      ),
      child: IconTheme.merge(
        data: IconThemeData(
          color: foreground,
          size: toolbarTheme.iconSize,
        ),
        child: Flex(
          direction: axis,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
