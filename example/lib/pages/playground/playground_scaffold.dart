import 'package:flutter/material.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../theme/example_theme_scope.dart';

/// Shared playground chrome for narrow (pushed) routes.
class PlaygroundScaffold extends StatelessWidget {
  /// Creates a playground scaffold.
  const PlaygroundScaffold({
    required this.title,
    required this.body,
    super.key,
  });

  /// App bar title (component name).
  final String title;

  /// Playground content.
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return Scaffold(
      body: ColoredBox(
        color: theme.colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewPaddingOf(context).bottom,
          ),
          child: Column(
            children: <Widget>[
              M3EAppBar.top(
                titleText: title,
                leading: M3EIconButton(
                  icon: const Icon(M3EIcons.arrow_back),
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                actions: <Widget>[
                  M3EIconButton(
                    icon: Icon(
                      theme.brightness == Brightness.dark
                          ? M3EIcons.light_mode
                          : M3EIcons.dark_mode,
                    ),
                    tooltip: 'Toggle theme',
                    onPressed: () {
                      M3ETheme.controllerOf(context)?.toggleBrightness(
                        fallback: theme.brightness,
                        autoTheming: ExampleThemeScope.of(context).autoTheming,
                      );
                    },
                  ),
                ],
              ),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}
