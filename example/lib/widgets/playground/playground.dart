import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show FloatingActionButtonLocation;

import 'play_code_snippet.dart';
import 'preview_layout.dart';

export 'controls/play_control_group.dart';
export 'controls/play_switch_list.dart';
export 'play_code_snippet.dart';

/// A component playground shown on its own preview screen.
abstract class PlaygroundWidget extends StatefulWidget {
  /// Creates a playground widget.
  const PlaygroundWidget({super.key});

  @override
  PlaygroundState<PlaygroundWidget> createState();
}

/// Scaffold slots a playground fills with its component.
@immutable
class PlaygroundSlots {
  /// Creates playground slots.
  const PlaygroundSlots({
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.startPane,
    this.header,
    this.overlay,
    this.extendBodyBehindAppBar = false,
  });

  /// Top app bar. Replaces the preview screen's app bar on narrow screens.
  final PreferredSizeWidget? appBar;

  /// Bottom bar.
  final Widget? bottomNavigationBar;

  /// Floating action button.
  final Widget? floatingActionButton;

  /// Where [floatingActionButton] sits.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Pane at the start edge of the body, such as a rail or standard drawer.
  final Widget? startPane;

  /// Intrinsic-height bar above the preview body, for top bars that are not
  /// [PreferredSizeWidget]s. Replaces the screen app bar on narrow screens,
  /// so it must embed [PlaygroundChrome]; the controls banner floats below it.
  final Widget? header;

  /// Layer above the whole scaffold, such as a modal drawer.
  final Widget? overlay;

  /// Lets the body run behind [appBar]. Needed by bars that hide on scroll,
  /// so the content moves under them instead of leaving their slot empty.
  /// The controls banner then rests below the bar's full height.
  final bool extendBodyBehindAppBar;
}

/// Preview-screen chrome a playground's [PlaygroundSlots.appBar] must embed.
///
/// Empty on wide screens, where the screen keeps its own app bar.
@immutable
class PlaygroundChrome {
  /// Creates playground chrome.
  const PlaygroundChrome({
    this.leading,
    this.trailingActions = const <Widget>[],
  });

  /// Back button.
  final Widget? leading;

  /// Trailing actions; the theme toggle is last.
  final List<Widget> trailingActions;
}

/// State for a [PlaygroundWidget].
///
/// Subclasses describe the preview, the controls and the code. The base
/// class lays them out for narrow and wide screens. Every [setState] also
/// notifies [changes], so controls shown in a bottom sheet route stay live.
abstract class PlaygroundState<T extends PlaygroundWidget> extends State<T> {
  final _PlaygroundChanges _changes = _PlaygroundChanges();

  /// Notifies after every [setState].
  Listenable get changes => _changes;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _changes.notify();
  }

  @override
  void dispose() {
    _changes.dispose();
    super.dispose();
  }

  /// The configured component.
  Widget buildPreview(BuildContext context);

  /// Control groups ([PlayControlGroup]) for the current variant only.
  List<Widget> buildControls(BuildContext context);

  /// Paste-ready samples for the current configuration.
  List<PlaySnippet> get snippets => const <PlaySnippet>[];

  /// Scaffold-positioned parts of the component.
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    return const PlaygroundSlots();
  }

  /// The primary scroll view around [buildPreview].
  ///
  /// [padding] clears the controls banner. Override for previews that need
  /// their own scroll view; keep `primary: true` and apply [padding].
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          primary: true,
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: math.max(0, constraints.maxHeight - padding.vertical),
            ),
            child: Center(child: buildPreview(context)),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => PreviewLayout(playground: this);
}

class _PlaygroundChanges extends ChangeNotifier {
  void notify() => notifyListeners();
}
