import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'm3e_menu_style_scope.dart';

/// Horizontal divider between menu items inside one elevated surface.
class M3EMenuDividerWidget extends StatelessWidget {
  const M3EMenuDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final menuTheme = theme.menuTheme;
    final style = M3EMenuStyleScope.styleOf(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4,
        horizontal: menuTheme.entryHorizontalPadding,
      ),
      child: Container(
        height: 1,
        color: menuTheme.dividerColor(theme.colorScheme, style),
      ),
    );
  }
}
