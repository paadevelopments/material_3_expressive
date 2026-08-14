import 'package:flutter/widgets.dart';

import 'example_theme_settings.dart';

/// Exposes the gallery's [ExampleThemeSettings] to every route.
class ExampleThemeScope extends InheritedNotifier<ExampleThemeSettings> {
  /// Creates a theme settings scope.
  const ExampleThemeScope({
    required ExampleThemeSettings settings,
    required super.child,
    super.key,
  }) : super(notifier: settings);

  /// The nearest settings object; throws when the scope is missing.
  static ExampleThemeSettings of(BuildContext context) {
    final ExampleThemeScope? scope = context
        .dependOnInheritedWidgetOfExactType<ExampleThemeScope>();
    assert(scope != null, 'No ExampleThemeScope found in context.');
    return scope!.notifier!;
  }
}
