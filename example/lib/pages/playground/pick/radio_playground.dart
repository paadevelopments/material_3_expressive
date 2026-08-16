import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ERadio].
class RadioPlayground extends StatefulWidget {
  /// Creates the radio playground.
  const RadioPlayground({super.key});

  @override
  State<RadioPlayground> createState() => _RadioPlaygroundState();
}

class _RadioPlaygroundState extends State<RadioPlayground> {
  String _plan = 'standard';
  bool _error = false;
  bool _enabled = true;
  bool _showLabels = true;

  static const List<String> _plans = <String>['standard', 'pro', 'team'];

  ValueChanged<String>? get _onChanged =>
      _enabled ? (String value) => setState(() => _plan = value) : null;

  List<PlaySnippet> get _snippets {
    final String changed = _enabled ? '(String value) {}' : 'null';
    final String label = _showLabels
        ? '\n  label: Text(${playDartString(_plan)}),'
        : '';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Radio group',
        code:
            '''
$kPlaySnippetImport

M3ERadio<String>(
  value: ${playDartString(_plan)},
  groupValue: ${playDartString(_plan)},
  error: $_error,$label
  onChanged: $changed,
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Radio group',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final String plan in _plans)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: M3ERadio<String>(
                    value: plan,
                    groupValue: _plan,
                    error: _error,
                    label: _showLabels ? Text(plan) : null,
                    onChanged: _onChanged,
                  ),
                ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'State',
          children: <Widget>[
            PlaySwitch(
              label: 'Show labels',
              value: _showLabels,
              onChanged: (bool v) => setState(() => _showLabels = v),
            ),
            PlaySwitch(
              label: 'Error',
              value: _error,
              onChanged: (bool v) => setState(() => _error = v),
            ),
            PlaySwitch(
              label: 'Enabled',
              value: _enabled,
              onChanged: (bool v) => setState(() => _enabled = v),
            ),
          ],
        ),
      ],
    );
  }
}
