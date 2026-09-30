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
    final double bottomBarHeight = keyboardVisible
        ? 0.0
        : rawMetrics.viewPadding.bottom;

    // Scaffold (not a plain Column) so the app bar's elevation shadow paints
    // above the scrolled-under body content instead of being painted over
    // by it — a Column just stacks siblings in tree order, so the body
    // immediately below would otherwise cover the shadow that's meant to
    // overlap it.
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: M3EAppBar.top(
        titleText: title,
        leading: M3EIconButton(
          variant: M3EIconButtonVariant.standard,
          icon: const Icon(M3EIcons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: <Widget>[
          M3EIconButton(
            variant: M3EIconButtonVariant.standard,
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
      body: Padding(
        padding: EdgeInsets.only(bottom: bottomBarHeight),
        child: body,
      ),
    );
  }
}
