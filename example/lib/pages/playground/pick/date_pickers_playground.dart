import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Which date picker the playground shows.
enum _DateVariant { docked, modal, range }

/// Live playground for [M3ECalendarDatePicker] and [M3EDatePicker].
class DatePickersPlayground extends PlaygroundWidget {
  /// Creates the date pickers playground.
  const DatePickersPlayground({super.key});

  @override
  PlaygroundState<DatePickersPlayground> createState() =>
      _DatePickersPlaygroundState();
}

class _DatePickersPlaygroundState
    extends PlaygroundState<DatePickersPlayground> {
  _DateVariant _variant = _DateVariant.docked;
  DateTime? _date = DateTime(2026, 8, 11);
  M3EDateRange? _range;
  M3EDatePickerEntryMode _entryMode = M3EDatePickerEntryMode.calendar;
  M3EDatePickerMode _calendarMode = M3EDatePickerMode.day;
  bool _expandToFit = false;
  bool _weekdaysOnly = false;
  bool _barrierDismissible = true;
  bool _customText = false;
  String _helpText = 'Select travel date';
  String _confirmText = 'Book';
  String _cancelText = 'Not now';

  static final DateTime _first = DateTime(2020);
  static final DateTime _last = DateTime(2030);

  bool get _modal => _variant != _DateVariant.docked;

  /// Calendar mode applies when the calendar can show first.
  bool get _hasCalendarMode =>
      _variant == _DateVariant.docked ||
      (_variant == _DateVariant.modal &&
          (_entryMode == M3EDatePickerEntryMode.calendar ||
              _entryMode == M3EDatePickerEntryMode.calendarOnly));

  bool _isWeekday(DateTime day) =>
      day.weekday != DateTime.saturday && day.weekday != DateTime.sunday;

  Future<void> _open() async {
    if (_variant == _DateVariant.range) {
      final M3EDateRange? picked = await M3EDatePicker.showRange(
        context,
        initialStartDate: _range?.start,
        initialEndDate: _range?.end,
        firstDate: _first,
        lastDate: _last,
        initialEntryMode: _entryMode,
        selectableDayPredicate: _weekdaysOnly ? _isWeekday : null,
        helpText: _customText ? _helpText : null,
        confirmText: _customText ? _confirmText : null,
        cancelText: _customText ? _cancelText : null,
        barrierDismissible: _barrierDismissible,
      );
      if (picked != null) {
        setState(() => _range = picked);
      }
      return;
    }
    final DateTime? picked = await M3EDatePicker.show(
      context,
      initialDate: _date,
      firstDate: _first,
      lastDate: _last,
      initialEntryMode: _entryMode,
      initialCalendarMode: _calendarMode,
      selectableDayPredicate: _weekdaysOnly ? _isWeekday : null,
      helpText: _customText ? _helpText : null,
      confirmText: _customText ? _confirmText : null,
      cancelText: _customText ? _cancelText : null,
      barrierDismissible: _barrierDismissible,
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  String _day(DateTime date) => date.toIso8601String().split('T').first;

  String get _result {
    if (_variant == _DateVariant.range) {
      final M3EDateRange? range = _range;
      if (range == null) {
        return 'Range: none';
      }
      final DateTime? end = range.end;
      return 'Range: ${_day(range.start)}'
          '${end == null ? '' : ' – ${_day(end)}'}';
    }
    final DateTime? date = _date;
    return 'Date: ${date == null ? 'none' : _day(date)}';
  }

  @override
  Widget buildPreview(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    if (_variant == _DateVariant.docked) {
      return M3ECalendarDatePicker(
        key: ValueKey<Object>('$_calendarMode-$_expandToFit-$_weekdaysOnly'),
        initialDate: _date,
        firstDate: _first,
        lastDate: _last,
        initialCalendarMode: _calendarMode,
        expandToFit: _expandToFit,
        selectableDayPredicate: _weekdaysOnly ? _isWeekday : null,
        onDateChanged: (DateTime value) => setState(() => _date = value),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        M3EButton.tonal(
          onPressed: _open,
          child: Text(
            _variant == _DateVariant.range ? 'Pick range' : 'Pick date',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _result,
          style: theme.typeScale.bodyMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _dateLit(DateTime? date) {
    if (date == null) {
      return 'null';
    }
    return 'DateTime(${date.year}, ${date.month}, ${date.day})';
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer();
    final String predicate = _weekdaysOnly
        ? '  selectableDayPredicate: (DateTime day) =>\n'
              '      day.weekday != DateTime.saturday &&\n'
              '      day.weekday != DateTime.sunday,\n'
        : '';
    if (_variant == _DateVariant.docked) {
      args
        ..writeln('  initialDate: ${_dateLit(_date)},')
        ..writeln('  firstDate: DateTime(2020),')
        ..writeln('  lastDate: DateTime(2030),')
        ..writeln(
          '  initialCalendarMode: M3EDatePickerMode.${_calendarMode.name},',
        )
        ..writeln('  expandToFit: $_expandToFit,')
        ..write(predicate)
        ..writeln('  onDateChanged: (DateTime value) {},');
      return <PlaySnippet>[
        PlaySnippet(
          label: 'Docked calendar',
          code: '$kPlaySnippetImport\n\nM3ECalendarDatePicker(\n$args);',
        ),
      ];
    }
    final bool range = _variant == _DateVariant.range;
    args.writeln('  context,');
    if (range) {
      args
        ..writeln('  initialStartDate: ${_dateLit(_range?.start)},')
        ..writeln('  initialEndDate: ${_dateLit(_range?.end)},');
    } else {
      args.writeln('  initialDate: ${_dateLit(_date)},');
    }
    args
      ..writeln('  firstDate: DateTime(2020),')
      ..writeln('  lastDate: DateTime(2030),')
      ..writeln(
        '  initialEntryMode: M3EDatePickerEntryMode.${_entryMode.name},',
      );
    if (_hasCalendarMode) {
      args.writeln(
        '  initialCalendarMode: M3EDatePickerMode.${_calendarMode.name},',
      );
    }
    args.write(predicate);
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
        label: range ? 'Range dialog' : 'Date dialog',
        code:
            '$kPlaySnippetImport\n\nfinal result = await M3EDatePicker.'
            '${range ? 'showRange' : 'show'}(\n$args);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_DateVariant>(
            label: 'Picker',
            value: _variant,
            values: _DateVariant.values,
            labelOf: (_DateVariant v) => switch (v) {
              _DateVariant.docked => 'docked calendar',
              _DateVariant.modal => 'modal date',
              _DateVariant.range => 'modal date range',
            },
            onChanged: (_DateVariant v) => setState(() => _variant = v),
          ),
          if (_modal)
            PlayEnumChoice<M3EDatePickerEntryMode>(
              label: 'Entry mode',
              value: _entryMode,
              values: M3EDatePickerEntryMode.values,
              labelOf: (M3EDatePickerEntryMode v) => v.name,
              onChanged: (M3EDatePickerEntryMode v) {
                setState(() => _entryMode = v);
              },
            ),
          if (_hasCalendarMode)
            PlayEnumChoice<M3EDatePickerMode>(
              label: 'Initial calendar mode',
              value: _calendarMode,
              values: M3EDatePickerMode.values,
              labelOf: (M3EDatePickerMode v) => v.name,
              onChanged: (M3EDatePickerMode v) {
                setState(() => _calendarMode = v);
              },
            ),
          if (!_modal)
            PlaySwitchItem(
              label: 'Expand to fit',
              description: 'Fill the available height',
              value: _expandToFit,
              onChanged: (bool v) => setState(() => _expandToFit = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Dates',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Weekdays only',
            description: 'Weekends cannot be selected',
            value: _weekdaysOnly,
            onChanged: (bool v) => setState(() => _weekdaysOnly = v),
          ),
        ],
      ),
      if (_modal)
        PlayControlGroup(
          title: 'Dialog',
          children: <Widget>[
            PlaySwitchItem(
              label: 'Dismiss on scrim tap',
              value: _barrierDismissible,
              onChanged: (bool v) => setState(() => _barrierDismissible = v),
            ),
            PlaySwitchItem(
              label: 'Custom text',
              description: 'Headline and action labels',
              value: _customText,
              onChanged: (bool v) => setState(() => _customText = v),
            ),
            if (_customText) ...<Widget>[
              PlayTextField(
                label: 'Help text',
                value: _helpText,
                onChanged: (String v) => setState(() => _helpText = v),
              ),
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
        ),
    ];
  }
}
