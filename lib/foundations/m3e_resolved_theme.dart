import 'package:flutter/material.dart';

import 'm3e_theme.dart';

/// Applies a resolved [M3EThemeData] to a subtree.
///
/// Projects [data] onto Material [Theme] so host widgets that read
/// [Theme.of] (text/icon/color scheme) track the active M3E tokens,
/// including after dynamic color updates.
class M3EResolvedTheme extends StatelessWidget {
  const M3EResolvedTheme({required this.data, required this.child, super.key});

  final M3EThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final IconThemeData icons = data.resolvedIconTheme;
    final TextStyle baseStyle = (data.textTheme.bodyMedium ?? const TextStyle())
        .copyWith(decoration: TextDecoration.none);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: data.colorScheme.toColorScheme(),
        textTheme: data.textTheme,
        iconTheme: icons,
        primaryIconTheme: icons.copyWith(color: data.colorScheme.onPrimary),
        splashColor: data.splashColor,
        highlightColor: data.highlightColor,
      ),
      child: M3EInheritedTheme(
        data: data,
        child: IconTheme(
          data: icons,
          child: DefaultTextStyle(
            style: baseStyle,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Inherited theme handle used by [M3ETheme.of].
class M3EInheritedTheme extends InheritedTheme {
  const M3EInheritedTheme({super.key, required this.data, required super.child});

  final M3EThemeData data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return M3EResolvedTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(M3EInheritedTheme oldWidget) => data != oldWidget.data;
}
