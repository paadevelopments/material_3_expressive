import 'package:flutter/widgets.dart';

import '../m3e_theme.dart';
import '../m3e_theme_scope.dart';

/// Registers an adaptive theme dependency for a single M3E component subtree.
///
/// Only descendants of an adaptive `M3ETheme` root with `M3EThemeScope` need
/// this wrapper. When no scope is present the `builder` runs unchanged.
class M3EComponentTheme extends StatelessWidget {
  const M3EComponentTheme({required this.builder, super.key});

  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    M3EThemeScope.resolveForComponent(context);
    return builder(context);
  }
}
