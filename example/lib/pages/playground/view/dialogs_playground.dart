import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EDialog].
class DialogsPlayground extends StatefulWidget {
  /// Creates the dialogs playground.
  const DialogsPlayground({super.key});

  @override
  State<DialogsPlayground> createState() => _DialogsPlaygroundState();
}

class _DialogsPlaygroundState extends State<DialogsPlayground> {
  String _title = 'Reset settings?';
  String _content = 'This will restore all settings to their default values.';
  bool _showIcon = true;
  bool _topDivider = false;
  bool _bottomDivider = false;
  bool _barrierDismissible = true;
  bool _multiSelect = false;

  List<PlaySnippet> get _snippets {
    final String icon = _showIcon
        ? '\n    icon: const Icon(M3EIcons.error),'
        : '';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Dialog',
        code:
            '''
$kPlaySnippetImport

M3EDialog.show<void>(
  context,
  barrierDismissible: $_barrierDismissible,
  dialog: M3EDialog(
    title: ${playDartString(_title)},$icon
    content: Text(${playDartString(_content)}),
    topDivider: $_topDivider,
    bottomDivider: $_bottomDivider,
    actions: <Widget>[
      M3EButton(
        style: M3EButtonStyle.text,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      M3EButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Confirm'),
      ),
    ],
  ),
);''',
      ),
      PlaySnippet(
        label: 'Selection',
        code:
            '''
$kPlaySnippetImport

await M3EDialog.showSelectionScreen(
  context,
  title: ${playDartString(_title)},
  multiSelect: $_multiSelect,
  barrierDismissible: $_barrierDismissible,
  options: const <String>['Standard', 'Pro', 'Team', 'Enterprise'],
  confirmLabel: ${_multiSelect ? "'Done'" : "'OK'"},
);''',
      ),
      PlaySnippet(
        label: 'Full screen',
        code:
            '''
$kPlaySnippetImport

M3EDialog.showFullScreen<void>(
  context,
  title: ${playDartString(_title)},
  action: M3EButton(
    style: M3EButtonStyle.text,
    onPressed: () => Navigator.of(context).pop(),
    child: const Text('Save'),
  ),
  body: Padding(
    padding: const EdgeInsets.all(24),
    child: Text(${playDartString(_content)}),
  ),
);''',
      ),
    ];
  }

  void _showBasic() {
    M3EDialog.show<void>(
      context,
      barrierDismissible: _barrierDismissible,
      dialog: M3EDialog(
        title: _title,
        icon: _showIcon ? const Icon(M3EIcons.error) : null,
        content: Text(_content),
        topDivider: _topDivider,
        bottomDivider: _bottomDivider,
        actions: <Widget>[
          M3EButton(
            style: M3EButtonStyle.text,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          M3EButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _showSelection() async {
    await M3EDialog.showSelectionScreen(
      context,
      title: _title,
      multiSelect: _multiSelect,
      barrierDismissible: _barrierDismissible,
      options: const <String>['Standard', 'Pro', 'Team', 'Enterprise'],
      confirmLabel: _multiSelect ? 'Done' : 'OK',
    );
  }

  void _showFullScreen() {
    M3EDialog.showFullScreen<void>(
      context,
      title: _title,
      action: M3EButton(
        style: M3EButtonStyle.text,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Save'),
      ),
      body: Padding(padding: const EdgeInsets.all(24), child: Text(_content)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Triggers',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              M3EButton(
                style: M3EButtonStyle.tonal,
                onPressed: _showBasic,
                child: const Text('Dialog'),
              ),
              M3EButton(
                style: M3EButtonStyle.tonal,
                onPressed: _showSelection,
                child: const Text('Selection'),
              ),
              M3EButton(
                style: M3EButtonStyle.tonal,
                onPressed: _showFullScreen,
                child: const Text('Full screen'),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Content',
          children: <Widget>[
            PlayTextField(
              label: 'Title',
              value: _title,
              onChanged: (String v) => setState(() => _title = v),
            ),
            PlayTextField(
              label: 'Content',
              value: _content,
              onChanged: (String v) => setState(() => _content = v),
            ),
            PlaySwitch(
              label: 'Show icon',
              value: _showIcon,
              onChanged: (bool v) => setState(() => _showIcon = v),
            ),
            PlaySwitch(
              label: 'Top divider',
              value: _topDivider,
              onChanged: (bool v) => setState(() => _topDivider = v),
            ),
            PlaySwitch(
              label: 'Bottom divider',
              value: _bottomDivider,
              onChanged: (bool v) => setState(() => _bottomDivider = v),
            ),
            PlaySwitch(
              label: 'Barrier dismissible',
              value: _barrierDismissible,
              onChanged: (bool v) => setState(() => _barrierDismissible = v),
            ),
            PlaySwitch(
              label: 'Multi select (selection)',
              value: _multiSelect,
              onChanged: (bool v) => setState(() => _multiSelect = v),
            ),
          ],
        ),
      ],
    );
  }
}
