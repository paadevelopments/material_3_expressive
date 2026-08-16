import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ESwitch].
class SwitchPlayground extends StatefulWidget {
  /// Creates the switch playground.
  const SwitchPlayground({super.key});

  @override
  State<SwitchPlayground> createState() => _SwitchPlaygroundState();
}

class _SwitchPlaygroundState extends State<SwitchPlayground> {
  bool _value = true;
  bool _enabled = true;
  bool _showIcons = true;
  double _stateLayerSize = 40;

  List<PlaySnippet> get _snippets {
    final String changed = _enabled ? '(bool next) {}' : 'null';
    final String icons = _showIcons
        ? '''
  selectedIcon: const Icon(M3EIcons.check),
  unselectedIcon: const Icon(M3EIcons.close),
'''
        : '';
    final String layer = _stateLayerSize == _stateLayerSize.roundToDouble()
        ? '${_stateLayerSize.toInt()}'
        : '$_stateLayerSize';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Switch',
        code:
            '''
$kPlaySnippetImport

M3ESwitch(
  value: $_value,
$icons  stateLayerSize: $layer,
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
          label: 'Switch',
          child: Row(
            children: <Widget>[
              M3ESwitch(
                value: _value,
                selectedIcon: _showIcons ? const Icon(M3EIcons.check) : null,
                unselectedIcon: _showIcons ? const Icon(M3EIcons.close) : null,
                stateLayerSize: _stateLayerSize,
                onChanged: _enabled
                    ? (bool next) => setState(() => _value = next)
                    : null,
              ),
              const SizedBox(width: 16),
              Text(_value ? 'On' : 'Off', style: theme.typeScale.bodyLarge),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlaySwitch(
              label: 'Show icons',
              value: _showIcons,
              onChanged: (bool v) => setState(() => _showIcons = v),
            ),
            PlaySlider(
              label: 'State layer size',
              value: _stateLayerSize,
              min: 32,
              max: 64,
              divisions: 8,
              onChanged: (double v) => setState(() => _stateLayerSize = v),
            ),
          ],
        ),
        PlayControlPanel(
          title: 'State',
          children: <Widget>[
            PlaySwitch(
              label: 'Value',
              value: _value,
              onChanged: (bool v) => setState(() => _value = v),
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
