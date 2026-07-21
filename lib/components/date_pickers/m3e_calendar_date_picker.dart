import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../foundations/foundations.dart';
import 'components/m3e_date_picker_mode_toggle.dart';
import 'components/m3e_month_picker.dart';
import 'components/m3e_year_picker.dart';
import 'enums/m3e_date_picker_enums.dart';
import 'models/m3e_date_picker_models.dart';
import 'res/m3e_date_picker_constants.dart';
import 'utils/m3e_date_picker_utils.dart';

/// Embeddable calendar for selecting a single date.
class M3ECalendarDatePicker extends StatefulWidget {
  const M3ECalendarDatePicker({
    required this.onDateChanged,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.currentDate,
    this.initialCalendarMode = M3EDatePickerMode.day,
    this.onDisplayedMonthChanged,
    this.onCalendarModeChanged,
    this.selectableDayPredicate,
    this.expandToFit = false,
    super.key,
  });

  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? currentDate;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<DateTime>? onDisplayedMonthChanged;
  final ValueChanged<M3EDatePickerMode>? onCalendarModeChanged;
  final M3EDatePickerMode initialCalendarMode;
  final M3ESelectableDayPredicate? selectableDayPredicate;
  final bool expandToFit;

  @override
  State<M3ECalendarDatePicker> createState() => _M3ECalendarDatePickerState();
}

class _M3ECalendarDatePickerState extends State<M3ECalendarDatePicker> {
  late M3EDatePickerMode _mode;
  late DateTime _displayedMonth;
  late DateTime _firstDate;
  late DateTime _lastDate;
  late DateTime _currentDate;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _firstDate = M3EDatePickerUtils.dateOnly(widget.firstDate);
    _lastDate = M3EDatePickerUtils.dateOnly(widget.lastDate);
    _currentDate =
        M3EDatePickerUtils.dateOnly(widget.currentDate ?? DateTime.now());
    _mode = widget.initialCalendarMode;
    _selectedDate = widget.initialDate == null
        ? null
        : M3EDatePickerUtils.dateOnly(widget.initialDate!);
    final DateTime base = _selectedDate ?? _currentDate;
    _displayedMonth = M3EDatePickerUtils.getMonth(base.year, base.month);
    assert(!_lastDate.isBefore(_firstDate));
  }

  void _handleModeChanged(M3EDatePickerMode mode) {
    HapticFeedback.selectionClick();
    setState(() => _mode = mode);
    widget.onCalendarModeChanged?.call(mode);
  }

  void _handleMonthChanged(DateTime month) {
    setState(() => _displayedMonth = month);
    widget.onDisplayedMonthChanged?.call(month);
  }

  void _handleYearChanged(DateTime value) {
    HapticFeedback.selectionClick();
    final DateTime clamped = M3EDatePickerUtils.clampDate(
      value,
      _firstDate,
      _lastDate,
    );
    setState(() {
      _mode = M3EDatePickerMode.day;
      _displayedMonth =
          M3EDatePickerUtils.getMonth(clamped.year, clamped.month);
      if (M3EDatePickerUtils.isSelectable(
        clamped,
        _firstDate,
        _lastDate,
        predicate: widget.selectableDayPredicate,
      )) {
        _selectedDate = clamped;
        widget.onDateChanged(clamped);
      }
    });
    widget.onDisplayedMonthChanged?.call(_displayedMonth);
    widget.onCalendarModeChanged?.call(M3EDatePickerMode.day);
  }

  void _handleDayChanged(DateTime value) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedDate = value;
      widget.onDateChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (BuildContext context) {
        final theme = M3ETheme.of(context);
        final dateTheme = theme.datePickerTheme;
        final Widget content = Column(
          mainAxisSize:
              widget.expandToFit ? MainAxisSize.max : MainAxisSize.min,
          children: <Widget>[
            if (widget.expandToFit)
              Expanded(
                child: switch (_mode) {
                  M3EDatePickerMode.day => M3EMonthPicker(
                      initialMonth: _displayedMonth,
                      firstDate: _firstDate,
                      lastDate: _lastDate,
                      selectedDate: _selectedDate,
                      currentDate: _currentDate,
                      onChanged: _handleDayChanged,
                      onMonthChanged: _handleMonthChanged,
                      selectableDayPredicate: widget.selectableDayPredicate,
                      expandToFit: true,
                      mode: _mode,
                      onModeChanged: _handleModeChanged,
                    ),
                  M3EDatePickerMode.year => M3EYearPicker(
                      selectedDate: _selectedDate,
                      firstDate: _firstDate,
                      lastDate: _lastDate,
                      onChanged: _handleYearChanged,
                      selectableDayPredicate: widget.selectableDayPredicate,
                      mode: _mode,
                      onModeChanged: _handleModeChanged,
                      displayedMonth: _displayedMonth,
                    ),
                },
              )
            else ...<Widget>[
              M3EDatePickerModeToggle(
                mode: _mode,
                monthDate: _displayedMonth,
                onChanged: _handleModeChanged,
              ),
              SizedBox(
                height: switch (_mode) {
                  M3EDatePickerMode.day =>
                    M3EDatePickerConstants.maxDayPickerHeight,
                  M3EDatePickerMode.year =>
                    M3EDatePickerUtils.calendarYearViewHeight(
                      _firstDate,
                      _lastDate,
                      includeSubHeader: false,
                    ),
                },
                child: switch (_mode) {
                  M3EDatePickerMode.day => M3EMonthPicker(
                      initialMonth: _displayedMonth,
                      firstDate: _firstDate,
                      lastDate: _lastDate,
                      selectedDate: _selectedDate,
                      currentDate: _currentDate,
                      onChanged: _handleDayChanged,
                      onMonthChanged: _handleMonthChanged,
                      selectableDayPredicate: widget.selectableDayPredicate,
                    ),
                  M3EDatePickerMode.year => M3EYearPicker(
                      selectedDate: _selectedDate,
                      firstDate: _firstDate,
                      lastDate: _lastDate,
                      onChanged: _handleYearChanged,
                      selectableDayPredicate: widget.selectableDayPredicate,
                      displayedMonth: _displayedMonth,
                    ),
                },
              ),
            ],
          ],
        );

        if (widget.expandToFit) {
          return content;
        }

        return Container(
          width: dateTheme.width,
          padding: dateTheme.padding,
          decoration: BoxDecoration(
            color: dateTheme.containerColor(theme.colorScheme),
            borderRadius: dateTheme.borderRadius,
          ),
          child: content,
        );
      },
    );
  }
}
