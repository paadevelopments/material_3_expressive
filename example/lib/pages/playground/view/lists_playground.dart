import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

enum _ListKind { item, cardList, dismissible, expandable }

/// Live playground for list components.
class ListsPlayground extends StatefulWidget {
  /// Creates the lists playground.
  const ListsPlayground({super.key});

  @override
  State<ListsPlayground> createState() => _ListsPlaygroundState();
}

class _ListsPlaygroundState extends State<ListsPlayground> {
  _ListKind _kind = _ListKind.item;
  M3ECardVariant _variant = M3ECardVariant.outlined;
  bool _showLeading = true;
  bool _showTrailing = true;
  String _headline = 'Wireless charging';
  String _supporting = 'On · Fast charge enabled';

  List<PlaySnippet> get _snippets {
    final String headline = playDartString(_headline);
    final String supporting = playDartString(_supporting);
    final String sample = switch (_kind) {
      _ListKind.item =>
        '''
M3EListItem(
  headline: $headline,
  supportingText: $supporting,${_showLeading ? '\n  leading: const Icon(M3EIcons.schedule),' : ''}${_showTrailing ? '\n  trailing: const Icon(M3EIcons.chevron_right),' : ''}
  onTap: () {},
);''',
      _ListKind.cardList =>
        '''
M3ECardList(
  variant: M3ECardVariant.${_variant.name},
  itemCount: 3,
  itemBuilder: (BuildContext context, int index) {
    return M3EListItem(
      headline: $headline,
      supportingText: $supporting,${_showLeading ? '\n      leading: const Icon(M3EIcons.inbox),' : ''}${_showTrailing ? '\n      trailing: const Icon(M3EIcons.chevron_right),' : ''}
    );
  },
);''',
      _ListKind.dismissible =>
        '''
M3EDismissibleColumn(
  itemCount: 3,
  onDismiss: (int index, DismissDirection direction) async => true,
  itemBuilder: (BuildContext context, int index) {
    return M3EListItem(
      headline: $headline,${_showLeading ? '\n      leading: const Icon(M3EIcons.schedule),' : ''}
    );
  },
);''',
      _ListKind.expandable =>
        '''
M3EExpandableList(
  data: <M3EExpandableData>[
    M3EExpandableData(
      title: $headline,
      subtitle: $supporting,${_showLeading ? '\n      leading: const Icon(M3EIcons.battery_alert),' : ''}
      body: const Text('Expanded body'),
    ),
  ],
);''',
    };
    return <PlaySnippet>[
      PlaySnippet(label: 'List', code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'List',
          child: switch (_kind) {
            _ListKind.item => _ItemPreview(
              headline: _headline,
              supporting: _supporting,
              showLeading: _showLeading,
              showTrailing: _showTrailing,
            ),
            _ListKind.cardList => _CardListPreview(
              headline: _headline,
              supporting: _supporting,
              variant: _variant,
              showLeading: _showLeading,
              showTrailing: _showTrailing,
            ),
            _ListKind.dismissible => _DismissiblePreview(
              headline: _headline,
              showLeading: _showLeading,
            ),
            _ListKind.expandable => _ExpandablePreview(
              headline: _headline,
              supporting: _supporting,
              showLeading: _showLeading,
            ),
          },
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Content',
          children: <Widget>[
            PlayEnumMenu<_ListKind>(
              label: 'Kind',
              value: _kind,
              values: _ListKind.values,
              labelOf: (_ListKind v) => v.name,
              onChanged: (_ListKind v) => setState(() => _kind = v),
            ),
            if (_kind == _ListKind.cardList)
              PlayEnumMenu<M3ECardVariant>(
                label: 'Card variant',
                value: _variant,
                values: M3ECardVariant.values,
                labelOf: (M3ECardVariant v) => v.name,
                onChanged: (M3ECardVariant v) {
                  setState(() => _variant = v);
                },
              ),
            PlayTextField(
              label: 'Headline',
              value: _headline,
              onChanged: (String v) => setState(() => _headline = v),
            ),
            PlayTextField(
              label: 'Supporting',
              value: _supporting,
              onChanged: (String v) => setState(() => _supporting = v),
            ),
            PlaySwitch(
              label: 'Leading',
              value: _showLeading,
              onChanged: (bool v) => setState(() => _showLeading = v),
            ),
            PlaySwitch(
              label: 'Trailing',
              value: _showTrailing,
              onChanged: (bool v) => setState(() => _showTrailing = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _ItemPreview extends StatelessWidget {
  const _ItemPreview({
    required this.headline,
    required this.supporting,
    required this.showLeading,
    required this.showTrailing,
  });

  final String headline;
  final String supporting;
  final bool showLeading;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return M3EListItem(
      headline: headline,
      supportingText: supporting,
      leading: showLeading ? const Icon(M3EIcons.schedule) : null,
      trailing: showTrailing ? const Icon(M3EIcons.chevron_right) : null,
      onTap: () {},
    );
  }
}

class _CardListPreview extends StatelessWidget {
  const _CardListPreview({
    required this.headline,
    required this.supporting,
    required this.variant,
    required this.showLeading,
    required this.showTrailing,
  });

  final String headline;
  final String supporting;
  final M3ECardVariant variant;
  final bool showLeading;
  final bool showTrailing;

  @override
  Widget build(BuildContext context) {
    return M3ECardList(
      variant: variant,
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: '$headline $index',
          supportingText: supporting,
          leading: showLeading ? const Icon(M3EIcons.inbox) : null,
          trailing: showTrailing ? const Icon(M3EIcons.chevron_right) : null,
        );
      },
    );
  }
}

class _DismissiblePreview extends StatelessWidget {
  const _DismissiblePreview({
    required this.headline,
    required this.showLeading,
  });

  final String headline;
  final bool showLeading;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return M3EDismissibleColumn(
      itemCount: 3,
      onDismiss: (int index, DismissDirection direction) async => true,
      style: M3EDismissibleListStyle(
        background: ColoredBox(
          color: theme.colorScheme.success,
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Icon(M3EIcons.check),
            ),
          ),
        ),
        secondaryBackground: ColoredBox(
          color: theme.colorScheme.danger,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Icon(M3EIcons.close),
            ),
          ),
        ),
      ),
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: '$headline $index',
          supportingText: 'Swipe to dismiss',
          leading: showLeading ? const Icon(M3EIcons.schedule) : null,
        );
      },
    );
  }
}

class _ExpandablePreview extends StatelessWidget {
  const _ExpandablePreview({
    required this.headline,
    required this.supporting,
    required this.showLeading,
  });

  final String headline;
  final String supporting;
  final bool showLeading;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return M3EExpandableList(
      data: <M3EExpandableData>[
        M3EExpandableData(
          title: headline,
          subtitle: supporting,
          leading: showLeading ? const Icon(M3EIcons.battery_alert) : null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Expanded body content for the list item.',
                style: theme.typeScale.bodyMedium,
              ),
              const SizedBox(height: 8),
              M3EButton(
                style: M3EButtonStyle.tonal,
                onPressed: () {},
                child: const Text('Action'),
              ),
            ],
          ),
        ),
        M3EExpandableData(
          title: 'System update',
          subtitle: 'Version 2.4.0 is ready',
          leading: showLeading ? const Icon(M3EIcons.system_update) : null,
          body: Text(
            'Security fixes and performance improvements.',
            style: theme.typeScale.bodyMedium,
          ),
        ),
      ],
    );
  }
}
