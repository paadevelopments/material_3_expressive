import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Search widget shown in the sliver.
enum _Mode { anchor, bar }

/// Search view layout; auto is full screen below 600dp.
enum _Layout { auto, fullScreen, docked }

/// Leading slot content.
enum _Leading { search, menu, none }

/// Trailing slot content.
enum _Trailing { none, one, two, avatar, iconAvatar }

/// Live playground for [M3ESearchBar], [M3ESearchAnchor], and
/// [M3ESliverSearchBar].
class SearchPlayground extends PlaygroundWidget {
  /// Creates the search playground.
  const SearchPlayground({super.key});

  @override
  PlaygroundState<SearchPlayground> createState() => _SearchPlaygroundState();
}

class _SearchPlaygroundState extends PlaygroundState<SearchPlayground> {
  final TextEditingController _barController = TextEditingController();
  final M3ESearchController _anchorController = M3ESearchController();

  _Mode _mode = _Mode.anchor;
  bool _expandOnFocus = true;
  bool _enabled = true;
  bool _showClear = true;
  M3ESearchViewStyle _style = M3ESearchViewStyle.contained;
  _Layout _layout = _Layout.auto;
  _Leading _leading = _Leading.search;
  _Trailing _trailing = _Trailing.one;
  M3ESearchBarScrollBehavior _scroll = M3ESearchBarScrollBehavior.scrollAway;
  String _hint = 'Search components';

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

  bool get _anchor => _mode == _Mode.anchor;

  bool? get _isFullScreen => switch (_layout) {
    _Layout.auto => null,
    _Layout.fullScreen => true,
    _Layout.docked => false,
  };

  @override
  void dispose() {
    _barController.dispose();
    _anchorController.dispose();
    super.dispose();
  }

  Widget? get _leadingWidget => switch (_leading) {
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
    return switch (_trailing) {
      _Trailing.none || _Trailing.avatar => null,
      _Trailing.one || _Trailing.iconAvatar => <Widget>[mic],
      _Trailing.two => <Widget>[mic, more],
    };
  }

  Widget? _avatar(BuildContext context) {
    if (_trailing != _Trailing.avatar && _trailing != _Trailing.iconAvatar) {
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

  /// History group before typing, results after.
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

  Widget _search(BuildContext context) {
    if (_anchor) {
      return M3ESearchAnchor.bar(
        searchController: _anchorController,
        barHintText: _hint,
        barLeading: _leadingWidget,
        barTrailing: _trailingWidgets,
        barAvatar: _avatar(context),
        isFullScreen: _isFullScreen,
        viewStyle: _style,
        showViewClearButton: _showClear,
        enabled: _enabled,
        suggestionsBuilder: _suggestions,
      );
    }
    return M3ESearchBar(
      controller: _barController,
      hintText: _hint,
      enabled: _enabled,
      expandOnFocus: _expandOnFocus,
      leading: _leadingWidget,
      trailing: _trailingWidgets,
      avatar: _avatar(context),
      showClearButton: _showClear,
    );
  }

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    // The sliver search bar scrolls with the page, below the banner.
    return Padding(
      padding: EdgeInsets.only(top: padding.top - 16),
      child: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          M3ESliverSearchBar(
            // The scroll behavior only applies when the sliver is created.
            key: ValueKey<M3ESearchBarScrollBehavior>(_scroll),
            scrollBehavior: _scroll,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _search(context),
          ),
          SliverPadding(
            padding: padding.copyWith(top: 8),
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

  @override
  List<PlaySnippet> get snippets {
    final String leading = switch (_leading) {
      _Leading.search => 'const Icon(M3EIcons.search)',
      _Leading.menu => 'menuButton',
      _Leading.none => 'null',
    };
    final String trailing = switch (_trailing) {
      _Trailing.none || _Trailing.avatar => 'null',
      _Trailing.one || _Trailing.iconAvatar => '<Widget>[micButton]',
      _Trailing.two => '<Widget>[micButton, moreButton]',
    };
    final bool avatar =
        _trailing == _Trailing.avatar || _trailing == _Trailing.iconAvatar;
    final String search = _anchor
        ? '''
M3ESearchAnchor.bar(
        searchController: searchController,
        barHintText: ${playDartString(_hint)},
        barLeading: $leading,
        barTrailing: $trailing,${avatar ? '\n        barAvatar: avatar,' : ''}
        isFullScreen: ${_isFullScreen ?? 'null'}, // null: full screen below 600dp
        viewStyle: M3ESearchViewStyle.${_style.name},
        showViewClearButton: $_showClear,
        enabled: $_enabled,
        suggestionsBuilder: (context, controller) => <Widget>[],
      )'''
        : '''
M3ESearchBar(
        hintText: ${playDartString(_hint)},
        leading: $leading,
        trailing: $trailing,${avatar ? '\n        avatar: avatar,' : ''}
        enabled: $_enabled,
        expandOnFocus: $_expandOnFocus,
        showClearButton: $_showClear,
      )''';
    return <PlaySnippet>[
      PlaySnippet(
        label: _anchor ? 'Search anchor' : 'Search bar',
        code:
            '''
$kPlaySnippetImport

CustomScrollView(
  slivers: <Widget>[
    M3ESliverSearchBar(
      scrollBehavior: M3ESearchBarScrollBehavior.${_scroll.name},
      child: $search,
    ),
    // content slivers…
  ],
);''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_Mode>(
            label: 'Widget',
            value: _mode,
            values: _Mode.values,
            labelOf: (_Mode v) => switch (v) {
              _Mode.anchor => 'search anchor (opens a view)',
              _Mode.bar => 'search bar only',
            },
            onChanged: (_Mode v) => setState(() => _mode = v),
          ),
          if (_anchor) ...<Widget>[
            PlayEnumChoice<M3ESearchViewStyle>(
              label: 'View style',
              value: _style,
              values: M3ESearchViewStyle.values,
              labelOf: (M3ESearchViewStyle v) => v.name,
              onChanged: (M3ESearchViewStyle v) => setState(() => _style = v),
            ),
            PlayEnumChoice<_Layout>(
              label: 'View layout',
              value: _layout,
              values: _Layout.values,
              labelOf: (_Layout v) => switch (v) {
                _Layout.auto => 'auto (full screen below 600dp)',
                _Layout.fullScreen => 'full screen',
                _Layout.docked => 'docked',
              },
              onChanged: (_Layout v) => setState(() => _layout = v),
            ),
          ],
          PlayEnumChoice<M3ESearchBarScrollBehavior>(
            label: 'Scroll behavior',
            value: _scroll,
            values: M3ESearchBarScrollBehavior.values,
            labelOf: (M3ESearchBarScrollBehavior v) => v.name,
            onChanged: (M3ESearchBarScrollBehavior v) {
              setState(() => _scroll = v);
            },
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlayTextField(
            label: 'Hint',
            value: _hint,
            onChanged: (String v) => setState(() => _hint = v),
          ),
          PlayEnumChoice<_Leading>(
            label: 'Leading',
            value: _leading,
            values: _Leading.values,
            labelOf: (_Leading v) => v.name,
            onChanged: (_Leading v) => setState(() => _leading = v),
          ),
          PlayEnumChoice<_Trailing>(
            label: 'Trailing',
            value: _trailing,
            values: _Trailing.values,
            labelOf: (_Trailing v) => switch (v) {
              _Trailing.none => 'none',
              _Trailing.one => 'one action',
              _Trailing.two => 'two actions',
              _Trailing.avatar => 'avatar',
              _Trailing.iconAvatar => 'action + avatar',
            },
            onChanged: (_Trailing v) => setState(() => _trailing = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Behavior',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Enabled',
            value: _enabled,
            onChanged: (bool v) => setState(() => _enabled = v),
          ),
          PlaySwitchItem(
            label: 'Clear button',
            description: _anchor ? 'In the open search view' : 'In the bar',
            value: _showClear,
            onChanged: (bool v) => setState(() => _showClear = v),
          ),
          if (!_anchor)
            PlaySwitchItem(
              label: 'Expand on focus',
              value: _expandOnFocus,
              onChanged: (bool v) => setState(() => _expandOnFocus = v),
            ),
        ],
      ),
    ];
  }
}
