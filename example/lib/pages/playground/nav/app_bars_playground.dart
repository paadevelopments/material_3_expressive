import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3EAppBar] variants.
class AppBarsPlayground extends PlaygroundWidget {
  /// Creates the app bars playground.
  const AppBarsPlayground({super.key});

  @override
  PlaygroundState<AppBarsPlayground> createState() => _AppBarsPlaygroundState();
}

enum _AppBarKind { top, search, bottom, sliver }

enum _SearchArrangement { outside, inside, twoTrailing }

enum _Flexibility { expanded, collapsed }

class _AppBarsPlaygroundState extends PlaygroundState<AppBarsPlayground> {
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

  @override
  List<PlaySnippet> get snippets {
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

  final M3ESearchController _searchController = M3ESearchController();
  M3EAppBarController? _appBarController;
  int _manual = 2;
  String? _startKey;

  static const List<String> _suggestions = <String>[
    'Inbox',
    'Starred',
    'Sent',
    'Drafts',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _appBarController?.dispose();
    super.dispose();
  }

  /// Hide mode has no effect on a bar that is not at the top.
  bool get _canHide => _kind != _AppBarKind.bottom;

  /// A bar that hides on scroll needs the content to run behind it.
  bool get _hidesOnScroll => _canHide && _hideMode != M3EAppBarHideMode.none;

  bool get _startExpanded => !_canFlex || _flexibility == _Flexibility.expanded;

  void _setUseController(bool value) {
    setState(() {
      _useController = value;
      final M3EAppBarController? old = _appBarController;
      _appBarController = value ? M3EAppBarController() : null;
      if (old != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
      }
    });
  }

  /// Collapses a flexible bar once it is built with "collapsed" picked.
  void _scheduleStart(BuildContext context) {
    final String key = '$_kind-$_variant-$_flexibility-$_useController';
    if (key == _startKey) {
      return;
    }
    _startKey = key;
    if (_startExpanded) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || !context.mounted) {
        return;
      }
      final M3EAppBarController? controller = _appBarController;
      if (controller != null) {
        await controller.collapse();
        return;
      }
      final ScrollController? primary = PrimaryScrollController.maybeOf(
        context,
      );
      if (primary == null || !primary.hasClients) {
        return;
      }
      final M3EAppBarMetrics metrics = M3ETheme.of(context).appBarTheme
          .metrics(_density);
      final double expanded = metrics.expandedHeight(
        _variant,
        hasSubtitle: _subtitle,
      );
      final double target = expanded - metrics.collapsedHeight;
      primary.jumpTo(target.clamp(0, primary.position.maxScrollExtent));
    });
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

  Widget? _imageTitleWidget(BuildContext context) {
    if (!_imageTitle || _kind == _AppBarKind.search) {
      return null;
    }
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

  List<Widget> _trailing(PlaygroundChrome chrome) {
    return <Widget>[
      if (_filledAction) _action(M3EIcons.edit, filled: true),
      _action(M3EIcons.search),
      ...chrome.trailingActions,
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

  Widget _messages(BuildContext context) {
    return M3EList(
      color: M3ETheme.of(context).colorScheme.surfaceContainerHighest,
      itemCount: 24,
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Message ${index + 1}',
          supportingText: _title,
          leading: const Icon(M3EIcons.mail),
        );
      },
    );
  }

  String? get _subtitleText => _subtitle ? 'New messages' : null;

  /// Floating show / hide / auto toolbar driving the bar controller.
  Widget _controllerToolbar(M3EAppBarController controller) {
    return M3EToolbar.floating(
      alignment: Alignment.bottomCenter,
      safeArea: true,
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
    );
  }

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    _scheduleStart(context);
    final Widget page;
    if (_kind == _AppBarKind.sliver) {
      final Widget? image = _imageTitleWidget(context);
      // The sliver bar sits first in the scroll view, below the banner.
      page = Padding(
        padding: EdgeInsets.only(top: padding.top - 16),
        child: CustomScrollView(
          primary: true,
          slivers: <Widget>[
            M3EAppBar.sliver(
              controller: _appBarController,
              title: image,
              titleText: image == null ? _title : null,
              subtitleText: _subtitleText,
              centerTitle: _centerTitle,
              density: _density,
              shapeFamily: _shape,
              variant: _variant,
              hideMode: _hideMode,
              actions: _trailing(const PlaygroundChrome()),
            ),
            SliverPadding(
              padding: padding.copyWith(top: 16),
              sliver: SliverToBoxAdapter(child: _messages(context)),
            ),
          ],
        ),
      );
    } else {
      page = ListView(
        primary: true,
        padding: padding,
        children: <Widget>[_messages(context)],
      );
    }
    final M3EAppBarController? controller = _appBarController;
    if (controller == null) {
      return page;
    }
    return Stack(
      children: <Widget>[
        Positioned.fill(child: page),
        _controllerToolbar(controller),
      ],
    );
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    final Widget? image = _imageTitleWidget(context);
    final M3EAppBarController? controller = _appBarController;
    switch (_kind) {
      case _AppBarKind.sliver:
        return const PlaygroundSlots();
      case _AppBarKind.search:
        final bool inside = _searchArrangement == _SearchArrangement.inside;
        return PlaygroundSlots(
          extendBodyBehindAppBar: _hidesOnScroll,
          appBar: M3EAppBar.search(
            controller: controller,
            searchController: _searchController,
            barHintText: 'Search mail',
            variant: _variant,
            hideMode: _hideMode,
            density: _density,
            shapeFamily: _shape,
            centerTitle: _centerTitle,
            wrapActions: _wrapActions,
            safeArea: _safeArea,
            leading: inside ? null : chrome.leading,
            barLeading: inside ? const Icon(M3EIcons.menu) : null,
            barTrailing: inside ? <Widget>[const Icon(M3EIcons.mic)] : null,
            actions: <Widget>[
              _action(M3EIcons.account_circle),
              if (_searchArrangement == _SearchArrangement.twoTrailing)
                _action(M3EIcons.more_vert),
              ...chrome.trailingActions,
            ],
            suggestionsBuilder: _buildSuggestions,
          ),
        );
      case _AppBarKind.top:
      case _AppBarKind.bottom:
        final bool bottom = _kind == _AppBarKind.bottom;
        return PlaygroundSlots(
          extendBodyBehindAppBar: _hidesOnScroll,
          appBar: M3EAppBar.top(
            controller: controller,
            title: bottom ? null : image,
            titleText: bottom || image == null ? _title : null,
            subtitleText: _subtitleText,
            centerTitle: _centerTitle,
            variant: _variant,
            hideMode: _hideMode,
            density: _density,
            shapeFamily: _shape,
            safeArea: _safeArea,
            leading: chrome.leading,
            actions: _trailing(chrome),
          ),
          bottomNavigationBar: bottom
              ? M3EAppBar.bottom(
                  safeArea: _safeArea,
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
                )
              : null,
        );
    }
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_AppBarKind>(
            label: 'Kind',
            value: _kind,
            values: _AppBarKind.values,
            labelOf: (_AppBarKind v) => switch (v) {
              _AppBarKind.top => 'top',
              _AppBarKind.search => 'search',
              _AppBarKind.bottom => 'top + bottom',
              _AppBarKind.sliver => 'sliver',
            },
            onChanged: (_AppBarKind v) => setState(() => _kind = v),
          ),
          PlayEnumChoice<M3EAppBarVariant>(
            label: 'Size',
            value: _variant,
            values: M3EAppBarVariant.values,
            labelOf: _variantLabel,
            onChanged: (M3EAppBarVariant v) => setState(() => _variant = v),
          ),
          if (_canFlex)
            PlayEnumChoice<_Flexibility>(
              label: 'Start',
              value: _flexibility,
              values: _Flexibility.values,
              labelOf: (_Flexibility v) => v.name,
              onChanged: (_Flexibility v) => setState(() => _flexibility = v),
            ),
          if (_canHide)
            PlayEnumChoice<M3EAppBarHideMode>(
              label: 'Hide on scroll',
              value: _hideMode,
              values: M3EAppBarHideMode.values,
              labelOf: (M3EAppBarHideMode v) => v.name,
              onChanged: (M3EAppBarHideMode v) => setState(() => _hideMode = v),
            ),
          PlaySwitchItem(
            label: 'Controller',
            description: 'A toolbar shows, hides or follows scroll',
            value: _useController,
            onChanged: _setUseController,
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlayEnumChoice<M3EAppBarDensity>(
            label: 'Density',
            value: _density,
            values: M3EAppBarDensity.values,
            labelOf: (M3EAppBarDensity v) => v.name,
            onChanged: (M3EAppBarDensity v) => setState(() => _density = v),
          ),
          PlayEnumChoice<M3EAppBarShapeFamily>(
            label: 'Shape',
            value: _shape,
            values: M3EAppBarShapeFamily.values,
            labelOf: (M3EAppBarShapeFamily v) => v.name,
            onChanged: (M3EAppBarShapeFamily v) => setState(() => _shape = v),
          ),
          PlaySwitchItem(
            label: 'Center title',
            value: _centerTitle,
            onChanged: (bool v) => setState(() => _centerTitle = v),
          ),
          if (_kind != _AppBarKind.sliver)
            PlaySwitchItem(
              label: 'Safe area',
              value: _safeArea,
              onChanged: (bool v) => setState(() => _safeArea = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          if (_kind != _AppBarKind.search) ...<Widget>[
            PlayTextField(
              label: 'Title',
              value: _title,
              onChanged: (String v) => setState(() => _title = v),
            ),
            PlaySwitchItem(
              label: 'Subtitle',
              value: _subtitle,
              onChanged: (bool v) => setState(() => _subtitle = v),
            ),
          ],
          if (_kind == _AppBarKind.top || _kind == _AppBarKind.sliver)
            PlaySwitchItem(
              label: 'Image title',
              description: 'An avatar in place of the title text',
              value: _imageTitle,
              onChanged: (bool v) => setState(() => _imageTitle = v),
            ),
          if (_kind != _AppBarKind.search)
            PlaySwitchItem(
              label: 'Filled trailing action',
              value: _filledAction,
              onChanged: (bool v) => setState(() => _filledAction = v),
            ),
          if (_kind == _AppBarKind.search) ...<Widget>[
            PlayEnumChoice<_SearchArrangement>(
              label: 'Search arrangement',
              value: _searchArrangement,
              values: _SearchArrangement.values,
              labelOf: (_SearchArrangement v) => switch (v) {
                _SearchArrangement.outside => 'icons outside the bar',
                _SearchArrangement.inside => 'icons inside the bar',
                _SearchArrangement.twoTrailing => 'two trailing actions',
              },
              onChanged: (_SearchArrangement v) {
                setState(() => _searchArrangement = v);
              },
            ),
            PlaySwitchItem(
              label: 'Wrap actions',
              value: _wrapActions,
              onChanged: (bool v) => setState(() => _wrapActions = v),
            ),
          ],
        ],
      ),
    ];
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
