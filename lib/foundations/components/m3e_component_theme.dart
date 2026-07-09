import 'package:flutter/widgets.dart';

import '../m3e_theme.dart';
import '../m3e_theme_scope.dart';

/// Resolves adaptive theme for a single [M3E] component subtree.
///
/// Only descendants of an adaptive [M3ETheme] root with [M3EThemeScope] need
/// this wrapper. When no scope is present the [child] is returned unchanged.
class M3EComponentTheme extends StatelessWidget {
  const M3EComponentTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final data = M3EThemeScope.resolveForComponent(context);
    if (data == null) {
      return child;
    }
    return M3ETheme(data: data, child: child);
  }
}
