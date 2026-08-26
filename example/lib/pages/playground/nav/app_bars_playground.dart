import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EAppBar] variants.
class AppBarsPlayground extends StatefulWidget {
  /// Creates the app bars playground.
  const AppBarsPlayground({super.key});

  @override
  State<AppBarsPlayground> createState() => _AppBarsPlaygroundState();
}

enum _AppBarKind { top, search, bottom, sliver }

class _AppBarsPlaygroundState extends State<AppBarsPlayground> {
  _AppBarKind _kind = _AppBarKind.top;
  M3EAppBarDensity _density = M3EAppBarDensity.regular;
  M3EAppBarShapeFamily _shape = M3EAppBarShapeFamily.square;
  M3EAppBarVariant _variant = M3EAppBarVariant.medium;
  bool _centerTitle = false;
  bool _safeArea = false;
  String _title = 'Inbox';

  final M3ESearchController _searchController = M3ESearchController();

  static const List<String> _suggestions = <String>[
    'Inbox',
    'Starred',
    'Sent',
    'Drafts',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _framed(M3EThemeData theme, Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: M3EShapes.radiusLarge,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ClipRRect(borderRadius: M3EShapes.radiusLarge, child: child),
    );
  }

  Widget _icon(IconData icon) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(child: Icon(icon, size: 24)),
    );
  }

  Iterable<Widget> _buildSuggestions(
    BuildContext context,
    M3ESearchController controller,
  ) {
    final String query = controller.text.trim().toLowerCase();
    final Iterable<String> matches = query.isEmpty
        ? _suggestions
        : _suggestions.where((String n) => n.toLowerCase().contains(query));
    return matches.map(
      (String name) => GestureDetector(
        onTap: () => controller.closeView(name),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(name),
        ),
      ),
    );
  }

  Widget _topPreview(M3EThemeData theme) {
    return _framed(
      theme,
      M3EAppBar.top(
        titleText: _title,
        centerTitle: _centerTitle,
        density: _density,
        shapeFamily: _shape,
        safeArea: _safeArea,
        leading: _icon(M3EIcons.menu),
        actions: <Widget>[_icon(M3EIcons.search)],
      ),
    );
  }

  Widget _searchPreview(M3EThemeData theme) {
    return _framed(
      theme,
      M3EAppBar.search(
        searchController: _searchController,
        barHintText: 'Search mail',
        density: _density,
        shapeFamily: _shape,
        centerTitle: _centerTitle,
        safeArea: _safeArea,
        leading: _icon(M3EIcons.menu),
        actions: <Widget>[_icon(M3EIcons.account_circle)],
        suggestionsBuilder: _buildSuggestions,
      ),
    );
  }

  Widget _bottomPreview(M3EThemeData theme) {
    return _framed(
      theme,
      M3EAppBar.bottom(
        safeArea: _safeArea,
        actions: <Widget>[
          _icon(M3EIcons.menu),
          _icon(M3EIcons.search),
          _icon(M3EIcons.edit),
        ],
        floatingActionButton: M3EFab(
          icon: const Icon(M3EIcons.add),
          size: M3EFabSize.small,
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _sliverPreview(M3EThemeData theme) {
    return _framed(
      theme,
      SizedBox(
        height: 180,
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: <Widget>[
            M3EAppBar.sliver(
              titleText: _title,
              centerTitle: _centerTitle,
              density: _density,
              shapeFamily: _shape,
              variant: _variant,
              actions: <Widget>[_icon(M3EIcons.search)],
            ),
            SliverList.list(
              children: <Widget>[
                for (int i = 0; i < 4; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      'Item ${i + 1}',
                      style: theme.typeScale.bodyMedium,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _preview(M3EThemeData theme) {
    return switch (_kind) {
      _AppBarKind.top => _topPreview(theme),
      _AppBarKind.search => _searchPreview(theme),
      _AppBarKind.bottom => _bottomPreview(theme),
      _AppBarKind.sliver => _sliverPreview(theme),
    };
  }

  List<PlaySnippet> get _snippets {
    final String sample = switch (_kind) {
      _AppBarKind.top =>
        '''
M3EAppBar.top(
  titleText: ${playDartString(_title)},
  centerTitle: $_centerTitle,
  density: M3EAppBarDensity.${_density.name},
  shapeFamily: M3EAppBarShapeFamily.${_shape.name},
  safeArea: $_safeArea,
  leading: const Icon(M3EIcons.menu),
  actions: const <Widget>[Icon(M3EIcons.search)],
);''',
      _AppBarKind.search =>
        '''
M3EAppBar.search(
  searchController: searchController,
  barHintText: 'Search mail',
  density: M3EAppBarDensity.${_density.name},
  shapeFamily: M3EAppBarShapeFamily.${_shape.name},
  centerTitle: $_centerTitle,
  safeArea: $_safeArea,
  leading: const Icon(M3EIcons.menu),
  suggestionsBuilder: (context, controller) => const <Widget>[],
);''',
      _AppBarKind.bottom =>
        '''
M3EAppBar.bottom(
  safeArea: $_safeArea,
  actions: const <Widget>[
    Icon(M3EIcons.menu),
    Icon(M3EIcons.search),
    Icon(M3EIcons.edit),
  ],
  floatingActionButton: M3EFab(
    icon: const Icon(M3EIcons.add),
    size: M3EFabSize.small,
    onPressed: () {},
  ),
);''',
      _AppBarKind.sliver =>
        '''
M3EAppBar.sliver(
  titleText: ${playDartString(_title)},
  centerTitle: $_centerTitle,
  density: M3EAppBarDensity.${_density.name},
  shapeFamily: M3EAppBarShapeFamily.${_shape.name},
  variant: M3EAppBarVariant.${_variant.name},
  actions: const <Widget>[Icon(M3EIcons.search)],
);''',
    };
    return <PlaySnippet>[
      PlaySnippet(label: _kind.name, code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(label: _kind.name, child: _preview(theme)),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Variant',
          children: <Widget>[
            PlayEnumMenu<_AppBarKind>(
              label: 'Kind',
              value: _kind,
              values: _AppBarKind.values,
              labelOf: (_AppBarKind v) => v.name,
              onChanged: (_AppBarKind v) => setState(() => _kind = v),
            ),
            if (_kind == _AppBarKind.sliver)
              PlayEnumSegmented<M3EAppBarVariant>(
                label: 'Sliver size',
                value: _variant,
                values: M3EAppBarVariant.values,
                labelOf: (M3EAppBarVariant v) => v.name,
                onChanged: (M3EAppBarVariant v) {
                  setState(() => _variant = v);
                },
              ),
          ],
        ),
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumSegmented<M3EAppBarDensity>(
              label: 'Density',
              value: _density,
              values: M3EAppBarDensity.values,
              labelOf: (M3EAppBarDensity v) => v.name,
              onChanged: (M3EAppBarDensity v) {
                setState(() => _density = v);
              },
            ),
            PlayEnumSegmented<M3EAppBarShapeFamily>(
              label: 'Shape',
              value: _shape,
              values: M3EAppBarShapeFamily.values,
              labelOf: (M3EAppBarShapeFamily v) => v.name,
              onChanged: (M3EAppBarShapeFamily v) {
                setState(() => _shape = v);
              },
            ),
            PlaySwitch(
              label: 'Center title',
              value: _centerTitle,
              onChanged: (bool v) => setState(() => _centerTitle = v),
            ),
            PlaySwitch(
              label: 'Safe area',
              value: _safeArea,
              onChanged: (bool v) => setState(() => _safeArea = v),
            ),
            PlayTextField(
              label: 'Title',
              value: _title,
              onChanged: (String v) => setState(() => _title = v),
            ),
          ],
        ),
      ],
    );
  }
}
