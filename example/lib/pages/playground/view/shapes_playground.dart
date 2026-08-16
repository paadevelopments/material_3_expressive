import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EShapeContainer] and [M3EShapeKind].
class ShapesPlayground extends StatelessWidget {
  /// Creates the shapes playground.
  const ShapesPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final Color fill = theme.colorScheme.primaryContainer;
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Catalog',
          child: Wrap(
            spacing: 12,
            runSpacing: 16,
            children: <Widget>[
              for (final M3EShapeKind kind in M3EShapeKind.all)
                SizedBox(
                  width: 88,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      M3EShapeContainer(
                        kind: kind,
                        width: 72,
                        height: 72,
                        color: fill,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        kind.name,
                        textAlign: TextAlign.center,
                        style: theme.typeScale.labelSmall,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        PlayPreviewCard(
          label: 'Clipped child',
          child: M3EShapeContainer.cookie4Sided(
            width: 120,
            height: 120,
            color: theme.colorScheme.tertiaryContainer,
            child: Center(
              child: Icon(
                M3EIcons.favorite,
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ),
      ],
      controls: const <Widget>[],
    );
  }
}
