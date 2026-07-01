import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// A titled block that groups related component demos on a gallery page.
class GallerySection extends StatelessWidget {
  const GallerySection({
    required this.title,
    required this.children,
    this.description,
    super.key,
  });

  final String title;
  final String? description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.typeScale.titleLarge
                .copyWith(color: theme.colorScheme.onSurface),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              description!,
              style: theme.typeScale.bodyMedium
                  .copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

/// A labelled sub-group inside a [GallerySection], with a wrapping layout.
class DemoRow extends StatelessWidget {
  const DemoRow({required this.label, required this.children, super.key});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.typeScale.labelLarge
                .copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          ),
        ],
      ),
    );
  }
}
