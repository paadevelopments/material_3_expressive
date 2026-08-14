import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../catalog/m3e_demo_section.dart';
import 'playground_body.dart';
import 'play_preview_card.dart';

/// Placeholder playground until a section batch is implemented.
class ComingSoonPlayground extends StatelessWidget {
  /// Creates a coming-soon playground.
  const ComingSoonPlayground({
    required this.componentTitle,
    required this.section,
    super.key,
  });

  /// Component display name.
  final String componentTitle;

  /// Parent section (for batch number).
  final M3EDemoSection section;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: componentTitle,
          child: Text(
            'Playground coming in batch ${section.batchNumber} '
            '(${section.navLabel}).',
            style: theme.typeScale.bodyLarge,
          ),
        ),
      ],
      controls: const <Widget>[],
    );
  }
}
