import 'package:flutter/material.dart' show ListTile;
import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/icon_buttons/enums/m3e_icon_button_enums.dart';
import 'package:material_3_expressive/components/text_fields/enums/m3e_text_field_variant.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../widgets/gallery_section.dart';

/// Demonstrates the Material 3 *Communication* and *Text input* groups.
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final M3ESearchController _anchorSearchController = M3ESearchController();
  double _progress = 0.6;
  int _refreshCount = 0;

  static const List<String> _galleryComponentNames = <String>[
    'Buttons',
    'Cards',
    'Carousel',
    'Checkbox',
    'Chips',
    'Date picker',
    'Dialog',
    'Dropdown',
    'FAB',
    'Navigation bar',
    'Progress',
    'Search bar',
    'Slider',
    'Snackbar',
    'Switch',
    'Tabs',
    'Text field',
    'Time picker',
    'Tooltip',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = M3ETheme.of(context);
    return GalleryPageScrollView(
      sections: <Widget>[
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
            const M3EBadge(
              showDot: true,
              child: Icon(M3EIcons.menu, size: 28),
            ),
            const M3EBadge(
              count: 8,
              child: Icon(M3EIcons.calendar_today, size: 28),
            ),
            const M3EBadge(
              count: 120,
              child: Icon(M3EIcons.edit, size: 28),
            ),
          ],
        ),
      ],
    );
  }

  Widget _progressSection() {
    return RepaintBoundary(
      child: GallerySection(
        title: 'Progress & loading',
        children: <Widget>[
          DemoRow(
            label: 'Indeterminate',
            children: <Widget>[
              const SizedBox(width: 200, child: M3ELinearProgress()),
              const M3ECircularProgress(),
              const M3ELoadingIndicator(),
              const M3ELoadingIndicator(
                variant: M3ELoadingIndicatorVariant.contained,
              ),
            ],
          ),
          DemoRow(
            label: 'Determinate',
            children: <Widget>[
              SizedBox(
                width: 200,
                child: M3ELinearProgress(
                  value: _progress,
                  shape: M3EProgressShape.flat,
                ),
              ),
              M3ECircularProgress(value: _progress),
              SizedBox(
                width: 220,
                child: M3ESlider(
                  value: _progress,
                  onChanged: (double value) =>
                      setState(() => _progress = value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 5));
    if (mounted) {
      setState(() => _refreshCount++);
    }
  }

  Widget _pullToRefresh() {
    return RepaintBoundary(
      child: GallerySection(
        title: 'Pull to refresh',
        children: <Widget>[
          DemoRow(
            label: 'Drag the lists down to refresh (count: $_refreshCount)',
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 180,
                child: M3ERefreshIndicator(
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
                child: M3ERefreshIndicator.contained(
                  onRefresh: _handleRefresh,
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
      ),
    );
  }

  Widget _tooltipAndSnackbar(BuildContext context) {
    return GallerySection(
      title: 'Tooltips & snackbar',
      children: <Widget>[
        DemoRow(
          label: 'Hover / long-press the icon; tap for a snackbar',
          children: <Widget>[
            M3ETooltip(
              message: 'Compose a new message',
              child: M3EIconButton(
                icon: const Icon(M3EIcons.edit),
                variant: M3EIconButtonVariant.tonal,
                onPressed: () {},
              ),
            ),
            M3EButton(
              onPressed: () => M3ESnackbar.show(
                context,
                message: 'Draft saved',
                actionLabel: 'Undo',
                onAction: () {},
              ),
              child: const Text('Show snackbar'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _inputs() {
    return GallerySection(
      title: 'Text fields & search',
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            children: [
              M3ETextField(
                controller: _nameController,
                label: 'Full name',
                supportingText: 'As it appears on your ID',
                leading: const Icon(M3EIcons.edit),
              ),
              const SizedBox(height: 16),
              const M3ETextField(
                label: 'Email',
                variant: M3ETextFieldVariant.outlined,
                errorText: 'Enter a valid email address',
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 24, 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              M3ESearchBar(
                controller: _searchController,
                expandOnFocus: true,
                hintText: 'Search components',
                trailing: <Widget>[
                  M3EIconButton(
                    icon: const Icon(M3EIcons.close),
                    onPressed: _searchController.clear,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              M3ESearchAnchor.bar(
                searchController: _anchorSearchController,
                barHintText: 'Search gallery components',
                shrinkWrap: true,
                suggestionsBuilder:
                    (BuildContext context, M3ESearchController controller) {
                  final String query = controller.text.trim().toLowerCase();
                  final Iterable<String> matches = query.isEmpty
                      ? _galleryComponentNames
                      : _galleryComponentNames.where(
                        (String name) => name.toLowerCase().contains(query),
                  );
                  return matches.map(
                        (String name) => ListTile(
                      title: Text(name),
                      onTap: () => controller.closeView(name),
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
