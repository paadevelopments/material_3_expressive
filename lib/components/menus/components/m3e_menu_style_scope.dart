import 'package:flutter/widgets.dart';

import '../enums/m3e_menu_color_style.dart';
import '../styles/m3e_menu_theme.dart';

/// Provides [colorStyle] / resolved [colors] to menu item descendants.
class M3EMenuStyleScope extends InheritedWidget {
  const M3EMenuStyleScope({
    required this.colorStyle,
    required this.colors,
    required super.child,
    super.key,
  });

  final M3EMenuColorStyle colorStyle;
  final M3EMenuColors colors;

  static M3EMenuStyleScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<M3EMenuStyleScope>();
  }

  static M3EMenuColorStyle styleOf(BuildContext context) {
    return maybeOf(context)?.colorStyle ?? M3EMenuColorStyle.standard;
  }

  static M3EMenuColors? colorsOf(BuildContext context) {
    return maybeOf(context)?.colors;
  }

  @override
  bool updateShouldNotify(covariant M3EMenuStyleScope oldWidget) {
    return colorStyle != oldWidget.colorStyle || colors != oldWidget.colors;
  }
}
