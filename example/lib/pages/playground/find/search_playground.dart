import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart' show MaterialPageRoute, Scaffold;

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

enum _Layout { auto, fullScreen, docked }

enum _Leading { search, menu, none }

enum _Trailing { none, one, two, avatar, iconAvatar }

/// Live playground for [M3ESearchBar], [M3ESearchAnchor], and
/// [M3ESliverSearchBar].
class SearchPlayground extends StatefulWidget {
  /// Creates the search playground.
  const SearchPlayground({super.key});

  @override
  State<SearchPlayground> createState() => _SearchPlaygroundState();
}

class _SearchPlaygroundState extends State<SearchPlayground> {
  bool _expandOnFocus = true;
  bool _enabled = true;
  bool _useAnchor = true;
  bool _showClear = true;
  M3ESearchViewStyle _style = M3ESearchViewStyle.contained;
  _Layout _layout = _Layout.auto;
  _Leading _leading = _Leading.search;
  _Trailing _trailing = _Trailing.one;
  M3ESearchBarScrollBehavior _scroll = M3ESearchBarScrollBehavior.scrollAway;
  String _hint = 'Search components';

  bool? get _isFullScreen => switch (_layout) {
    _Layout.auto => null,
    _Layout.fullScreen => true,
    _Layout.docked => false,
  };

  void _openDemo() {
    final options = _SearchDemoOptions(
      useAnchor: _useAnchor,
      style: _style,
      isFullScreen: _isFullScreen,
      leading: _leading,
      trailing: _trailing,
      scroll: _scroll,
      enabled: _enabled,
      expandOnFocus: _expandOnFocus,
      showClear: _showClear,
      hint: _hint,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => _SearchDemoHost(options: options),
      ),
    );
  }

  List<PlaySnippet> get _snippets {
    final String sample = _useAnchor
        ? '''
M3ESearchAnchor.bar(
  searchController: searchController,
  barHintText: ${playDartString(_hint)},
  isFullScreen: ${_isFullScreen ?? 'null'}, // null: full-screen below 600dp
  viewStyle: M3ESearchViewStyle.${_style.name},
  suggestionsBuilder: (context, controller) => const <Widget>[],
);'''
        : '''
M3ESearchBar(
  hintText: ${playDartString(_hint)},
  enabled: $_enabled,
  expandOnFocus: $_expandOnFocus,
  showClearButton: $_showClear,
);''';
    return <PlaySnippet>[
      PlaySnippet(
        label: _useAnchor ? 'Search anchor' : 'Search bar',
        code: '$kPlaySnippetImport\n$sample',
      ),
      PlaySnippet(
        label: 'Scroll behavior',
        code:
            '''
$kPlaySnippetImport
CustomScrollView(
  slivers: <Widget>[
    M3ESliverSearchBar(
      scrollBehavior: M3ESearchBarScrollBehavior.${_scroll.name},
      child: M3ESearchBar(hintText: 'Search your library'),
    ),
    // content slivers…
  ],
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Search demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a screen with the search bar on top of scrolling '
                'content. Resize the window across 600dp to switch between '
                'full-screen and docked search.',
                style: M3ETheme.of(context).typeScale.bodyMedium.copyWith(
                  color: M3ETheme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open search demo'),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Mode',
          children: <Widget>[
            PlaySwitch(
              label: 'Use search anchor',
              value: _useAnchor,
              onChanged: (bool v) => setState(() => _useAnchor = v),
            ),
            if (_useAnchor)
              PlayEnumSegmented<M3ESearchViewStyle>(
                label: 'Style',
                value: _style,
                values: M3ESearchViewStyle.values,
                labelOf: (M3ESearchViewStyle v) => v.name,
                onChanged: (M3ESearchViewStyle v) => setState(() => _style = v),
              ),
            if (_useAnchor)
              PlayEnumSegmented<_Layout>(
                label: 'Layout',
                value: _layout,
                values: _Layout.values,
                labelOf: (_Layout v) => v.name,
                onChanged: (_Layout v) => setState(() => _layout = v),
              ),
            if (!_useAnchor)
              PlaySwitch(
                label: 'Expand on focus',
                value: _expandOnFocus,
                onChanged: (bool v) => setState(() => _expandOnFocus = v),
              ),
            PlaySwitch(
              label: 'Enabled',
              value: _enabled,
              onChanged: (bool v) => setState(() => _enabled = v),
            ),
            PlaySwitch(
              label: 'Clear button',
              value: _showClear,
              onChanged: (bool v) => setState(() => _showClear = v),
            ),
            PlayTextField(
              label: 'Hint',
              value: _hint,
              onChanged: (String v) => setState(() => _hint = v),
            ),
          ],
        ),
        PlayControlPanel(
          title: 'Content',
          children: <Widget>[
            PlayEnumSegmented<_Leading>(
              label: 'Leading',
              value: _leading,
              values: _Leading.values,
              labelOf: (_Leading v) => v.name,
              onChanged: (_Leading v) => setState(() => _leading = v),
            ),
            PlayEnumSegmented<_Trailing>(
              label: 'Trailing',
              value: _trailing,
              values: _Trailing.values,
              labelOf: (_Trailing v) => switch (v) {
                _Trailing.none => 'none',
                _Trailing.one => '1',
                _Trailing.two => '2',
                _Trailing.avatar => 'avatar',
                _Trailing.iconAvatar => '1 + avatar',
              },
              onChanged: (_Trailing v) => setState(() => _trailing = v),
            ),
            PlayEnumSegmented<M3ESearchBarScrollBehavior>(
              label: 'Scroll',
              value: _scroll,
              values: M3ESearchBarScrollBehavior.values,
              labelOf: (M3ESearchBarScrollBehavior v) => v.name,
              onChanged: (M3ESearchBarScrollBehavior v) =>
                  setState(() => _scroll = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _SearchDemoOptions {
  const _SearchDemoOptions({
    required this.useAnchor,
    required this.style,
    required this.isFullScreen,
    required this.leading,
    required this.trailing,
    required this.scroll,
    required this.enabled,
    required this.expandOnFocus,
    required this.showClear,
    required this.hint,
  });

  final bool useAnchor;
  final M3ESearchViewStyle style;
  final bool? isFullScreen;
  final _Leading leading;
  final _Trailing trailing;
  final M3ESearchBarScrollBehavior scroll;
  final bool enabled;
  final bool expandOnFocus;
  final bool showClear;
  final String hint;
}

/// Full screen with the search bar above scrolling content.
class _SearchDemoHost extends StatefulWidget {
  const _SearchDemoHost({required this.options});

  final _SearchDemoOptions options;

  @override
  State<_SearchDemoHost> createState() => _SearchDemoHostState();
}

class _SearchDemoHostState extends State<_SearchDemoHost> {
  final TextEditingController _barController = TextEditingController();
  final M3ESearchController _anchorController = M3ESearchController();

  static const List<String> _history = <String>['Buttons', 'Navigation bar'];

  static const List<String> _names = <String>[
    'Buttons',
    'Cards',
    'Carousel',
    'Navigation bar',
    'Progress',
    'Search bar',
    'Snackbar',
    'Tabs',
    'Text field',
    'Tooltip',
  ];

  @override
  void dispose() {
    _barController.dispose();
    _anchorController.dispose();
    super.dispose();
  }

  _SearchDemoOptions get _o => widget.options;

  Widget? get _leadingWidget => switch (_o.leading) {
    _Leading.search => const Icon(M3EIcons.search),
    _Leading.menu => M3EIconButton(
      variant: M3EIconButtonVariant.standard,
      icon: const Icon(M3EIcons.menu),
      tooltip: 'Menu',
      onPressed: () {},
    ),
    _Leading.none => null,
  };

  List<Widget>? get _trailingWidgets {
    final Widget mic = M3EIconButton(
      variant: M3EIconButtonVariant.standard,
      icon: const Icon(M3EIcons.mic),
      tooltip: 'Voice search',
      onPressed: () {},
    );
    final Widget more = M3EIconButton(
      variant: M3EIconButtonVariant.standard,
      icon: const Icon(M3EIcons.more_vert),
      tooltip: 'More',
      onPressed: () {},
    );
    return switch (_o.trailing) {
      _Trailing.none || _Trailing.avatar => null,
      _Trailing.one || _Trailing.iconAvatar => <Widget>[mic],
      _Trailing.two => <Widget>[mic, more],
    };
  }

  Widget? get _avatar {
    if (_o.trailing != _Trailing.avatar &&
        _o.trailing != _Trailing.iconAvatar) {
      return null;
    }
    final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
    return Semantics(
      label: 'Account',
      button: true,
      child: ColoredBox(
        color: scheme.primaryContainer,
        child: Center(
          child: Text('A', style: TextStyle(color: scheme.onPrimaryContainer)),
        ),
      ),
    );
  }

  /// History group, a gap, then a "Results" group.
  Iterable<Widget> _suggestions(
    BuildContext context,
    M3ESearchController controller,
  ) {
    final String query = controller.text.trim().toLowerCase();
    final List<String> matches = query.isEmpty
        ? _history
        : _names
              .where((String name) => name.toLowerCase().contains(query))
              .toList();
    final M3EThemeData theme = M3ETheme.of(context);
    return <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Text(
          query.isEmpty ? 'Recent' : 'Results',
          style: theme.typeScale.labelLarge.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      M3EList(
        itemCount: matches.length,
        itemBuilder: (BuildContext context, int index) {
          return M3EListItem(
            headline: matches[index],
            leading: Icon(query.isEmpty ? M3EIcons.history : M3EIcons.search),
            onTap: () => controller.closeView(matches[index]),
          );
        },
      ),
    ];
  }

  Widget _buildAnchor() {
    return M3ESearchAnchor.bar(
      searchController: _anchorController,
      barHintText: _o.hint,
      barLeading: _leadingWidget,
      barTrailing: _trailingWidgets,
      barAvatar: _avatar,
      isFullScreen: _o.isFullScreen,
      viewStyle: _o.style,
      showViewClearButton: _o.showClear,
      enabled: _o.enabled,
      suggestionsBuilder: _suggestions,
    );
  }

  Widget _buildBar() {
    return M3ESearchBar(
      controller: _barController,
      hintText: _o.hint,
      enabled: _o.enabled,
      expandOnFocus: _o.expandOnFocus,
      leading: _leadingWidget,
      trailing: _trailingWidgets,
      avatar: _avatar,
      showClearButton: _o.showClear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: M3ETheme.of(context).colorScheme.surface,
      appBar: M3EAppBar.top(
        titleText: 'Search',
        leading: M3EIconButton(
          variant: M3EIconButtonVariant.standard,
          icon: const Icon(M3EIcons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          M3ESliverSearchBar(
            scrollBehavior: _o.scroll,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _o.useAnchor ? _buildAnchor() : _buildBar(),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            sliver: M3EList.sliver(
              variant: M3ECardVariant.filled,
              itemCount: 40,
              itemBuilder: (BuildContext context, int index) {
                return M3EListItem(
                  headline: _names[index % _names.length],
                  supportingText: 'Result ${index + 1}',
                  leading: const Icon(M3EIcons.widgets),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
