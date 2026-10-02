import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

enum _CardScreen { card, collection, transform }

/// Live playground for [M3ECard] and [M3ECardGroup].
class CardsPlayground extends PlaygroundWidget {
  /// Creates the cards playground.
  const CardsPlayground({super.key});

  @override
  PlaygroundState<CardsPlayground> createState() => _CardsPlaygroundState();
}

class _CardsPlaygroundState extends PlaygroundState<CardsPlayground> {
  _CardScreen _screen = _CardScreen.card;
  M3ECardVariant _variant = M3ECardVariant.elevated;
  M3ECardOverflowAlignment _overflowAlignment = M3ECardOverflowAlignment.topEnd;
  M3ECardDividerSpan _mediaDividerSpan = M3ECardDividerSpan.edge;
  M3ECardDividerSpan _textDividerSpan = M3ECardDividerSpan.padding;
  bool _tappable = true;
  bool _enabled = true;
  bool _semanticLink = false;
  bool _showMedia = true;
  bool _mediaAbove = true;
  bool _mediaDecorative = false;
  bool _contentOnMedia = false;
  bool _overlayPlate = false;
  bool _dividerAfterMedia = false;
  bool _dividerAfterText = true;
  bool _showActions = true;
  bool _showOverflow = true;
  bool _showSubhead = true;
  bool _dragged = false;
  bool _expanded = false;
  bool _capHeight = false;
  bool _adaptOrientation = false;
  bool _swipe = true;
  M3ECardSwipeMode _swipeMode = M3ECardSwipeMode.both;
  bool _leadingSwipe = true;
  bool _trailingSwipe = true;
  double _maxHeight = 180;
  String _title = 'Card title';
  String _subhead = 'Subhead';
  String _body = 'Supporting text for the card body.';

  @override
  List<PlaySnippet> get snippets {
    final String pressed = _tappable ? '() {}' : 'null';
    final String sample = switch (_screen) {
      _CardScreen.card =>
        '''
M3ECard(
  variant: M3ECardVariant.${_variant.name},
  enabled: $_enabled,
  semanticLink: $_semanticLink,
  dragged: $_dragged,
  expanded: $_expanded,${_capHeight ? '\n  maxHeight: $_maxHeight,' : ''}
  onPressed: $pressed,${_swipeFields()}
  headline: ${playDartString(_title)},${_showSubhead ? '\n  subhead: ${playDartString(_subhead)},' : ''}
  supportingText: ${playDartString(_body)},${_showMedia ? '\n  media: const SizedBox(height: 120),' : ''}${_showMedia && !_contentOnMedia ? '\n  vertical: $_mediaAbove,' : ''}
  contentOnMedia: $_contentOnMedia,
  contentOverlayPlate: $_overlayPlate,
  dividerAfterMedia: $_dividerAfterMedia,
  mediaDividerSpan: M3ECardDividerSpan.${_mediaDividerSpan.name},
  dividerAfterText: $_dividerAfterText,
  textDividerSpan: M3ECardDividerSpan.${_textDividerSpan.name},
  overflowAlignment: M3ECardOverflowAlignment.${_overflowAlignment.name},
);''',
      _CardScreen.collection =>
        '''
M3ECardGroup(
  layout: width < 600 ? M3ECardGroupLayout.list : M3ECardGroupLayout.grid,
  adaptOrientation: $_adaptOrientation,
  onReorder: (int from, int to) {},
  children: <Widget>[
    M3ECard(
      variant: M3ECardVariant.${_variant.name},
      headline: ${playDartString(_title)},
      onPressed: () {},${_swipeFields()}
    ),
  ],
);''',
      _CardScreen.transform =>
        '''
M3ECard(
  variant: M3ECardVariant.${_variant.name},
  headline: ${playDartString(_title)},
  openBuilder: (BuildContext context) {
    return const SizedBox.shrink();
  },
);''',
    };
    return <PlaySnippet>[
      PlaySnippet(label: 'Card', code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    return _CardPreviewPage(
      padding: padding,
      screen: _screen,
      variant: _variant,
      overflowAlignment: _overflowAlignment,
      tappable: _tappable,
      enabled: _enabled,
      semanticLink: _semanticLink,
      showMedia: _showMedia,
      mediaAbove: _mediaAbove,
      mediaDecorative: _mediaDecorative,
      contentOnMedia: _contentOnMedia,
      overlayPlate: _overlayPlate,
      dividerAfterMedia: _dividerAfterMedia,
      dividerAfterText: _dividerAfterText,
      mediaDividerSpan: _mediaDividerSpan,
      textDividerSpan: _textDividerSpan,
      showActions: _showActions,
      showOverflow: _showOverflow,
      showSubhead: _showSubhead,
      dragged: _dragged,
      expanded: _expanded,
      capHeight: _capHeight,
      adaptOrientation: _adaptOrientation,
      swipe: _swipe,
      swipeMode: _swipeMode,
      leadingSwipe: _leadingSwipe,
      trailingSwipe: _trailingSwipe,
      maxHeight: _maxHeight,
      title: _title,
      subhead: _subhead,
      body: _body,
    );
  }

  String _dividerSpanLabel(M3ECardDividerSpan span) {
    return span == M3ECardDividerSpan.edge ? 'Edge to edge' : 'Within padding';
  }

  String _swipeFields() {
    if (!_swipe) {
      return '';
    }
    final dismiss = _swipeMode != M3ECardSwipeMode.reveal;
    return '''
  swipeMode: M3ECardSwipeMode.${_swipeMode.name},${dismiss ? '\n  onSwipe: () {},' : ''}${_leadingSwipe ? '\n  leadingSwipeAction: const Icon(M3EIcons.favorite_border),' : ''}${_trailingSwipe ? '\n  trailingSwipeAction: const Icon(M3EIcons.delete),' : ''}''';
  }

  String _swipeModeLabel(M3ECardSwipeMode mode) {
    return switch (mode) {
      M3ECardSwipeMode.dismiss => 'Delete',
      M3ECardSwipeMode.reveal => 'Reveal',
      M3ECardSwipeMode.both => 'Both',
    };
  }

  List<Widget> _swipeControls() {
    return <Widget>[
      PlaySwitchItem(
        label: 'Swipe',
        value: _swipe,
        onChanged: (bool value) => setState(() => _swipe = value),
      ),
      if (_swipe) ...<Widget>[
        PlayEnumChoice<M3ECardSwipeMode>(
          label: 'Swipe behavior',
          value: _swipeMode,
          values: M3ECardSwipeMode.values,
          labelOf: _swipeModeLabel,
          onChanged: (M3ECardSwipeMode value) =>
              setState(() => _swipeMode = value),
        ),
        PlaySwitchItem(
          label: 'Left action',
          value: _leadingSwipe,
          onChanged: (bool value) => setState(() => _leadingSwipe = value),
        ),
        PlaySwitchItem(
          label: 'Right action',
          value: _trailingSwipe,
          onChanged: (bool value) => setState(() => _trailingSwipe = value),
        ),
      ],
    ];
  }

  List<Widget> get _panels {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_CardScreen>(
            label: 'Preview',
            value: _screen,
            values: _CardScreen.values,
            labelOf: (_CardScreen value) => value.name,
            onChanged: (_CardScreen value) => setState(() => _screen = value),
          ),
        ],
      ),
      ...switch (_screen) {
        _CardScreen.card => <Widget>[
          _appearancePanel(cardStates: true),
          _contentPanel(),
          _actionsPanel(swipe: true),
        ],
        _CardScreen.collection => <Widget>[_collectionPanel()],
        _CardScreen.transform => <Widget>[
          _appearancePanel(cardStates: false),
          _contentPanel(),
          _actionsPanel(swipe: false),
        ],
      },
    ];
  }

  Widget _appearancePanel({required bool cardStates}) {
    return PlayControlGroup(
      title: 'Appearance',
      children: <Widget>[
        _variantControl(),
        PlaySwitchItem(
          label: 'Enabled',
          value: _enabled,
          onChanged: (bool value) => setState(() => _enabled = value),
        ),
        if (cardStates) ...<Widget>[
          PlaySwitchItem(
            label: 'Tappable',
            value: _tappable,
            onChanged: (bool value) => setState(() => _tappable = value),
          ),
          PlaySwitchItem(
            label: 'Link role',
            value: _semanticLink,
            onChanged: (bool value) => setState(() => _semanticLink = value),
          ),
          PlaySwitchItem(
            label: 'Dragged',
            value: _dragged,
            onChanged: (bool value) => setState(() => _dragged = value),
          ),
          PlaySwitchItem(
            label: 'Expanded',
            value: _expanded,
            onChanged: (bool value) => setState(() => _expanded = value),
          ),
          PlaySwitchItem(
            label: 'Cap height',
            value: _capHeight,
            onChanged: (bool value) => setState(() => _capHeight = value),
          ),
          if (_capHeight)
            PlaySlider(
              label: 'Max height',
              value: _maxHeight,
              min: 80,
              max: 320,
              divisions: 12,
              onChanged: (double value) => setState(() => _maxHeight = value),
            ),
        ],
      ],
    );
  }

  Widget _contentPanel() {
    return PlayControlGroup(
      title: 'Content',
      children: <Widget>[
        PlayTextField(
          label: 'Title',
          value: _title,
          onChanged: (String value) => setState(() => _title = value),
        ),
        PlaySwitchItem(
          label: 'Subhead',
          value: _showSubhead,
          onChanged: (bool value) => setState(() => _showSubhead = value),
        ),
        if (_showSubhead)
          PlayTextField(
            label: 'Subhead text',
            value: _subhead,
            onChanged: (String value) => setState(() => _subhead = value),
          ),
        PlayTextField(
          label: 'Body',
          value: _body,
          onChanged: (String value) => setState(() => _body = value),
        ),
        PlaySwitchItem(
          label: 'Media',
          value: _showMedia,
          onChanged: (bool value) => setState(() => _showMedia = value),
        ),
        if (_showMedia) ...<Widget>[
          if (!_contentOnMedia)
            PlaySwitchItem(
              label: 'Media above text',
              value: _mediaAbove,
              onChanged: (bool value) => setState(() => _mediaAbove = value),
            ),
          PlaySwitchItem(
            label: 'Decorative media',
            value: _mediaDecorative,
            onChanged: (bool value) => setState(() => _mediaDecorative = value),
          ),
          PlaySwitchItem(
            label: 'Content on media',
            value: _contentOnMedia,
            onChanged: (bool value) => setState(() => _contentOnMedia = value),
          ),
          if (_contentOnMedia)
            PlaySwitchItem(
              label: 'Overlay plate',
              value: _overlayPlate,
              onChanged: (bool value) => setState(() => _overlayPlate = value),
            ),
          PlaySwitchItem(
            label: 'Divider after media',
            value: _dividerAfterMedia,
            onChanged: (bool value) =>
                setState(() => _dividerAfterMedia = value),
          ),
          if (_dividerAfterMedia)
            PlayEnumChoice<M3ECardDividerSpan>(
              label: 'Media divider',
              value: _mediaDividerSpan,
              values: M3ECardDividerSpan.values,
              labelOf: _dividerSpanLabel,
              onChanged: (M3ECardDividerSpan value) =>
                  setState(() => _mediaDividerSpan = value),
            ),
        ],
        PlaySwitchItem(
          label: 'Divider after text',
          value: _dividerAfterText,
          onChanged: (bool value) => setState(() => _dividerAfterText = value),
        ),
        if (_dividerAfterText)
          PlayEnumChoice<M3ECardDividerSpan>(
            label: 'Text divider',
            value: _textDividerSpan,
            values: M3ECardDividerSpan.values,
            labelOf: _dividerSpanLabel,
            onChanged: (M3ECardDividerSpan value) =>
                setState(() => _textDividerSpan = value),
          ),
      ],
    );
  }

  Widget _actionsPanel({required bool swipe}) {
    return PlayControlGroup(
      title: 'Actions',
      children: <Widget>[
        PlaySwitchItem(
          label: 'Action button',
          value: _showActions,
          onChanged: (bool value) => setState(() => _showActions = value),
        ),
        PlaySwitchItem(
          label: 'Overflow',
          value: _showOverflow,
          onChanged: (bool value) => setState(() => _showOverflow = value),
        ),
        if (_showOverflow)
          PlayEnumChoice<M3ECardOverflowAlignment>(
            label: 'Overflow alignment',
            value: _overflowAlignment,
            values: M3ECardOverflowAlignment.values,
            labelOf: (M3ECardOverflowAlignment value) => value.name,
            onChanged: (M3ECardOverflowAlignment value) =>
                setState(() => _overflowAlignment = value),
          ),
        if (swipe) ..._swipeControls(),
      ],
    );
  }

  Widget _collectionPanel() {
    return PlayControlGroup(
      title: 'Collection',
      children: <Widget>[
        _variantControl(),
        PlaySwitchItem(
          label: 'Enabled',
          value: _enabled,
          onChanged: (bool value) => setState(() => _enabled = value),
        ),
        ..._swipeControls(),
        PlaySwitchItem(
          label: 'Adapt orientation',
          value: _adaptOrientation,
          onChanged: (bool value) => setState(() => _adaptOrientation = value),
        ),
      ],
    );
  }

  Widget _variantControl() {
    return PlayEnumChoice<M3ECardVariant>(
      label: 'Variant',
      value: _variant,
      values: M3ECardVariant.values,
      labelOf: (M3ECardVariant value) => value.name,
      onChanged: (M3ECardVariant value) => setState(() => _variant = value),
    );
  }

  @override
  List<Widget> buildControls(BuildContext context) => _panels;
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return M3EMenu.entries(
      position: M3EMenuAnchorPosition.bottomEnd,
      anchorBuilder: (BuildContext context, VoidCallback open) {
        return M3EIconButton(
          variant: M3EIconButtonVariant.tonal,
          icon: const Icon(M3EIcons.more_vert),
          tooltip: 'More',
          inflateHitTarget: false,
          onPressed: () {
            onOpen();
            open();
          },
        );
      },
      entries: const <M3EMenuEntry>[
        M3EMenuEntry(label: 'Move'),
        M3EMenuEntry(label: 'Delete'),
      ],
    );
  }
}

class _CardPreviewPage extends StatefulWidget {
  const _CardPreviewPage({
    required this.padding,
    required this.screen,
    required this.variant,
    required this.overflowAlignment,
    required this.tappable,
    required this.enabled,
    required this.semanticLink,
    required this.showMedia,
    required this.mediaAbove,
    required this.mediaDecorative,
    required this.contentOnMedia,
    required this.overlayPlate,
    required this.dividerAfterMedia,
    required this.dividerAfterText,
    required this.mediaDividerSpan,
    required this.textDividerSpan,
    required this.showActions,
    required this.showOverflow,
    required this.showSubhead,
    required this.dragged,
    required this.expanded,
    required this.capHeight,
    required this.adaptOrientation,
    required this.swipe,
    required this.swipeMode,
    required this.leadingSwipe,
    required this.trailingSwipe,
    required this.maxHeight,
    required this.title,
    required this.subhead,
    required this.body,
  });

  final EdgeInsets padding;
  final _CardScreen screen;
  final M3ECardVariant variant;
  final M3ECardOverflowAlignment overflowAlignment;
  final bool tappable;
  final bool enabled;
  final bool semanticLink;
  final bool showMedia;
  final bool mediaAbove;
  final bool mediaDecorative;
  final bool contentOnMedia;
  final bool overlayPlate;
  final bool dividerAfterMedia;
  final bool dividerAfterText;
  final M3ECardDividerSpan mediaDividerSpan;
  final M3ECardDividerSpan textDividerSpan;
  final bool showActions;
  final bool showOverflow;
  final bool showSubhead;
  final bool dragged;
  final bool expanded;
  final bool capHeight;
  final bool adaptOrientation;
  final bool swipe;
  final M3ECardSwipeMode swipeMode;
  final bool leadingSwipe;
  final bool trailingSwipe;
  final double maxHeight;
  final String title;
  final String subhead;
  final String body;

  @override
  State<_CardPreviewPage> createState() => _CardPreviewPageState();
}

class _CardPreviewPageState extends State<_CardPreviewPage> {
  final List<String> _items = <String>[
    'North',
    'East',
    'South',
    'West',
    'Central',
    'Harbor',
  ];
  final Set<String> _selected = <String>{};
  String? _target;

  void _note(String target) {
    setState(() => _target = target);
  }

  void _reorder(int from, int to) {
    setState(() {
      if (to < 0 || to >= _items.length) {
        return;
      }
      final String item = _items.removeAt(from);
      _items.insert(to, item);
    });
  }

  void _toggleSelected(String item) {
    setState(() {
      if (!_selected.add(item)) {
        _selected.remove(item);
      }
    });
  }

  Widget _media(M3EThemeData theme) {
    final bool stacked = widget.mediaAbove && !widget.contentOnMedia;
    Widget band = SizedBox(
      width: stacked || widget.contentOnMedia ? null : 120,
      height: 120,
      child: ColoredBox(color: theme.colorScheme.secondaryContainer),
    );
    if (!widget.mediaDecorative) {
      band = Semantics(label: 'Cover image', image: true, child: band);
    }
    return band;
  }

  String get _mediaCaption {
    if (widget.contentOnMedia) {
      return widget.overlayPlate
          ? 'Text sits on a surface plate over the media.'
          : 'Text sits on a scrim over the media.';
    }
    final String place = widget.mediaAbove
        ? 'Media is stacked above the text'
        : 'Media sits beside the text';
    return widget.mediaDecorative
        ? '$place and is hidden from screen readers.'
        : '$place.';
  }

  Widget? _leadingSwipeAction(M3EThemeData theme) {
    if (!widget.leadingSwipe) {
      return null;
    }
    return M3EIconButton(
      variant: M3EIconButtonVariant.standard,
      icon: Icon(
        M3EIcons.favorite_border,
        color: theme.colorScheme.onPrimaryContainer,
      ),
      tooltip: 'Favorite',
      inflateHitTarget: false,
      onPressed: () => _note('Favorite'),
    );
  }

  Widget? _trailingSwipeAction(M3EThemeData theme) {
    if (!widget.trailingSwipe) {
      return null;
    }
    return M3EIconButton(
      variant: M3EIconButtonVariant.standard,
      icon: Icon(M3EIcons.delete, color: theme.colorScheme.onErrorContainer),
      tooltip: 'Delete',
      inflateHitTarget: false,
      onPressed: () => _note('Delete'),
    );
  }

  bool get _dismissSwipe =>
      widget.swipe && widget.swipeMode != M3ECardSwipeMode.reveal;

  Widget _collectionMedia(M3EThemeData theme, {required bool vertical}) {
    return SizedBox(
      width: vertical ? null : 96,
      height: 96,
      child: ColoredBox(color: theme.colorScheme.secondaryContainer),
    );
  }

  Widget _card(M3EThemeData theme, {String? headline, String? supporting}) {
    final bool actionable =
        widget.tappable || widget.screen == _CardScreen.transform;
    return M3ECard(
      variant: widget.variant,
      enabled: widget.enabled,
      semanticLink: widget.semanticLink,
      dragged: widget.dragged,
      expanded: widget.expanded,
      maxHeight: widget.capHeight ? widget.maxHeight : null,
      onPressed: actionable ? () => _note('Card') : null,
      onSwipe: _dismissSwipe
          ? () {
              _note('Dismissed');
              if (headline != null) {
                setState(() {
                  _items.remove(headline);
                  _selected.remove(headline);
                });
              }
            }
          : null,
      swipeMode: widget.swipe ? widget.swipeMode : M3ECardSwipeMode.dismiss,
      leadingSwipeAction: widget.swipe ? _leadingSwipeAction(theme) : null,
      trailingSwipeAction: widget.swipe ? _trailingSwipeAction(theme) : null,
      trailingSwipeColor: theme.colorScheme.errorContainer,
      openBuilder: widget.screen == _CardScreen.transform
          ? (BuildContext context) {
              return ColoredBox(
                color: M3ETheme.of(context).colorScheme.surface,
                child: Center(
                  child: M3ECard(
                    headline: 'Detail',
                    supportingText: 'Back or tap close.',
                    actions: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: M3EButton.tonal(
                        onPressed: () =>
                            M3ECardContainerTransformScope.closeOf(context),
                        child: const Text('Close'),
                      ),
                    ),
                  ),
                ),
              );
            }
          : null,
      headline: headline ?? widget.title,
      subhead: widget.showSubhead ? widget.subhead : null,
      supportingText: supporting ?? widget.body,
      media: widget.showMedia ? _media(theme) : null,
      vertical: widget.showMedia && !widget.contentOnMedia
          ? widget.mediaAbove
          : null,
      mediaDecorative: widget.mediaDecorative,
      contentOnMedia: widget.contentOnMedia,
      contentOverlayPlate: widget.overlayPlate,
      dividerAfterMedia: widget.dividerAfterMedia,
      mediaDividerSpan: widget.mediaDividerSpan,
      dividerAfterText: widget.dividerAfterText,
      textDividerSpan: widget.textDividerSpan,
      overflowAlignment: widget.overflowAlignment,
      overflow: widget.showOverflow
          ? _OverflowMenu(onOpen: () => _note('Overflow'))
          : null,
      actions: widget.showActions
          ? Align(
              alignment: AlignmentDirectional.centerEnd,
              child: M3EButton.filled(
                onPressed: () => _note('Action'),
                child: const Text('Action'),
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final Widget body = switch (widget.screen) {
      _CardScreen.card || _CardScreen.transform => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.showMedia)
                Text(
                  _mediaCaption,
                  style: theme.typeScale.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              if (widget.showMedia) const SizedBox(height: 12),
              _card(theme),
            ],
          ),
        ),
      ),
      _CardScreen.collection => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool compact =
              constraints.maxWidth < theme.cardTheme.compactBreakpoint;
          final bool vertical = widget.adaptOrientation;
          final M3EThemeData groupTheme = vertical
              ? theme.copyWith(
                  cardTheme: theme.cardTheme.copyWith(expandedBreakpoint: 0),
                )
              : theme;
          return M3ETheme(
            data: groupTheme,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (_target != null)
                  Text(
                    'Last tap: $_target',
                    style: theme.typeScale.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                if (_target != null) const SizedBox(height: 12),
                Text(
                  vertical
                      ? 'Media is stacked above the text.'
                      : 'Media sits beside the text.',
                  style: theme.typeScale.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                M3ECardGroup(
                  layout: compact
                      ? M3ECardGroupLayout.list
                      : M3ECardGroupLayout.grid,
                  adaptOrientation: vertical,
                  gap: theme.cardTheme.gap,
                  onReorder: _reorder,
                  children: <Widget>[
                    for (final String item in _items)
                      M3ECard(
                        variant: widget.variant,
                        enabled: widget.enabled,
                        headline: item,
                        supportingText: 'Tap to select. Long-press to reorder.',
                        media: _collectionMedia(theme, vertical: vertical),
                        onPressed: () => _toggleSelected(item),
                        onSwipe: _dismissSwipe
                            ? () {
                                setState(() {
                                  _items.remove(item);
                                  _selected.remove(item);
                                });
                              }
                            : null,
                        swipeMode: widget.swipe
                            ? widget.swipeMode
                            : M3ECardSwipeMode.dismiss,
                        leadingSwipeAction: widget.swipe
                            ? _leadingSwipeAction(theme)
                            : null,
                        trailingSwipeAction: widget.swipe
                            ? _trailingSwipeAction(theme)
                            : null,
                        trailingSwipeColor: theme.colorScheme.errorContainer,
                        actions: _selected.contains(item)
                            ? Icon(
                                M3EIcons.check,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    };
    return ListView(
      primary: true,
      padding: widget.padding,
      children: <Widget>[
        if (widget.screen != _CardScreen.collection) ...<Widget>[
          Text(
            _target == null
                ? 'Tap the card, the action, or the overflow.'
                : 'Last tap: $_target',
            style: theme.typeScale.bodyMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
        ],
        body,
      ],
    );
  }
}
