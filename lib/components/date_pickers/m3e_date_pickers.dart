import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'models/m3e_calendar_labels.dart';

/// A Material 3 Expressive date picker.
///
/// A month calendar for selecting a single date. Navigate months with the
/// arrows; the selected day is filled and today is outlined.
class M3EDatePicker extends StatefulWidget {
  const M3EDatePicker({
    required this.onDateSelected,
    this.selectedDate,
    this.firstDate,
    this.lastDate,
    super.key,
  });

  final ValueChanged<DateTime> onDateSelected;
  final DateTime? selectedDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  State<M3EDatePicker> createState() => _M3EDatePickerState();
}

class _M3EDatePickerState extends State<M3EDatePicker> {
  late DateTime _visibleMonth;

  @override
  void initState() {
    super.initState();
    final DateTime base = widget.selectedDate ?? DateTime.now();
    _visibleMonth = DateTime(base.year, base.month);
  }

  void _shiftMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final dateTheme = theme.datePickerTheme;
    return M3EComponentTheme(
      child: Container(
        width: dateTheme.width,
        padding: dateTheme.padding,
        decoration: BoxDecoration(
          color: dateTheme.containerColor(scheme),
          borderRadius: dateTheme.borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildHeader(theme),
            _buildWeekdays(theme),
            _buildGrid(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            M3ECalendarLabels.monthYear(
              _visibleMonth.year,
              _visibleMonth.month,
            ),
            style:
            theme.typeScale.titleSmall.copyWith(color: scheme.onSurface),
          ),
        ),
        _buildArrow(scheme, M3EIcons.chevron_left, () => _shiftMonth(-1)),
        _buildArrow(scheme, M3EIcons.chevron_right, () => _shiftMonth(1)),
      ],
    );
  }

  Widget _buildArrow(M3EColorScheme scheme, IconData icon, VoidCallback onTap) {
    final dateTheme = M3ETheme.of(context).datePickerTheme;
    return M3ETappable(
      onTap: onTap,
      builder: (BuildContext context, M3EInteractionState state) {
        return Padding(
          padding: dateTheme.arrowPadding,
          child: Icon(
            icon,
            color: scheme.onSurfaceVariant,
            size: dateTheme.arrowIconSize,
          ),
        );
      },
    );
  }

  Widget _buildWeekdays(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    return Row(
      children: <Widget>[
        for (final String label in M3ECalendarLabels.weekdayInitials)
          Expanded(
            child: Center(
              child: Text(
                label,
                style: theme.typeScale.bodySmall
                    .copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGrid(M3EThemeData theme) {
    final dateTheme = theme.datePickerTheme;
    final int year = _visibleMonth.year;
    final int month = _visibleMonth.month;
    final int days = M3ECalendarLabels.daysInMonth(year, month);
    final int offset = M3ECalendarLabels.firstWeekday(year, month);
    final int cellCount =
        ((days + offset) / dateTheme.daysPerWeek).ceil() *
        dateTheme.daysPerWeek;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: dateTheme.gridPadding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: dateTheme.daysPerWeek,
      ),
      itemCount: cellCount,
      itemBuilder: (BuildContext context, int index) {
        final int day = index - offset + 1;
        if (day < 1 || day > days) {
          return const SizedBox.shrink();
        }
        return _buildDay(theme, DateTime(year, month, day));
      },
    );
  }

  Widget _buildDay(M3EThemeData theme, DateTime date) {
    final scheme = theme.colorScheme;
    final dateTheme = theme.datePickerTheme;
    final bool selected = _isSameDay(date, widget.selectedDate);
    final bool today = _isSameDay(date, DateTime.now());
    final bool enabled = _isEnabled(date);
    final Color foreground = dateTheme.dayForegroundColor(
      scheme,
      selected: selected,
      enabled: enabled,
    );

    return M3ETappable(
      enabled: enabled,
      onTap: () => widget.onDateSelected(date),
      builder: (BuildContext context, M3EInteractionState state) {
        return Center(
          child: Container(
            width: dateTheme.daySize,
            height: dateTheme.daySize,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? scheme.primary : null,
              border: today && !selected
                  ? Border.all(color: scheme.primary)
                  : null,
            ),
            child: Text(
              '${date.day}',
              style:
              theme.typeScale.bodyMedium.copyWith(color: foreground),
            ),
          ),
        );
      },
    );
  }

  bool _isEnabled(DateTime date) {
    if (widget.firstDate != null && date.isBefore(widget.firstDate!)) {
      return false;
    }
    if (widget.lastDate != null && date.isAfter(widget.lastDate!)) {
      return false;
    }
    return true;
  }

  bool _isSameDay(DateTime a, DateTime? b) {
    return b != null &&
        a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}
