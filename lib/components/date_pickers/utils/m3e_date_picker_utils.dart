import 'dart:math' as math;

/// Date helpers shared by calendar, input, and dialog pickers.
abstract final class M3EDatePickerUtils {
  const M3EDatePickerUtils._();

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isInRange(DateTime day, DateTime start, DateTime end) {
    final DateTime normalized = dateOnly(day);
    final DateTime rangeStart = dateOnly(start);
    final DateTime rangeEnd = dateOnly(end);
    return !normalized.isBefore(rangeStart) && !normalized.isAfter(rangeEnd);
  }

  static DateTime clampDate(DateTime date, DateTime firstDate, DateTime lastDate) {
    if (date.isBefore(firstDate)) {
      return firstDate;
    }
    if (date.isAfter(lastDate)) {
      return lastDate;
    }
    return date;
  }

  static DateTime getMonth(int year, int month) {
    return DateTime(year, month);
  }

  static int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  static int monthDelta(DateTime startMonth, DateTime endMonth) {
    return (endMonth.year - startMonth.year) * 12 +
        endMonth.month -
        startMonth.month;
  }

  static DateTime addMonthsToMonthDate(DateTime monthDate, int delta) {
    return DateTime(monthDate.year, monthDate.month + delta);
  }

  static DateTime getDay(int year, int month, int day) {
    return DateTime(year, month, day);
  }

  static DateTime normalizeSelectedDay(DateTime selected, DateTime monthDate) {
    final int days = daysInMonth(monthDate.year, monthDate.month);
    final int preferredDay = math.min(selected.day, days);
    return DateTime(monthDate.year, monthDate.month, preferredDay);
  }

  static bool isSelectable(
    DateTime date,
    DateTime firstDate,
    DateTime lastDate, {
    bool Function(DateTime day)? predicate,
  }) {
    if (date.isBefore(firstDate) || date.isAfter(lastDate)) {
      return false;
    }
    return predicate?.call(date) ?? true;
  }
}
