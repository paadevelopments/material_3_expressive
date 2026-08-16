import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ECheckbox].
class CheckboxPlayground extends StatefulWidget {
  /// Creates the checkbox playground.
  const CheckboxPlayground({super.key});

  @override
  State<CheckboxPlayground> createState() => _CheckboxPlaygroundState();
}

class _CheckboxPlaygroundState extends State<CheckboxPlayground> {
  bool? _value = true;
  bool _tristate = false;
  bool _error = false;
  bool _enabled = true;

  void _onChanged(bool? next) {
    setState(() => _value = next);
  }

  List<PlaySnippet> get _snippets {
    final bool? value = _tristate ? _value : (_value ?? false);
    final String changed = _enabled ? '(bool? next) {}' : 'null';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Checkbox',
        code:
            '''
$kPlaySnippetImport

M3ECheckbox(
  value: $value,
  tristate: $_tristate,
  error: $_error,
  onChanged: $changed,
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
          label: 'Checkbox',
          child: Row(
            children: <Widget>[
              M3ECheckbox(
                value: _tristate ? _value : (_value ?? false),
                tristate: _tristate,
                error: _error,
                onChanged: _enabled ? _onChanged : null,
              ),
              const SizedBox(width: 12),
              Text(
                _value == null
                    ? 'indeterminate'
                    : (_value! ? 'checked' : 'unchecked'),
                style: theme.typeScale.bodyLarge,
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
              label: 'Tristate',
              value: _tristate,
              onChanged: (bool v) {
                setState(() {
                  _tristate = v;
                  if (!v && _value == null) {
                    _value = false;
                  }
                });
              },
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
