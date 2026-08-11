import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for time pickers.
class TimePickersPlayground extends StatefulWidget {
  /// Creates the time pickers playground.
  const TimePickersPlayground({super.key});

  @override
  State<TimePickersPlayground> createState() => _TimePickersPlaygroundState();
}

class _TimePickersPlaygroundState extends State<TimePickersPlayground> {
  M3ETime _time = const M3ETime(hour: 9, minute: 30);
  M3ETimePickerEntryMode _entryMode = M3ETimePickerEntryMode.dial;
  bool _use24Hour = false;
  final bool _expandToFit = false;

  Future<void> _pickTime() async {
    final M3ETime? picked = await M3ETimePicker.show(
      context,
      initialTime: _time,
      initialEntryMode: _entryMode,
      alwaysUse24HourFormat: _use24Hour,
    );
    if (picked != null) {
      setState(() => _time = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Dial',
          child: M3EDialTimePicker(
            key: ValueKey<Object>('$_use24Hour-$_expandToFit'),
            value: _time,
            use24HourFormat: _use24Hour,
            expandToFit: _expandToFit,
            onChanged: (M3ETime value) => setState(() => _time = value),
          ),
        ),
        PlayPreviewCard(
          label: 'Dialog',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              M3EButton(
                style: M3EButtonStyle.tonal,
                onPressed: _pickTime,
                child: const Text('Pick time'),
              ),
              const SizedBox(height: 12),
              Text(
                'Time: ${_time.hour.toString().padLeft(2, '0')}:'
                '${_time.minute.toString().padLeft(2, '0')}',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Picker',
          children: <Widget>[
            PlayEnumMenu<M3ETimePickerEntryMode>(
              label: 'Entry mode',
              value: _entryMode,
              values: M3ETimePickerEntryMode.values,
              labelOf: (M3ETimePickerEntryMode v) => v.name,
              onChanged: (M3ETimePickerEntryMode v) {
                setState(() => _entryMode = v);
              },
            ),
            PlaySwitch(
              label: '24-hour format',
              value: _use24Hour,
              onChanged: (bool v) => setState(() => _use24Hour = v),
            ),
          ],
        ),
      ],
    );
  }
}
