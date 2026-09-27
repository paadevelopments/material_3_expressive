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

enum _SearchArrangement { outside, inside, twoTrailing }

enum _Flexibility { expanded, collapsed }

class _AppBarsPlaygroundState extends State<AppBarsPlayground> {
  _AppBarKind _kind = _AppBarKind.top;
  M3EAppBarDensity _density = M3EAppBarDensity.regular;
  M3EAppBarShapeFamily _shape = M3EAppBarShapeFamily.square;
  M3EAppBarVariant _variant = M3EAppBarVariant.mediumFlexible;
  bool _centerTitle = false;
  bool _safeArea = true;
  bool _subtitle = false;
  bool _imageTitle = false;
  bool _filledAction = true;
  bool _useController = false;
  M3EAppBarHideMode _hideMode = M3EAppBarHideMode.none;
  _Flexibility _flexibility = _Flexibility.expanded;
  _SearchArrangement _searchArrangement = _SearchArrangement.outside;
  bool _wrapActions = false;
  String _title = 'Inbox';

  bool get _canFlex => _variant != M3EAppBarVariant.small;

  List<PlaySnippet> get _snippets {
    final String controllerSetup = !_useController
        ? ''
        : '''
final controller = M3EAppBarController();
${_canFlex && _flexibility == _Flexibility.collapsed ? 'controller.collapse();\n' : ''}''';
    final String controllerArg = _useController
        ? '  controller: controller,\n'
        : '';
    final String sample = switch (_kind) {
      _AppBarKind.top =>
        '''
$controllerSetup
M3EAppBar.top(
$controllerArg  titleText: ${playDartString(_title)},
  subtitleText: ${_subtitle ? "'New messages'" : 'null'},
  centerTitle: $_centerTitle,
  variant: M3EAppBarVariant.${_variant.name},
  hideMode: M3EAppBarHideMode.${_hideMode.name},
  density: M3EAppBarDensity.${_density.name},
  shapeFamily: M3EAppBarShapeFamily.${_shape.name},
  safeArea: $_safeArea,
  leading: const Icon(M3EIcons.menu),
  actions: const <Widget>[
    M3EIconButton(
      icon: Icon(M3EIcons.search),
      variant: M3EIconButtonVariant.filled,
      onPressed: null,
    ),
  ],
);''',
      _AppBarKind.search =>
        '''
$controllerSetup
M3EAppBar.search(
$controllerArg  searchController: searchController,
  barHintText: 'Search mail',
  variant: M3EAppBarVariant.${_variant.name},
  hideMode: M3EAppBarHideMode.${_hideMode.name},
  density: M3EAppBarDensity.${_density.name},
  shapeFamily: M3EAppBarShapeFamily.${_shape.name},
  centerTitle: $_centerTitle,
  wrapActions: $_wrapActions,
  safeArea: $_safeArea,
  leading: const Icon(M3EIcons.menu),
  suggestionsBuilder: (context, controller) => const <Widget>[],
);''',
      _AppBarKind.bottom =>
        '''
$controllerSetup
M3EAppBar.top(
$controllerArg  titleText: ${playDartString(_title)},
  variant: M3EAppBarVariant.${_variant.name},
  hideMode: M3EAppBarHideMode.${_hideMode.name},
);
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
$controllerSetup
M3EAppBar.sliver(
$controllerArg  titleText: ${playDartString(_title)},
  subtitleText: ${_subtitle ? "'New messages'" : 'null'},
  centerTitle: $_centerTitle,
  density: M3EAppBarDensity.${_density.name},
  shapeFamily: M3EAppBarShapeFamily.${_shape.name},
  variant: M3EAppBarVariant.${_variant.name},
  hideMode: M3EAppBarHideMode.${_hideMode.name},
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
            subtitle: _subtitle,
            imageTitle: _imageTitle,
            filledAction: _filledAction,
            hideMode: _hideMode,
            searchArrangement: _searchArrangement,
            wrapActions: _wrapActions,
            startExpanded: !_canFlex || _flexibility == _Flexibility.expanded,
            useController: _useController,
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
                'Opens a full screen for the selected app bar. Scrolling any '
                'variant switches the bar to the scrolled surface and '
                'elevation, and scrolling back to the top restores them. '
                'Set flexibility and the controller here, then open the demo.',
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
            PlayEnumSegmented<M3EAppBarVariant>(
              label: 'Variant',
              value: _variant,
              values: M3EAppBarVariant.values,
              labelOf: _variantLabel,
              onChanged: (M3EAppBarVariant v) {
                setState(() => _variant = v);
              },
            ),
            if (_canFlex)
              PlayEnumSegmented<_Flexibility>(
                label: 'Flexibility',
                value: _flexibility,
                values: _Flexibility.values,
                labelOf: (_Flexibility v) => v.name,
                onChanged: (_Flexibility v) {
                  setState(() => _flexibility = v);
                },
              ),
            PlayEnumSegmented<M3EAppBarHideMode>(
              label: 'Hide on scroll',
              value: _hideMode,
              values: M3EAppBarHideMode.values,
              labelOf: (M3EAppBarHideMode v) => v.name,
              onChanged: (M3EAppBarHideMode v) {
                setState(() => _hideMode = v);
              },
            ),
          ],
        ),
        PlayControlPanel(
          title: 'Controller',
          children: <Widget>[
            PlaySwitch(
              label: 'Controller',
              value: _useController,
              onChanged: (bool v) => setState(() => _useController = v),
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
            PlaySwitch(
              label: 'Subtitle',
              value: _subtitle,
              onChanged: (bool v) => setState(() => _subtitle = v),
            ),
            if (_kind == _AppBarKind.top)
              PlaySwitch(
                label: 'Image title',
                value: _imageTitle,
                onChanged: (bool v) => setState(() => _imageTitle = v),
              ),
            PlaySwitch(
              label: 'Filled trailing action',
              value: _filledAction,
              onChanged: (bool v) => setState(() => _filledAction = v),
            ),
            if (_kind == _AppBarKind.search) ...<Widget>[
              PlayEnumMenu<_SearchArrangement>(
                label: 'Search arrangement',
                value: _searchArrangement,
                values: _SearchArrangement.values,
                labelOf: (_SearchArrangement v) => v.name,
                onChanged: (_SearchArrangement v) {
                  setState(() => _searchArrangement = v);
                },
              ),
              PlaySwitch(
                label: 'Wrap actions',
                value: _wrapActions,
                onChanged: (bool v) => setState(() => _wrapActions = v),
              ),
            ],
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

  String _variantLabel(M3EAppBarVariant variant) {
    return switch (variant) {
      M3EAppBarVariant.small => 'small',
      M3EAppBarVariant.mediumFlexible => 'medium flexible',
      M3EAppBarVariant.largeFlexible => 'large flexible',
      M3EAppBarVariant.medium => 'medium baseline',
      M3EAppBarVariant.large => 'large baseline',
    };
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
    required this.subtitle,
    required this.imageTitle,
    required this.filledAction,
    required this.hideMode,
    required this.searchArrangement,
    required this.wrapActions,
    required this.startExpanded,
    required this.useController,
  });

  final _AppBarKind kind;
  final M3EAppBarDensity density;
  final M3EAppBarShapeFamily shape;
  final M3EAppBarVariant variant;
  final bool centerTitle;
  final bool safeArea;
  final String title;
  final bool subtitle;
  final bool imageTitle;
  final bool filledAction;
  final M3EAppBarHideMode hideMode;
  final _SearchArrangement searchArrangement;
  final bool wrapActions;
  final bool startExpanded;
  final bool useController;

  @override
  State<_AppBarDemoHost> createState() => _AppBarDemoHostState();
}

class _AppBarDemoHostState extends State<_AppBarDemoHost> {
  final M3ESearchController _searchController = M3ESearchController();
  M3EAppBarController? _appBarController;
  int _manual = 2;

  static const List<String> _suggestions = <String>[
    'Inbox',
    'Starred',
    'Sent',
    'Drafts',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.useController) {
      _appBarController = M3EAppBarController();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _applyStart();
    });
  }

  Future<void> _applyStart() async {
    if (widget.startExpanded || widget.variant == M3EAppBarVariant.small) {
      return;
    }
    final M3EAppBarController? controller = _appBarController;
    if (controller != null) {
      await controller.collapse();
      return;
    }
    final ScrollController? primary = PrimaryScrollController.maybeOf(context);
    if (primary == null || !primary.hasClients) {
      return;
    }
    final M3EAppBarMetrics metrics = M3ETheme.of(context).appBarTheme
        .metrics(widget.density);
    final double expanded = metrics.expandedHeight(
      widget.variant,
      hasSubtitle: widget.subtitle,
    );
    final double target = expanded - metrics.collapsedHeight;
    primary.jumpTo(target.clamp(0, primary.position.maxScrollExtent));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _appBarController?.dispose();
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

  Widget _action(IconData icon, {bool filled = false}) {
    return M3EIconButton(
      variant: filled
          ? M3EIconButtonVariant.filled
          : M3EIconButtonVariant.standard,
      icon: Icon(icon),
      tooltip: filled ? 'Create' : 'Action',
      onPressed: () {},
    );
  }

  Widget _imageTitle() {
    final M3EThemeData theme = M3ETheme.of(context);
    final double size = theme.appBarTheme.avatarSize;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
    );
  }

  List<Widget> _trailing() {
    return <Widget>[
      if (widget.filledAction) _action(M3EIcons.edit, filled: true),
      _action(M3EIcons.search),
    ];
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

  Widget _messages() {
    return M3EList(
      color: M3ETheme.of(context).colorScheme.surfaceContainerHighest,
      itemCount: 24,
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Message ${index + 1}',
          supportingText: widget.title,
          leading: const Icon(M3EIcons.mail),
        );
      },
    );
  }

  Widget _scrollPage() {
    return ListView(
      children: <Widget>[
        Padding(padding: const EdgeInsets.all(16), child: _messages()),
      ],
    );
  }

  Widget? _titleWidget() {
    if (widget.imageTitle) {
      return _imageTitle();
    }
    return null;
  }

  String? get _subtitleText => widget.subtitle ? 'New messages' : null;

  Widget _screen(Widget page) {
    final M3EAppBarController? controller = _appBarController;
    if (controller == null) {
      return page;
    }
    return Stack(
      children: <Widget>[
        page,
        M3EToolbar.floating(
          alignment: Alignment.bottomCenter,
          safeArea: false,
          activeIndex: _manual,
          onActiveIndexChanged: (int index) {
            setState(() => _manual = index);
            switch (index) {
              case 0:
                controller.show();
              case 1:
                controller.hide();
              default:
                controller.followScroll();
            }
          },
          actions: <M3EToolbarItem>[
            M3EToolbarAction(
              icon: M3EIcons.visibility,
              label: 'Show',
              tooltip: 'Show',
              onPressed: controller.show,
            ),
            M3EToolbarAction(
              icon: M3EIcons.visibility_off,
              label: 'Hide',
              tooltip: 'Hide',
              onPressed: controller.hide,
            ),
            M3EToolbarAction(
              icon: M3EIcons.autorenew,
              label: 'Auto',
              tooltip: 'Auto',
              onPressed: controller.followScroll,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final Widget? image = _titleWidget();
    final M3EAppBarController? controller = _appBarController;
    final Widget page = switch (widget.kind) {
      _AppBarKind.top => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: M3EAppBar.top(
          controller: controller,
          title: image,
          titleText: image == null ? widget.title : null,
          subtitleText: _subtitleText,
          centerTitle: widget.centerTitle,
          variant: widget.variant,
          hideMode: widget.hideMode,
          density: widget.density,
          shapeFamily: widget.shape,
          safeArea: widget.safeArea,
          leading: _backButton(),
          actions: _trailing(),
        ),
        body: _scrollPage(),
      ),
      _AppBarKind.search => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: M3EAppBar.search(
          controller: controller,
          searchController: _searchController,
          barHintText: 'Search mail',
          variant: widget.variant,
          hideMode: widget.hideMode,
          density: widget.density,
          shapeFamily: widget.shape,
          centerTitle: widget.centerTitle,
          wrapActions: widget.wrapActions,
          safeArea: widget.safeArea,
          leading: widget.searchArrangement == _SearchArrangement.inside
              ? null
              : _backButton(),
          barLeading: widget.searchArrangement == _SearchArrangement.inside
              ? const Icon(M3EIcons.menu)
              : null,
          barTrailing: widget.searchArrangement == _SearchArrangement.inside
              ? <Widget>[const Icon(M3EIcons.mic)]
              : null,
          actions: widget.searchArrangement == _SearchArrangement.twoTrailing
              ? <Widget>[
                  _action(M3EIcons.account_circle),
                  _action(M3EIcons.more_vert),
                ]
              : <Widget>[_action(M3EIcons.account_circle)],
          suggestionsBuilder: _buildSuggestions,
        ),
        body: _scrollPage(),
      ),
      _AppBarKind.bottom => Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: M3EAppBar.top(
          controller: controller,
          titleText: widget.title,
          subtitleText: _subtitleText,
          centerTitle: widget.centerTitle,
          variant: widget.variant,
          hideMode: widget.hideMode,
          density: widget.density,
          shapeFamily: widget.shape,
          safeArea: widget.safeArea,
          leading: _backButton(),
          actions: _trailing(),
        ),
        body: _scrollPage(),
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
              controller: controller,
              title: image,
              titleText: image == null ? widget.title : null,
              subtitleText: _subtitleText,
              centerTitle: widget.centerTitle,
              density: widget.density,
              shapeFamily: widget.shape,
              variant: widget.variant,
              hideMode: widget.hideMode,
              leading: _backButton(),
              actions: _trailing(),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(child: _messages()),
            ),
          ],
        ),
      ),
    };
    return _screen(page);
  }
}
