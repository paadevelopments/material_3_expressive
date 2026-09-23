import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

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
  bool _safeArea = true;
  String _title = 'Inbox';

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

  void _openDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _AppBarDemoHost(
            kind: _kind,
            density: _density,
            shape: _shape,
            variant: _variant,
            centerTitle: _centerTitle,
            safeArea: _safeArea,
            title: _title,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'App bar demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a full screen for the selected app bar, with a page '
                'under it. Scroll the sliver variant to review its size.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open app bar demo'),
              ),
            ],
          ),
        ),
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

class _AppBarDemoHost extends StatefulWidget {
  const _AppBarDemoHost({
    required this.kind,
    required this.density,
    required this.shape,
    required this.variant,
    required this.centerTitle,
    required this.safeArea,
    required this.title,
  });

  final _AppBarKind kind;
  final M3EAppBarDensity density;
  final M3EAppBarShapeFamily shape;
  final M3EAppBarVariant variant;
  final bool centerTitle;
  final bool safeArea;
  final String title;

  @override
  State<_AppBarDemoHost> createState() => _AppBarDemoHostState();
}

class _AppBarDemoHostState extends State<_AppBarDemoHost> {
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

  Widget _backButton() {
    return M3EIconButton(
      variant: M3EIconButtonVariant.standard,
      icon: const Icon(M3EIcons.arrow_back),
      tooltip: 'Back',
      onPressed: () => Navigator.of(context).maybePop(),
    );
  }

  Widget _action(IconData icon) {
    return M3EIconButton(
      variant: M3EIconButtonVariant.standard,
      icon: Icon(icon),
      onPressed: () {},
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

  Widget _page() {
    return M3ECardList.builder(
      itemCount: 16,
      listPadding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Message ${index + 1}',
          supportingText: widget.title,
          leading: const Icon(M3EIcons.mail),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final Widget page = _page();
    return switch (widget.kind) {
      _AppBarKind.top => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: M3EAppBar.top(
          titleText: widget.title,
          centerTitle: widget.centerTitle,
          density: widget.density,
          shapeFamily: widget.shape,
          safeArea: widget.safeArea,
          leading: _backButton(),
          actions: <Widget>[_action(M3EIcons.search)],
        ),
        body: page,
      ),
      _AppBarKind.search => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: M3EAppBar.search(
          searchController: _searchController,
          barHintText: 'Search mail',
          density: widget.density,
          shapeFamily: widget.shape,
          centerTitle: widget.centerTitle,
          safeArea: widget.safeArea,
          leading: _backButton(),
          actions: <Widget>[_action(M3EIcons.account_circle)],
          suggestionsBuilder: _buildSuggestions,
        ),
        body: page,
      ),
      _AppBarKind.bottom => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: M3EAppBar.top(titleText: widget.title, leading: _backButton()),
        body: page,
        bottomNavigationBar: M3EAppBar.bottom(
          safeArea: widget.safeArea,
          actions: <Widget>[
            _action(M3EIcons.menu),
            _action(M3EIcons.search),
            _action(M3EIcons.edit),
          ],
          floatingActionButton: M3EFab(
            icon: const Icon(M3EIcons.add),
            size: M3EFabSize.small,
            onPressed: () {},
          ),
        ),
      ),
      _AppBarKind.sliver => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: CustomScrollView(
          slivers: <Widget>[
            M3EAppBar.sliver(
              titleText: widget.title,
              centerTitle: widget.centerTitle,
              density: widget.density,
              shapeFamily: widget.shape,
              variant: widget.variant,
              leading: _backButton(),
              actions: <Widget>[_action(M3EIcons.search)],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: M3ECardList(
                  itemCount: 24,
                  itemBuilder: (BuildContext context, int index) {
                    return M3EListItem(
                      headline: 'Message ${index + 1}',
                      supportingText: widget.title,
                      leading: const Icon(M3EIcons.mail),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    };
  }
}
