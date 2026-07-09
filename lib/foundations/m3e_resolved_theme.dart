import 'package:flutter/material.dart' show InheritedTheme, Theme;
import 'package:flutter/widgets.dart';

import 'm3e_theme_data.dart';

/// Applies a resolved [M3EThemeData] to a subtree.
class M3EResolvedTheme extends StatelessWidget {
  const M3EResolvedTheme({required this.data, required this.child, super.key});

  final M3EThemeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = data.typeScale.bodyMedium.copyWith(
      color: data.colorScheme.onSurface,
      decoration: TextDecoration.none,
    );
    Widget themedChild = M3EInheritedTheme(
      data: data,
      child: IconTheme(
        data: IconThemeData(color: data.colorScheme.onSurface, size: 24),
        child: DefaultTextStyle(
          style: baseStyle,
          child: child,
        ),
      ),
    );
    if (data.splashColor != null || data.highlightColor != null) {
      themedChild = Theme(
        data: Theme.of(context).copyWith(
          splashColor: data.splashColor,
          highlightColor: data.highlightColor,
        ),
        child: themedChild,
      );
    }
    return themedChild;
  }
}

/// Inherited theme handle used by [M3ETheme.of].
class M3EInheritedTheme extends InheritedTheme {
  const M3EInheritedTheme({required this.data, required super.child});

  final M3EThemeData data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return M3EResolvedTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(M3EInheritedTheme oldWidget) => data != oldWidget.data;
}
