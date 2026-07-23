import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../widgets/gallery_section.dart';

/// Demonstrates every component in the Material 3 *Containment* group.
class ContainmentPage extends StatefulWidget {
  const ContainmentPage({super.key});

  @override
  State<ContainmentPage> createState() => _ContainmentPageState();
}

class _ContainmentPageState extends State<ContainmentPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final List<Widget> _heroCarouselItems = _buildCarouselItems();
  late final List<Widget> _uncontainedCarouselItems = _buildCarouselItems();

  static List<Widget> _buildCarouselItems() {
    return List<Widget>.generate(10, (int index) {
      return ColoredBox(
        color: Colors.primaries[index % Colors.primaries.length]
            .withValues(alpha: 0.8),
        child: const SizedBox.expand(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = M3ETheme.of(context);
    return GalleryPageScrollView(
      sections: <Widget>[
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
              style: theme.typeScale.titleMedium.copyWith(
                color: theme.colorScheme.onSurface,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Supporting text for the card body.',
              style: theme.typeScale.bodyMedium.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                decoration: TextDecoration.none,
              ),
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
              child: M3ECard(child: body('Elevated')),
            ),
            SizedBox(
              width: 220,
              child: M3ECard(
                variant: M3ECardVariant.filled,
                child: body('Filled'),
              ),
            ),
            SizedBox(
              width: 220,
              child: M3ECard(
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
        RepaintBoundary(
          child: SizedBox(
            height: 200,
            child: M3ECarousel(
              type: M3ECarouselType.hero,
              heroAlignment: M3ECarouselHeroAlignment.center,
              onTap: (int tapIndex) => log(tapIndex.toString()),
              children: _heroCarouselItems,
            ),
          ),
        ),
        const SizedBox(height: 16),
        RepaintBoundary(
          child: SizedBox(
            height: 160,
            child: M3ECarousel(
              type: M3ECarouselType.uncontained,
              heroAlignment: M3ECarouselHeroAlignment.center,
              onTap: (int tapIndex) => log(tapIndex.toString()),
              children: _uncontainedCarouselItems,
            ),
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
        M3EListItem(
          headline: 'Wireless charging',
          supportingText: 'On · Fast charge enabled',
          leading: const Icon(M3EIcons.schedule),
          trailing: const Icon(M3EIcons.chevron_right),
          onTap: () {},
        ),
        const SizedBox(height: 8),
        M3EListItem(
          headline: 'Calendar sync',
          supportingText: 'Syncs every 15 minutes',
          leading: const Icon(M3EIcons.calendar_today),
          trailing: const Icon(M3EIcons.chevron_right),
          onTap: () {},
        ),
        const SizedBox(height: 24),
        const _ListLabel('Card list items'),
        M3ECardList(
          itemCount: 3,
          onTap: (index) => log('Tapped card $index'),
          itemBuilder: (context, index) {
            final labels = ['Inbox', 'Drafts', 'Sent'];
            final icons = [M3EIcons.schedule, M3EIcons.calendar_today, M3EIcons.check];
            return M3EListItem(
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
          child: M3ECardList.builder(
            itemCount: 20,
            onTap: (index) => log('Tapped item $index'),
            itemBuilder: (context, index) => M3EListItem(
              headline: 'Scrollable Item $index',
              supportingText: 'Supports many items with lazy loading',
              leading: const Icon(M3EIcons.schedule),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const _ListLabel('Dismissible list (swipe to dismiss)'),
        M3EDismissibleColumn(
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
            return M3EListItem(
              headline: labels[index],
              supportingText: 'Physics-based dismissible card',
              leading: const Icon(M3EIcons.schedule),
            );
          },
        ),
        const SizedBox(height: 24),
        const _ListLabel('Expandable list (expressive motions)'),
        M3EExpandableList(
          data: [
            M3EExpandableData(
              title: 'Battery level low',
              subtitle: 'Plug in your device to avoid losing your work.',
              leading: const Icon(M3EIcons.battery_alert),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your battery is at 10% and will run out soon.'),
                  const SizedBox(height: 8),
                  M3EButton(
                    style: M3EButtonStyle.tonal,
                    onPressed: () {},
                    child: const Text('Enable battery saver'),
                  ),
                ],
              ),
            ),
            M3EExpandableData(
              title: 'System update available',
              subtitle: 'Version 2.4.0 is ready to install.',
              leading: const Icon(M3EIcons.system_update),
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
        const M3EDivider(),
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
              const M3EDivider(axis: M3EDividerAxis.vertical),
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
            M3EButton(
              style: M3EButtonStyle.tonal,
              onPressed: () => _showDialog(context),
              child: const Text('Dialog'),
            ),
            M3EButton(
              style: M3EButtonStyle.tonal,
              onPressed: () => _showDialogWithDividers(context),
              child: const Text('Dialog + dividers'),
            ),
            M3EButton(
              style: M3EButtonStyle.tonal,
              onPressed: () => _showSelectionDialog(context),
              child: const Text('Selection'),
            ),
            M3EButton(
              style: M3EButtonStyle.tonal,
              onPressed: () => _showMultiSelectionDialog(context),
              child: const Text('Multi selection'),
            ),
            M3EButton(
              style: M3EButtonStyle.tonal,
              onPressed: () => _showFullScreen(context),
              child: const Text('Full screen'),
            ),
            M3EButton(
              style: M3EButtonStyle.tonal,
              onPressed: () => _showBottomSheet(context),
              child: const Text('Bottom sheet'),
            ),
            M3EButton(
              style: M3EButtonStyle.tonal,
              onPressed: () => _showSideSheet(context),
              child: const Text('Side sheet'),
            ),
          ],
        ),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    M3EDialog.show<void>(
      context,
      dialog: M3EDialog(
        title: 'Reset settings?',
        icon: const Icon(M3EIcons.error),
        content: const Text(
          'This will restore all settings to their default values.',
        ),
        actions: <Widget>[
          M3EButton(
            style: M3EButtonStyle.text,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          M3EButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showDialogWithDividers(BuildContext context) {
    M3EDialog.show<void>(
      context,
      dialog: M3EDialog(
        title: 'Choose a plan',
        topDivider: true,
        bottomDivider: true,
        content: const Text(
          'Dividers span the full dialog width between the header, '
          'content, and actions.',
        ),
        actions: <Widget>[
          M3EButton(
            style: M3EButtonStyle.text,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          M3EButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) async {
    final List<String>? selected = await M3EDialog.showSelectionScreen(
      context,
      title: 'Choose a plan',
      options: const <String>['Standard', 'Pro', 'Team', 'Enterprise'],
    );
    if (!context.mounted || selected == null) {
      return;
    }
    // Selection confirmed — demo only logs via no-op pop already handled.
  }

  Future<void> _showMultiSelectionDialog(BuildContext context) async {
    final List<String>? selected = await M3EDialog.showSelectionScreen(
      context,
      title: 'Select topics',
      multiSelect: true,
      options: const <String>['Design', 'Engineering', 'Marketing', 'Sales'],
      confirmLabel: 'Done',
    );
    if (!context.mounted || selected == null) {
      return;
    }
  }

  void _showFullScreen(BuildContext context) {
    M3EDialog.showFullScreen<void>(
      context,
      title: 'New event',
      action: M3EButton(
        style: M3EButtonStyle.text,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Save'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Text('Full-screen dialog body content goes here.'),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    M3EBottomSheet.show<void>(
      context,
      builder: (BuildContext context) => const Padding(
        padding: EdgeInsets.all(24),
        child: Text('A modal bottom sheet with a drag handle.'),
      ),
    );
  }

  void _showSideSheet(BuildContext context) {
    M3ESideSheet.show<void>(
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
