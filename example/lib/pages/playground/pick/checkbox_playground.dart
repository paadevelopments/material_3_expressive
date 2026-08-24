import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_slider.dart';
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
  bool _customChildren = false;
  double _boxSize = 18;
  double _hitSize = 40;

  void _onChanged(bool? next) {
    setState(() => _value = next);
  }

  List<PlaySnippet> get _snippets {
    final bool? value = _tristate ? _value : (_value ?? false);
    final String changed = _enabled ? '(bool? next) {}' : 'null';
    final String custom = _customChildren
        ? '''
  checkedChild: Icon(M3EIcons.check_circle),
  uncheckedChild: Icon(M3EIcons.circle),
'''
        : '';
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
  boxSize: ${_boxSize.toStringAsFixed(0)},
  hitSize: ${_hitSize.toStringAsFixed(0)},
  label: const Text('Accept terms'),
$custom  onChanged: $changed,
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final bool? value = _tristate ? _value : (_value ?? false);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Checkbox',
          child: M3ECheckbox(
            value: value,
            tristate: _tristate,
            error: _error,
            boxSize: _boxSize,
            hitSize: _hitSize,
            label: const Text('Accept terms'),
            checkedChild: _customChildren
                ? Icon(
                    M3EIcons.check_circle,
                    size: _boxSize,
                    color: theme.colorScheme.primary,
                  )
                : null,
            uncheckedChild: _customChildren
                ? Icon(
                    M3EIcons.circle,
                    size: _boxSize,
                    color: theme.colorScheme.onSurfaceVariant,
                  )
                : null,
            onChanged: _enabled ? _onChanged : null,
          ),
        ),
        if (_customChildren)
          PlayPreviewCard(
            label: 'Custom children',
            child: Text(
              value == null
                  ? 'indeterminate (built-in)'
                  : (value ? 'custom checked' : 'custom unchecked'),
              style: theme.typeScale.bodyMedium,
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
            PlaySwitch(
              label: 'Custom children',
              value: _customChildren,
              onChanged: (bool v) => setState(() => _customChildren = v),
            ),
          ],
        ),
        PlayControlPanel(
          title: 'Size',
          children: <Widget>[
            PlaySlider(
              label: 'Box size',
              value: _boxSize,
              min: 14,
              max: 32,
              divisions: 18,
              onChanged: (double v) => setState(() => _boxSize = v),
            ),
            PlaySlider(
              label: 'Hit size',
              value: _hitSize,
              min: 32,
              max: 56,
              divisions: 24,
              onChanged: (double v) => setState(() => _hitSize = v),
            ),
          ],
        ),
      ],
    );
  }
}
