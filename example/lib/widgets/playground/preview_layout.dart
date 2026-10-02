import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../theme/example_theme_scope.dart';
import 'playground.dart';
import 'playground_controls_pane.dart';
import 'preview_controls_banner.dart';
import 'preview_scope.dart';

/// Preview screen layout for a [PlaygroundState].
///
/// Narrow: one scaffold that holds the component's slots, a floating
/// controls banner and a full-screen-height controls sheet. Wide: equal
/// controls and preview panes; the preview pane is a nested scaffold.
class PreviewLayout extends StatelessWidget {
  /// Creates a preview layout.
  const PreviewLayout({required this.playground, super.key});

  /// Playground to lay out.
  final PlaygroundState<PlaygroundWidget> playground;

  void _openControls(BuildContext context, String title) {
    M3EBottomSheet.show<void>(
      context,
      expandToFullScreen: true,
      fullScreenTitle: title,
      builder: (BuildContext context) {
        return ListenableBuilder(
          listenable: playground.changes,
          builder: (BuildContext context, Widget? _) {
            return PlaygroundControlsPane(
              playground: playground,
              inSheet: true,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final String title = PreviewScope.titleOf(context);
    final bool wide =
        MediaQuery.sizeOf(context).width >= kM3EDemoWideBreakpoint;
    final Widget back = M3EIconButton(
      variant: M3EIconButtonVariant.standard,
      icon: const Icon(M3EIcons.arrow_back),
      tooltip: 'Back',
      onPressed: () => Navigator.of(context).maybePop(),
    );
    final Widget toggle = M3EIconButton(
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
    );
    final PreferredSizeWidget screenBar = M3EAppBar.top(
      titleText: title,
      leading: back,
      actions: <Widget>[toggle],
    );

    if (wide) {
      final PlaygroundSlots slots = playground.buildSlots(
        context,
        const PlaygroundChrome(),
      );
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: screenBar,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: FocusTraversalGroup(
                child: PlaygroundControlsPane(
                  playground: playground,
                  inSheet: false,
                ),
              ),
            ),
            const M3EDivider(axis: M3EDividerAxis.vertical),
            Expanded(
              child: FocusTraversalGroup(
                child: _slotScaffold(
                  theme: theme,
                  slots: slots,
                  appBar: slots.appBar,
                  body: _withHeader(
                    slots.header,
                    Builder(
                      builder: (BuildContext context) {
                        return playground.buildPreviewScroll(
                          context,
                          _previewPadding(
                            context,
                            top: 16 + _barInset(context, slots),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final PlaygroundSlots slots = playground.buildSlots(
      context,
      PlaygroundChrome(leading: back, trailingActions: <Widget>[toggle]),
    );
    return _slotScaffold(
      theme: theme,
      slots: slots,
      appBar: slots.header != null ? null : (slots.appBar ?? screenBar),
      body: _withHeader(
        slots.header,
        Builder(
          builder: (BuildContext context) {
            final double inset = _barInset(context, slots);
            return Stack(
              children: <Widget>[
                Positioned.fill(
                  child: playground.buildPreviewScroll(
                    context,
                    _previewPadding(
                      context,
                      top: PreviewControlsBanner.extent + inset,
                    ),
                  ),
                ),
                Positioned(
                  top: inset,
                  left: 0,
                  right: 0,
                  child: PreviewControlsBanner(
                    onPressed: () => _openControls(context, title),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Height of the app bar the body runs behind, or zero.
  static double _barInset(BuildContext context, PlaygroundSlots slots) {
    return slots.extendBodyBehindAppBar ? MediaQuery.paddingOf(context).top : 0;
  }

  static Widget _withHeader(Widget? header, Widget body) {
    if (header == null) {
      return body;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        header,
        Expanded(child: body),
      ],
    );
  }

  static EdgeInsets _previewPadding(
    BuildContext context, {
    required double top,
  }) {
    return EdgeInsets.fromLTRB(
      16,
      top,
      16,
      32 + MediaQuery.paddingOf(context).bottom,
    );
  }

  static Widget _slotScaffold({
    required M3EThemeData theme,
    required PlaygroundSlots slots,
    required PreferredSizeWidget? appBar,
    required Widget body,
  }) {
    final Widget? start = slots.startPane;
    final Widget scaffold = Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: appBar,
      extendBodyBehindAppBar: appBar != null && slots.extendBodyBehindAppBar,
      body: start == null
          ? body
          : Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                start,
                Expanded(child: body),
              ],
            ),
      bottomNavigationBar: slots.bottomNavigationBar,
      floatingActionButton: slots.floatingActionButton,
      floatingActionButtonLocation: slots.floatingActionButtonLocation,
    );
    final Widget? overlay = slots.overlay;
    if (overlay == null) {
      return scaffold;
    }
    return Stack(
      children: <Widget>[
        Positioned.fill(child: scaffold),
        overlay,
      ],
    );
  }
}
