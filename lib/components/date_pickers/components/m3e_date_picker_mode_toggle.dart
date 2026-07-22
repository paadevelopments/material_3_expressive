import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_date_picker_enums.dart';
import '../res/m3e_date_picker_constants.dart';

/// Toggles between day and year calendar modes.
class M3EDatePickerModeToggle extends StatelessWidget {
  const M3EDatePickerModeToggle({
    required this.mode,
    required this.onChanged,
    required this.monthDate,
    super.key,
  });

  final M3EDatePickerMode mode;
  final ValueChanged<M3EDatePickerMode> onChanged;
  final DateTime monthDate;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final dateTheme = theme.datePickerTheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String label = mode == M3EDatePickerMode.day
        ? localizations.formatMonthYear(monthDate)
        : localizations.formatYear(DateTime(monthDate.year));

    return SizedBox(
      height: M3EDatePickerConstants.subHeaderHeight,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: M3ETappable(
          onTap: () {
            onChanged(
              mode == M3EDatePickerMode.day
                  ? M3EDatePickerMode.year
                  : M3EDatePickerMode.day,
            );
          },
          semanticLabel: mode == M3EDatePickerMode.day
              ? localizations.selectYearSemanticsLabel
              : localizations.formatMonthYear(monthDate),
          builder: (BuildContext context, M3EInteractionState state) {
            return Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    label,
                    style: theme.typeScale.titleSmall.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Icon(
                    mode == M3EDatePickerMode.day
                        ? M3EIcons.arrow_drop_down
                        : M3EIcons.arrow_drop_up,
                    size: dateTheme.arrowIconSize,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
