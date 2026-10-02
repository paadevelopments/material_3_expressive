import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3ERadio] and [M3ERadioGroup].
class RadioPlayground extends PlaygroundWidget {
  /// Creates the radio playground.
  const RadioPlayground({super.key});

  @override
  PlaygroundState<RadioPlayground> createState() => _RadioPlaygroundState();
}

class _RadioPlaygroundState extends PlaygroundState<RadioPlayground> {
  static const List<String> _plans = <String>[
    'Basic',
    'Standard',
    'Pro',
    'Team',
    'Enterprise',
  ];

  String _plan = 'Standard';
  double _optionCount = 3;
  Axis _direction = Axis.vertical;
  String _groupLabel = 'Plan';
  bool _error = false;
  bool _enabled = true;
  bool _disableLast = false;
  bool _showLabels = true;

  List<String> get _options => _plans.take(_optionCount.round()).toList();

  ValueChanged<String>? _onChangedFor(int index, int count) {
    if (!_enabled || (_disableLast && index == count - 1)) {
      return null;
    }
    return (String value) => setState(() => _plan = value);
  }

  @override
  Widget buildPreview(BuildContext context) {
    final List<String> options = _options;
    final List<Widget> radios = <Widget>[
      for (int i = 0; i < options.length; i++)
        Padding(
          padding: _direction == Axis.vertical
              ? const EdgeInsets.only(bottom: 4)
              : const EdgeInsetsDirectional.only(end: 12),
          child: M3ERadio<String>(
            value: options[i],
            groupValue: _plan,
            error: _error,
            label: _showLabels ? Text(options[i]) : null,
            semanticLabel: _showLabels ? null : options[i],
            onChanged: _onChangedFor(i, options.length),
          ),
        ),
    ];
    return M3ERadioGroup<String>(
      groupValue: _plan,
      groupLabel: _groupLabel,
      onChanged: _enabled
          ? (String value) => setState(() => _plan = value)
          : null,
      child: _direction == Axis.vertical
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: radios,
            )
          : Wrap(children: radios),
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final String changed = _enabled ? '(String value) {}' : 'null';
    final String label = _showLabels
        ? "\n      label: Text(plan),"
        : '\n      semanticLabel: plan,';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Radio group',
        code:
            '''
$kPlaySnippetImport

M3ERadioGroup<String>(
  groupValue: ${playDartString(_plan)},
  groupLabel: ${playDartString(_groupLabel)},
  onChanged: $changed,
  child: ${_direction == Axis.vertical ? 'Column' : 'Wrap'}(
    children: <Widget>[
      for (final String plan in plans)
        M3ERadio<String>(
          value: plan,
          groupValue: ${playDartString(_plan)},
          error: $_error,$label
          onChanged: $changed,
        ),
    ],
  ),
);''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Group',
        children: <Widget>[
          PlayTextField(
            label: 'Group label',
            value: _groupLabel,
            onChanged: (String v) => setState(() => _groupLabel = v),
          ),
          PlaySlider(
            label: 'Options',
            value: _optionCount,
            min: 2,
            max: _plans.length.toDouble(),
            divisions: _plans.length - 2,
            onChanged: (double v) {
              setState(() {
                _optionCount = v;
                if (!_options.contains(_plan)) {
                  _plan = _options.first;
                }
              });
            },
          ),
          PlayEnumChoice<Axis>(
            label: 'Direction',
            value: _direction,
            values: Axis.values,
            labelOf: (Axis v) => v.name,
            onChanged: (Axis v) => setState(() => _direction = v),
          ),
          PlayEnumChoice<String>(
            label: 'Selected',
            value: _plan,
            values: _options,
            labelOf: (String v) => v,
            onChanged: (String v) => setState(() => _plan = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'State',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Show labels',
            value: _showLabels,
            onChanged: (bool v) => setState(() => _showLabels = v),
          ),
          PlaySwitchItem(
            label: 'Error',
            value: _error,
            onChanged: (bool v) => setState(() => _error = v),
          ),
          PlaySwitchItem(
            label: 'Enabled',
            value: _enabled,
            onChanged: (bool v) => setState(() => _enabled = v),
          ),
          if (_enabled)
            PlaySwitchItem(
              label: 'Disable last option',
              value: _disableLast,
              onChanged: (bool v) => setState(() => _disableLast = v),
            ),
        ],
      ),
    ];
  }
}
