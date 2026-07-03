import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
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
        _lists(theme),
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
    return GallerySection(
      title: 'Carousel',
      children: <Widget>[
        SizedBox(
          height: 200,
          child: M3EContainment.carousel(
            type: M3ECarouselType.hero,
            heroAlignment: M3ECarouselHeroAlignment.center,
            onTap: (int tapIndex) => log(tapIndex.toString()),
            children: List<Widget>.generate(10, (int index) {
              return ColoredBox(
                color: Colors.primaries[index % Colors.primaries.length].withValues(alpha: 0.8),
                child: const SizedBox.expand(),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: M3EContainment.carousel(
            type: M3ECarouselType.uncontained,
            heroAlignment: M3ECarouselHeroAlignment.center,
            onTap: (int tapIndex) => log(tapIndex.toString()),
            children: List<Widget>.generate(10, (int index) {
              return ColoredBox(
                color: Colors.primaries[index % Colors.primaries.length].withValues(alpha: 0.8),
                child: const SizedBox.expand(),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _lists(M3EThemeData theme) {
    return GallerySection(
      title: 'Lists',
      children: <Widget>[
        const _ListLabel('Standard list items'),
        M3EContainment.listItem(
          headline: 'Wireless charging',
          supportingText: 'On · Fast charge enabled',
          leading: const Icon(M3EIcons.schedule),
          trailing: const Icon(M3EIcons.chevron_right),
          onTap: () {},
        ),
        M3EContainment.divider(),
        M3EContainment.listItem(
          headline: 'Calendar sync',
          supportingText: 'Syncs every 15 minutes',
          leading: const Icon(M3EIcons.calendar_today),
          trailing: const Icon(M3EIcons.chevron_right),
          onTap: () {},
        ),
        const SizedBox(height: 24),
        const _ListLabel('Card list items'),
        M3EContainment.cardList(
          itemCount: 3,
          onTap: (index) => log('Tapped card $index'),
          itemBuilder: (context, index) {
            final labels = ['Inbox', 'Drafts', 'Sent'];
            final icons = [M3EIcons.schedule, M3EIcons.calendar_today, M3EIcons.check];
            return M3EContainment.listItem(
              headline: labels[index],
              supportingText: 'Dynamic rounding based on position',
              leading: Icon(icons[index]),
              trailing: const Icon(M3EIcons.chevron_right),
            );
          },
        ),
        const SizedBox(height: 24),
        const _ListLabel('Card list builder (scrollable)'),
        SizedBox(
          height: 200,
          child: M3EContainment.cardListBuilder(
            itemCount: 20,
            shrinkWrap: true,
            onTap: (index) => log('Tapped item $index'),
            itemBuilder: (context, index) => M3EContainment.listItem(
              headline: 'Scrollable Item $index',
              supportingText: 'Supports many items with lazy loading',
              leading: const Icon(M3EIcons.schedule),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const _ListLabel('Dismissible list (swipe to dismiss)'),
        M3EContainment.dismissibleColumn(
          itemCount: 3,
          onDismiss: (index, direction) async {
            log('Dismissed item $index in direction $direction');
            return true;
          },
          onTap: (index) => log('Tapped dismissible item $index'),
          style: M3EDismissibleListStyle(
            background: Container(
              color: theme.colorScheme.success,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Icon(M3EIcons.check, color: theme.colorScheme.onSurface),
            ),
            secondaryBackground: Container(
              color: theme.colorScheme.danger,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Icon(M3EIcons.close, color: theme.colorScheme.onSurface),
            ),
          ),
          itemBuilder: (context, index) {
            final labels = ['Swipe right to archive', 'Swipe left to delete', 'Expressive physics'];
            return M3EContainment.listItem(
              headline: labels[index],
              supportingText: 'Physics-based dismissible card',
              leading: const Icon(M3EIcons.schedule),
            );
          },
        ),
        const SizedBox(height: 24),
        const _ListLabel('Expandable list (expressive motions)'),
        M3EContainment.expandableCardColumn(
          data: [
            M3EExpandableData(
              title: 'Battery level low',
              subtitle: 'Plug in your device to avoid losing your work.',
              leading: const Icon(Icons.battery_alert),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your battery is at 10% and will run out soon.'),
                  const SizedBox(height: 8),
                  M3EActions.button(
                    label: 'Enable battery saver',
                    style: M3EButtonStyle.tonal,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            M3EExpandableData(
              title: 'System update available',
              subtitle: 'Version 2.4.0 is ready to install.',
              leading: const Icon(Icons.system_update),
              body: const Text(
                'This update includes important security fixes and performance improvements. '
                'It will take approximately 10 minutes to complete.',
              ),
            ),
          ],
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
              style: M3EButtonStyle.tonal,
              onPressed: () => _showDialog(context),
            ),
            M3EActions.button(
              label: 'Full screen',
              style: M3EButtonStyle.tonal,
              onPressed: () => _showFullScreen(context),
            ),
            M3EActions.button(
              label: 'Bottom sheet',
              style: M3EButtonStyle.tonal,
              onPressed: () => _showBottomSheet(context),
            ),
            M3EActions.button(
              label: 'Side sheet',
              style: M3EButtonStyle.tonal,
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
            style: M3EButtonStyle.text,
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
        style: M3EButtonStyle.text,
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

class _ListLabel extends StatelessWidget {
  const _ListLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: theme.typeScale.labelLarge.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
