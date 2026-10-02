import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import 'playground.dart';

/// Controls and code for a playground, switched by a tab bar.
///
/// Shared by the wide controls pane and the narrow controls bottom sheet.
class PlaygroundControlsPane extends StatefulWidget {
  /// Creates a controls pane.
  const PlaygroundControlsPane({
    required this.playground,
    required this.inSheet,
    super.key,
  });

  /// Playground that supplies the controls and snippets.
  final PlaygroundState<PlaygroundWidget> playground;

  /// Whether the pane is the body of a bottom sheet. The list then uses the
  /// sheet's primary scroll controller, so dragging resizes the sheet first.
  final bool inSheet;

  @override
  State<PlaygroundControlsPane> createState() => _PlaygroundControlsPaneState();
}

class _PlaygroundControlsPaneState extends State<PlaygroundControlsPane> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final List<PlaySnippet> snippets = widget.playground.snippets;
    final bool showTabs = snippets.isNotEmpty;
    final bool code = showTabs && _tab == 1;
    final double bottom = widget.inSheet
        ? 0
        : MediaQuery.paddingOf(context).bottom;
    final Widget list = ListView(
      primary: widget.inSheet,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 32 + bottom),
      children: code
          ? <Widget>[
              for (final PlaySnippet snippet in snippets)
                PlayCodeSnippet(snippet: snippet),
            ]
          : widget.playground.buildControls(context),
    );
    // Fills the given height so every tab spans the sheet's (or pane's)
    // full content area, however short its content is.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (showTabs)
          M3ETabs(
            tabs: const <M3ETab>[
              M3ETab(label: 'Controls'),
              M3ETab(label: 'Code'),
            ],
            selectedIndex: _tab,
            onTabSelected: (int index) => setState(() => _tab = index),
          ),
        Expanded(child: list),
      ],
    );
  }
}
