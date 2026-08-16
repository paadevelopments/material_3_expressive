import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ESideSheet].
class SideSheetPlayground extends StatefulWidget {
  /// Creates the side sheet playground.
  const SideSheetPlayground({super.key});

  @override
  State<SideSheetPlayground> createState() => _SideSheetPlaygroundState();
}

class _SideSheetPlaygroundState extends State<SideSheetPlayground> {
  String _title = 'Filters';
  String _body = 'Side sheet content for detailed options.';
  bool _showActions = true;

  List<PlaySnippet> get _snippets {
    final String actions = _showActions
        ? '''
  actions: <Widget>[
    M3EButton(
      style: M3EButtonStyle.text,
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Reset'),
    ),
    M3EButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Apply'),
    ),
  ],
'''
        : '';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Side sheet',
        code:
            '''
$kPlaySnippetImport

M3ESideSheet.show<void>(
  context,
  title: ${playDartString(_title)},
  body: Padding(
    padding: const EdgeInsets.all(24),
    child: Text(${playDartString(_body)}),
  ),
$actions);''',
      ),
    ];
  }

  void _showSheet() {
    M3ESideSheet.show<void>(
      context,
      title: _title,
      body: Builder(
        builder: (BuildContext context) {
          final M3EThemeData theme = M3ETheme.of(context);
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Text(_body, style: theme.typeScale.bodyLarge),
          );
        },
      ),
      actions: _showActions
          ? <Widget>[
              M3EButton(
                style: M3EButtonStyle.text,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Reset'),
              ),
              M3EButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Apply'),
              ),
            ]
          : const <Widget>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Trigger',
          child: M3EButton(
            style: M3EButtonStyle.tonal,
            onPressed: _showSheet,
            child: const Text('Show side sheet'),
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Sheet',
          children: <Widget>[
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
              label: 'Show actions',
              value: _showActions,
              onChanged: (bool v) => setState(() => _showActions = v),
            ),
          ],
        ),
      ],
    );
  }
}
