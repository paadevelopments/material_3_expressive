import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import 'play_code_snippet.dart';

export 'play_code_snippet.dart';

/// Scrollable playground: previews, optional code, then controls.
class PlaygroundBody extends StatelessWidget {
  /// Creates a playground body.
  const PlaygroundBody({
    required this.previews,
    required this.controls,
    this.snippets = const <PlaySnippet>[],
    super.key,
  });

  /// Live variation previews.
  final List<Widget> previews;

  /// Paste-ready samples for the current controls.
  final List<PlaySnippet> snippets;

  /// Live control widgets.
  final List<Widget> controls;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: <Widget>[
        Text('Preview', style: theme.typeScale.titleMedium),
        const SizedBox(height: 12),
        ...previews,
        if (snippets.isNotEmpty) ...<Widget>[
          const SizedBox(height: 24),
          Text('Code', style: theme.typeScale.titleMedium),
          const SizedBox(height: 12),
          for (final PlaySnippet snippet in snippets)
            PlayCodeSnippet(snippet: snippet),
        ],
        if (controls.isNotEmpty) ...<Widget>[
          const SizedBox(height: 24),
          Text('Controls', style: theme.typeScale.titleMedium),
          const SizedBox(height: 12),
          ...controls,
        ],
      ],
    );
  }
}
