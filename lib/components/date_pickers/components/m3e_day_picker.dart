import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../res/m3e_date_picker_constants.dart';
import '../utils/m3e_date_picker_utils.dart';
import '../utils/m3e_date_picker_utils.dart';
import 'm3e_day_cell.dart';

/// Weekday headers and day grid for one month.
class M3EDayPicker extends StatelessWidget {
  const M3EDayPicker({
    required this.displayedMonth,
    required this.selectedDate,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    this.selectableDayPredicate,
    this.rangeStart,
    this.rangeEnd,
    this.fitHeight = false,
    super.key,
  });

  final DateTime displayedMonth;
  final DateTime? selectedDate;
  final DateTime currentDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;
  final bool Function(DateTime day)? selectableDayPredicate;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final bool fitHeight;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final dateTheme = theme.datePickerTheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final int year = displayedMonth.year;
    final int month = displayedMonth.month;
    final int daysInMonth = M3EDatePickerUtils.daysInMonth(year, month);
    final int firstDayOffset =
        (DateTime(year, month).weekday - localizations.firstDayOfWeekIndex) % 7;
    final int cellCount =
        ((daysInMonth + firstDayOffset) / dateTheme.daysPerWeek).ceil() *
        dateTheme.daysPerWeek;
    const int _maxDayPickerRowCount = 6;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double rowHeight = fitHeight && constraints.hasBoundedHeight
            ? ((constraints.maxHeight -
                        dateTheme.gridPadding.vertical -
                        24) /
                    _maxDayPickerRowCount)
                .clamp(40.0, M3EDatePickerConstants.dayPickerRowHeight)
            : M3EDatePickerConstants.dayPickerRowHeight;

        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                for (int i = 0; i < dateTheme.daysPerWeek; i++)
                  Expanded(
                    child: Center(
                      child: Text(
                        localizations.narrowWeekdays[
                            (localizations.firstDayOfWeekIndex + i) % 7],
                        style: dateTheme.weekdayStyle(
                          theme.typeScale,
                          theme.colorScheme,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: dateTheme.gridPadding,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: rowHeight,
              ),
              itemCount: cellCount,
              itemBuilder: (BuildContext context, int index) {
                final int day = index - firstDayOffset + 1;
                if (day < 1 || day > daysInMonth) {
                  return const SizedBox.shrink();
                }
                final DateTime date = DateTime(year, month, day);
                final bool enabled = M3EDatePickerUtils.isSelectable(
                  date,
                  firstDate,
                  lastDate,
                  predicate: selectableDayPredicate,
                );
                final bool selected =
                    M3EDatePickerUtils.isSameDay(date, selectedDate);
                final bool today =
                    M3EDatePickerUtils.isSameDay(date, currentDate);
                final DateTime? start = rangeStart;
                final DateTime? end = rangeEnd;
                final bool isRangeStart =
                    start != null && M3EDatePickerUtils.isSameDay(date, start);
                final bool isRangeEnd =
                    end != null && M3EDatePickerUtils.isSameDay(date, end);
                final bool inRange = start != null &&
                    end != null &&
                    M3EDatePickerUtils.isInRange(date, start, end);

                return M3EDayCell(
                  date: date,
                  selected: selected,
                  today: today,
                  enabled: enabled,
                  inRange: inRange,
                  rangeStart: isRangeStart,
                  rangeEnd: isRangeEnd,
                  onTap: enabled ? () => onChanged(date) : null,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
