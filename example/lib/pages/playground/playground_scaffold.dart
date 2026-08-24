import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

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

    final MediaQueryData rawMetrics = MediaQueryData.fromView(View.of(context));
    final bool keyboardVisible = rawMetrics.viewInsets.bottom > 0;
    final double bottomBarHeight = keyboardVisible ? 0.0 : rawMetrics.viewPadding.bottom;

    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: bottomBarHeight,
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
    );
  }
}
