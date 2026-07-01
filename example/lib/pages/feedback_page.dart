import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../widgets/gallery_section.dart';

/// Demonstrates the Material 3 *Communication* and *Text input* groups.
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  double _progress = 0.6;
  int _refreshCount = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        _badges(theme),
        _progressSection(),
        _pullToRefresh(),
        _tooltipAndSnackbar(context),
        _inputs(),
      ],
    );
  }

  Widget _badges(M3EThemeData theme) {
    return GallerySection(
      title: 'Badges',
      children: <Widget>[
        DemoRow(
          label: 'Dot and numeric',
          children: <Widget>[
            M3ECommunication.badge(
              child: const Icon(M3EIcons.menu, size: 28),
            ),
            M3ECommunication.badge(
              label: '8',
              child: const Icon(M3EIcons.calendarToday, size: 28),
            ),
            M3ECommunication.badge(
              label: '99+',
              child: const Icon(M3EIcons.edit, size: 28),
            ),
          ],
        ),
      ],
    );
  }

  Widget _progressSection() {
    return GallerySection(
      title: 'Progress & loading',
      children: <Widget>[
        DemoRow(
          label: 'Indeterminate',
          children: <Widget>[
            SizedBox(width: 200, child: M3ECommunication.linearProgress()),
            M3ECommunication.circularProgress(),
            M3ECommunication.loadingIndicator(),
            M3ECommunication.loadingIndicator(
              variant: M3ELoadingIndicatorVariant.contained,
            ),
          ],
        ),
        DemoRow(
          label: 'Determinate',
          children: <Widget>[
            SizedBox(
              width: 200,
              child: M3ECommunication.linearProgress(
                value: _progress,
                shape: M3EProgressShape.flat,
              ),
            ),
            M3ECommunication.circularProgress(value: _progress),
            SizedBox(
              width: 220,
              child: M3ESelection.slider(
                value: _progress,
                onChanged: (double value) =>
                    setState(() => _progress = value),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    if (mounted) {
      setState(() => _refreshCount++);
    }
  }

  Widget _pullToRefresh() {
    return GallerySection(
      title: 'Pull to refresh',
      children: <Widget>[
        DemoRow(
          label: 'Drag the lists down to refresh (count: $_refreshCount)',
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 180,
              child: M3ECommunication.refreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Expressive item ${index + 1}'),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 200,
              height: 180,
              child: M3ECommunication.refreshIndicator(
                onRefresh: _handleRefresh,
                contained: true,
                child: ListView.builder(
                  itemCount: 12,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Contained item ${index + 1}'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _tooltipAndSnackbar(BuildContext context) {
    return GallerySection(
      title: 'Tooltips & snackbar',
      children: <Widget>[
        DemoRow(
          label: 'Hover / long-press the icon; tap for a snackbar',
          children: <Widget>[
            M3ECommunication.tooltip(
              message: 'Compose a new message',
              child: M3EActions.iconButton(
                icon: const Icon(M3EIcons.edit),
                variant: M3EIconButtonVariant.tonal,
                onPressed: () {},
              ),
            ),
            M3EActions.button(
              label: 'Show snackbar',
              onPressed: () => M3ECommunication.showSnackbar(
                context,
                message: 'Draft saved',
                actionLabel: 'Undo',
                onAction: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _inputs() {
    return GallerySection(
      title: 'Text fields & search',
      children: <Widget>[
        M3ETextInputs.textField(
          controller: _nameController,
          label: 'Full name',
          supportingText: 'As it appears on your ID',
          leading: const Icon(M3EIcons.edit),
        ),
        const SizedBox(height: 16),
        M3ETextInputs.textField(
          label: 'Email',
          variant: M3ETextFieldVariant.outlined,
          errorText: 'Enter a valid email address',
        ),
        const SizedBox(height: 16),
        M3ETextInputs.searchBar(
          controller: _searchController,
          hintText: 'Search components',
          trailing: <Widget>[
            M3EActions.iconButton(
              icon: const Icon(M3EIcons.close),
              onPressed: _searchController.clear,
            ),
          ],
        ),
      ],
    );
  }
}
