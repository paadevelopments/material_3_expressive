import 'package:flutter/material.dart';

import '../models/m3e_date_picker_models.dart';
import 'm3e_input_date_picker_form_field.dart';

/// Text fields for entering a date range in a picker dialog.
class M3EInputDateRangePickerFormField extends StatelessWidget {
  const M3EInputDateRangePickerFormField({
    required this.firstDate,
    required this.lastDate,
    this.initialStartDate,
    this.initialEndDate,
    this.onStartDateSaved,
    this.onEndDateSaved,
    this.selectableDayPredicate,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldStartHintText,
    this.fieldEndHintText,
    this.fieldStartLabelText,
    this.fieldEndLabelText,
    super.key,
  });

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final ValueChanged<DateTime>? onStartDateSaved;
  final ValueChanged<DateTime>? onEndDateSaved;
  final M3ESelectableDayForRangePredicate? selectableDayPredicate;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldStartHintText;
  final String? fieldEndHintText;
  final String? fieldStartLabelText;
  final String? fieldEndLabelText;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        M3EInputDatePickerFormField(
          firstDate: firstDate,
          lastDate: lastDate,
          initialDate: initialStartDate,
          onDateSaved: onStartDateSaved,
          selectableDayPredicate: selectableDayPredicate,
          errorFormatText: errorFormatText,
          errorInvalidText: errorInvalidText,
          fieldHintText: fieldStartHintText,
          fieldLabelText:
              fieldStartLabelText ?? localizations.dateRangeStartLabel,
          autofocus: true,
        ),
        const SizedBox(height: 16),
        M3EInputDatePickerFormField(
          firstDate: firstDate,
          lastDate: lastDate,
          initialDate: initialEndDate,
          onDateSaved: onEndDateSaved,
          selectableDayPredicate: selectableDayPredicate,
          errorFormatText: errorFormatText,
          errorInvalidText: errorInvalidText,
          fieldHintText: fieldEndHintText,
          fieldLabelText: fieldEndLabelText ?? localizations.dateRangeEndLabel,
        ),
      ],
    );
  }
}
