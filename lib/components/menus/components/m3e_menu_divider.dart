import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Horizontal divider between menu sections.
class M3EMenuDividerWidget extends StatelessWidget {
  const M3EMenuDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: 1,
        color: theme.menuTheme.dividerColor(theme.colorScheme),
      ),
    );
  }
}
