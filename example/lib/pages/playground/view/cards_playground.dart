import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ECard].
class CardsPlayground extends StatefulWidget {
  /// Creates the cards playground.
  const CardsPlayground({super.key});

  @override
  State<CardsPlayground> createState() => _CardsPlaygroundState();
}

class _CardsPlaygroundState extends State<CardsPlayground> {
  M3ECardVariant _variant = M3ECardVariant.elevated;
  bool _tappable = true;
  String _title = 'Card title';
  String _body = 'Supporting text for the card body.';

  List<PlaySnippet> get _snippets {
    final String pressed = _tappable ? '() {}' : 'null';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Card',
        code:
            '''
$kPlaySnippetImport

M3ECard(
  variant: M3ECardVariant.${_variant.name},
  onPressed: $pressed,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(${playDartString(_title)}),
      const SizedBox(height: 4),
      Text(${playDartString(_body)}),
    ],
  ),
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Card',
          child: SizedBox(
            width: 260,
            child: M3ECard(
              variant: _variant,
              onPressed: _tappable ? () {} : null,
              child: _CardBody(title: _title, body: _body, theme: theme),
            ),
          ),
        ),
        PlayPreviewCard(
          label: 'All variants',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              for (final M3ECardVariant variant in M3ECardVariant.values)
                SizedBox(
                  width: 180,
                  child: M3ECard(
                    variant: variant,
                    onPressed: _tappable ? () {} : null,
                    child: _CardBody(
                      title: variant.name,
                      body: _body,
                      theme: theme,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumSegmented<M3ECardVariant>(
              label: 'Variant',
              value: _variant,
              values: M3ECardVariant.values,
              labelOf: (M3ECardVariant v) => v.name,
              onChanged: (M3ECardVariant v) => setState(() => _variant = v),
            ),
            PlayTextField(
              label: 'Title',
              value: _title,
              onChanged: (String v) => setState(() => _title = v),
            ),
            PlayTextField(
              label: 'Body',
              value: _body,
              onChanged: (String v) => setState(() => _body = v),
            ),
            PlaySwitch(
              label: 'Tappable',
              value: _tappable,
              onChanged: (bool v) => setState(() => _tappable = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _CardBody extends StatelessWidget {
  const _CardBody({
    required this.title,
    required this.body,
    required this.theme,
  });

  final String title;
  final String body;
  final M3EThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: theme.typeScale.titleMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          body,
          style: theme.typeScale.bodyMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
