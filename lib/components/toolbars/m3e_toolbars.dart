import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_toolbar_color.dart';
import 'styles/m3e_toolbar_tokens.dart';

export 'enums/m3e_toolbar_color.dart';
export 'styles/m3e_toolbar_tokens.dart';

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
    final scheme = M3ETheme.of(context).colorScheme;
    final Color background = M3EToolbarTokens.backgroundColor(scheme, color);
    final Color foreground = M3EToolbarTokens.foregroundColor(scheme, color);

    return Container(
      padding: M3EToolbarTokens.padding,
      decoration: ShapeDecoration(
        shape: M3EShapes.stadium,
        color: background,
        shadows: M3EElevation.shadows(
          M3EToolbarTokens.elevation,
          shadowColor: scheme.shadow,
        ),
      ),
      child: IconTheme.merge(
        data: IconThemeData(
          color: foreground,
          size: M3EToolbarTokens.iconSize,
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
