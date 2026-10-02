import 'package:flutter/widgets.dart';

/// Width at or above which the catalog is a grid and the preview screen
/// splits into a controls pane and a preview pane.
const double kM3EDemoWideBreakpoint = 900;

/// Exposes the previewed component's title to its playground.
class PreviewScope extends InheritedWidget {
  /// Creates a preview scope.
  const PreviewScope({required this.title, required super.child, super.key});

  /// Component display name.
  final String title;

  /// The nearest title, or an empty string.
  static String titleOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PreviewScope>()?.title ??
        '';
  }

  @override
  bool updateShouldNotify(PreviewScope oldWidget) => title != oldWidget.title;
}
