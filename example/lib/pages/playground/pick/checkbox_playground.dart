import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Tristate checkbox values as a preset.
enum _CheckState { unchecked, checked, indeterminate }

/// Live playground for [M3ECheckbox].
class CheckboxPlayground extends PlaygroundWidget {
  /// Creates the checkbox playground.
  const CheckboxPlayground({super.key});

  @override
  PlaygroundState<CheckboxPlayground> createState() =>
      _CheckboxPlaygroundState();
}

class _CheckboxPlaygroundState extends PlaygroundState<CheckboxPlayground> {
  bool? _value = true;
  bool _tristate = false;
  bool _error = false;
  bool _enabled = true;
  bool _showLabel = true;
  String _label = 'Accept terms';
  bool _customChildren = false;
  double _boxSize = 18;
  double _hitSize = 40;
  bool _customTarget = false;
  double _targetSize = 48;

  bool? get _effectiveValue => _tristate ? _value : (_value ?? false);

  _CheckState get _checkState => switch (_effectiveValue) {
    true => _CheckState.checked,
    false => _CheckState.unchecked,
    null => _CheckState.indeterminate,
  };

  @override
  Widget buildPreview(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return M3ECheckbox(
      value: _effectiveValue,
      tristate: _tristate,
      error: _error,
      boxSize: _boxSize,
      hitSize: _hitSize,
      targetSize: _customTarget ? _targetSize : null,
      label: _showLabel ? Text(_label) : null,
      semanticLabel: _showLabel ? null : _label,
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
      onChanged: _enabled
          ? (bool? next) => setState(() => _value = next)
          : null,
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer()
      ..writeln('  value: $_effectiveValue,')
      ..writeln('  tristate: $_tristate,')
      ..writeln('  error: $_error,')
      ..writeln('  boxSize: ${_boxSize.round()},')
      ..writeln('  hitSize: ${_hitSize.round()},');
    if (_customTarget) {
      args.writeln('  targetSize: ${_targetSize.round()},');
    }
    if (_showLabel) {
      args.writeln('  label: Text(${playDartString(_label)}),');
    } else {
      args.writeln('  semanticLabel: ${playDartString(_label)},');
    }
    if (_customChildren) {
      args
        ..writeln('  checkedChild: const Icon(M3EIcons.check_circle),')
        ..writeln('  uncheckedChild: const Icon(M3EIcons.circle),');
    }
    args.writeln('  onChanged: ${_enabled ? '(bool? next) {}' : 'null'},');
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Checkbox',
        code: '$kPlaySnippetImport\n\nM3ECheckbox(\n$args);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'State',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Tristate',
            description: 'Allows an indeterminate value',
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
          if (_tristate)
            PlayEnumChoice<_CheckState>(
              label: 'Value',
              value: _checkState,
              values: _CheckState.values,
              labelOf: (_CheckState v) => v.name,
              onChanged: (_CheckState v) {
                setState(() {
                  _value = switch (v) {
                    _CheckState.checked => true,
                    _CheckState.unchecked => false,
                    _CheckState.indeterminate => null,
                  };
                });
              },
            ),
          if (!_tristate)
            PlaySwitchItem(
              label: 'Checked',
              value: _value ?? false,
              onChanged: (bool v) => setState(() => _value = v),
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
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlayTextField(
            label: _showLabel ? 'Label' : 'Semantic label',
            value: _label,
            onChanged: (String v) => setState(() => _label = v),
          ),
          PlaySwitchItem(
            label: 'Show label',
            description: 'Text beside the box, inside the tap target',
            value: _showLabel,
            onChanged: (bool v) => setState(() => _showLabel = v),
          ),
          PlaySwitchItem(
            label: 'Custom children',
            description: 'Icons replace the checked and unchecked box',
            value: _customChildren,
            onChanged: (bool v) => setState(() => _customChildren = v),
          ),
        ],
      ),
      PlayControlGroup(
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
            label: 'State layer size',
            value: _hitSize,
            min: 32,
            max: 56,
            divisions: 24,
            onChanged: (double v) => setState(() => _hitSize = v),
          ),
          PlaySwitchItem(
            label: 'Custom target size',
            value: _customTarget,
            onChanged: (bool v) => setState(() => _customTarget = v),
          ),
          if (_customTarget)
            PlaySlider(
              label: 'Target size',
              value: _targetSize,
              min: 32,
              max: 72,
              divisions: 40,
              onChanged: (double v) => setState(() => _targetSize = v),
            ),
        ],
      ),
    ];
  }
}
