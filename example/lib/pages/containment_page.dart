import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../widgets/gallery_section.dart';

/// Demonstrates every component in the Material 3 *Containment* group.
class ContainmentPage extends StatelessWidget {
  const ContainmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        _cards(theme),
        _carousel(theme),
        _lists(),
        _dividers(theme),
        _overlays(context),
      ],
    );
  }

  Widget _cards(M3EThemeData theme) {
    Widget body(String title) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: theme.typeScale.titleMedium
                  .copyWith(color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              'Supporting text for the card body.',
              style: theme.typeScale.bodyMedium
                  .copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        );

    return GallerySection(
      title: 'Cards',
      children: <Widget>[
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: <Widget>[
            SizedBox(
              width: 220,
              child: M3EContainment.card(child: body('Elevated')),
            ),
            SizedBox(
              width: 220,
              child: M3EContainment.card(
                variant: M3ECardVariant.filled,
                child: body('Filled'),
              ),
            ),
            SizedBox(
              width: 220,
              child: M3EContainment.card(
                variant: M3ECardVariant.outlined,
                onPressed: () {},
                child: body('Outlined (tap)'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _carousel(M3EThemeData theme) {
    final List<Color> colors = <Color>[
      theme.colorScheme.primaryContainer,
      theme.colorScheme.secondaryContainer,
      theme.colorScheme.tertiaryContainer,
      theme.colorScheme.surfaceContainerHighest,
    ];
    return GallerySection(
      title: 'Carousel',
      children: <Widget>[
        M3EContainment.carousel(
          height: 160,
          items: <Widget>[
            for (int i = 0; i < colors.length; i++)
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors[i],
                  borderRadius: M3EShapes.radiusLarge,
                ),
                child: Center(
                  child: Text(
                    'Item ${i + 1}',
                    style: theme.typeScale.titleMedium
                        .copyWith(color: theme.colorScheme.onSurface),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _lists() {
    return GallerySection(
      title: 'Lists',
      children: <Widget>[
        M3EContainment.listItem(
          headline: 'Wireless charging',
          supportingText: 'On · Fast charge enabled',
          leading: const Icon(M3EIcons.schedule),
          trailing: const Icon(M3EIcons.chevronRight),
          onTap: () {},
        ),
        M3EContainment.divider(),
        M3EContainment.listItem(
          headline: 'Calendar sync',
          supportingText: 'Syncs every 15 minutes',
          leading: const Icon(M3EIcons.calendarToday),
          trailing: const Icon(M3EIcons.chevronRight),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _dividers(M3EThemeData theme) {
    return GallerySection(
      title: 'Dividers',
      children: <Widget>[
        M3EContainment.divider(),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: Row(
            children: <Widget>[
              Text(
                'Left',
                style: theme.typeScale.bodyMedium
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
              const SizedBox(width: 12),
              M3EContainment.divider(axis: M3EDividerAxis.vertical),
              const SizedBox(width: 12),
              Text(
                'Right',
                style: theme.typeScale.bodyMedium
                    .copyWith(color: theme.colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _overlays(BuildContext context) {
    return GallerySection(
      title: 'Dialogs & sheets',
      description: 'Tap to present modal surfaces over the app.',
      children: <Widget>[
        DemoRow(
          label: 'Triggers',
          children: <Widget>[
            M3EActions.button(
              label: 'Dialog',
              variant: M3EButtonVariant.filledTonal,
              onPressed: () => _showDialog(context),
            ),
            M3EActions.button(
              label: 'Full screen',
              variant: M3EButtonVariant.filledTonal,
              onPressed: () => _showFullScreen(context),
            ),
            M3EActions.button(
              label: 'Bottom sheet',
              variant: M3EButtonVariant.filledTonal,
              onPressed: () => _showBottomSheet(context),
            ),
            M3EActions.button(
              label: 'Side sheet',
              variant: M3EButtonVariant.filledTonal,
              onPressed: () => _showSideSheet(context),
            ),
          ],
        ),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    M3EContainment.showDialog<void>(
      context,
      dialog: M3EContainment.dialog(
        title: 'Reset settings?',
        icon: const Icon(M3EIcons.error),
        content: const Text(
          'This will restore all settings to their default values.',
        ),
        actions: <Widget>[
          M3EActions.button(
            label: 'Cancel',
            variant: M3EButtonVariant.text,
            onPressed: () => Navigator.of(context).pop(),
          ),
          M3EActions.button(
            label: 'Reset',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showFullScreen(BuildContext context) {
    M3EContainment.showFullScreenDialog<void>(
      context,
      title: 'New event',
      action: M3EActions.button(
        label: 'Save',
        variant: M3EButtonVariant.text,
        onPressed: () => Navigator.of(context).pop(),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Text('Full-screen dialog body content goes here.'),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    M3EContainment.showBottomSheet<void>(
      context,
      builder: (BuildContext context) => const Padding(
        padding: EdgeInsets.all(24),
        child: Text('A modal bottom sheet with a drag handle.'),
      ),
    );
  }

  void _showSideSheet(BuildContext context) {
    M3EContainment.showSideSheet<void>(
      context,
      title: 'Filters',
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Text('Side sheet content for detailed options.'),
      ),
    );
  }
}
