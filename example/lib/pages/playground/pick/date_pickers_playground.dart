import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for date pickers.
class DatePickersPlayground extends StatefulWidget {
  /// Creates the date pickers playground.
  const DatePickersPlayground({super.key});

  @override
  State<DatePickersPlayground> createState() => _DatePickersPlaygroundState();
}

class _DatePickersPlaygroundState extends State<DatePickersPlayground> {
  DateTime? _date = DateTime(2026, 8, 11);
  M3EDateRange? _range;
  M3EDatePickerEntryMode _entryMode = M3EDatePickerEntryMode.calendar;
  M3EDatePickerMode _calendarMode = M3EDatePickerMode.day;
  final bool _expandToFit = false;

  static final DateTime _first = DateTime(2020);
  static final DateTime _last = DateTime(2030);

  Future<void> _pickDate() async {
    final DateTime? picked = await M3EDatePicker.show(
      context,
      initialDate: _date,
      firstDate: _first,
      lastDate: _last,
      initialEntryMode: _entryMode,
      initialCalendarMode: _calendarMode,
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  Future<void> _pickRange() async {
    final M3EDateRange? picked = await M3EDatePicker.showRange(
      context,
      initialStartDate: _range?.start ?? _date,
      initialEndDate: _range?.end,
      firstDate: _first,
      lastDate: _last,
      initialEntryMode: _entryMode,
    );
    if (picked != null) {
      setState(() => _range = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final String dateLabel = _date == null
        ? 'none'
        : _date!.toIso8601String().split('T').first;
    final String rangeLabel = _range == null
        ? 'none'
        : '${_range!.start.toIso8601String().split('T').first}'
              '${_range!.end != null ? ' – ${_range!.end!.toIso8601String().split('T').first}' : ''}';

    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Calendar',
          child: M3ECalendarDatePicker(
            key: ValueKey<Object>('$_calendarMode-$_expandToFit'),
            initialDate: _date,
            firstDate: _first,
            lastDate: _last,
            initialCalendarMode: _calendarMode,
            expandToFit: _expandToFit,
            onDateChanged: (DateTime value) {
              setState(() => _date = value);
            },
          ),
        ),
        PlayPreviewCard(
          label: 'Dialogs',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  M3EButton(
                    style: M3EButtonStyle.tonal,
                    onPressed: _pickDate,
                    child: const Text('Pick date'),
                  ),
                  M3EButton(
                    style: M3EButtonStyle.tonal,
                    onPressed: _pickRange,
                    child: const Text('Pick range'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Date: $dateLabel',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                'Range: $rangeLabel',
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
            PlayEnumMenu<M3EDatePickerEntryMode>(
              label: 'Entry mode',
              value: _entryMode,
              values: M3EDatePickerEntryMode.values,
              labelOf: (M3EDatePickerEntryMode v) => v.name,
              onChanged: (M3EDatePickerEntryMode v) {
                setState(() => _entryMode = v);
              },
            ),
            PlayEnumMenu<M3EDatePickerMode>(
              label: 'Calendar mode',
              value: _calendarMode,
              values: M3EDatePickerMode.values,
              labelOf: (M3EDatePickerMode v) => v.name,
              onChanged: (M3EDatePickerMode v) {
                setState(() => _calendarMode = v);
              },
            ),
          ],
        ),
      ],
    );
  }
}
