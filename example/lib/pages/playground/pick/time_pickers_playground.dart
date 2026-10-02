import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Which time picker the playground shows.
enum _TimeVariant { dial, modal }

/// Orientation preset; auto follows the screen.
enum _Layout { auto, portrait, landscape }

/// Live playground for [M3EDialTimePicker] and [M3ETimePicker].
class TimePickersPlayground extends PlaygroundWidget {
  /// Creates the time pickers playground.
  const TimePickersPlayground({super.key});

  @override
  PlaygroundState<TimePickersPlayground> createState() =>
      _TimePickersPlaygroundState();
}

class _TimePickersPlaygroundState
    extends PlaygroundState<TimePickersPlayground> {
  _TimeVariant _variant = _TimeVariant.dial;
  M3ETime _time = const M3ETime(hour: 9, minute: 30);
  M3ETimePickerEntryMode _entryMode = M3ETimePickerEntryMode.dial;
  _Layout _layout = _Layout.auto;
  bool _use24Hour = false;
  bool _expandToFit = false;
  bool _emptyInitialInput = false;
  bool _barrierDismissible = true;
  bool _customText = false;
  String _helpText = 'Set alarm';
  String _confirmText = 'Save';
  String _cancelText = 'Discard';

  Orientation? get _orientation => switch (_layout) {
    _Layout.auto => null,
    _Layout.portrait => Orientation.portrait,
    _Layout.landscape => Orientation.landscape,
  };

  bool get _inputEntry =>
      _entryMode == M3ETimePickerEntryMode.input ||
      _entryMode == M3ETimePickerEntryMode.inputOnly;

  Future<void> _open() async {
    final M3ETime? picked = await M3ETimePicker.show(
      context,
      initialTime: _time,
      initialEntryMode: _entryMode,
      orientation: _orientation,
      alwaysUse24HourFormat: _use24Hour,
      emptyInitialInput: _inputEntry && _emptyInitialInput,
      barrierDismissible: _barrierDismissible,
      helpText: _customText ? _helpText : null,
      confirmText: _customText ? _confirmText : null,
      cancelText: _customText ? _cancelText : null,
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  String get _timeLabel =>
      '${_time.hour.toString().padLeft(2, '0')}:'
      '${_time.minute.toString().padLeft(2, '0')}';

  @override
  Widget buildPreview(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    if (_variant == _TimeVariant.dial) {
      return M3EDialTimePicker(
        key: ValueKey<Object>('$_use24Hour-$_expandToFit-$_layout'),
        value: _time,
        use24HourFormat: _use24Hour,
        expandToFit: _expandToFit,
        orientation: _orientation,
        helpText: _customText ? _helpText : null,
        onChanged: (M3ETime value) => setState(() => _time = value),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        M3EButton.tonal(onPressed: _open, child: const Text('Pick time')),
        const SizedBox(height: 12),
        Text(
          'Time: $_timeLabel',
          style: theme.typeScale.bodyMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final String time =
        'const M3ETime(hour: ${_time.hour}, minute: ${_time.minute})';
    final String orientation = _orientation == null
        ? ''
        : '  orientation: Orientation.${_orientation!.name},\n';
    if (_variant == _TimeVariant.dial) {
      final String help = _customText
          ? '  helpText: ${playDartString(_helpText)},\n'
          : '';
      return <PlaySnippet>[
        PlaySnippet(
          label: 'Dial',
          code:
              '''
$kPlaySnippetImport

M3EDialTimePicker(
  value: $time,
  use24HourFormat: $_use24Hour,
  expandToFit: $_expandToFit,
$orientation$help  onChanged: (M3ETime value) {},
);''',
        ),
      ];
    }
    final StringBuffer args = StringBuffer()
      ..writeln('  context,')
      ..writeln('  initialTime: $time,')
      ..writeln(
        '  initialEntryMode: M3ETimePickerEntryMode.${_entryMode.name},',
      )
      ..writeln('  alwaysUse24HourFormat: $_use24Hour,')
      ..write(orientation);
    if (_inputEntry && _emptyInitialInput) {
      args.writeln('  emptyInitialInput: true,');
    }
    if (_customText) {
      args
        ..writeln('  helpText: ${playDartString(_helpText)},')
        ..writeln('  confirmText: ${playDartString(_confirmText)},')
        ..writeln('  cancelText: ${playDartString(_cancelText)},');
    }
    if (!_barrierDismissible) {
      args.writeln('  barrierDismissible: false,');
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Dialog',
        code:
            '$kPlaySnippetImport\n\n'
            'final M3ETime? time = await M3ETimePicker.show(\n$args);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    final bool modal = _variant == _TimeVariant.modal;
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_TimeVariant>(
            label: 'Picker',
            value: _variant,
            values: _TimeVariant.values,
            labelOf: (_TimeVariant v) => switch (v) {
              _TimeVariant.dial => 'docked dial',
              _TimeVariant.modal => 'modal',
            },
            onChanged: (_TimeVariant v) => setState(() => _variant = v),
          ),
          if (modal)
            PlayEnumChoice<M3ETimePickerEntryMode>(
              label: 'Entry mode',
              value: _entryMode,
              values: M3ETimePickerEntryMode.values,
              labelOf: (M3ETimePickerEntryMode v) => v.name,
              onChanged: (M3ETimePickerEntryMode v) {
                setState(() => _entryMode = v);
              },
            ),
          PlayEnumChoice<_Layout>(
            label: 'Orientation',
            value: _layout,
            values: _Layout.values,
            labelOf: (_Layout v) => v.name,
            onChanged: (_Layout v) => setState(() => _layout = v),
          ),
          PlaySwitchItem(
            label: '24-hour format',
            value: _use24Hour,
            onChanged: (bool v) => setState(() => _use24Hour = v),
          ),
          if (!modal)
            PlaySwitchItem(
              label: 'Expand to fit',
              description: 'Fill the available space',
              value: _expandToFit,
              onChanged: (bool v) => setState(() => _expandToFit = v),
            ),
          if (modal && _inputEntry)
            PlaySwitchItem(
              label: 'Empty initial input',
              description: 'Hour and minute fields start blank',
              value: _emptyInitialInput,
              onChanged: (bool v) => setState(() => _emptyInitialInput = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: modal ? 'Dialog' : 'Text',
        children: <Widget>[
          if (modal)
            PlaySwitchItem(
              label: 'Dismiss on scrim tap',
              value: _barrierDismissible,
              onChanged: (bool v) => setState(() => _barrierDismissible = v),
            ),
          PlaySwitchItem(
            label: 'Custom text',
            description: modal
                ? 'Headline and action labels'
                : 'Headline above the dial',
            value: _customText,
            onChanged: (bool v) => setState(() => _customText = v),
          ),
          if (_customText) ...<Widget>[
            PlayTextField(
              label: 'Help text',
              value: _helpText,
              onChanged: (String v) => setState(() => _helpText = v),
            ),
            if (modal) ...<Widget>[
              PlayTextField(
                label: 'Confirm text',
                value: _confirmText,
                onChanged: (String v) => setState(() => _confirmText = v),
              ),
              PlayTextField(
                label: 'Cancel text',
                value: _cancelText,
                onChanged: (String v) => setState(() => _cancelText = v),
              ),
            ],
          ],
        ],
      ),
    ];
  }
}
