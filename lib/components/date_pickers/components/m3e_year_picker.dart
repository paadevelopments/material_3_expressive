import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_date_picker_enums.dart';
import '../res/m3e_date_picker_constants.dart';
import '../utils/m3e_date_picker_utils.dart';

/// Scrollable year grid for calendar date pickers.
class M3EYearPicker extends StatefulWidget {
  const M3EYearPicker({
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onChanged,
    this.selectableDayPredicate,
    this.mode,
    this.onModeChanged,
    this.displayedMonth,
    super.key,
  });

  final DateTime? selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onChanged;
  final bool Function(DateTime day)? selectableDayPredicate;
  final M3EDatePickerMode? mode;
  final ValueChanged<M3EDatePickerMode>? onModeChanged;
  final DateTime? displayedMonth;

  @override
  State<M3EYearPicker> createState() => _M3EYearPickerState();
}

class _M3EYearPickerState extends State<M3EYearPicker> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    final int selectedYear = widget.selectedDate?.year ?? widget.firstDate.year;
    _controller = ScrollController(
      initialScrollOffset: _initialOffset(
        selectedYear,
        widget.firstDate.year,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final dateTheme = theme.datePickerTheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final int firstYear = widget.firstDate.year;
    final int lastYear = widget.lastDate.year;
    final int yearCount = lastYear - firstYear + 1;
    final int selectedYear = widget.selectedDate?.year ?? firstYear;
    final DateTime monthDate =
        widget.displayedMonth ?? widget.selectedDate ?? widget.firstDate;
    final double gridHeight = M3EDatePickerUtils.yearPickerGridHeight(yearCount);
    final bool scrollable =
        M3EDatePickerUtils.yearPickerGridNaturalHeight(yearCount) > gridHeight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.mode != null && widget.onModeChanged != null)
          SizedBox(
            height: M3EDatePickerConstants.subHeaderHeight,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: M3ETappable(
                onTap: () => widget.onModeChanged!(M3EDatePickerMode.day),
                semanticLabel: localizations.formatMonthYear(monthDate),
                builder: (BuildContext context, M3EInteractionState state) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          localizations.formatYear(DateTime(monthDate.year)),
                          style: theme.typeScale.titleSmall.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Icon(
                          M3EIcons.arrow_drop_up,
                          size: dateTheme.arrowIconSize,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        SizedBox(
          height: gridHeight,
          child: GridView.builder(
            controller: _controller,
            physics: scrollable
                ? null
                : const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(
              M3EDatePickerConstants.yearPickerPadding,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: M3EDatePickerConstants.yearPickerColumnCount,
              mainAxisExtent: M3EDatePickerConstants.yearPickerRowHeight,
              mainAxisSpacing: M3EDatePickerConstants.yearPickerRowSpacing,
              crossAxisSpacing: M3EDatePickerConstants.yearPickerRowSpacing,
            ),
            itemCount: yearCount,
            itemBuilder: (BuildContext context, int index) {
              final int year = firstYear + index;
              final DateTime normalized = M3EDatePickerUtils.clampDate(
                M3EDatePickerUtils.normalizeSelectedDay(
                  widget.selectedDate ?? DateTime(year, 1, 1),
                  DateTime(year, widget.selectedDate?.month ?? 1),
                ),
                widget.firstDate,
                widget.lastDate,
              );
              final DateTime candidate =
                  DateTime(year, normalized.month, normalized.day);
              final bool enabled = M3EDatePickerUtils.isSelectable(
                candidate,
                widget.firstDate,
                widget.lastDate,
                predicate: widget.selectableDayPredicate,
              );
              final bool selected = year == selectedYear;
              final Color foreground = dateTheme.yearForegroundColor(
                theme.colorScheme,
                selected: selected,
                enabled: enabled,
              );

              return M3ETappable(
                enabled: enabled,
                onTap: enabled ? () => widget.onChanged(candidate) : null,
                semanticLabel: localizations.formatYear(DateTime(year)),
                builder: (BuildContext context, M3EInteractionState state) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? dateTheme.selectedDayBackgroundColor(
                              theme.colorScheme,
                            )
                          : null,
                    ),
                    child: Text(
                      localizations.formatYear(DateTime(year)),
                      style: (selected
                              ? dateTheme.selectedYearStyle
                              : dateTheme.yearStyle)(
                            theme.typeScale,
                            theme.colorScheme,
                          ).copyWith(color: foreground),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  static double _initialOffset(int selectedYear, int firstYear) {
    const double rowHeight =
        M3EDatePickerConstants.yearPickerRowHeight +
        M3EDatePickerConstants.yearPickerRowSpacing;
    const int columns = M3EDatePickerConstants.yearPickerColumnCount;
    final int row = ((selectedYear - firstYear) / columns).floor();
    return row * rowHeight;
  }
}
